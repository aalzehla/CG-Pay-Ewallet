
alter PROCEDURE [dbo].[sproc_direct_gateway_Service] @flag CHAR(3)
	,@txn_id VARCHAR(50) = NULL
	,@product_id VARCHAR(50) = NULL
AS
BEGIN
	IF @flag = 'txn'
	BEGIN
		SELECT t.txn_id,
				s.product_code as product_id,
				t.product_label,
				t.txn_type_id,
				t.company_id,
				t.partner_txn_id,
				t.grand_parent_id,
				t.parent_id,
				t.agent_id,
				t.subscriber_no,
				t.amount,
				t.service_charge,
				t.bonus_amt,
				t.status,
				t.user_id,
				t.created_UTC_date,
				t.created_local_date,
				t.created_nepali_date,
				t.created_by,
				t.created_ip,
				t.created_platform,
				t.updated_by,
				t.updated_UTC_date,
				t.updated_local_date,
				t.updated_nepali_date,
				t.updated_ip,
				t.gateway_id,
				t.gateway_txn_id,
				t.gateway_bill_id,
				t.is_auto_commission_agent,
				t.is_auto_commission_parent,
				t.is_auto_commission_gparent,
				t.admin_commission,
				t.manual_reprocessed,
				t.is_reconciled,
				t.reconcile_count,
				t.batch_id,
				t.batch_txn_id,
				t.process_id,
				t.admin_remarks,
				t.agent_remarks,
				t.last_agent_balance,
				t.admin_cost_amount,
				t.status_code,
				t.json_data,
				t.otp_code,
				t.FileName,
				t.Remarks
			,t.created_ip ip_address
			,g.gateway_name
		FROM tbl_transaction t
		JOIN tbl_manage_services s ON t.product_id = s.product_id
		JOIN tbl_gateway_detail g ON g.gateway_id = s.primary_gateway
		WHERE txn_id = @txn_id
			AND isnull(gateway_status, 'N') = 'Y'
			AND t.STATUS = 'pending'

		RETURN;
	END

	IF @flag = 'pro'
	BEGIN
		SELECT *
		FROM tbl_manage_services s
		JOIN tbl_gateway_detail g ON g.gateway_id = s.primary_gateway
		WHERE product_id = @product_id

		RETURN;
	END
END
