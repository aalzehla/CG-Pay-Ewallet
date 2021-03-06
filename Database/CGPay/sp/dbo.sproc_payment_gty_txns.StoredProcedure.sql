USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_payment_gty_txns]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sproc_payment_gty_txns]
(@flag               CHAR(3), 
 @pmt_Txn_Id         INT            = NULL, 
 @amount             DECIMAL(18, 2)  = NULL, 
 @service_Charge     FLOAT          = NULL, 
 @total_amount       DECIMAL(18, 2)  = NULL, 
 @status             VARCHAR(10)    = NULL, 
 @sub_status         VARCHAR(10)    = NULL, 
 @pmt_gateway_id     INT            = NULL, 
 @pmt_gateway_name   VARCHAR(50)    = NULL, 
 @pmt_gateway_txn_id INT            = NULL, 
 @gateway_time_stamp DATETIME       = NULL, 
 @card_no            VARCHAR(30)    = NULL, 
 @card_expiry_date   VARCHAR(10)    = NULL, 
 @card_sssuer        VARCHAR(30)    = NULL, 
 @name_on_card       VARCHAR(50)    = NULL, 
 @gateway_status      VARCHAR(10)    = NULL, 
 @remarks            VARCHAR(500)   = NULL, 
 @email              VARCHAR(50)    = NULL, 
 @mobile             VARCHAR(10)    = NULL, 
 @agent_id           INT            = NULL, 
 @user_id            VARCHAR(50)    = NULL, 
 @user_name          VARCHAR(60)    = NULL, 
 @process_id         VARCHAR(100)   = NULL, 
 @gateway_process_id VARCHAR(100)   = NULL, 
 @type               VARCHAR(10)    = NULL, 
 @action_user        VARCHAR(60)    = NULL, 
 @domain_name        VARCHAR(500)   = NULL, 
 @from_ip_address    VARCHAR(20)    = NULL, 
 @delivery_data      VARCHAR(500)   = NULL, 
 @created_platform   VARCHAR(50)    = NULL
)
AS
    BEGIN
       
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN
                DECLARE @sql VARCHAR(MAX);
                IF @flag = 'i'
                    BEGIN
                        IF EXISTS
                        (
                            SELECT 'x'
                            FROM tbl_payment_gateway_transaction
                            WHERE pmt_txn_id = @pmt_Txn_Id
                                  AND STATUS = 'Pending'
                        )
                            BEGIN
                                SELECT '1' Code, 
                                       'Transaction already exists, status pending' Message, 
                                       NULL id;
                                RETURN;
                        END;
                        IF EXISTS
                        (
                            SELECT 'x'
                            FROM tbl_payment_gateway_transaction
                            WHERE pmt_txn_id = @pmt_Txn_Id
                                  AND STATUS = 'Received'
                                  
                        )
                            BEGIN
                                SELECT '1' Code, 
                                       'Transaction already exists' Message, 
                                       NULL id;
                                RETURN;
                        END;
                            ELSE
                            BEGIN TRY
                                BEGIN
                                    INSERT INTO [dbo].tbl_payment_gateway_transaction
                                    (amount, 
                                     service_charge, 
                                     total_amount, 
                                     [Status], 
                                     pmt_gateway_id, 
                                     pmt_gateway_name, 
                                     card_no, 
                                     card_expiry_date, 
                                     card_issuer, 
                                     name_on_card, 
                                     [Remarks], 
                                     [Email], 
                                     [Mobile], 
                                     agent_id, 
                                     user_id, 
                                     user_name, 
                                     process_id, 
                                     [Type], 
                                     created_UTC_date, 
                                     created_local_date, 
                                     created_nepali_date, 
                                     created_by, 
									 created_ip,
                                     [CreatedPlatform]
                                    )
                                    VALUES
                                    (@amount, 
                                     @service_Charge, 
                                     @total_amount, 
                                     'Pending', 
                                     @pmt_gateway_id, 
                                     @pmt_gateway_name, 
                                     @card_no, 
                                     @card_expiry_date, 
                                     @card_sssuer, 
                                     @name_on_card, 
                                     @Remarks, 
                                     @email, 
                                     @mobile, 
                                     @agent_id, 
                                     @user_id, 
                                     @user_name, 
                                     @process_id, 
                                     @type, 
                                     GETUTCDATE(), 
                                     GETDATE(), 
                                     [dbo].func_get_nepali_date(DEFAULT), 
                                     @action_user, 
                                     @from_ip_address, 
                                     @created_platform
                                    );
                                    SELECT '0' CODE, 
                                           'Successfully inserted into Third Part Txns Table' MESSAGE, 
                                           @pmt_Txn_Id TXN_ID;
                                    RETURN;
                        END;
                        END TRY
                            BEGIN CATCH
                                SELECT '1' CODE, 
                                       'Technical Error: Could not intiate transaction!' MESSAGE, 
                                       NULL id;
                                RETURN;
                        END CATCH;
                END;
                IF @flag = 'up'     --update process id                                                                           
                    BEGIN
                        IF NOT EXISTS
                        (
                            SELECT 'X'
                            FROM tbl_payment_gateway_transaction
                            WHERE pmt_txn_id = @pmt_Txn_Id
                                  AND process_id IS NULL
                        )
                            BEGIN
                                SELECT '1' CODE, 
                                       'NO TRANSACTION FOUND' MESSAGE, 
                                       NULL id;
                                RETURN;
                        END;
                        UPDATE tbl_payment_gateway_transaction
                          SET 
                              process_id = @process_id
                        WHERE pmt_txn_id = @pmt_Txn_Id;
                        SELECT '0' CODE, 
                               'PROCESS ID UPDATED SUCCESSFULLY' MESSAGE, 
                               NULL id;
                        RETURN;
                END;
                IF @flag = 'ft'
                    BEGIN
                        --check transaction status
                        IF NOT EXISTS
                        (
                            SELECT 'X'
                            FROM tbl_payment_gateway_transaction
                            WHERE pmt_txn_id = @pmt_Txn_Id
                                  AND STATUS IS NULL
                        )
                            BEGIN
                                SELECT '1' CODE, 
                                       'NO TRANSACTION FOUND' MESSAGE, 
                                       NULL;
                                RETURN;
                        END;
                        UPDATE tbl_payment_gateway_transaction
                          SET 
                              gateway_status = ISNULL(@gateway_status, gateway_status), 
                              [status] = 'Received', 
                              pmt_gateway_txn_id = ISNULL(@pmt_gateway_txn_id, pmt_gateway_txn_id), 
                              gateway_process_id = ISNULL(@gateway_process_id, gateway_process_id), 
                              gateway_timestamp = ISNULL(@gateway_time_stamp, gateway_timestamp)
                        WHERE pmt_txn_id = @pmt_Txn_Id;

                        --if txn is fail or error
                        IF @gateway_status <> 'SUCCESS'
                            BEGIN
                                SELECT '1' CODE, 
                                       'COULDN''T GET RESPONSE FROM THIRD PARTY GATEWAY' MESSAGE, 
                                       NULL;
                                RETURN;
                        END;
                        IF @gateway_status = 'SUCCESS'
                            BEGIN
                                SELECT @amount = amount, 
                                       @mobile = ad.agent_mobile_no, 
                                       @email = ad.agent_email_address, 
                                       @action_user = ud.user_name, 
                                       @user_id = ud.user_id
                                FROM tbl_payment_gateway_transaction p
                                     JOIN tbl_agent_detail ad ON p.agent_id = ad.agent_id
                                     JOIN tbl_user_detail ud ON ud.agent_id = ad.agent_id
                                WHERE pmt_txn_id = @pmt_Txn_Id;
                                UPDATE tbl_agent_detail
                                  SET 
                                      available_balance = ISNULL(available_balance, 0) + (@amount)
                                WHERE agent_id = @agent_id;
                                SELECT '0' CODE, 
                                       'Successfully Updated Balance for agent ' MESSAGE, 
                                       NULL;
                                RETURN;
                        END;
                        SELECT '0' CODE, 
                               'UPDATED SUCCESSFULLY' MESSAGE, 
                               @pmt_gateway_txn_id PGatewayTxnId, 
                               pmt_txn_id TxnId, 
                               pmt_gateway_txn_id GatewayTxnId, 
                               [STATUS] TxnStatus, 
                               Amount AMOUNT, 
                               gateway_status GatewayStatus, 
                               agent_id AgentId, 
                               user_name UserName
                        FROM tbl_payment_gateway_transaction
                        WHERE pmt_txn_id = @pmt_Txn_Id;
                        RETURN;
                END;
                IF @flag = 's'
                    BEGIN
                        SET @sql = ' SELECT Status, PGatewayTxnId, PGatewayName, Mobile,Email,Amount,GatewayStatus,CreatedBy, CreatedDateLocal,Type, AgentId, UserId FROM DtaPaymentGatewayTransaction where 1=1';
                        IF @pmt_Txn_Id IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and PTxnId =''' + CAST(@pmt_Txn_Id AS VARCHAR) + '''';
                        END;
                        IF @pmt_gateway_id IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and and PGatewayId =''' + CAST(@pmt_gateway_id AS VARCHAR) + '''';
                        END;
                        IF @pmt_gateway_txn_id IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and PGatewayTxnId =''' + CAST(@pmt_gateway_txn_id AS VARCHAR) + '''';
                        END;
                        IF @status IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and Status =''' + @status + '''';
                        END;
                        IF @agent_id IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and AgentId =''' + CAST(@agent_id AS VARCHAR) + '''';
                        END;
                        IF @user_id IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and UserId =''' + CAST(@user_id AS VARCHAR) + '''';
                        END;
                        IF @type IS NOT NULL
                            BEGIN
                                SET @sql = @sql + ' and Type =''' + @type + '''';
                        END;
                        SET @sql = @sql + 'order by CreatedDateLocal desc ';
                        PRINT(@sql);
                        EXEC (@sql);
                END;
            END;
        END TRY
        BEGIN CATCH
            IF @@trancount > 0
                ROLLBACK TRANSACTION;
            SELECT 1 CODE, 
                   ERROR_MESSAGE() MESSAGE, 
                   NULL id;
        END CATCH;
    END;


GO
