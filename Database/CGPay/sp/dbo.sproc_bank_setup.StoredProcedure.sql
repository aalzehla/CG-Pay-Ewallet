USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_bank_setup]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sproc_bank_setup] @flag            CHAR(30), 
                                          @action_user     VARCHAR(50)  = NULL, 
                                          @bank_id         INT          = NULL, 
                                          @bank_name       VARCHAR(200) = NULL, 
                                          @bank_branch     VARCHAR(100) = NULL, 
                                          @status          VARCHAR(100) = NULL, 
                                          @account_number  VARCHAR(100) = NULL, 
                                          @is_distributor  VARCHAR(10)  = NULL, 
                                          @ip_address      VARCHAR(100) = NULL, 
                                          @agent_id        VARCHAR(20)  = NULL, 
                                          @created_by      VARCHAR(50)  = NULL, 
                                          @funding_bank_id VARCHAR(50)  = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @sql VARCHAR(MAX);
        IF @flag = 'list'
            BEGIN
                IF @action_user = 'admin'
                    BEGIN
                        SELECT funding_bank_id, 
                               funding_bank_name, 
                               funding_bank_branch, 
                               funding_account_number, 
                               created_by, 
                               CONVERT(VARCHAR, created_local_date, 103) createddate, 
                               bank_status, 
                               for_distributor
                        FROM tbl_funding_bank_account;
                END;
                    ELSE
                    BEGIN
                        SELECT funding_bank_id, 
                               funding_bank_name, 
                               funding_bank_branch, 
                               funding_account_number, 
                               created_by, 
                               CONVERT(VARCHAR, created_local_date, 103) createddate, 
                               bank_status, 
                               for_distributor
                        FROM tbl_funding_bank_account
                        WHERE bank_status = 'y';
                END;
        END;
        IF @flag = 'id'
            BEGIN
                SELECT funding_bank_id, 
                       funding_bank_name, 
                       funding_bank_branch, 
                       funding_account_number, 
                       created_by, 
                       CONVERT(VARCHAR, created_local_date, 103) createddate, 
                       bank_status, 
                       for_distributor
                FROM tbl_funding_bank_account
                WHERE funding_bank_id = @bank_id;
        END;
        IF @flag = 'i'
            BEGIN
                IF NOT EXISTS
                (
                    SELECT 'x'
                    FROM tbl_funding_bank_account
                    WHERE funding_bank_name = @bank_name
                          AND funding_bank_branch = @bank_branch
                          OR funding_account_number = @account_number
                          AND bank_status = 'y'
                )
                    BEGIN
                        INSERT INTO tbl_funding_bank_account
                        ( 
                         funding_bank_name, 
                         funding_bank_branch, 
                         funding_account_number, 
                         bank_status, 
                         created_UTC_date, 
                         created_local_date, 
						 created_nepali_date,
                         created_by, 
                         created_ip, 
                         for_distributor
                        )
                        VALUES
                        (
                         @bank_name, 
                         @bank_branch, 
                         @account_number, 
                         @status, 
                         GETUTCDATE(), 
                         GETDATE(), 
						dbo.func_get_nepali_date(default),
                         @action_user, 
                         @ip_address, 
                         @is_distributor
                        );
                        SELECT '0' AS errorcode, 
                               UPPER(@bank_name) + ' with branch: ' + UPPER(@bank_branch) + ' and a/c no: ' + @account_number + ' added succesfully' message, 
                               NULL AS id;
                END;
                    ELSE
                    BEGIN
                        SELECT '1' AS errorcode, 
                               'duplicate insertion with requested parameters.' message, 
                               NULL AS id;
                END;
        END;
        IF @flag = 'u'
            BEGIN
                UPDATE tbl_funding_bank_account
                  SET 
                      funding_bank_name = ISNULL(@bank_name, funding_bank_name), 
                      funding_bank_branch = ISNULL(@bank_branch, funding_bank_branch), 
                      funding_account_number = ISNULL(@account_number, funding_account_number), 
                      bank_status = ISNULL(@status, bank_status), 
                      updated_by = ISNULL(@action_user, updated_by), 
                      updated_UTC_date = GETUTCDATE(), 
                      updated_local_date = GETDATE(), 
                      updated_ip = @ip_address
                WHERE funding_bank_id = @funding_bank_id;
                SELECT @bank_name = funding_bank_name
                FROM tbl_funding_bank_account
                WHERE funding_bank_id = @funding_bank_id;
                SELECT '0' AS errorcode, 
                       'details of ' + @bank_name + ' updated successfully.' message, 
                       NULL AS id;
        END;
    END;


GO
