USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_topup_report]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE       procedure [dbo].[sproc_topup_report] @flag          char(3), 
                                        @agent_id       int          = null, 
                                        @txn_id         int          = null, 
                                        @parent_id      int          = null, 
                                        @grandparent_id     int          = null, 
                                        @product_id     int          = null, 
                                        @product_name   varchar(100) = null, 
                                        @gateway_id     int          = null, 
                                        @from_date      datetime     = null, 
                                        @to_date        datetime     = null, 
                                        @status        varchar(100) = null, 
                                        @distributor_id int          = null, 
                                        @sub_dist_id     int          = null, 
                                        @txn_type_id     int          = null, 
                                        @product_type   varchar(20)  = null, 
                                        @created_by     varchar(50)  = null, 
                                        @action_user    varchar(50)  = null
as
    begin
        -- set nocount on added to prevent extra result sets from
        -- interfering with select statements.
        set nocount on;
        declare @sql varchar(max);
        if @flag = 's'
            begin
                set @sql = 'select right(''0000000000'' + cast(dt.txn_id as varchar), 8) as txnid, 
       product_label, 
       grand_parent_id, 
       parent_id, 
       dt.agent_id, 
       subscriber_no, 
       amount, 
       status as txnstatus, 
       user_id, 
       created_local_date as txndate,
	   agent_remarks
from tbl_transaction dt
    left join tbl_transaction_commission dtc on dt.txn_id = dtc.txn_id
     left join tbl_transaction_detail dtd on dtd.txn_id = dt.txn_id
where 1 = 1; ';
                if @agent_id is not null
                    begin
                        set @sql = @sql + ' and dt.agentid = ' + cast(@agent_id as varchar);
                end;
                if @txn_id is not null
                    begin
                        set @sql = @sql + ' and dt.txnid = ' + cast(@txn_id as varchar);
                end;
                if @product_id is not null
                    begin
                        set @sql = @sql + ' and dt.productid = ' + cast(@product_id as varchar);
                end;
                if @gateway_id is not null
                    begin
                        set @sql = @sql + ' and dt.gatewayid = ' + cast(@gateway_id as varchar);
                end;
                if @status is not null
                    begin
                        set @sql = @sql + ' and dt.status = ''' + @status + '''';
                end;
                if @from_date is not null
                   and @to_date is not null
                    begin
                        set @sql+=' and dt.createddatelocal between ''' + convert(varchar(10), @from_date, 101) + ''' and ''' + convert(varchar(10), dateadd(dd, 1, @to_date), 101) + '''';
                end;
                print @sql;
                exec (@sql);
        end;  -- get customer topup report

        if @flag = 'smt'
            begin
                select top 10 right('0000000000' + cast(dt.txn_id as varchar), 8) as txnid, 
                              dt.product_label, 
                              grand_parent_id, 
                              parent_id, 
                              dt.agent_id, 
                              subscriber_no, 
                              amount, 
                              dt.status as txnstatus, 
                              user_id, 
                              dt.created_local_date as txndate
                from tbl_transaction dt
                     join tbl_transaction_commission dtc on dt.txn_id = dtc.txn_id
                     left join tbl_transaction_commission dtd on dtd.txn_id = dt.txn_id
                     join tbl_manage_services ms on ms.product_id = dt.product_id
                where case
                          when @created_by is not null
                          then dt.created_by
                          else cast(dt.agent_id as varchar)
                      end = case
                                when @created_by is not null
                                then @created_by
                                else cast(@agent_id as varchar)
                            end
                      and ms.product_type = @product_type
                order by dt.created_local_date desc;
        end; -- customer top 10 txns

        if @flag = 'rct'
            begin
                set @sql = 'SELECT RIGHT(''0000000000'' + CAST(dt.txn_id AS VARCHAR), 8) AS txnid, 
       dt.product_label, 
       dt.company_id, 
       dm.company, 
       dm.txn_type, 
       dt.agent_id, 
       dt.subscriber_no, 
       dt.amount, 
       dt.service_charge, 
       dt.bonus_amt, 
       dt.[status], 
       dt.status_code, 
       dt.[user_id], 
       dt.created_local_date, 
       dt.created_by, 
       dt.created_platform, 
       dt.admin_commission, 
       dtc.agent_commission, 
       dtc.parent_commission, 
       dtc.grand_parent_commission, 
       dtc.txn_reward_point, 
       dtd.customer_id, 
       dtd.customer_name, 
       dtd.plan_id, 
       dtd.plan_name, 
       dtd.extra_field1, 
       dtd.extra_field2, 
       dtd.extra_field3, 
       dtd.extra_field4, 
       dt.admin_remarks, 
       dg.gateway_name AS gatewayname
FROM tbl_transaction dt
     LEFT JOIN tbl_transaction_commission dtc ON dt.txn_id = dtc.txn_id
     JOIN tbl_manage_services dm ON dm.product_id = dt.product_id
     LEFT JOIN tbl_transaction_detail dtd ON dtd.txn_id = dt.txn_id
     INNER JOIN tbl_gateway_detail dg ON dg.gateway_id = dt.gateway_id
      and dt.txn_id = ' + cast(@txn_id as varchar);
                if @txn_id is null
                    begin
                        select '1' code, 
                               'transaction id is required' message, 
                               null id;
                        return;
                end;
                if @agent_id is not null
                    begin
                        set @sql = @sql + ' and dt.agent_id= ' + cast(@agent_id as varchar);
                end;
                print @sql;
                exec (@sql);
        end; -- transaction reciept 

        if @flag = 'sp'
            begin
                set @sql = 'SELECT RIGHT(''0000000000'' + CAST(dt.txn_id AS VARCHAR), 8) AS txnid, 
       dm.txn_type, 
       du.[user_name], 
       dt.[product_label], 
       subscriber_no, 
       dt.created_local_date AS txndate, 
       amount, 
       dt.admin_remarks, 
       dg.gateway_name AS gatewayname
FROM tbl_transaction dt
     JOIN tbl_transaction_commission dtc ON dt.txn_id = dtc.txn_id
     LEFT JOIN tbl_transaction_detail dtd ON dtd.txn_id = dt.txn_id
     INNER JOIN tbl_agent_detail dta ON dta.agent_id = dt.agent_id
     INNER JOIN tbl_agent_detail dta1 ON dta1.agent_id = dt.parent_id
     INNER JOIN tbl_agent_detail dta2 ON dta2.agent_id = dt.grand_parent_id
     INNER JOIN tbl_manage_services dm ON dm.product_id = dt.product_id
     INNER JOIN tbl_gateway_detail dg ON dg.gateway_id = dt.gateway_id
     INNER JOIN tbl_user_detail du ON du.[user_id] = dt.[user_id]
            where 1 = 1';
                if @distributor_id is not null
                    begin
                        set @sql = @sql + ' and dt.parent_id = ' + cast(@distributor_id as varchar);
                end;
                if @sub_dist_id is not null
                    begin
                        if @distributor_id is null
                            begin
                                select '1' code, 
                                       ' parent id is required' message, 
                                       null id;
                                return;
                        end;
                            else
                            begin
                                set @sql = @sql + ' and dt.parent_id = ' + cast(@sub_dist_id as varchar) + 'and dt.grandparentid = ' + cast(@distributor_id as varchar);
                        end;
                end;
                if @txn_type_id is not null
                    begin
                        set @sql = @sql + ' and dt.txn_type_id = ' + cast(@txn_type_id as varchar);
                end;
                if @product_id is not null
                    begin
                        set @sql = @sql + ' and dt.product_id = ' + cast(@product_id as varchar);
                end;
                if @status is not null
                    begin
                        set @sql = @sql + '  and dt.status = ''' + @status + '''';
                end;
                if @from_date is not null
                   and @to_date is not null
                    begin
                        set @sql+=' and dt.created_local_date between ''' + convert(varchar(10), @from_date, 101) + ''' and ''' + convert(varchar(10), dateadd(dd, 1, @to_date), 101) + '''';
                end;
                print @sql;
                exec (@sql);
        end; -- merchant detail/topup report

        if @flag = 'txn'  -- search individual txn
            begin
                if @txn_id is null
                    begin
                        select '1' code, 
                               'transaction id/subscriber no/partner txn id is required' message, 
                               null id;
                        return;
                end;
                set @sql = 'select right(''0000000000'' +cast(dt.txn_id as varchar), 8) as txnid, dm.txn_type, du.user_name,
dt.product_label,subscriber_no, convert(varchar,dt.created_local_date,103) as txndate,cast(amount as varchar) amount,dt.admin_remarks,dg.gateway_name as gatewayname 
            from tbl_transaction dt 
            join tbl_transaction_commission dtc on dt.txn_id = dtc.txn_id
            left join tbl_transaction_detail dtd on dtd.txn_id = dt.txn_id
            inner join tbl_agent_detail dta on dta.agent_id  =  dt.agent_id
            inner join tbl_agent_detail dta1 on dta1.agent_id  =  dt.parent_id 
            inner join tbl_agent_detail dta2 on dta2.agent_id  =  dt.grand_parent_id
            inner join tbl_manage_services dm on dm.product_id = dt.product_id
            inner join tbl_gateway_detail dg on dg.gateway_id = dt.gateway_id
            inner join tbl_user_detail du on du.[user_id] =  dt.[user_id]
            where 1 = 1  
            and dt.txn_id = ' + cast(@txn_id as varchar) + '
            or dt.subscriber_no like ''%' + cast(@txn_id as varchar) + '%''
            or dt.partner_txn_id like ' + cast(@txn_id as varchar) + '';
                print @sql;
                exec (@sql);
        end;

        if @flag = 'rcc'
            begin
            

                if @txn_id is null
                    begin
                        select '1' code, 
                               'transaction id is required' message, 
                               null id;
                        return;
                end;
                    else
                    begin
                        if not exists
                        (
                            select 'x'
                            from tbl_transaction
                            where created_by = @action_user
                                  and @txn_id = @txn_id
                        )
                            begin
                                select '1' code, 
                                       'transaction not found' message, 
                                       null id;
                                return;
                        end;
                end;
                select '0' code, 
                       'nea' templatename, -- reciept template
                       ms.product_logo as servicelogourl, 
                       ms.product_label as servicetitle, 
                       ms.company as fullservicename,
                       --for nea
                       nea.nea_txn_id as receiptno, 
                       nea.office_code as officeid, 
                       nea.office as countername, 
                       nea.consumer_id as consumerid, 
                       nea.bill_date, 
                       nea.due_bill_of as duebillof, 
                       nea.no_of_days, 
                       nea.sc_no, 
                       nea.consumed_units as consumedunit, 
                       nea.payable_amt as payableamount, 
                       nea.rebate as rebate, 
                       nea.fine_rate as finerate, 
                       nea.payable_amt as payableamount, 
                       nea.service_charge as servicecharge, 
                       nea.total_due_amt as totaldueamt, 
                       nea.paid_amt as paidamount, 
                       nea.amount_due_left as amountdueleft, 
                       nea.customer_name as [name], 
                       dt.txn_id, 
                       dt.product_id, 
                       subscriber_no, 
                       amount, 
                       dt.service_charge, 
                       bonus_amt, 
                       dt.created_local_date as date, 
                       dt.created_nepali_date, 
                       dt.created_by, 
                       dt.status as [status], 
                       '1111' billno, 
                       '' logourlextra
                from tbl_transaction dt
                     join tbl_manage_services ms on ms.product_id = dt.product_id
                     left join tbl_transaction_detail_nea nea on nea.txn_id = dt.txn_id
                where dt.txn_id = @txn_id
                order by 1 desc;

              
        end; -- transaction reciept copy

		if @flag = 'p' -- pending txns
		begin
			select right('0000000000' + cast(dt.txn_id as varchar), 8) as txnid, 
			product_label, 
			grand_parent_id, 
			parent_id, 
			dt.agent_id, 
			subscriber_no, 
			amount, 
			status as txnstatus, 
			user_id, 
			created_local_date as txndate,
			agent_remarks
			from tbl_transaction dt
			left join tbl_transaction_commission dtc on dt.txn_id = dtc.txn_id
			left join tbl_transaction_detail dtd on dtd.txn_id = dt.txn_id
			where 1 = 1 
			and dt.status = 'Pending'
		end

    end;


GO
