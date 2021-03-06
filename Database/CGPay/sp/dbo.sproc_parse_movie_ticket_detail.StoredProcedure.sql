USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_parse_movie_ticket_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sproc_parse_movie_ticket_detail]
(@flag            char(5), 
 @additional_value nvarchar(max), 
 @action_user      varchar(max)  = null, 
 @txn_id           int           = null, 
 @from_ip_address   varchar(100)  = null, 
 @user_id          varchar(100)  = null, 
 @api_log_id        int           = null, 
 @gtw_txn_id         int           = null
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
                into #temp_movieticketdetail
                from
                (
                    select *, 
                           '000' code, 
                           'succesfully inserted' message
                    from openxml(@idoc, '/inputissuemovieticket/seats/movieselectedseat', 4) with(processid varchar(300) '../../processid', movieid varchar(100) '../../movieid', showid varchar(100) '../../showid', noofseat varchar(100) '../../noofseat', amount varchar(50) '../../amount', showdate varchar(100) '../../showdate', showtime varchar(50) '../../showtime', category varchar(100) 'category', seatid varchar(100) 'seatid', seatname varchar(200) 'seatname')
                ) a;
                exec sp_xml_removedocument 
                     @idoc;
                select @code = code, 
                       @response_msg = message
                from #temp_movieticketdetail;
                if @code <> '000'
                    begin
                        select @code code, 
                               @response_msg message, 
                               null id;
                        return;
                end;

                --select * from ##temp_movieticketdetail  
                insert into tbl_transaction_detail_movie
                (show_date, 
                 show_time, 
                 process_id, 
                 movie_id, 
                 show_id, 
                 gross_amount, 
                 category, 
                 seat_id, 
                 seat_name, 
                 no_of_seats, 
                 user_id, 
                 created_by, 
                 created_local_date, 
                 created_UTC_date, 
                 created_nepali_date, 
                 created_ip, 
                 txn_id
                )
                       select show_date, 
                              show_time, 
                              process_id, 
                              movie_id, 
                              show_id, 
                              amount, 
                              category, 
                              seat_id, 
                              seat_name, 
                              no_of_seats, 
                              @user_id, 
                              @action_user, 
                              getdate(), 
                              getutcdate(), 
                              [dbo].func_get_nepali_date(default), 
                              @from_ip_address, 
                              @txn_id
                       from #temp_movieticketdetail;
                select '0' code, 
                       'movie detail inserted successfullt' message, 
                       null id;
        end;
        if @flag = 'u'
            begin
                select *
                into #temp_movieticketbookingdetail
                from
                (
                    select *, 
                           '000' code, 
                           'succesfully updated' message
                    from openxml(@idoc, '/ticketdetail/tickets/ticket', 4) with(theatername varchar(300) '../../theatername', theateraddress varchar(100) '../../theateraddress', companyname varchar(100) '../../companyname', companyaddress varchar(100) '../../companyaddress', companyvat varchar(100) '../../companyvat', screenname varchar(50) '../../screenname', showdate varchar(100) '../../showdate', showtime varchar(50) '../../showtime', moviename varchar(100) '../../moviename', movienationality varchar(100) '../../movienationality', moviegenre varchar(100) '../../moviegenre', ticketurl varchar(100) '../../ticketurl', seat varchar(100) 'seat', category varchar(100) 'category', invoicedatetime varchar(200) 'invoicedatetime', showdatetime varchar(200) 'showdatetime', qrbarcode varchar(200) 'qrbarcode', invoicenumber varchar(200) 'invoicenumber', entrancefee varchar(200) 'entrancefee', netfee varchar(200) 'netfee', fdtax varchar(200) 'fdtax', vat varchar(200) 'vat', luxury varchar(200) 'luxury', luxurynet varchar(200) 'luxurynet', luxuryvat varchar(200) 'luxuryvat', charge3d varchar(200) 'charge3d', charge3dnet varchar(200) 'charge3dnet', charge3dvat varchar(200) 'charge3dvat', servicecharge varchar(200) 'servicecharge', localcharge varchar(200) 'localcharge', grossamount varchar(200) 'grossamount', paymentmode varchar(200) 'paymentmode', gatewaycharge varchar(200) 'gatewaycharge')
                ) a;

                --select * from #temp_airticketbooking
                --return
                exec sp_xml_removedocument 
                     @idoc;
                select @code = code, 
                       @response_msg = message
                from #temp_movieticketbookingdetail;
                if @code <> '000'
                    begin
                        select @code code, 
                               @response_msg message, 
                               null id;
                        return;
                end;
                update tbl_transaction_detail_movie
                  set 
                      theater_name = ab.theater_name, 
                      theater_address = ab.theater_address, 
                      company_name = ab.company_name, 
                      company_address = ab.company_address, 
                      compant_vat_no = ab.compant_vat_no, 
                      screen_name = ab.screen_name, 
                      show_date = ab.show_date, 
                      show_time = cast(ab.show_time as varchar), 
                      movie_name = ab.movie_name, 
                      movie_genre = ab.movie_genre, 
                      movie_nationality = ab.movie_nationality, 
                      ticket_url = ab.ticket_url, 
                      seat_id = ab.seat_id, 
                      category = ab.category, 
                      invoice_date = ab.invoice_date, 
                      show_date_time = ab.show_date_time, 
                      qr_bar_code = ab.qr_bar_code, 
                      invoice_number = ab.invoice_number, 
                      entrance_fee = ab.entrance_fee, 
                      net_fee = ab.net_fee, 
                      fd_tax = ab.fd_tax, 
                      vat = ab.vat, 
                      luxury = ab.luxury, 
                      luxury_net = ab.luxury_net, 
                      luxury_vat = ab.luxury_vat, 
                      charge_3d = ab.charge_3d, 
                      charge_3d_net = ab.charge_3d_net, 
                      charge_3d_vat = ab.charge_3d_vat, 
                      service_charge = ab.service_charge, 
                      local_charge = ab.local_charge, 
                      gross_amount = ab.gross_amount, 
                      payment_mode = ab.payment_mode, 
                      gateway_charge = ab.gateway_charge, 
                      updated_by = @action_user, 
                      updated_local_date = getdate(), 
                      updated_nepali_date = [dbo].func_get_nepali_date(default), 
                      updated_UTC_date = getutcdate(), 
                      updated_ip = @from_ip_address
                from #temp_movieticketbookingdetail ab
                where txn_id = @txn_id;
        end;
    end;  


GO
