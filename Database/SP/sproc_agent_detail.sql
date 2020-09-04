USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_agent_detail]    Script Date: 23/04/2020 15:30:35 ******/
DROP PROCEDURE [dbo].[sproc_agent_detail]
GO

/****** Object:  StoredProcedure [dbo].[sproc_agent_detail]    Script Date: 23/04/2020 15:30:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sproc_agent_detail] (
	@flag CHAR(10)
	,--- i=INSERT,u=UPDATE,d=DELETE,l=LOCKED,ul=UNLOCKED,s=SEARCH                
	@agent_id INT = NULL
	,@agent_code VARCHAR(30) = NULL
	,@agent_operation_type VARCHAR(20) = NULL
	,@agent_name VARCHAR(50) = NULL
	,@first_name VARCHAR(100) = NULL
	,@middle_name VARCHAR(100) = NULL
	,@last_name VARCHAR(100) = NULL
	,@balance DECIMAL(18, 2) = NULL
	,@country VARCHAR(20) = NULL
	,@province VARCHAR(30) = NULL
	,@district VARCHAR(50) = NULL
	,@local_body VARCHAR(50) = NULL
	,@ward_no INT = NULL
	,@address VARCHAR(60) = NULL
	,@latitude VARCHAR(30) = NULL
	,@longitude VARCHAR(30) = NULL
	,@phone_no VARCHAR(20) = NULL
	,@email_address VARCHAR(50) = NULL
	,@web_url VARCHAR(100) = NULL
	,@registration_no VARCHAR(20) = NULL
	,@pan_no VARCHAR(20) = NULL
	,@credit_limit DECIMAL(18, 2) = NULL
	,@support_staff VARCHAR(50) = NULL
	,@contract_date DATETIME = NULL
	,@logo_img NVARCHAR(MAX) = NULL
	,@contact_name VARCHAR(50) = NULL
	,@country_code VARCHAR(3) = NULL
	,@mobile_no VARCHAR(50) = NULL
	,@Contact_id_type VARCHAR(50) = NULL
	,@Contact_id_no VARCHAR(50) = NULL
	,@Contact_id_issue_date DATETIME = NULL
	,@Contact_id_issue_district VARCHAR(50) = NULL
	,@commission_cat_id INT = NULL
	,@Status VARCHAR(10) = NULL
	,@lock_status CHAR(3) = NULL
	,@locked_reason VARCHAR(350) = NULL
	--,@is_deleted CHAR(3) = NULL      
	,@created_ip VARCHAR(50) = NULL
	,@created_platform VARCHAR(10) = NULL
	,@parent_Id VARCHAR(10) = NULL
	,@grand_parent_id VARCHAR(10) = NULL
	,@referal_id VARCHAR(10) = NULL
	,@agent_referal_id VARCHAR(10) = NULL
	,@kyc_status CHAR(3) = NULL
	,@agent_type VARCHAR(20) = NULL
	,@is_auto_commission CHAR(1) = NULL
	,@qr_image VARCHAR(150) = NULL
	,@fund_load_reward INT = NULL
	,@txn_rewardpoint INT = NULL
	,@from_date DATETIME = NULL
	,@end_date DATETIME = NULL
	,@action_ip NVARCHAR(50) = NULL
	,@action_user NVARCHAR(200) = NULL
	,@platform VARCHAR(100) = NULL
	)
AS
SET NOCOUNT ON

BEGIN TRY
	BEGIN
		IF (@action_user IS NULL)
		BEGIN
			EXEC sproc_error_handler @error_code = '1'
				,@Msg = 'UserName is required'
				,@id = NULL

			RETURN
		END

		DECLARE @action_agent_type VARCHAR(20)
			,@action_parent_id INT
			,@action_agent_id INT
			,@action_grand_parent_id INT
			,@contract_nepali_date VARCHAR(10) = NULL
			,@last_online DATETIME = NULL
		DECLARE @sql NVARCHAR(max)
			,@currentdate DATETIME

		SELECT @action_agent_type = A.agent_type
			,@action_parent_id = A.parent_id
			,@action_agent_id = U.agent_id
			,@action_grand_parent_id = A.grand_parent_id
		FROM [dbo].tbl_user_detail AS U
		LEFT JOIN tbl_agent_detail AS A ON U.agent_id = A.agent_id
		WHERE A.agent_id = @agent_id

		IF (@action_agent_id IS NULL)
		BEGIN
			SET @action_agent_type = 'admin'
		END

		IF (@action_agent_type != 'admin')
		BEGIN
			IF (
					@parent_Id IS NOT NULL
					AND @parent_Id != @action_parent_id
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'PARENT ID DID NOT MATCH'
					,@id = @action_user
			END

			IF (
					@action_agent_type = 'subdistributor'
					AND @agent_type = 'distributor'
					)
			BEGIN
				EXEC sproc_error_handler @error_Code = '1'
					,@Msg = 'YOUR ARE NOT ALLOWED TO CREATE DISTRIBUTOR'
					,@id = @agent_id
			END

			IF (@parent_Id IS NULL)
			BEGIN
				SET @grand_parent_id = NULL
			END

			IF (
					@action_agent_type = 'subdistributor'
					AND @action_parent_id IS NOT NULL
					AND @agent_type IN (
						'merchant'
						,'walletUser'
						)
					AND @grand_parent_id IS NULL
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'GRAND PARENT ID IS REQUIRED'
					,@id = @agent_id
			END
		END

		IF @contract_date IS NOT NULL
			SET @contract_nepali_date = dbo.func_get_nepali_date(@contract_date)

		IF (@Flag = 'i')
		BEGIN
			IF @grand_parent_id IS NULL
				AND @parent_Id IS NOT NULL
				SELECT @grand_parent_id = parent_id
				FROM tbl_agent_detail
				WHERE agent_id = @parent_Id

			SELECT @agent_id = max(agent_id)
			FROM tbl_agent_detail

			SELECT @agent_code = right('0000000000' + Cast((isnull(@agent_id, 0) + 1) AS VARCHAR(10)), 10)

			SET @Country = isnull(@country, 'Nepal')
			SET @country_code = isnull(@country_code, 'NPL')

			IF EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail
					WHERE agent_email_address = @email_address
					)
			BEGIN
				SELECT '1' Code
					,'Email Address already exists' Message
					,NULL id

				RETURN
			END

			IF EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail
					WHERE agent_mobile_no = @mobile_no
					)
			BEGIN
				SELECT '1' Code
					,'Mobile Number already exists' Message
					,NULL id

				RETURN
			END

			IF @commission_cat_id IS NULL
			BEGIN
				SELECT @commission_cat_id = category_id
				FROM tbl_commission_category
				WHERE category_name = 'Default'
			END

			INSERT INTO tbl_agent_detail (
				agent_code
				,agent_operation_type
				,first_name
				,middle_name
				,last_name
				,available_balance
				,agent_country
				,permanent_province
				,permanent_district
				,permanent_localbody
				,permanent_wardno
				,permanent_address
				,[Latitude]
				,[Longitude]
				,agent_phone_no
				,agent_email_address
				,web_url
				,agent_registration_no
				,agent_pan_no
				,agent_credit_limit
				,agent_support_staff
				,agent_contract_local_date
				,agent_contract_nepali_date
				,agent_logo_img
				,contact_person_name
				,agent_country_code
				,contact_person_mobile_no
				,contact_person_id_type
				,contact_person_id_no
				,contact_id_issue_local_date
				,contact_id_issued_bs_date
				,contact_id_issued_district
				,agent_commission_id
				,agent_status
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,created_ip
				,created_platform
				,parent_id
				,grand_parent_id
				,referal_id
				,agent_referal_id
				,kyc_status
				,agent_type
				,is_auto_commission
				,agent_qr_image
				,fund_load_reward
				,txn_reward_point
				)
			VALUES (
				@agent_code
				,@agent_operation_type
				,@first_name
				,@middle_name
				,@last_name
				,Isnull(@balance, 0)
				,@Country
				,@Province
				,@District
				,@local_body
				,@ward_no
				,@Address
				,@Latitude
				,@Longitude
				,@phone_no
				,@email_address
				,@web_url
				,@registration_no
				,@pan_no
				,isnull(@credit_limit, 0) --agent_credit_limit
				,@support_staff --agent_support_staff
				,@contract_date --agent_contract_nepali_date
				,@contract_nepali_date
				,@logo_img
				,@contact_name
				,@country_code
				,@mobile_no
				,@Contact_id_type
				,@Contact_id_no
				,@Contact_id_issue_date
				,dbo.func_get_nepali_date(@Contact_id_issue_date)
				,@Contact_id_issue_district
				,@commission_cat_id
				,Isnull(@Status, 'Y')
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,@action_ip
				,@Platform
				,@parent_Id
				,@grand_parent_id
				,@referal_id
				,@agent_referal_id
				,'Pending'
				,@agent_type
				,Isnull(@is_auto_commission, 'M')
				,@qr_image
				,Isnull(@fund_load_reward, 0)
				,Isnull(@txn_rewardpoint, 0)
				)

			SELECT '0' STATUS
				,'Agent created successfully' Message
				,NULL id
		END

		IF (@flag = 'u')
		BEGIN
			IF (@agent_id IS NULL)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'AGENT ID CANNOT BE NULL'
					,@id = NULL

				RETURN
			END

			IF (
					(
						SELECT COUNT(*)
						FROM tbl_agent_detail
						WHERE agent_id = @agent_id
						) = 0
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'Agent not found'
					,@id = @agent_id

				RETURN
			END

			UPDATE tbl_agent_detail
			SET agent_code = ISNULL(@agent_code, agent_code)
				,agent_operation_type = ISNULL(@agent_operation_type, agent_operation_type)
				,first_name = ISNULL(@first_name, first_name)
				,middle_name = ISNULL(@middle_name, middle_name)
				,last_name = ISNULL(@last_name, last_name)
				,available_balance = ISNULL(@Balance, available_balance)
				,agent_country = ISNULL(@Country, agent_country)
				,permanent_province = ISNULL(@Province, permanent_province)
				,permanent_district = ISNULL(@District, permanent_district)
				,permanent_localbody = ISNULL(@local_body, permanent_localbody)
				,permanent_wardno = ISNULL(@ward_no, permanent_wardno)
				,permanent_address = ISNULL(@Address, permanent_address)
				,[Latitude] = ISNULL(@Latitude, [Latitude])
				,[Longitude] = ISNULL(@Longitude, [Longitude])
				,agent_phone_no = ISNULL(@phone_no, agent_phone_no)
				,agent_email_address = ISNULL(@email_address, agent_email_address)
				,web_url = ISNULL(@web_url, web_url)
				,agent_registration_no = ISNULL(@registration_no, agent_registration_no)
				,agent_pan_no = ISNULL(@pan_no, agent_pan_no)
				,agent_credit_limit = ISNULL(@credit_limit, agent_credit_limit)
				,agent_support_staff = ISNULL(@support_staff, agent_support_staff)
				,agent_contract_local_date = ISNULL(@contract_date, agent_contract_local_date)
				,agent_contract_nepali_date = ISNULL(@contract_nepali_date, agent_contract_nepali_date)
				,agent_logo_img = ISNULL(@logo_img, agent_logo_img)
				,contact_person_name = ISNULL(@contact_name, contact_person_name)
				,agent_country_code = ISNULL(@country_code, agent_country_code)
				,contact_person_mobile_no = ISNULL(@mobile_no, contact_person_mobile_no)
				,contact_person_id_type = ISNULL(@Contact_id_type, contact_person_id_type)
				,contact_person_id_no = ISNULL(@Contact_id_no, contact_person_id_no)
				,contact_id_issue_local_date = ISNULL(@Contact_id_issue_date, contact_id_issue_local_date)
				,contact_id_issued_district = ISNULL(@Contact_id_issue_district, contact_id_issued_district)
				,agent_commission_id = ISNULL(@commission_cat_id, agent_commission_id)
				,agent_status = ISNULL(@Status, agent_status)
				,updated_by = @action_user
				,updated_nepali_date = ISNULL(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)
				,updated_UTC_date = GETUTCDATE()
				,updated_local_date = GETDATE()
				,updated_ip = ISNULL(@action_ip, updated_ip)
				,referal_id = ISNULL(@referal_id, referal_id)
				,agent_referal_id = ISNULL(@agent_referal_id, agent_referal_id)
				,kyc_status = ISNULL(@kyc_status, kyc_status)
				,agent_type = ISNULL(@agent_type, agent_type)
				,is_auto_commission = ISNULL(@is_auto_commission, is_auto_commission)
				,agent_qr_image = ISNULL(@qr_image, agent_qr_image)
				,fund_load_reward = ISNULL(@fund_load_reward, fund_load_reward)
				,txn_reward_point = ISNULL(@txn_rewardpoint, txn_reward_point)
			WHERE agent_id = @agent_id
				AND isnull(agent_status, 'N') != 'Y'

			SELECT '0' STATUS
				,'AGENT UPDATED SUCCESSFULLY' Message
				,NULL id
		END

		IF (@flag = 'd')
		BEGIN
			IF (@agent_code IS NULL)
			BEGIN
				EXEC sproc_error_handler @error_Code = '1'
					,@Msg = 'Agent ID cannot  be null'
					,@id = NULL

				RETURN
			END

			IF (
					(
						SELECT COUNT(*)
						FROM tbl_agent_detail
						WHERE agent_id = @agent_id
						) = 0
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'Agent not found'
					,@id = @agent_id

				RETURN
			END

			UPDATE tbl_agent_detail
			SET agent_status = 'Y'
			WHERE agent_id = @agent_id

			SELECT '0' STATUS
				,'Agent deleted successfully' Message
				,NULL id
		END

		IF (@flag = 'l')
		BEGIN
			IF (
					@agent_id IS NULL
					OR @locked_reason IS NULL
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'Agent ID or Lock Reason is required'
					,@id = NULL

				RETURN
			END

			IF (
					(
						SELECT COUNT(*)
						FROM tbl_agent_detail
						WHERE agent_id = @agent_id
						) = 0
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'Agent not found'
					,@id = @agent_id

				RETURN
			END

			UPDATE tbl_agent_detail
			SET lock_status = 'Y'
				,locked_by = @action_user
				,locked_UTC_date = GETUTCDATE()
				,locked_local_date = GETUTCDATE()
				,locked_reason = @locked_reason
			WHERE agent_id = @agent_id
				AND agent_status != 'y'

			EXEC sproc_error_handler @error_code = '0'
				,@Msg = 'Agent locked successfully'
				,@id = @agent_id
		END

		IF (@flag = 'ul')
		BEGIN
			IF (@agent_code IS NULL)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'Enter required field before unlocking agent'
					,@id = @agent_id

				RETURN
			END

			IF (
					(
						SELECT COUNT(*)
						FROM tbl_agent_detail
						WHERE agent_id = @agent_id
						) = 0
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'Agent not found'
					,@id = @agent_id

				RETURN
			END

			UPDATE tbl_agent_detail
			SET lock_status = NULL
				,locked_by = NULL
				,locked_UTC_date = NULL
				,locked_local_date = NULL
				,locked_reason = NULL
			--,[UpdatedBy]=@UpdatedBy                
			--,[UpdatedDateBS]=@UpdatedDateBS                
			--,[UpdatedDateLocal]=@UpdatedDateLocal                
			--,[UpdatedDateUTC]=@UpdatedDateUTC                
			--,[UpdatedIp]=@UpdatedIp                
			WHERE agent_id = @agent_id
				AND agent_status != 'Y'
				AND lock_status = 'Y'

			SELECT '0' AS STATUS
				,'Agent Locked successfully' AS Message
				,@agent_id AS Id
		END

		IF (@Flag = 's')
		BEGIN
			SET @currentdate = dbo.func_get_nepali_date(DEFAULT)
			SET @sql = 'SELECT * FROM tbl_agent_detail WHERE 1=1 '

			IF (@action_user != 'superadmin')
				AND NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail ad
					JOIN tbl_user_detail ud ON ad.agent_id = ud.agent_id
					WHERE ud.user_name = @action_user
						AND isnull(ud.is_primary, 'n') = 'y'
					)
			BEGIN
				SET @sql = @sql + ' AND Created_By = ''' + @action_user + ''''
			END
			ELSE IF @action_user IS NOT NULL
				AND (
					@parent_Id IS NULL
					AND @agent_id IS NULL
					)
				AND EXISTS (
					SELECT 'x'
					FROM tbl_user_detail
					WHERE agent_type IS NULL
						OR agent_type = 'admin'
						AND user_name = @action_user
					)
			BEGIN
				SET @sql = @sql + ' AND parent_id is null'
			END

			IF (@agent_type IS NOT NULL)
			BEGIN
				SET @sql = @sql + ' AND Agent_Type = ''' + @agent_type + ''''
			END

			IF @agent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Agent_Id = ''' + cast(@agent_id AS VARCHAR) + ''''
			END

			IF @kyc_status IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Kyc_Status = ''' + cast(@kyc_status AS VARCHAR) + ''''
			END

			IF @parent_Id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND parent_id = ''' + cast(@parent_Id AS VARCHAR) + ''''
			END

			IF @grand_parent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND grand_parent_id = ''' + cast(@grand_parent_id AS VARCHAR) + ''''
			END

			IF @status IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Status = ''' + @Status + ''''
			END

			IF @mobile_no IS NOT NULL --or @email is not null or @full_name is not null                  
			BEGIN
				SET @sql = @sql + ' AND Mobile_No LIKE  ''%' + @mobile_no + '%'' or EMAIL LIKE ''%' + @mobile_no + '%'' or Name LIKE ''%' + @first_name + '%'''
			END

			IF @end_date IS NULL
				SET @end_date = @currentdate

			IF @from_date IS NOT NULL
				AND @end_date IS NOT NULL
				SET @sql = @sql + ' AND Created_Local_Date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999'''

			PRINT(@sql)

			EXEC (@sql)
		END

		IF @flag = 'ddl' --get all active distributors dropdownlist (used in balance topup-refund)         
		BEGIN
			IF @agent_type IS NULL
			BEGIN
				SELECT agent_id
					,first_name
					,last_name
					,middle_name
					,created_local_date AS DISTRIBUTOR_CREATED_DATE
					,created_by CREATED_BY
					,updated_local_date AS DISTRIBUTOR_UPDATED_DATE
					,updated_by UPDATE_BY
				FROM tbl_agent_detail
				WHERE agent_id IS NULL
			END

			SELECT agent_id
				,first_name
				,middle_name
				,last_name
				,created_UTC_date AS DISTRIBUTOR_CREATED_DATE
				,created_by CREATED_BY
				,updated_local_date AS DISTRIBUTOR_UPDATED_DATE
				,updated_by UPDATE_BY
			FROM tbl_agent_detail
			WHERE ISNULL(agent_status, 'Y') = 'Y'
				AND ISNULL(agent_status, 'N') = 'N'
				AND agent_type = @agent_type
		END

		IF @Flag = 'si'
		BEGIN
			SET @currentdate = dbo.func_get_nepali_date(DEFAULT)
			SET @sql = 'SELECT * FROM tbl_agent_detail WHERE 1=1 '

			IF @agent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Agent_Id = ''' + cast(@agent_id AS VARCHAR) + ''''
			END

			IF (@action_user != 'admin')
				AND NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail ad
					JOIN tbl_user_detail ud ON ad.agent_id = ud.agent_id
					WHERE ud.user_name = @action_user
						AND isnull(ud.is_primary, 'n') = 'y'
					)
			BEGIN
				SET @sql = @sql + ' AND Created_By = ''' + @action_user + ''''
			END
			ELSE IF @action_user IS NOT NULL
				AND (
					@parent_Id IS NULL
					AND @agent_id IS NULL
					)
				AND EXISTS (
					SELECT 'x'
					FROM tbl_user_detail
					WHERE agent_type IS NULL
						OR agent_type = 'admin'
						AND user_name = @action_user
					)
			BEGIN
				SET @sql = @sql + ' AND parent_id is null'
			END

			IF (@agent_type IS NOT NULL)
			BEGIN
				SET @sql = @sql + ' AND Agent_Type = ''' + @agent_type + ''''
			END

			IF @kyc_status IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Kyc_Status = ''' + cast(@kyc_status AS VARCHAR) + ''''
			END

			IF @parent_Id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND parent_id = ''' + cast(@parent_Id AS VARCHAR) + ''''
			END

			IF @grand_parent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND grand_parent_id = ''' + cast(@grand_parent_id AS VARCHAR) + ''''
			END

			IF @status IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Status = ''' + @Status + ''''
			END

			IF @mobile_no IS NOT NULL --or @email is not null or @full_name is not null                  
			BEGIN
				SET @sql = @sql + ' AND MobileNo LIKE  ''%' + @mobile_no + '%'' or EMAIL LIKE ''%' + @mobile_no + '%'' or Name LIKE ''%' + @first_name + '%'''
			END

			IF @end_date IS NULL
				SET @end_date = @currentdate

			IF @from_date IS NOT NULL
				AND @end_date IS NOT NULL
				SET @sql = @sql + ' AND Created_Local_Date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999'''

			PRINT @sql

			EXEC (@sql)
		END

		IF @Flag = 'wu' -- wallet user list  
		BEGIN
			SET @currentdate = dbo.func_get_nepali_date(DEFAULT)
			SET @sql = 'SELECT * FROM tbl_agent_detail WHERE 1=1 '
			SET @sql = @sql + ' AND Agent_Id = ''' + cast(@agent_id AS VARCHAR) + ''''

			IF (@agent_type IS NOT NULL)
			BEGIN
				SET @sql = @sql + ' AND Agent_Type = ''' + @agent_type + ''''
			END

			IF @parent_Id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND parent_id = ''' + cast(@parent_Id AS VARCHAR) + ''''
			END

			IF @grand_parent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND grand_parent_id = ''' + cast(@grand_parent_id AS VARCHAR) + ''''
			END

			PRINT @sql

			EXEC (@sql)
		END
	END
END TRY

BEGIN CATCH
	IF @@trancount > 0
		ROLLBACK TRANSACTION

	SELECT 1 CODE
		,ERROR_MESSAGE() msg
		,NULL id
END CATCH
GO


