USE [Wepaynepal]
GO
SET IDENTITY_INSERT [dbo].[tbl_app_version_control] ON 

INSERT [dbo].[tbl_app_version_control] ([vid], [app_platform], [app_version], [is_major_update], [is_minor_update], [created_by], [created_local_date], [created_utc_date], [created_nepali_date], [created_ip], [app_update_info]) VALUES (1, N'IOS', N'avp', N'Y  ', N'Y  ', N'superadmin', CAST(N'2020-06-08 17:28:29.997' AS DateTime), CAST(N'2020-06-08 11:43:29.997' AS DateTime), N'2077-02-26', N'::1', N'upi')
INSERT [dbo].[tbl_app_version_control] ([vid], [app_platform], [app_version], [is_major_update], [is_minor_update], [created_by], [created_local_date], [created_utc_date], [created_nepali_date], [created_ip], [app_update_info]) VALUES (2, N'Android', N'test', N'Y  ', N'Y  ', N'superadmin', CAST(N'2020-06-11 03:06:02.810' AS DateTime), CAST(N'2020-06-10 21:21:02.810' AS DateTime), N'2077-02-29', N'27.34.26.1', N'testing')
SET IDENTITY_INSERT [dbo].[tbl_app_version_control] OFF
