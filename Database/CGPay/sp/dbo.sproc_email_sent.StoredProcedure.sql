USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_email_sent]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sproc_email_sent] 
@flag varchar(3) = null
,@email_subject varchar(50)= null
,@email_text varchar(max)  =null
,@email_file_attached varchar(100) =null
,@notes_attachment varchar(100) =null
,@sent_by varchar(100) =null
,@sent_to varchar(100) =null
,@sent_to_cc varchar(100) =null
,@sent_to_bcc varchar(100) =null
,@email_send_status char(3) =null
,@active_flag char(3) =null
,@created_by  varchar(100) =null
,@created_ts datetime = null
,@updated_by varchar(100) =null
,@updated_ts datetime = null
,@txn_no  varchar(100) = null
as
begin
     if @flag='i'
     begin
             insert  into [tbl_email_request]            
                            (            
                                email_subject
                                ,email_text
                                ,email_send_by
                                ,email_send_to
                                ,email_send_to_cc
                                ,email_send_to_bcc
                                ,email_send_status
                                ,is_active
                                ,created_by
                                ,created_UTC_date
								,created_local_date
								,created_nepali_date

                                  
                            )            
                    values  (            
                              @email_subject,            
                              @email_text,            
                              @sent_by,   
                              @sent_to,           
                              @sent_to_cc,            
                              @sent_to_bcc,  
                             'n',
                             'y',
                             @created_by,
							 GETUTCDATE(),
                             getdate(),
							 dbo.func_get_nepali_date(default)

                            )   
     end
end


GO
