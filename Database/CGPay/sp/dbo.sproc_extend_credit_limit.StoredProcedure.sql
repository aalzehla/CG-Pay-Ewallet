USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_extend_credit_limit]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sproc_extend_credit_limit] 
	-- Add the parameters for the stored procedure here
	@flag char(3),
	@agent_id int = null,
	@user_id  int =  null,
	@credit_limit decimal(18,2) = null,
	@remarks varchar(500) =  null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @current_credit_limit decimal(18,2)
    -- Insert statements for procedure here

	if not exists(select 'x' from tbl_agent_detail where agent_id = @agent_id)
	begin
		select 1 code, 'Agent Not Found' message, null id
		return
	end	


	if @credit_limit is not null
	begin
		if @credit_limit < 0
		begin
			if  @credit_limit <> '-1' 
			begin
				select '1' code, 'Invalid Credit Limit' message, null id
				return
			end
		end
	end

	if exists(select 'x' from tbl_agent_detail where agent_id = @agent_id and agent_credit_limit  = '-1')
	begin
		select '1' code, 'Cannot extend credit limit, Already set as ''-1''' message , null id
		return
	end


	if @flag = 'c' --chk current credit limit
	begin
		select isnull(agent_credit_limit,0) from tbl_agent_detail where agent_id = @agent_id
	end



	if @flag = 'e' --extend credit limit
	begin
		update tbl_agent_detail set agent_credit_limit = isnull(agent_credit_limit,0) + @credit_limit where agent_id = @agent_id	
	end



END


GO
