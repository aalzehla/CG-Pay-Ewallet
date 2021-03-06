USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_api_log_report]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sproc_api_log_report] @flag       VARCHAR(10) = NULL, 
                                                       @api_log_id VARCHAR(20) = NULL, 
                                                       @from_date  VARCHAR(20) = NULL, 
                                                       @to_date    VARCHAR(20) = NULL
AS
     DECLARE @sql VARCHAR(MAX);
    BEGIN
	
  if @from_date is null 
  begin
	set @from_date =  Convert(date,(DATEADD(Hour,-1, GETDATE())),120)-- as varchar)
  end
  else
  begin
	set @from_date = convert(date, @from_date, 120)
  end

  if @to_date is null
  begin
	set @to_date = Convert(date,(DATEADD(hour,0,GETDATE())),120)-- as varchar)
  end
  else
  begin
	set @to_date = convert(date, @to_date, 120)
  end
			
        IF @flag = 's'
            BEGIN
                SET @sql = 'select case when ar.authorization_token is null then al.user_id
		else ud.user_name end as user_id ,al.api_log_id, al.function_ame, al.created_local_date,al.created_UTC_date, al.created_ip, al.txn_id, al.api_request, al.api_response 
							from tbl_api_log al
							left join tbl_authorization_request ar
							on al.user_id = ar.authorization_token
							left join tbl_user_detail ud 
							on  ar.request_user = ud.user_id where 1=1';
                IF(@api_log_id IS NOT NULL)
                    BEGIN
                        SET @sql = @sql + ' and al.api_log_id = ''' + @api_log_id + '''';
                END;
                IF(@from_date IS NOT NULL
                   AND @to_date IS NOT NULL)
                    BEGIN
                        SET @sql = @sql + ' and al.created_local_date between ''' + @from_date + ''' and ''' + @to_date + ' 23:59:59.997'''
						set @sql += ' order by al.created_local_date desc'
                END;
                PRINT @sql;
                EXEC (@sql);
        END;
    END;


GO
