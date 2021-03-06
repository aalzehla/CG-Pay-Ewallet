USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_product_denomination]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sproc_product_denomination]
(@flag        VARCHAR(10)
 ,		--i=insert,u=update,d=delete,s=search	 
 @denomination_id      INT            = NULL, 
 @product_id   INT            = NULL, 
 @denomination_amount      DECIMAL(18, 2)  = NULL, 
 @top_up_value  MONEY          = NULL, 
 @bonus_amount MONEY          = NULL, 
 @denomination_label   VARCHAR(500)   = NULL, 
 @denomination_status      CHAR(3)        = NULL, 
 @action_user  NVARCHAR(200)  = NULL
)
AS
     SET NOCOUNT ON;
    BEGIN TRY
        BEGIN
            IF(@action_user IS NULL)
                BEGIN
                    EXEC sproc_error_handler
                         @error_code = '1', 
                         @msg = 'user is required', 
                         @id = NULL;
            END;
            IF(@flag = 'i')
                BEGIN
                    IF(@denomination_id > 0)
                        BEGIN
                            EXEC sproc_error_handler 
                                 @error_code = '1', 
                                 @msg = 'denoid mus be null', 
                                 @id = NULL;
                            RETURN;
                    END;
                    INSERT INTO tbl_product_denomination
                    (product_id, 
                     amount, 
                     topup_value, 
                     bonus_amount, 
                     denomination_label, 
                     denomination_status, 
                     created_UTC_date, 
                     created_local_date, 
                     created_nepali_date, 
                     created_by
                    )
                    VALUES
                    (@product_id, 
                     @denomination_amount, 
                     @top_up_value, 
                     @bonus_amount, 
                     @denomination_label, 
                     @denomination_status, 
                     GETUTCDATE(), 
                     GETDATE(), 
                     dbo.func_get_nepali_date(DEFAULT), 
                     @action_user
                    );
                    EXEC sproc_error_handler 
                         @error_code = '0', 
                         @msg = 'denomination created successfully', 
                         @id = NULL;
            END;
            IF(@flag = 'u')
                BEGIN
                    UPDATE tbl_product_denomination
                      SET 
                          product_id = ISNULL(@product_id, product_id), 
                          [amount] = ISNULL(@denomination_amount, [amount]), 
                          topup_value = ISNULL(@top_up_value, topup_value), 
                          bonus_amount = ISNULL(@bonus_amount, bonus_amount), 
                          denomination_label = ISNULL(@denomination_label, denomination_label), 
                          denomination_status = ISNULL(@denomination_status, denomination_status), 
                          created_UTC_date = GETUTCDATE(), 
                          created_local_date = GETDATE(), 
                          created_nepali_date = dbo.func_get_nepali_date(DEFAULT), 
                          created_by = @action_user
                    WHERE denomination_id = @denomination_id;
                    EXEC sproc_error_handler 
                         @error_code = '0', 
                         @msg = 'denomination updated successfully', 
                         @id = NULL;
            END;
            IF(@flag = 's')
                BEGIN
                    SELECT product_id AS productid, 
                           [amount] AS amount, 
                           topup_value AS topupvalue, 
                           bonus_amount AS bonusamount, 
                           denomination_label AS denolabel, 
                           denomination_status AS STATUS
                    FROM tbl_product_denomination
                    WHERE product_id = @product_id;
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
