USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_epin_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sproc_epin_detail]
(@flag                VARCHAR(10), 
 @epin_id             INT            = NULL, 
 @txn_id              INT            = NULL, 
 @product_id          INT            = NULL, 
 @amount              DECIMAL(18, 2)  = NULL, 
 @serial_no           VARCHAR(50)    = NULL, 
 @pin_no              VARCHAR(100)   = NULL, 
 @expiry_date         DATETIME       = NULL, 
 @expiry_nepali_date  VARCHAR(20)    = NULL, 
 @epin_status         VARCHAR(20)    = NULL, 
 @gateway_txn_id      VARCHAR(100)   = NULL, 
 @batch_id            VARCHAR(250)   = NULL, 
 @process_id          VARCHAR(100)   = NULL, 
 @created_utc_date    DATETIME       = NULL, 
 @created_local_date  DATETIME       = NULL, 
 @created_nepali_date VARCHAR(10)    = NULL, 
 @created_by          VARCHAR(100)   = NULL, 
 @created_ip          VARCHAR(20)    = NULL, 
 @updated_by          DATETIME       = NULL, 
 @updated_utc_date    VARCHAR(50)    = NULL, 
 @updated_local_date  DATETIME       = NULL, 
 @updated_nepali_date VARCHAR(10)    = NULL
)
AS
     SET NOCOUNT ON;
    BEGIN TRY
        BEGIN
            IF(@flag = 'insert')
                BEGIN
                    IF EXISTS
                    (
                        SELECT TOP 1 'x'
                        FROM tbl_epin_detail
                        WHERE epin_id = @epin_id
                    )
                        BEGIN
                            EXEC sproc_error_handler 
                                 @error_code = '1', 
                                 @msg = 'Epin detail already exists', 
                                 @id = NULL;
                            RETURN;
                    END;
                    INSERT INTO tbl_epin_detail
                    (txn_id, 
                     product_id, 
                     epin_amount, 
                     serial_no, 
                     pin_no, 
                     [expiry_date], 
                     expiry_nepali_date, 
                     [status], 
                     gateway_txn_id, 
                     batch_id, 
                     process_id, 
                     created_UTC_date, 
                     created_local_date, 
                     created_nepali_date, 
                     created_by, 
                     created_ip
                    )
                    VALUES
                    (@txn_id, 
                     @product_id, 
                     @amount, 
                     @serial_no, 
                     @pin_no, 
                     @expiry_date, 
                     @expiry_nepali_date, 
                     @epin_status, 
                     @gateway_txn_id, 
                     @batch_id, 
                     @process_id, 
                     @created_utc_date, 
                     @created_local_date, 
                     @created_nepali_date, 
                     @created_by, 
                     @created_ip
                    );
                    SELECT '0' AS STATUS, 
                           'Epin detail  create success.' AS message;
            END;
            IF(@flag = 'update')
                BEGIN
                    IF(@epin_id IS NULL)
                        BEGIN
                            EXEC sproc_error_handler 
                                 @error_code = '1', 
                                 @msg = 'epin detail id required', 
                                 @id = NULL;
                            RETURN;
                    END;
                    IF(
                    (
                        SELECT COUNT(*)
                        FROM tbl_epin_detail
                        WHERE epin_id = @epin_id
                    ) = 0)
                        BEGIN
                            EXEC sproc_error_handler 
                                 @error_code = '1', 
                                 @msg = 'epindetail not found', 
                                 @id = @epin_id;
                            RETURN;
                    END;
                    UPDATE tbl_epin_detail
                      SET 
                          txn_id = ISNULL(@txn_id, txn_id), 
                          product_id = ISNULL(@product_id, product_id), 
                          epin_amount = ISNULL(@amount, epin_amount), 
                          serial_no = ISNULL(@serial_no, serial_no), 
                          pin_no = ISNULL(@pin_no, pin_no), 
                          [expiry_date] = ISNULL(@expiry_date, [expiry_date]), 
                          expiry_nepali_date = ISNULL(@expiry_nepali_date, expiry_nepali_date), 
                          [status] = ISNULL(@epin_status, [status]), 
                          gateway_txn_id = ISNULL(@gateway_txn_id, gateway_txn_id), 
                          batch_id = ISNULL(@batch_id, batch_id), 
                          process_id = ISNULL(@process_id, process_id), 
                          updated_UTC_date = ISNULL(@updated_utc_date, updated_UTC_date), 
                          updated_local_date = ISNULL(@updated_local_date, updated_local_date), 
                          updated_nepali_date = ISNULL(@updated_nepali_date, updated_nepali_date), 
                          updated_by = ISNULL(@updated_by, updated_by)
                    WHERE epin_id = @epin_id;
                    SELECT '0' AS STATUS, 
                           'epindetail  update success.' AS message, 
                           @epin_id AS extra;
            END;
            IF(@flag = 'search')
                BEGIN
                    SELECT *
                    FROM tbl_epin_detail;
            END;
        END;
    END TRY
    BEGIN CATCH
        IF @@trancount > 0
            ROLLBACK TRANSACTION;
        SELECT 1 code, 
               ERROR_MESSAGE() msg, 
               NULL id;
    END CATCH;


GO
