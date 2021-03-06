USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_parse_air_ticket_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sproc_parse_air_ticket_detail]
(@flag             char(5), 
 @additional_value nvarchar(max), 
 @action_user      varchar(max)  = null, 
 @txn_id           int           = null, 
 @from_ip_address  varchar(100)  = null, 
 	@user_id varchar(100)  = null,
 @api_log_id       int           = null, 
 @gtw_txn_id       int           = null
)
as
    begin
        declare @xml_envelope varchar(500), @process_id varchar(50), @idoc int, @code int, @status varchar(100), @response_msg varchar(200);
        exec sp_xml_preparedocument 
             @idoc output, 
             @additional_value;
        if @flag = 'c'
            begin
                select *
                into #temp_airticketdetail
                from
                (
                    select *, 
                           'adult' paxtype
                    from openxml(@idoc, '/inputflightconfirmdomestic/adultpassengers/passenger', 4) with(process_id varchar(300) 'processid', code varchar(20) 'code', message varchar(500) 'message', out_bound_flight_id varchar(100) '../../outboundflightid', in_bound_flight_id varchar(100) '../../inboundflightid', contact_person varchar(100) '../../contactperson', contact_email varchar(50) '../../contactemail', contact_no varchar(50) '../../contactno', adult varchar(50) '../../adult', child varchar(50) '../../child', infant varchar(50) '../../infant', nationality varchar(50) '../../nationality', currency varchar(20) '../../currency', amount varchar(20) '../../amount', title varchar(100) 'title', last_name varchar(100) 'lastname', first_name varchar(200) 'firstname')
                    union all
                    select *, 
                           'child' paxtype
                    from openxml(@idoc, '/inputflightconfirmdomestic/childpassengers/passenger', 4) with(process_id varchar(300) 'processid', code varchar(20) 'code', message varchar(500) 'message', out_bound_flight_id varchar(100) '../../outboundflightid', inbound_flight_id varchar(100) '../../inboundflightid', contact_person varchar(100) '../../contactperson', contact_email varchar(50) '../../contactemail', contact_no varchar(50) '../../contactno', adult varchar(50) '../../adult', child varchar(50) '../../child', infant varchar(50) '../../infant', nationality varchar(50) '../../nationality', currency varchar(20) '../../currency', amount varchar(20) '../../amount', title varchar(100) 'title', last_name varchar(100) 'lastname', first_name varchar(200) 'firstname')
                ) a;
                exec sp_xml_removedocument 
                     @idoc;
                select @code = code, 
                       @response_msg = message
                from #temp_airticketdetail;
                if @code <> '000'
                    begin
                        select @code code, 
                               @response_msg message, 
                               null id;
                        return;
                end;

                --select * from #temp_airticketdetail
                insert into tbl_transaction_detail_flight_detail
                (outbound_flight_id, 
                 inbound_flight_id, 
                 adult_passenger, 
                 child_passenger, 
                 infant_passenger, 
                 txn_id, 
                 pax_id, 
                 tax_currency, 
                 contact_name, 
                 contact_email, 
                 contact_phone, 
                 title, 
                 first_name, 
                 last_name, 
                 nationality, 
                 process_id, 
                 user_id, 
                 created_by, 
                 created_local_date, 
                 created_UTC_date, 
                 created_nepali_date, 
                 created_ip
                )
                       select outbound_flight_id, 
                              inbound_flight_id, 
                              adult, 
                              child, 
                              infant, 
                              @txn_id, 
                              paxtype, 
                              'npr', 
                              contact_person, 
                              contact_email, 
                              contact_no, 
                              title, 
                              first_name, 
                              last_name, 
                              nationality, 
                              @process_id, 
                              @user_id, 
                              @action_user, 
                              getdate(), 
                              getutcdate(), 
                              [dbo].func_get_nepali_date(default), 
                              @from_ip_address
                       from #temp_airticketdetail;
                select '0' code, 
                       'flight detail inserted successfullt' message, 
                       null id;
        end;
        if @flag = 'u'
            begin
                select *
                into #temp_airticketbooking
                from openxml(@idoc, '/itinerary/ticket', 2) with(processid varchar(300) 'processid', code varchar(20) 'code', message varchar(500) 'message', airlinecode varchar(100) 'airlinecode', airlinename varchar(100) 'airlinename', pnrno varchar(100) 'pnrno', title varchar(100) 'title', gender varchar(100) 'gender', firstname varchar(200) 'firstname', lastname varchar(100) 'lastname', paxno varchar(100) 'paxno', paxtype varchar(100) 'paxtype', nationality varchar(50) 'nationality', paxid varchar(100) 'paxid', issuedate datetime 'issuedate', flightno varchar(100) 'flightno', flightdate datetime 'flightdate', departure varchar(100) 'departure', flighttime varchar(100) 'flighttime', ticketno varchar(100) 'ticketno', arrival varchar(100) 'arrival', arrivaltime varchar(100) 'arrivaltime', sector varchar(100) 'sector', classcode varchar(100) 'classcode', currency varchar(20) 'currency', fare decimal(18, 2) 'fare', surcharge varchar(100) 'surcharge', tax decimal(18, 2) 'tax', commission decimal(18, 2) 'commission', refundable varchar(100) 'refundable', reportingtime varchar(100) 'reportingtime', freebaggage varchar(100) 'freebaggage');

                --select * from #temp_airticketbooking
                --return
                exec sp_xml_removedocument 
                     @idoc;
                select @code = code, 
                       @response_msg = message
                from #temp_airticketbooking;
                if @code <> '000'
                    begin
                        select @code code, 
                               @response_msg message, 
                               null id;
                        return;
                end;
                update tbl_transaction_detail_flight_detail
                  set 
                      airline = ab.airline_name, 
                      pnr_no = ab.pnrno, 
                      gender = ab.gender, 
                      pax_no = ab.paxno, 
                      pax_type = ab.pax_type, 
                      pax_id = ab.paxid, 
                      flight_date = cast(ab.flight_date as varchar), 
                      ticket_commission = ab.commission, 
                      partner_txn_id = @gtw_txn_id, 
                      issued_date = ab.issuedate, 
                      flight_time = ab.flight_time, 
                      flight_no = ab.flight_no, 
                      departure_from = ab.departure, 
                      ticket_no = ab.ticket_no, 
                      arrival_to = ab.arrival, 
                      arrival_time = ab.arrival_time, 
                      ticket_fare = ab.fare, 
                      scharge = ab.surcharge, 
                      tax = ab.tax, 
                      reporting_time = ab.reporting_time, 
                      refundable = ab.refundable, 
                      free_baggage = ab.free_baggage, 
                      updated_by = @action_user, 
                      updated_local_date = getdate(), 
                      updated_nepali_date = [dbo].func_get_nepali_date(default), 
                      updated_UTC_date = getutcdate(), 
                      updated_ip = @from_ip_address
                from #temp_airticketbooking ab
                where txn_id = @txn_id;
        end;
    end;


GO
