USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_check_mobile_number]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_check_mobile_number]
(@subscriber varchar(100), 
 @product_id  varchar(10)
)
returns varchar(20)
as
     begin
         declare @rtn varchar(50), @is_num int, @prefix varchar(1000);
         declare @result table([value] varchar(50));
         set @rtn = 'failed';
         if len(@subscriber) <> 10 -- if not 9 digit
             return 'failed';
         select @is_num = case
                             when @subscriber not like '%[^0-9]%'
                             then 1
                             else 0
                         end;
         if @is_num = 0 -- if not numeric
             return 'failed';

         -- mobile number prefixes
         set @prefix = '984,986,980,981,982,972,961,962,988,989,974,976,975';
         insert into @result([value])
                select distinct 
                       [value]
                from dbo.[func_comma_to_table](@prefix);

         -- check prefix for subscriber
         if left(@subscriber, 3) not in(select [value]
                                        from @result)
             begin
                 return 'failed';
         end;
             else
             if @product_id = 1
                and left(@subscriber, 3) not in(select [value]
                                                from @result)
                 return 'failed';
         return @rtn;
     end;


GO
