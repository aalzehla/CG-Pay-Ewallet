USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_get_nepali_date]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_get_nepali_date] (@EnglishDate DATE=null)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @BS_Year INT
		,@BS_Month VARCHAR(2)
		,@NpDay VARCHAR(2)
		,@EngDay DATE
		,@DayDiff INT
		,@DayName INT
		,@Result VARCHAR(50)
	set @EnglishDate=isnull(@EnglishDate,getdate())
	SELECT @EngDay = english_date
		,@BS_Year = nepali_year
		,@BS_Month = nepali_month
	FROM dbo.tbl_date_log(NOLOCK)
	WHERE DATEDIFF(DAY, english_date, @EnglishDate) >= 0
	ORDER BY english_date;

	SELECT @DayDiff = DATEDIFF(DAY, @EngDay, @EnglishDate);

	SELECT @NpDay = 1 + @DayDiff;

	SET @NpDay = REPLICATE('0', 2 - LEN(@NpDay)) + @NpDay;
	SET @BS_Month = REPLICATE('0', 2 - LEN(@BS_Month)) + @BS_Month;
	SET @Result = CONVERT(VARCHAR(4), @BS_Year) + '-' + CONVERT(VARCHAR(2), @BS_Month) + '-' + CONVERT(VARCHAR(2), @NpDay);

	RETURN (@Result);
END;


GO
