

ALTER PROCEDURE [dbo].[sproc_commission_email_job]
AS
BEGIN
	DECLARE @fromDate VARCHAR(20)
		,@toDate VARCHAR(20),
		@body_start varchar(200),
		@body_end varchar(200)

	SET @fromDate = format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd')
	SET @toDate = format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd') + ' 23:59:59.997'

	DECLARE @table NVARCHAR(max)

	SET @table = '<table border =1><thead><tr><td>Transaction Date</td><td>Service</td><td>Transaction Type</td><td>Total Transaction</td><td>Total Amount</td><td>Commission Earned</td></tr></thead><tbody>'

	SELECT Convert(DATE, t.created_local_date, 102) AS Transaction_date
		,t.product_label AS Service
		,tms.txn_type AS TransactionType
		,count(txn_id) AS TotalTransaction
		,Sum(Amount) AS TotalAmount
		,Sum(isnull(admin_commission, 0)) AS CommissionEarned
	INTO #temp
	FROM tbl_transaction t WITH (NOLOCK)
	JOIN tbl_manage_services tms WITH (NOLOCK) ON tms.txn_type_id = t.txn_type_id
		AND t.product_id = tms.product_id
	WHERE 1 = 1
		AND t.STATUS = 'Success'
		and t.gateway_id =9
		AND convert(DATE, t.created_local_date, 102) BETWEEN format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd')
			AND format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd') + ' 23:59:59.997'
	GROUP BY Convert(DATE, t.created_local_date, 102)
		,tms.txn_type
		,t.product_label
	ORDER BY Convert(DATE, t.created_local_date, 102) DESC

	SELECT @table += '<tr><td>' + format(transaction_date, 'yyyy-MM-dd HH:mm:ss') + '</td>
	<td>' + Service + '</td>
	<td>' + TransactionType + '</td>
	<td>' + cast(TotalTransaction AS VARCHAR) + '</td>
	<td>' + cast(TotalAmount AS VARCHAR) + '</td>
	<td>' + cast(CommissionEarned AS VARCHAR) + '</td>	
	</tr>'
	FROM #temp

	SET @table += '</tbody></table>'

	Set @body_start = 'Dear Team, </br>'
	Set @body_start = @body_start + 'Please find the CGPAY daily transaction commission report as following: </br></br>'

	Set @body_end = '</br></br>If there are any queries, please feel free to contact DIGIHUB accounts team.</br>'
	Set @body_end = @body_end +  'System generated email, please do not reply.'

	INSERT INTO tbl_email_request (
		email_subject
		,email_text
		,email_send_by
		,email_send_to
		,email_send_to_cc
		,email_send_to_bcc
		,email_send_status
		,is_active
		,created_local_date
		,created_UTC_date
		,created_nepali_date
		,created_by
		)
	VALUES (
		'CGPAY Daily Commission Report'
		,@body_start + @table + @body_end
		,'support@cgpay.com.np'
		,'avaya.rijal@nepalpayment.com;salina.shakya@nepalpayment.com'
		,'sabin@nepalpayment.com;samir.khadka@nepalpayment.com'
		,'ajar.maharjan@nepalpayment.com'
		,'n'
		,'y'
		,GETDATE()
		,GETUTCDATE()
		,dbo.func_get_nepali_date(Default)
		,'System'
		)

	--SELECT @table

	DROP TABLE #temp
END
