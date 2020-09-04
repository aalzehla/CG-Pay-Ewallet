-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Alter PROCEDURE sproc_get_product_denomination 
	@flag char(3)=null,
	@extra1 varchar(50)=null,
	@extra2 varchar(50)=null

AS
BEGIN
Declare @sql varchar(max)
	if @flag='S'
	begin
		set @sql='Select denomination_label,amount from tbl_product_denomination where 1=1'
		if @extra1 is not null
		set @sql=@sql+' and product_id= '''+@extra1+''''

		if @extra2 is not null
		set @sql=@sql+' and amount= '''+@extra2+''''

		print(@sql)
		exec(@sql)
	end
END
GO
