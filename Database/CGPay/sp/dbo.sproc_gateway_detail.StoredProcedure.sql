USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_gateway_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[sproc_gateway_detail] @flag            CHAR(3),   
                                          @gateway_id       VARCHAR(20)   = NULL,   
                                          @gateway_name            NVARCHAR(100) = NULL,   
                                          @gateway_balance         MONEY         = NULL,   
                                          @gateway_country         VARCHAR(50)   = NULL,   
                                          @gateway_currency        CHAR(3)       = NULL,   
                                          @gateway_user_name     VARCHAR(500)   = NULL,   
                                          @gateway_password     VARCHAR(500)  = NULL,   
                                          @gateway_access_code   VARCHAR(500)  = NULL,   
                                          @gateway_security_code VARCHAR(500)  = NULL,   
                                          @gateway_api_token     VARCHAR(500)  = NULL,   
                                          @gateway_url          NVARCHAR(500) = NULL,   
                                          @gateway_status          CHAR(3)       = NULL,  
										  @gateway_type       CHAR(3)       = NULL,  
                                          @gateway_contact  NVARCHAR(100) = NULL,   
                                          @is_direct_gateway CHAR(3)       = NULL,   
                                          @action_user      VARCHAR(20)   = NULL,   
                                          @from_date        VARCHAR(20)   = NULL,   
                                          @to_date          VARCHAR(20)   = NULL,   
                                          @remarks         VARCHAR(5000) = NULL,   
                                          @from_ip_address   VARCHAR(20)   = NULL,   
                                          @transaction_date DATETIME      = NULL,   
                                          @page_size        VARCHAR(5)    = 10,   
                                          @search          VARCHAR(MAX)  = NULL  
AS  
    BEGIN  
        SET NOCOUNT ON;  
        BEGIN TRY  
            DECLARE @new_gateway_id VARCHAR(25), @desc VARCHAR(MAX), @sql VARCHAR(MAX);  
            DECLARE @prefix VARCHAR(10)= 'gtw';  
            DECLARE @id VARCHAR;  
            IF @flag = 'i'  
                BEGIN  
                    IF EXISTS  
                    (  
                        SELECT 'x'  
                        FROM tbl_gateway_detail  
                        WHERE gateway_id = @gateway_id  
                    )  
                        BEGIN  
                            SELECT '1' code,   
                                   'gateway already exists' message,   
                                   NULL id;  
                    END;  
                        ELSE  
                        INSERT INTO [dbo].tbl_gateway_detail  
                        (gateway_name,   
                         gateway_balance,   
                         gateway_country,   
                         gateway_currency,   
                         gateway_username,   
                         gateway_access_code,   
                         gateway_password,   
                         gateway_security_code,   
                         gateway_api_token,   
                         gateway_url,   
                         gateway_status,  
						 gateway_type,
						 is_direct_gateway,
						 created_ip,
                         created_by,   
                         created_local_date,   
                         created_nepali_date,   
                         created_UTC_date  
                        )  
                        --,fromipaddress  
                        VALUES  
                        (@gateway_name,   
                         ISNULL(@gateway_balance, 0),   
                         @gateway_country,   
                         'NPR',   
                         @gateway_user_name,   
                         @gateway_access_code,   
                         @gateway_password,   
                         @gateway_security_code,   
                         @gateway_api_token,   
						 @gateway_url,   
                         @gateway_status,  
						 @gateway_type,
						 @is_direct_gateway,
						 @from_ip_address,
                         @action_user,   
                         GETDATE(),   
                         [dbo].func_get_nepali_date(DEFAULT),   
                         GETUTCDATE()  
                        );  
  
                    --,@fromipaddress  
                    SELECT '0' code,   
                           'gateway added succesfully' message,   
                           NULL;  
                    RETURN;  
            END; -- new gteway add  
  
            IF @flag = 'st'  
                BEGIN  
                    IF NOT EXISTS  
                    (  
                        SELECT 'x'  
                        FROM tbl_gateway_detail  
                        WHERE gateway_id = @gateway_id  
                    )  
                        BEGIN  
                            SELECT '1' code,   
                                   'gateway doesn''t exist' message,   
                                   NULL id;  
                            RETURN;  
                    END;  
                        ELSE  
                        BEGIN  
                            UPDATE [dbo].tbl_gateway_detail  
                              SET   
                                  gateway_status = ISNULL(@gateway_status, gateway_status),   
								  updated_ip=ISNULL(@from_ip_address, updated_ip),
                                  updated_by = ISNULL(@action_user, updated_by),   
                                  updated_local_date = ISNULL(GETDATE(), updated_local_date),   
                                  updated_UTC_date = ISNULL(GETUTCDATE(), updated_UTC_date),   
                                  updated_nepali_date = ISNULL([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
                            WHERE gateway_id = @gateway_id;  
                            SELECT '0' code,   
                                   'gateway updated succesfully' message,   
                                   NULL id;  
                            RETURN;  
                    END;  
            END; -- status update  
  
            IF @flag = 'u'  
                BEGIN  
                    IF NOT EXISTS  
                    (  
                        SELECT 'x'  
                        FROM tbl_gateway_detail   
                        WHERE gateway_id = @gateway_id  
                    )  
                        BEGIN  
                            SELECT '1' code,   
                                   'gateway doesn''t exist' message,   
                                   NULL id;  
                            RETURN;  
                    END;  
                        ELSE  
                        BEGIN  
                            UPDATE [dbo].tbl_gateway_detail  
                              SET   
                                  gateway_name = ISNULL(@gateway_name, gateway_name),   
                                  gateway_country = ISNULL(@gateway_country, gateway_country),   
                                  gateway_url = ISNULL(@gateway_url, gateway_url),   
                                  gateway_username = ISNULL(@gateway_user_name, gateway_username),   
                                  gateway_password = ISNULL(@gateway_password, gateway_password),   
                                  gateway_access_code = ISNULL(@gateway_access_code, gateway_access_code),   
                                  is_direct_gateway = ISNULL(@is_direct_gateway, is_direct_gateway),   
                                  gateway_security_code = ISNULL(@gateway_security_code, gateway_security_code),   
                                  gateway_api_token = ISNULL(@gateway_api_token, gateway_api_token),   
                                  gateway_balance = ISNULL(gateway_balance + @gateway_balance, gateway_balance) ,
								  gateway_type=@gateway_type,
								  gateway_status=@gateway_status,
                                  --,[remarks] = isnull(@remarks, [remarks])   
								  updated_ip=ISNULL(@from_ip_address,updated_ip),
                                  updated_by = ISNULL(@action_user, updated_by),   
                                  updated_local_date = ISNULL(GETDATE(), updated_local_date),   
                                  updated_UTC_date = ISNULL(GETUTCDATE(), updated_UTC_date),   
                                  updated_nepali_date = ISNULL([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
                            WHERE gateway_id = @gateway_id;  
                            SELECT '0' code,   
                                   'gateway updated succesfully' message,   
                                   NULL id;  
                            RETURN;  
                    END;  
            END;  -- gateway detail update  
  
            IF @flag = 's'  
                BEGIN  
                    IF @gateway_id IS NOT NULL  
                        BEGIN  
                            SELECT gateway_id,   
                                   gateway_name,   
                                   ISNULL(gateway_balance, 0) gateway_balance,   
                                   gateway_country,  
								   gateway_currency,
								   gateway_username,
								   gateway_password,
								   gateway_access_code,
								   gateway_security_code,
								   gateway_api_token,
								   is_direct_gateway,
                                   gateway_url,  
								   gateway_type,
								   
								   
                                   
           gateway_status as [STATUS]  
                            FROM tbl_gateway_detail  
                            WHERE gateway_id = @gateway_id;  
                            RETURN;  
                    END;  
                        ELSE  
                        BEGIN  
                            SELECT gateway_id,   
                                   gateway_name,   
                                   ISNULL(gateway_balance, 0) gateway_balance,   
                                   gateway_country,   
                                   gateway_url,  
                                   --CASE  
                                   --    WHEN gateway_status = 'y'  
                                   --    THEN 'active'  
                                   --    WHEN gateway_status = 'n'  
                                   --    THEN 'inactive'  
                                   --    ELSE ISNULL(gateway_status, 'y')  
                                   --END   
           gateway_status as [STATUS]  
                            FROM tbl_gateway_detail;  
                            RETURN;  
                    END;  
            END;  -- select gateway  
  
            IF @flag = 'sid'  
                BEGIN  
                    SELECT *,  
                           CASE  
                               WHEN gateway_status = 'y'  
                               THEN 'active'  
                               WHEN gateway_status = 'n'  
                               THEN 'inactive'  
                               ELSE ISNULL(gateway_status, 'y')  
                           END gatewaystatus  
                    FROM tbl_gateway_detail  
                    WHERE gateway_id = @gateway_id;  
                    RETURN;  
            END;  -- get status of each gateway  
  
            IF @flag = 'ub'  
                BEGIN TRY  
                    IF NOT EXISTS  
                    (  
                        SELECT 'x'  
                        FROM tbl_gateway_detail  
                        WHERE gateway_id = @gateway_id  
                    )  
                        BEGIN  
                            SELECT '1' code,   
                                   'gateway doesn''t exist' message,   
                                   NULL id;  
                            RETURN;  
                    END;  
                        ELSE  
                    BEGIN TRANSACTION gatwaybalancetransfer;  
                    BEGIN  
                        UPDATE tbl_gateway_detail  
                          SET   
                              gateway_balance = ISNULL(gateway_balance, 0) + ISNULL(@gateway_balance, 0)  
                        WHERE gateway_id = @gateway_id;  
                        INSERT INTO tbl_gateway_balance  
                        (gateway_id,   
                         balance_type,   
                         amount,   
                         currency_code,   
                         admin_remarks,   
                         created_by,   
                         created_UTC_date,   
                         created_local_date,   
                         created_nepali_date,   
                         created_ip,   
                         transaction_date  
                        )  
                        VALUES  
                        (@gateway_id,   
                         'topup',   
                         @gateway_balance,   
                         'NPR',   
                         @remarks,   
                         @action_user,   
                         GETUTCDATE(),   
                         GETDATE(),   
                         [dbo].func_get_nepali_date(DEFAULT),   
                         @from_ip_address,   
                         @transaction_date  
                        );  
                        SELECT '0' code,   
                               'balance updated succesfully' message,   
                               NULL id;  
            END;  
                    COMMIT TRANSACTION gatwaybalancetransfer;  
                    RETURN;  
            END TRY  
                BEGIN CATCH  
                    IF @@trancount > 0  
                        ROLLBACK TRANSACTION gatwaybalancetransfer;  
                    SET @desc = 'sql error found:(' + ERROR_MESSAGE() + ')';  
                    INSERT INTO tbl_error_log_sql  
                    (sql_error_desc,   
                     sql_error_script,   
                     sql_query_string,   
                     sql_error_category,   
                     sql_error_source,   
                     sql_error_local_date,   
                     sql_error_UTC_date,   
                     sql_error_nepali_date  
                    )  
                           SELECT @desc,   
                                  'sproc_gateway_detail(gatwaybalancetransfer:flag ''ub'') on line ' + CAST(ERROR_LINE() AS VARCHAR),   
                                  'sql',   
                                  'sql',   
                                  'sproc_gateway_detail(gatwaybalancetransfer)',   
                                  GETDATE(),   
                                  GETUTCDATE(),   
                                  [dbo].func_get_nepali_date(DEFAULT);  
                    SELECT '1' code,   
                           'errorid: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) message,   
                           NULL id;  
            END CATCH;  --balance update  
  
            IF @flag = 'r'  
                BEGIN  
                    IF @gateway_id IS NOT NULL  
                        BEGIN  
                            IF NOT EXISTS  
                            (  
                                SELECT 'x'  
                                FROM tbl_gateway_detail  
                                WHERE gateway_id = @gateway_id  
                            )  
                                BEGIN  
                                    SELECT '1' code,   
                                           'gateway doesn''t exist' message,   
                                           NULL id;  
                                    RETURN;  
                            END;  
                    END;  
                    SET @sql = 'SELECT gb.gateway_id,   
       gd.gateway_name AS gateway_name,   
       gb.balance_type,   
       gb.amount,   
       gd.gateway_balance AS updated_balance,   
       gb.created_by,   
       gb.admin_remarks,   
       gb.currency_code,   
       gb.created_local_date,   
       gb.created_nepali_date  
FROM tbl_gateway_balance gb WITH(NOLOCK)  
     JOIN tbl_gateway_detail gd WITH(NOLOCK) ON gd.gateway_id = gb.gateway_id     
   where 1 = 1';  
                    IF @gateway_id IS NOT NULL  
                        BEGIN  
                            SET @sql = @sql + ' and gb.gateway_id = ' + @gateway_id;  
                    END;  
                    IF @from_date IS NOT NULL  
                       AND @to_date IS NOT NULL  
                        BEGIN  
                            SET @sql = @sql + ' and gb.created_local_date between ''' + CAST(@from_date AS VARCHAR) + ''' and ''' + CAST(@to_date AS VARCHAR) + ' 23:59:59.997''';  
                    END;  
                    PRINT(@sql);  
                    EXEC (@sql);  
                    SET @sql = @sql + 'order by gb.created_local_date desc ';  
            END; -- gateway report  
  
            IF @flag = 'ddl'  
                BEGIN  
                    SELECT gateway_id,   
                           gateway_name AS gatewayname  
                    FROM tbl_gateway_detail  
                    WHERE ISNULL(gateway_status, 'y') = 'y';  
            END; -- gateway dropdown  
  
        END TRY  
        BEGIN CATCH  
            IF @@trancount > 0  
                ROLLBACK TRANSACTION;  
            SELECT 1 code,   
                   ERROR_MESSAGE() message,   
                   ERROR_LINE() id;  
        END CATCH;  
    END;  

GO
