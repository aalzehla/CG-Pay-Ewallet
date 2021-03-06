USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_funding_bank_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sproc_funding_bank_detail] @flag                   CHAR(3)      = NULL, 
                                                   @agent_id               INT          = NULL, 
                                                   @funding_bank_name      VARCHAR(100) = NULL, 
                                                   @funding_bank_branch    VARCHAR(100) = NULL, 
                                                   @funding_account_number VARCHAR(100) = NULL, 
                                                   @funding_bank_status    CHAR(10)     = NULL, 
                                                   @from_ip_address        VARCHAR(15)  = NULL, 
                                                   @for_distributor        CHAR(3)      = NULL, 
                                                   @action_user            VARCHAR(50)  = NULL, 
                                                   @funding_bank_id        INT          = NULL
AS
    BEGIN
		IF @flag = 'S'
		BEGIN
			SELECT funding_bank_id,funding_bank_name,funding_bank_branch,funding_account_number,bank_status, created_by, created_local_date FROM tbl_funding_bank_account
		END
        IF @flag = 'i'
            BEGIN
                IF EXISTS
                (
                    SELECT 'x'
                    FROM tbl_funding_bank_account
                    WHERE funding_bank_name = LTRIM(RTRIM(@funding_bank_name))
                          AND funding_account_number = @funding_account_number
                )
                    BEGIN
                        SELECT '1' code, 
                               'bank name and account number already exists. please check.' message, 
                               NULL id;
                        RETURN;
                END;
				--set identity_insert dbo.tbl_funding_bank_account on;
                INSERT INTO dbo.tbl_funding_bank_account
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
                 @funding_bank_name, 
                 @funding_bank_branch, 
                 @funding_account_number, 
                case when @funding_bank_status = '' then 'N' else @funding_bank_status end, 
                 GETUTCDATE(), 
                 GETDATE(), 
                 [dbo].func_get_nepali_date(DEFAULT), 
                 @action_user, 
                 @from_ip_address, 
                 ISNULL(@for_distributor, 'n')
                );
                SELECT '0' code, 
                       'bank addedd successfully' message, 
                       NULL id;
                RETURN;
        END; 

        IF @flag = 'u'
            BEGIN 

                UPDATE dbo.tbl_funding_bank_account
                  SET 
                      funding_bank_name = ISNULL(@funding_bank_name, funding_bank_name), 
                      funding_bank_branch = ISNULL(@funding_bank_branch, funding_bank_branch), 
                      funding_account_number = ISNULL(@funding_account_number, funding_account_number), 
                      bank_status =case when @funding_bank_status = '' then 'N' else @funding_bank_status end, --ISNULL(@funding_bank_status, 'N'), 
                      updated_UTC_date = ISNULL(GETUTCDATE(), updated_UTC_date), 
                      updated_local_date = ISNULL(GETDATE(), updated_local_date), 
                      updated_nepali_date = ISNULL([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date), 
					  updated_by = ISNULL(@action_user, updated_by),
                      updated_ip = ISNULL(@from_ip_address, updated_ip), 
                      for_distributor = ISNULL(@for_distributor, for_distributor)
                WHERE funding_bank_id = @funding_bank_id;
                SELECT '0' code, 
                       'bank detail successfully updated' message, 
                       NULL id;
                RETURN;
        END;
    END;



GO
