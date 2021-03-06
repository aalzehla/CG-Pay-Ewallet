USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_static_services_info]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sproc_static_services_info] @flag varchar(20) = null
as
    begin
        if(@flag = 'fundload')
            begin
                select '/client/fundload/ebanking' [url], 
                       'internet.png' imagesrc, 
                       'e-banking' title, 
                       'y' status
                union all
                select '/client/fundload/mobilebanking' [url], 
                       'mobilebankin.png' imagesrc, 
                       'mobile banking' title, 
                       'y' status
                union all
                select '#modal' [url], 
                       'nchl.png' imagesrc, 
                       'connect ips' title, 
                       'y' status
                union all
                select '/client/fundload/viacard' [url], 
                       'loadviacard.png' imagesrc, 
                       'card (visa / sct)' title, 
                       'y' status
                union all
                select '/client/fundload/remittance' [url], 
                       'remittance.png' imagesrc, 
                       'remittance payment' title, 
                       'y' status
               
                return;
        end;
    end;


GO
