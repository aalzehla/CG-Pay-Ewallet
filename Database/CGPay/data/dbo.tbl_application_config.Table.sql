USE [Wepaynepal]
GO
SET IDENTITY_INSERT [dbo].[tbl_application_config] ON 

INSERT [dbo].[tbl_application_config] ([id], [config_label], [config_value], [config_value1], [config_value2], [config_value3], [config_value4], [config_value5], [created_by], [created_ts], [updated_by], [updated_ts]) VALUES (1, N'Authorisation', N'wePayApiUser', N'wePayAp1us3r@20', N'73FF9B25E1064EBE884611EB038D997B-81F971764D1E451ABCE25C281A1E5810==', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbl_application_config] OFF
