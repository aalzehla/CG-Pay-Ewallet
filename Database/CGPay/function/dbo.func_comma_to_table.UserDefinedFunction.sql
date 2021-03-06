USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_comma_to_table]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_comma_to_table]
(@str_string varchar(max)
)
returns @result table(value varchar(50))
as
     begin
         declare @x xml;
         select @x = cast('<a>' + replace(@str_string, ',', '</a><a>') + '</a>' as xml);
         insert into @result
                select t.value('.', 'varchar(50)') as result
                from @x.nodes('/a') as x(t);
         update @result
           set 
               [value] = ltrim(rtrim([value]));
         delete from @result
         where ltrim(rtrim([value])) = '';
         return;
     end; 


GO
