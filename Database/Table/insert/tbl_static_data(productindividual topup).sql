USE [CGPay]
GO

INSERT INTO [dbo].[tbl_static_data]
           ([sdata_type_id]
           ,[static_data_value]
           ,[static_data_label]
           ,[static_data_description]
           ,[additional_value1]
           )
     VALUES
           (18,'22','GSM','GSM PRODUCTS','/Client/Payment/NTPre'),
		   (18,'23','GSM','GSM PRODUCTS','/Client/Payment/NTPost'),
		   (18,'24','GSM','GSM PRODUCTS','/Client/Payment/NTCdmaPre'),
		   (18,'25','GSM','GSM PRODUCTS','/Client/Payment/NTCdmaPost'),
		   (18,'26','GSM','GSM PRODUCTS','/Client/Payment/Ncell'),
		   (18,'27','GSM','GSM PRODUCTS','/Client/Payment/SmartCell'),
		   (18,'28','GSM','GSM PRODUCTS','/Client/Payment/UTL')
GO


