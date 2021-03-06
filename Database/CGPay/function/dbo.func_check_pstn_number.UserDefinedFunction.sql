USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_check_pstn_number]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[func_check_pstn_number]
(@subscriber varchar(100), 
 @product    varchar(10)
)
returns varchar(20)
as
     begin
         declare @area_codes varchar(1000), @rtn varchar(50), @is_num int;
         declare @result table([value] varchar(50));
         set @rtn = 'failed';
         if len(@subscriber) <> 9 -- if not 9 digit
             return 'failed';
         select @is_num = case
                             when @subscriber not like '%[^0-9]%'
                             then 1
                             else 0
                         end;
         if @is_num = 0 -- if not numeric
             return 'failed';

         -- total area code of nepal
         set @area_codes = '01,010,011,019,021,023,024,025,026,027,029,031,033,035,036,037,038,041,044,046,047,048,049,051,053,055,056,057,061,063,064,065,066,067,068,069,071,075,076,077,078,079,081,082,083,084,086,087,088,088,089,091,092,093,094,095,096,097,099';
         insert into @result([value])
                select distinct 
                       [value]
                from dbo.func_comma_to_table(@area_codes);
         if @product = 'nt'
             begin
                 if exists
                 (
                     select *
                     from @result
                     where substring(@subscriber, 1, len([value]) + 1) = [value] + '4'
                           or substring(@subscriber, 1, len([value]) + 1) = [value] + '5'
                           or substring(@subscriber, 1, len([value]) + 1) = [value] + '6'
                 )
                     begin
                         --if exists (select * from @result where 
                         --substring(@subscriber,1,len([value])+2)=[value]+'69' or
                         --substring(@subscriber,1,len([value])+2)=[value]+'62')
                         -- return 'failed'
                         --else
                         return 'success';
                 end;
                     else
                     return 'failed';
         end;
             else
             if @product = 'utl'
                 begin
                     if exists
                     (
                         select *
                         from @result
                         where substring(@subscriber, 1, len([value]) + 1) = [value] + '2'
                     )
                         return 'success';
                         else
                         return 'failed';
             end;
                 else
                 return 'failed';
         return @rtn;
     end;


GO
