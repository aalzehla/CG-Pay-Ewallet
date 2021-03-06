USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_split_comma_seperated_values]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[func_split_comma_seperated_values]  
(@list AS VARCHAR(max))  
RETURNS @items TABLE (item VARCHAR(max) Not Null)  
AS  
BEGIN  
 DECLARE @item AS VARCHAR(max), @Pos AS INT  
  
 WHILE DATALENGTH(@list)>0  
 BEGIN  
  SET @Pos=CHARINDEX(',',@list)  
     
  IF @Pos=0 SET @Pos=DATALENGTH(@List)+1  
   SET @Item =  LTRIM(RTRIM(LEFT(@list,@Pos-1)))  
  IF @item<>'' INSERT INTO @items SELECT @item  
   SET @List=SUBSTRING(@list,@Pos+DATALENGTH(','),8000)  
 END  
  
 RETURN  
END  


GO
