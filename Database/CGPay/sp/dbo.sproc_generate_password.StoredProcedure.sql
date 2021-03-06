USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_generate_password]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sproc_generate_password] (  @password VARCHAR(8000)=''  output,  
 @UpperCaseItems SMALLINT = 0    
 ,@LowerCaseItems SMALLINT = 0    
 ,@NumberItems SMALLINT = 0    
 ,@SpecialItems SMALLINT = 0    
   
 )    
AS    
SET NOCOUNT ON    
    
IF nullif(@UpperCaseItems, 0) IS NULL    
 SET @UpperCaseItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
    
IF nullif(@LowerCaseItems, 0) IS NULL    
 SET @LowerCaseItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
    
IF nullif(@NumberItems, 0) IS NULL    
 SET @NumberItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
    
IF nullif(@SpecialItems, 0) IS NULL    
 SET @SpecialItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
    
IF @UpperCaseItems + @LowerCaseItems + @NumberItems + @SpecialItems < 8    
BEGIN    
 SET @UpperCaseItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
 SET @LowerCaseItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
 SET @NumberItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
 SET @SpecialItems = FLOOR(RAND() * (11 - 9 + 1)) + 1    
END    
    
DECLARE @UpperCase VARCHAR(26)    
 ,@LowerCase VARCHAR(26)    
 ,@Numbers VARCHAR(10)    
 ,@Special VARCHAR(13)    
 ,@Temp VARCHAR(8000)    
 ,@i SMALLINT    
 ,@c VARCHAR(1)    
 ,@v TINYINT    
    
-- Set the default items in each group of characters    
SELECT @UpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    
 ,@LowerCase = 'abcdefghijklmnopqrstuvwxyz'    
 ,@Numbers = '0123456789'    
 ,@Special = '!@#$+'    
 ,@Temp = ''    
 ,@Password = ''    
    
-- Enforce some limits on the length of the password    
IF @UpperCaseItems > 20    
 SET @UpperCaseItems = 20    
    
IF @LowerCaseItems > 20    
 SET @LowerCaseItems = 20    
    
IF @NumberItems > 20    
 SET @NumberItems = 20    
    
IF @SpecialItems > 20    
 SET @SpecialItems = 20    
-- Get the Upper Case Items    
SET @i = ABS(@UpperCaseItems)    
    
WHILE @i > 0    
 AND LEN(@UpperCase) > 0    
 SELECT @v = ABS(CAST(CAST(NEWID() AS BINARY (16)) AS BIGINT)) % LEN(@UpperCase) + 1    
  ,@c = SUBSTRING(@UpperCase, @v, 1)    
  ,@UpperCase = CASE     
   WHEN @UpperCaseItems < 0    
    THEN STUFF(@UpperCase, @v, 1, '')    
   ELSE @UpperCase    
   END    
  ,@Temp = @Temp + @c    
  ,@i = @i - 1    
    
-- Get the Lower Case Items    
SET @i = ABS(@LowerCaseItems)    
    
WHILE @i > 0    
 AND LEN(@LowerCase) > 0    
 SELECT @v = ABS(CAST(CAST(NEWID() AS BINARY (16)) AS BIGINT)) % LEN(@LowerCase) + 1    
  ,@c = SUBSTRING(@LowerCase, @v, 1)    
  ,@LowerCase = CASE     
   WHEN @LowerCaseItems < 0    
    THEN STUFF(@LowerCase, @v, 1, '')    
   ELSE @LowerCase    
   END    
  ,@Temp = @Temp + @c    
  ,@i = @i - 1    
    
-- Get the Number Items    
SET @i = ABS(@NumberItems)    
    
WHILE @i > 0    
 AND LEN(@Numbers) > 0    
 SELECT @v = ABS(CAST(CAST(NEWID() AS BINARY (16)) AS BIGINT)) % LEN(@Numbers) + 1    
  ,@c = SUBSTRING(@Numbers, @v, 1)    
  ,@Numbers = CASE     
   WHEN @NumberItems < 0    
    THEN STUFF(@Numbers, @v, 1, '')    
   ELSE @Numbers    
   END    
  ,@Temp = @Temp + @c    
  ,@i = @i - 1    
    
-- Get the Special Items    
SET @i = ABS(@SpecialItems)    
    
WHILE @i > 0    
 AND LEN(@Special) > 0    
 SELECT @v = ABS(CAST(CAST(NEWID() AS BINARY (16)) AS BIGINT)) % LEN(@Special) + 1    
  ,@c = SUBSTRING(@Special, @v, 1)    
  ,@Special = CASE     
   WHEN @SpecialItems < 0    
    THEN STUFF(@Special, @v, 1, '')    
   ELSE @Special    
   END    
  ,@Temp = @Temp + @c    
  ,@i = @i - 1    
    
-- Scramble the order of the selected items    
WHILE LEN(@Temp) > 0    
 SELECT @v = ABS(CAST(CAST(NEWID() AS BINARY (16)) AS BIGINT)) % LEN(@Temp) + 1    
  ,@Password = @Password + SUBSTRING(@Temp, @v, 1)    
  ,@Temp = STUFF(@Temp, @v, 1, '')    
    
IF len(@password) < 8    
BEGIN    
 EXEC sproc_generate_password @UpperCaseItems = @UpperCaseItems    
  ,@LowerCaseItems = @LowerCaseItems    
  ,@NumberItems = @NumberItems    
  ,@SpecialItems = @SpecialItems     
  ,@password=@password output   
return  
END    


GO
