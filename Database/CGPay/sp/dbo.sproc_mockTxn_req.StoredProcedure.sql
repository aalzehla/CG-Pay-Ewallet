USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_mockTxn_req]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sproc_mockTxn_req]
	@flag char(3) = null,
	@subscriber varchar(50) =  null,
	@user_id int  = null,
	@amount decimal(18,2) = null,
	@product_id int  =  null,
	@agent_id int  =  null,
	@action_user varchar(50) = null


AS
BEGIN
declare @last_client_balance decimal(18,2), @product varchar(100), @txn_type varchar(100), 
                     @company_id int, 
                     @gparent_id int, 
                     @parent_id int, 
					 @service_charge decimal(18,2) ,
					 @bonus_amt decimal(18,2)

	if @flag = 's' -- success
	begin
		
		select @product = product_label, @txn_type = txn_type, @company_id = company_id from tbl_manage_services where product_id = @product_id
		select @parent_id = parent_id from tbl_user_detail u join tbl_agent_detail a on a.agent_id  = u.agent_id where u.user_id = @user_id


		  --deduct merchant account                                                                                                   
                    update dbo.tbl_agent_detail
                      set 
                          available_balance = isnull(available_balance, 0) - isnull(@amount, 0)
                    where agent_id = @agent_id;

					  --log last client balance                                                                                     
                    select @last_client_balance = isnull(available_balance, 0)
                    from dbo.tbl_agent_detail with(nolock)
                    where agent_id = @agent_id;


					 -- insert transaction detail into transaction table                    
                    insert into [dbo].tbl_transaction
                    ([product_id], 
                     [product_label], 
                     [txn_type_id], 
                     company_id, 
                     grand_parent_id, 
                     parent_id,
                     [agent_id], 
                     subscriber_no, 
                     [amount], 
                     service_charge, 
                     bonus_amt, 
                     [status], 
                     [user_id], 
                     created_UTC_date, 
                     created_local_date, 
                     created_nepali_date, 
                     created_by, 
                   
                     agent_remarks
                    )
                    values
                    (@product_id, 
                     @product, 
                     @txn_type, 
                     @company_id, 
                     @gparent_id, 
                     @parent_id, 
                     @agent_id, 
                     @subscriber, 
                     @amount, 
                     isnull(@service_charge, 0), 
                     isnull(@bonus_amt, 0), 
                     'Sucess', 
                     @user_id, 
                     getutcdate(), 
                     getdate(), 
                     [dbo].func_get_nepali_date(default), 
                     @action_user, 
                     'transaction is Sucess'

                    );
		Select '0' code, 'Transaction Succesfull' message, null id
		return 

	end

END


GO
