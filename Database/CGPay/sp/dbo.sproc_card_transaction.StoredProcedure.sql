USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_card_transaction]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sproc_card_transaction] 
	@flag char(3),
	@agent_id int  = null,
	@user_id int  =  null,
	@user_email varchar(512) = null,
	@user_mobile_no varchar(512) = null,
	@action_user varchar(512) = null,
	@action_ip varchar(51) = null,
	@card_no varchar(512) = null,
	@amount decimal(18,2) =  null
AS
BEGIN
	select * from tbl_agent_card_management order by 1 desc
	select * from tbl_static_data where sdata_type_id = 23

	Declare @card_type_label varchar(512), @card_type int
	--gift card : 2

	if @card_no  is null
	begin
		select '1' code, 'Card Number is required' message, null id
		return
	end

	if not exists(select 'x' from tbl_agent_card_management where card_no = @card_no and isnull(is_active,'n') = 'y')
	begin
		select '1' code, 'Card doesn''t exist' message,null id
		return
	end

	if not exists(select 'x' from tbl_agent_card_management where card_no = @card_no and agent_id = @agent_id )
	begin
		select '1' code, 'Invalid Card Number' message, null id
		return
	end

	select @card_type_label = sd.static_data_label, @card_type = ac.card_type
	from tbl_agent_card_management ac
	join tbl_static_data sd on sd.static_data_value = ac.card_type	
	where card_no = @card_no and agent_id  = @agent_id and isnull(is_active,'n') = 'y' 
	and sd.sdata_type_id = 23

	if @card_type = 2
	begin
		update tbl_agent_card_management set is_active = 'y' where card_no = @card_no and agent_id = @agent_id
		select '0' code, 'Gift Card Successfully Used' message, null id
		return
	end

	if @card_type = 4
	begin
		update tbl_agent_card_management set Amount = Amount - @amount where card_no = @card_no and agent_id = @agent_id
		select '0' code, 'Prepaid Card Successfully Used for Amount: '+cast(@amount as varchar) + ' NPR' message, null id
		return
	end


END


GO
