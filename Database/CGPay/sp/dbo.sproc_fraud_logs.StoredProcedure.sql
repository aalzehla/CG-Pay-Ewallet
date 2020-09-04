USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_fraud_logs]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sproc_fraud_logs]
@flag char(5),
@User_id varchar (50) =  null,
@function_id varchar(50) =  null,
@log_Type varchar(max) =  null,
@Ip_Address varchar(50) =  null,
@browser varchar(100) =  null
as
Begin
	if @flag = 'i'
	Begin
		Select '1' Code, 'Fraud Authorisation Log' Message, null id
		return
	End
End


GO
