USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_check_subscriber]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[func_check_subscriber]
(@subscriber_no varchar(25), 
 @productid    int
)
returns varchar(20)
as
     begin
         declare @is_numeric int, @str_len int, @rtn varchar(50), @ishex int;
         set @rtn = 'failed';
         set @subscriber_no = ltrim(rtrim(@subscriber_no));
         set @str_len = len(@subscriber_no);
         if @productid = 19 --dishhome
             begin
                 if @str_len < 1
                    or @str_len > 11
                     return 'failed';
                 select @is_numeric = case
                                         when @subscriber_no not like '%[^0-9]%'
                                         then 1
                                         else 0
                                     end;
                 if @is_numeric = 0
                     begin
                         if @str_len <> 10
                             return 'failed';
                             else
                             if left(@subscriber_no, 2) <> '0x'
                                and left(@subscriber_no, 2) <> '0c'
                                and left(@subscriber_no, 2) <> '07'
                                 return 'failed';
                                 else
                                 return 'chip';
                 end;
                     else
                     begin
                         if @str_len = 11
                            and left(@subscriber_no, 3) not in('719', '025')
                             return 'failed';
                             else
                             if @str_len = 11
                                and left(@subscriber_no, 3) in('719', '025')
                                 return 'cas';
                                 else
                                 if @str_len = 10
                                    and left(@subscriber_no, 3) = '070'
                                     return 'chip';
                                     else -- customer id
                                     return 'acc';
                 end;
                                 --return @rtn
         end;
         if @productid = 33 -- simtv
             begin
                 if @str_len <> 10
                    and @str_len <> 11
                    and @str_len <> 16
                     return 'failed';
                 select @is_numeric = case
                                         when @subscriber_no not like '%[^0-9]%'
                                         then 1
                                         else 0
                                     end;
                 if @is_numeric = 0
                     begin
                         if @str_len <> 16
                             return 'failed';
                         select @ishex = case
                                             when @subscriber_no not like '%[^0-9a-f]%'
                                             then 1
                                             else 0
                                         end;
                         if @ishex = 0
                             return 'failed';
                             else
                             return 'chip';
                 end;
                     else
                     begin
                         if @str_len <> 10
                            and @str_len <> 11
                             return 'failed';
                             else
                             if @str_len = 10
                                and left(@subscriber_no, 1) = '1'
                                 return 'cid';
                                 else
                                 if @str_len = 11
                                    and left(@subscriber_no, 1) = '0'
                                     return 'cas';
                                     else
                                     return 'failed';
                 end;
                                 --return @rtn
         end;
         return @rtn;
     end;


GO
