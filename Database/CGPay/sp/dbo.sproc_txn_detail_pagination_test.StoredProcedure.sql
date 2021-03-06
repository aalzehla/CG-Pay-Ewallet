USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_txn_detail_pagination_test]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP PROCEDURE sproc_txn_detail_pagination_test
GO

CREATE PROCEDURE [dbo].[sproc_txn_detail_pagination_test] @datatable BIT             = 1
,                                                        @txn_from VARCHAR(10)      = NULL
,                                                        @txn_to VARCHAR(10)        = NULL
,                                                        @page_number int           = 0
,                                                        @no_of_records VARCHAR(10) = NULL
,                                                        @user_name VARCHAR(20)     = null
,                                                        @flag char                 = null
AS
BEGIN

	if (@flag = 's')
	begin
		DECLARE @sql NVARCHAR(max) = ''

		if not exists(select 'x'
			from tbl_user_detail
			where user_email = @user_name
				or user_mobile_no = @user_name )
		begin
			select '104'                  code
			,      'Username is required' Message
			,      null                   id

		end

		else

		begin

		
			declare @agent_id varchar(10);
			select @agent_id = agent_id
			from tbl_user_detail
			where user_email = @user_name
				or user_mobile_no = @user_name

				if not exists((select 'x' from tbl_transaction where agent_id = @agent_id) union (select 'x' from tbl_agent_QR_transaction where agent_id = @agent_id ))
				begin
					select '1' code, 'No transaction found' message,  null id
					return 
				end

			select * 
				INTO #temp1
							FROM
				(
				SELECT product_id          
							,      product_label       
							,      t.agent_id          
							,      subscriber_no       
							,      amount              
							,      t.status            
							,      t.created_local_date
							FROM       tbl_transaction            t 
							inner join tbl_user_detail            ud on ud.agent_id = t.agent_id
							inner join tbl_transaction_commission tc on tc.txn_id = t.txn_id
							where ud.agent_id = @agent_id
				union
				select 
					'',
					pmt_description,
					ab.agent_id,
					agent_code,
					ab.amount,
					'success',
					ab.created_local_date 
					from
					tbl_agent_QR_transaction qt 
					join tbl_agent_balance ab 
					on qt.pid=ab.txn_id  
					where ab.agent_id = @agent_id
				) as x

			--SELECT product_id          
			--,      product_label       
			--,      t.agent_id          
			--,      subscriber_no       
			--,      amount              
			--,      t.status            
			--,      t.created_local_date
			--,      ROW_NUMBER() OVER (
			--ORDER BY t.created_local_date DESC
			--)                           AS row_id
			--	INTO #temp
			--FROM       tbl_transaction            t 
			--inner join tbl_user_detail            ud on ud.agent_id = t.agent_id
			--inner join tbl_transaction_commission tc on tc.txn_id = t.txn_id
			--where ud.agent_id = @agent_id
			----WHERE created_local_date BETWEEN isnull(@txn_from, format(getdate(), 'yyyy-MM-dd'))
			----		AND isnull(@txn_to, format(getdate(), 'yyyy-MM-dd'))+' 23:59:59'
			--ORDER BY ud.created_local_date DESC;

			SELECT 
				product_id          
			,      product_label       
			,      agent_id          
			,      subscriber_no       
			,      amount              
			,      status            
			,      created_local_date
			,      ROW_NUMBER() OVER (
			ORDER BY created_local_date DESC
			)                           AS row_id
				INTO #temp
			FROM       #temp1 
			ORDER BY created_local_date DESC;

			drop table #temp1


			declare @pgno varchar(10)
			if @page_number=0
				or @page_number<0
				set @page_number=1
			set @pgno=cast(@page_number-1 as varchar)


			exec sproc_pagination '#temp'
			,                     @datatable
			,                     @pgno
			,                     @no_of_records


			drop table #temp
		end
	end
END






GO
