USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_encrypt_db]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[func_encrypt_db] (@str as Varchar(100))    
RETURNS varchar(100) AS    
BEGIN   
declare  @y varchar(100),@x as varchar(100)  
set @x=''  
declare  @i int  
set @i=1  
 while @i <= len(@str)  
 begin  
  set @y =  convert(varchar(10),Char(ASCII(SUBSTRING(@str, @i, 1)) + 25))  
  set @x=@x+@y  
  set @i=@i+1  
 END  
return (@x)  
end


GO
