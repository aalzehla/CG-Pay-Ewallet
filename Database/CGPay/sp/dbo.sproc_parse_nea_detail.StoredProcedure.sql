USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_parse_nea_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sproc_parse_nea_detail]
(@additional_value nvarchar(max), 
 @action_user      varchar(max)  = null, 
 @txn_id           int           = null, 
 @from_ip_address   varchar(100)  = null, 
 @user_id          int           = null
)
as
    begin
        declare @xml_envelope varchar(500), @process_id varchar(50), @idoc int, @code int, @status varchar(100), @response_msg varchar(200);
        exec sp_xml_preparedocument 
             @idoc output, 
             @additional_value;
        select *
        into #temp_neacustomerbill_info
        from openxml(@idoc, 'envelope/body/getneabillresponse/getneabillresult', 4) with(processid varchar(300) 'processid', code varchar(20) 'code', message varchar(500) 'message', scno varchar(100) 'scno', customername varchar(100) 'customername', duebillof varchar(100) 'duebillof', payableamount varchar(50) 'payableamount', consumerid varchar(50) 'consumerid', officecode varchar(50) 'officecode', office varchar(50) 'office', billdate varchar(50) 'billdate', noofdays varchar(20) 'noofdays', billamt varchar(20) 'billamt', finerate varchar(100) 'finerate', rebate varchar(100) 'rebate', totaldueamount varchar(200) 'totaldueamount', servicecharge varchar(100) 'servicecharge');
        exec sp_xml_removedocument 
             @idoc;
        select @code = code, 
               @response_msg = message
        from #temp_neacustomerbill_info;
        if @code <> '000'
            begin
                select @code code, 
                       @response_msg message;
                return;
        end;

        -- select @processid = process_id from tbl_log where sno=@txnid
        --select * from dtatransactiondetailnea
        insert into tbl_transaction_detail_nea
        (sc_no, 
         consumer_id, 
         customer_name, 
         office_code, 
         office, 
         bill_date, 
         due_bill_of, 
         no_of_days, 
         bill_amt, 
         payable_amt, 
         fine_rate, 
         rebate, 
         service_charge, 
         total_due_amt, 
         process_id, 
         nea_response_code, 
         nea_message, 
         user_id, 
         created_local_date, 
         created_UTC_date, 
         created_nepali_date, 
         created_by, 
         created_ip
        )
               select sc_no, 
                      consumer_id, 
                      customer_name, 
                      office_code, 
                      office, 
                      bill_date, 
                      due_bill_of, 
                      no_of_days, 
                      bill_amt, 
                      payable_amount, 
                      fine_rate, 
                      rebate, 
                      service_charge, 
                      total_due_amount, 
                      @process_id, 
                      code, 
                      message, 
                      @user_id, 
                      getdate(), 
                      getutcdate(), 
                      [dbo].func_get_nepali_date(default), 
                      @action_user, 
                      @from_ip_address
               from #temp_neacustomerbill_info;
    end;


GO
