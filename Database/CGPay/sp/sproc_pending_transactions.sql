USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_pending_transactions]    Script Date: 8/28/2020 6:35:17 PM ******/
DROP PROCEDURE [dbo].[sproc_pending_transactions]
GO

/****** Object:  StoredProcedure [dbo].[sproc_pending_transactions]    Script Date: 8/28/2020 6:35:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE     PROCEDURE [dbo].[sproc_pending_transactions] @flag CHAR(3)
	,@gateway_name VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	-- Insert statements for procedure here  
	IF @flag = 'gpt'
	BEGIN
		SELECT TOP 5 tlp.txn_id,
				tms.product_code as product_id,
				tlp.product_label,
				tlp.txn_type_id,
				tlp.company_id,
				tlp.partner_txn_id,
				tlp.grand_parent_id,
				tlp.parent_id,
				tlp.agent_id,
				tlp.subscriber_no,
				tlp.amount,
				tlp.service_charge,
				tlp.bonus_amt,
				tlp.status,
				tlp.user_id,
				tlp.created_UTC_date,
				tlp.created_local_date,
				tlp.created_nepali_date,
				tlp.created_by,
				tlp.created_ip,
				tlp.created_platform,
				tlp.updated_by,
				tlp.updated_UTC_date,
				tlp.updated_local_date,
				tlp.updated_nepali_date,
				tlp.updated_ip,
				tlp.gateway_id,
				tlp.gateway_txn_id,
				tlp.gateway_bill_id,
				tlp.is_auto_commission_agent,
				tlp.is_auto_commission_parent,
				tlp.is_auto_commission_gparent,
				tlp.admin_commission,
				tlp.manual_reprocessed,
				tlp.is_reconciled,
				tlp.reconcile_count,
				tlp.batch_id,
				tlp.batch_txn_id,
				tlp.process_id,
				tlp.admin_remarks,
				tlp.agent_remarks,
				tlp.last_agent_balance,
				tlp.admin_cost_amount,
				tlp.status_code,
				tlp.json_data,
				tlp.otp_code,
				tlp.FileName,
				tlp.Remarks,
			'prabhupay' gateway_name--tgd.gateway_name 
			into #tempTransaction
		FROM tbl_transaction tlp
		JOIN tbl_manage_services tms with (NOLOCK) ON tms.product_id = tlp.product_id
		JOIN tbl_gateway_detail tgd with (NOLOCK) ON tgd.gateway_id = isnull(tms.primary_gateway, tms.secondary_gateway)
		WHERE tlp.STATUS = 'Pending'

		UPDATE tbl_transaction_pending
		SET [Status] = 'Processed'
			,updated_local_date = GETUTCDATE()
		FROM tbl_transaction btp with (NOLOCK)
		JOIN #tempTransaction t ON btp.txn_id = t.txn_id

		SELECT *
		FROM #tempTransaction
	END
END

GO


