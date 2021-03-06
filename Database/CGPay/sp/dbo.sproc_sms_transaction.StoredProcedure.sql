USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_sms_transaction]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
create   procedure [dbo].[sproc_sms_transaction]  
(@flag             varchar(3),   
 @sms_country          varchar(100)  = null,   
 @sms_destination_no      varchar(20)   = null,   
 @sms_sender_id         varchar(20)   = null,   
 @message          nvarchar(max) = null,   
 @gateway_message_id varchar(100) null,   
 @status           varchar(20)   = null,   
 @agent_id          int           = null,   
 @created_by        varchar(20)   = null,   
 @created_ip        varchar(100)  = null  
)  
as  
    begin  
	declare @sms_operator_id int,@gateway_id int

        if @flag = 'i'  
            begin  
                insert into tbl_sms_transaction  
                (country,   
                 sms_operator_id,   
                 sms_destination,   
                 sms_sender_id,   
                 sms_message_type,   
                 [message],   
                 sms_gateway_message_id,   
                 status,   
                 agent_id,   
                 created_by,   
                 created_date,   
                 sms_gateway_id
                )  
                values  
                (@sms_country,   
                 @sms_operator_id,   
                 @sms_destination_no,   
                 @sms_sender_id,   
                 1,   
                 @message,   
                 @gateway_message_id,   
                 @status, 
				 @agent_id,
                 @created_by,   
                 getutcdate(),
				 @gateway_id   
                );  
        end;  
    end;  

GO
