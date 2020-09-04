USE [WePayNepal]
GO

INSERT INTO [dbo].[tbl_kyc_documents]
           ([agent_id]
           ,[Identification_type]
           ,[Identification_NO]
           ,[Identification_issued_date]
           ,[Identification_expiry_date]
           ,[Identification_issued_place]
           ,[Identification_photo_Logo]
           ,[Id_document_front]
           ,[Id_document_back]
           ,[KYC_Verified]
           ,[created_by]
           ,[created_UTC_date]
           ,[created_local_date]
           ,[created_nepali_date])
     VALUES
           (1000
           ,'ctizenship'
           ,12345
           ,GETDATE()
           ,GETDATE()
           ,'Kathmandu'
           ,'Logo'
           ,'Front'
           ,'Back'
           ,'T'
           ,'Admin'
           ,GETDATE()
           ,GETDATE()
           ,GETDATE())
GO


