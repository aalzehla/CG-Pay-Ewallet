USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiProc_Get_balance]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[apiProc_Get_balance] @flag CHAR(3)
	,@token VARCHAR(1000) = NULL
	,@username VARCHAR(100) = NULL
AS
BEGIN
	DECLARE @userId INT
		,@availableBalance DECIMAL(18, 2)

	--if @token is null and @username is null
	--begin
	--	SELECT '100' code
	--		,'Token is required' message
	--	return
	--end
	IF @username IS NULL
	BEGIN
		SELECT '100' code
			,'Required fields are missing' message

		RETURN
	END

	--select @userId=request_user
	--from tbl_authorization_request
	--where authorization_token=@token and status='y'
	SELECT @userId = User_id
	FROM tbl_user_detail ud
	left JOIN tbl_agent_Detail ad ON ad.agent_id = ud.agent_id
	WHERE ud.user_mobile_no = @username
		OR ud.user_email = @username
		or ud.user_name =@username

	-- SET NOCOUNT ON added to prevent extra result sets from  
	IF @flag = 'gt'
	BEGIN
		IF @userId IS NULL
		BEGIN
			SELECT '100' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @availableBalance = available_balance
			FROM tbl_user_detail ud
			JOIN tbl_agent_Detail ad ON ad.agent_id = ud.agent_id
			WHERE ud.user_id = @userId

			SELECT '0' code
				,'Successfully retrieved current balance' message
				,isnull(@availableBalance, 0) balance_amount
				,@userId id

			RETURN
		END
	END
END


GO
