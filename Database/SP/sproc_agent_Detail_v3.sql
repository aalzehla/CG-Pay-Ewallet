USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_agent_Detail_v3]    Script Date: 22/08/2020 22:25:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE OR ALTER  
	

 PROCEDURE [dbo].[sproc_agent_Detail_v3] @flag CHAR(8) = NULL
	,@action_user VARCHAR(50) = NULL
	,@user_id INT = NULL
	,@agent_id INT = NULL
	,@parent_id INT = NULL
	,@agent_type VARCHAR(20) = NULL
	,@agent_operation_type VARCHAR(15) = NULL
	,@agent_commission_type BIT = NULL
	,@agent_name VARCHAR(512) = NULL
	,@agent_phone_number VARCHAR(15) = NULL
	,@agent_mobile_no VARCHAR(10) = NULL
	,@agent_email VARCHAR(512) = NULL
	,@agent_web_url VARCHAR(512) = NULL
	,@agent_registration_no VARCHAR(512) = NULL
	,@agent_Pan_no VARCHAR(512) = NULL
	,@agent_contract_date VARCHAR(512) = NULL
	,@agent_province VARCHAR(512) = NULL
	,@agent_district VARCHAR(512) = NULL
	,@agent_local_body VARCHAR(512) = NULL
	,@agent_ward_number INT = NULL
	,@agent_street VARCHAR(512) = NULL
	,@agent_country VARCHAR(512) = NULL
	,@agent_credit_limit DECIMAL(18, 2) = NULL
	,@agent_available_balance DECIMAL(18, 2) = NULL
	,@agent_logo VARCHAR(max) = NULL
	,@agent_reg_certificate VARCHAR(max) = NULL
	,@agent_pan_Certificate VARCHAR(max) = NULL
	,@agent_commission_cat_id INT = NULL
	,@agent_nationality VARCHAR(512) = NULL
	,@action_ip VARCHAR(20) = NULL
	,@action_platform VARCHAR(30) = NULL
	,
	-----user details-------  
	@user_name VARCHAR(50) = NULL
	,@password VARCHAR(512) = NULL
	,@confirm_password VARCHAR(512) = NULL
	,@first_name VARCHAR(512) = NULL
	,@middle_name VARCHAR(512) = NULL
	,@last_name VARCHAR(512) = NULL
	,@Full_name VARCHAR(512) = NULL
	,@user_mobile_number VARCHAR(10) = NULL
	,@user_email VARCHAR(512) = NULL
	,
	----contact person for business agent  
	@contact_person_name VARCHAR(512) = NULL
	,@contact_person_mobile_number VARCHAR(10) = NULL
	,@contact_person_ID_type VARCHAR(512) = NULL
	,@contact_person_ID_no VARCHAR(512) = NULL
	,@contact_person_Id_issue_date VARCHAR(512) = NULL
	,@contact_person_id_issue_date_nepali VARCHAR(512) = NULL
	,@contact_person_id_expiry_date VARCHAR(512) = NULL
	,@contact_person_id_expiry_date_nepali VARCHAR(512) = NULL
	,@contact_person_id_issue_district VARCHAR(512) = NULL
	,@contact_person_address VARCHAR(512) = NULL
	,@role_id INT = NULL
	,@usr_type_id INT = NULL
	,@action_browser VARCHAR(512) = NULL
	,@is_primary CHAR(3) = NULL
	,@agent_status VARCHAR(51) = NULL
	,@end_date DATETIME = NULL
	,@from_date DATETIME = NULL
	,@user_status VARCHAR(20) = NULL
	,@usr_type VARCHAR(20) = NULL
AS
SET NOCOUNT ON;

DECLARE @action_agent_type VARCHAR(20)
	,@action_parent_id INT
	,@action_agent_id INT
	,@action_grand_parent_id INT
	,@contract_nepali_date VARCHAR(10)
	,@id INT
DECLARE @sql NVARCHAR(MAX)
	,@currentdate DATETIME
	,@last_online DATETIME
	,@agent_code VARCHAR(512)
	,@agent_country_code CHAR(3)
	,@new_card_no VARCHAR(50)
	,@desc VARCHAR(max)

BEGIN TRY
	BEGIN
		IF (@action_user IS NULL)
			AND @flag != 'drole'
			AND @flag != 'gdrole'
			AND @flag != 'arole'
		BEGIN

		select 1 code, 'UserName is required' Message, null id
			--EXEC sproc_error_handler @error_code = '1'
			--	,@Msg = 'UserName is required'
			--	,@id = NULL;

			RETURN;
		END;

		SELECT @action_agent_type = A.agent_type
			,@action_parent_id = A.parent_id
			,@action_agent_id = U.agent_id
			,@action_grand_parent_id = ad.parent_id
		FROM [dbo].tbl_user_detail  AS U with (NOLOCK)
		LEFT JOIN tbl_agent_detail AS A with (NOLOCK) ON U.agent_id = A.agent_id
		LEFT JOIN tbl_agent_detail AS ad with (NOLOCK) ON ad.agent_id = A.parent_id
		WHERE A.agent_id = @agent_id;

		--if agentid or agenttype is null then the agent is admin  
		IF (@action_agent_id IS NULL)
		BEGIN
			SET @action_agent_type = 'admin';
		END;

		IF (@action_agent_type != 'admin')
		BEGIN
			IF (
					@parent_Id IS NOT NULL
					AND @parent_Id != @action_parent_id
					)
			BEGIN
				
				select 1 code, 'PARENT ID DID NOT MATCH' Message, null id
				return
				--EXEC sproc_error_handler @error_code = '1'
				--	,@Msg = 'PARENT ID DID NOT MATCH'
				--	,@id = NULL;
			END;

			--sub distributor not allowed to create distributor  
			IF (
					@action_agent_type IN (
						'subdistributor'
						,'agent'
						,'subagent'
						)
					AND @agent_type = 'distributor'
					)
			BEGIN
				--EXEC sproc_error_handler @error_Code = '1'
				--	,@Msg = 'YOUR ARE NOT ALLOWED TO CREATE DISTRIBUTOR'
				--	,@id = @agent_id;

					select 1 code, 'YOU ARE NOT ALLOWED TO CREATE DISTRIBUTOR' Message, null id
					return
			END;
		END

		IF @agent_contract_date IS NOT NULL
			SET @contract_nepali_date = dbo.func_get_nepali_date(@agent_contract_date);

		--insert agent/user detail  
		IF @flag = 'i'
		BEGIN
			SELECT @agent_id = MAX(agent_id)
			FROM tbl_agent_detail;

			SELECT @agent_code = RIGHT('0000000000' + CAST((ISNULL(@agent_id, 0) + 1) AS VARCHAR(10)), 10);

			SET @agent_country = ISNULL(@agent_country, 'Nepal');
			SET @agent_country_code = ISNULL(@agent_country_code, 'NPL');

			IF EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail with (NOLOCK)
					WHERE agent_email_address = @agent_email
					)
			BEGIN
				SELECT '1' Code
					,'Email Address already exists' Message
					,NULL id;

				RETURN;
			END;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail with (NOLOCK)
					WHERE agent_mobile_no = @agent_mobile_no
					)
			BEGIN
				SELECT '1' Code
					,'Mobile Number already exists' Message
					,NULL id;

				RETURN;
			END;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_mobile_no = @user_mobile_number
					)
			BEGIN
				SELECT '1' Code
					,'User Mobile Number already exists' Message
					,NULL id;

				RETURN;
			END;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_email = @user_email
					)
			BEGIN
				SELECT '1' Code
					,'User Email already exists' Message
					,NULL id;

				RETURN;
			END;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_name = @user_name
					)
			BEGIN
				SELECT '1' Code
					,'User Name already exists' Message
					,NULL id;
				
				RETURN;
			END;

			IF @agent_commission_cat_id IS NULL
			BEGIN
				SELECT @agent_commission_cat_id = category_id
				FROM tbl_commission_category with (NOLOCK)
				WHERE category_name = 'Default';
			END;

			BEGIN TRY
				BEGIN TRANSACTION createAgentDetail

				INSERT INTO [dbo].[tbl_agent_detail] (
					[parent_id]
					,[agent_code]
					,[agent_type]
					,[agent_operation_type]
					,[agent_name]
					,first_name
					,middle_name
					,last_name
					,full_name
					,[available_balance]
					,[agent_phone_no]
					,[agent_mobile_no]
					,[agent_email_address]
					,[agent_nationality]
					,[agent_country]
					,[agent_country_code]
					,permanent_province
					,permanent_district
					,[permanent_localbody]
					,[permanent_wardno]
					,[permanent_address]
					,[web_url]
					,[agent_registration_no]
					,[agent_pan_no]
					,[agent_credit_limit]
					,[agent_contract_local_date]
					,[agent_contract_nepali_date]
					,[agent_logo_img]
					,[agent_document_img_front]
					,[agent_document_img_back]
					,[contact_person_name]
					,[contact_person_mobile_no]
					,[contact_person_id_type]
					,[contact_person_id_no]
					,[contact_id_issue_local_date]
					,[contact_id_issued_bs_date]
					,[contact_id_issued_district]
					,contact_person_address
					,[agent_commission_id]
					,[agent_status]
					,[is_auto_commission]
					,[fund_load_reward]
					,[txn_reward_point]
					,[lock_status]
					,[created_UTC_date]
					,[created_local_date]
					,[created_nepali_date]
					,[created_by]
					,[created_ip]
					,[created_platform]
					,kyc_status
					)
				VALUES (
					@parent_id
					,@agent_code
					,@agent_type
					,@agent_operation_type
					,@agent_name
					,@first_name
					,@middle_name
					,@last_name
					,isnull(@first_name, '') + ' ' + isnull(@middle_name, '') + ' ' + isnull(@last_name, '')
					,@agent_available_balance
					,@agent_phone_number
					,@agent_mobile_no
					,@agent_email
					,isnull(@agent_nationality, 'Nepali')
					,@agent_country
					,@agent_country_code
					,@agent_province
					,@agent_district
					,@agent_local_body
					,@agent_ward_number
					,@agent_street
					,@agent_web_url
					,@agent_registration_no
					,@agent_Pan_no
					,@agent_credit_limit
					,@agent_contract_date
					,dbo.func_get_nepali_date(@agent_contract_date)
					,@agent_logo
					,@agent_pan_Certificate
					,@agent_reg_certificate
					,@contact_person_name
					,@contact_person_mobile_number
					,@contact_person_ID_type
					,@contact_person_ID_no
					,@contact_person_Id_issue_date
					,@contact_person_id_issue_date_nepali
					,@contact_person_id_issue_district
					,@contact_person_address
					,isnull(@agent_commission_cat_id, '1')
					,'y'
					,@agent_commission_type
					,0
					,0
					,'n'
					,GETUTCDATE()
					,GETDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					,@action_user
					,@action_ip
					,@action_platform
					,'N'
					)

				SET @id = SCOPE_IDENTITY()

				--  select * from tbl_user_detail  
				INSERT INTO [dbo].[tbl_user_detail] (
					[agent_id]
					,[role_id]
					,[usr_type_id]
					,[usr_type]
					,[user_name]
					,[full_name]
					,[password]
					,[user_email]
					,[user_mobile_no]
					,[status]
					,[created_UTC_date]
					,[created_local_date]
					,[created_nepali_date]
					,[created_by]
					,[created_ip]
					,[created_platform]
					,[allow_multiple_login]
					,[is_login_enabled]
					,[is_primary]
					,[browser_info]
					)
				VALUES (
					@id
					,@role_id
					,@usr_type_id
					,@usr_type
					,@user_name
					,isnull(@first_name, '') + ' ' + isnull(@middle_name, '') + ' ' + isnull(@last_name, '')
					,PWDENCRYPT(@password)
					,@user_email
					,@user_mobile_number
					,'y'
					,GETUTCDATE()
					,GETDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					,@action_user
					,@action_ip
					,@action_platform
					,'y'
					,'y'
					,'y'
					,@action_browser
					)

				SET @user_ID = SCOPE_IDENTITY()

				INSERT INTO tbl_kyc_documents (
					agent_id
					,KYC_Verified
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					@id
					,'N'
					,'System'
					,GEtDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					)

				SET @new_card_no = '1000' + cast(convert(NUMERIC(12, 0), rand() * 899999999999) + 100000000000 AS VARCHAR)

				INSERT INTO tbl_agent_card_management (
					agent_id
					,card_no
					,user_name
					,user_id
					,is_active
					,card_type
					,card_issued_date
					,card_expiry_date
					,created_by
					,created_local_date
					,created_utc_date
					,created_nepali_date
					)
				VALUES (
					@id
					,@new_card_no
					,'User' + @user_mobile_number
					,@user_ID
					,'y'
					,'1'
					,GETDATE()
					,DATEADD(YEAR, 4, GETDATE())
					,'System'
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					)

					select '0' code, 'Agent Created Successfully' Message, @id id
					--return

				--EXEC sproc_error_handler @error_code = '0'
				--	,@msg = 'Agent created successfully'
				--	,@id = NULL;

				COMMIT TRANSACTION createAgentDetail

			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION createAgentDetail

				SET @desc = 'sql error found:(' + error_message() + ')'

				INSERT INTO tbl_error_log_sql (
					sql_error_desc
					,sql_error_script
					,sql_query_string
					,sql_error_category
					,sql_error_source
					,sql_error_local_date
					,sql_error_UTC_date
					,sql_error_nepali_date
					)
				SELECT @desc
					,'sproc_agent_Detail_v3(insert Agent Detail, user detail,kyc document and Card:flag ''i'')'
					,'sql'
					,'sql'
					,'sproc_agent_Detail_v3(insert Agent Detail, user detail,kyc document and Card)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH

			RETURN
				--SELECT '0' STATUS ,'Agent created successfully' Message,NULL id;    
		END;

		--update agent/user detail  
		IF @flag = 'u'
		BEGIN
			IF (@agent_id IS NULL)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@Msg = 'AGENT ID CANNOT BE NULL'
					,@id = NULL;

				RETURN;
			END;

			IF (
					(
						SELECT COUNT(*)
						FROM tbl_agent_detail with (NOLOCK)
						WHERE agent_id = @agent_id
						) = 0
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'Agent not found'
					,@id = @agent_id;

				RETURN;
			END;

			IF @user_id IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT 'x'
						FROM tbl_user_detail with (NOLOCK)
						WHERE user_id = @user_id
						)
				BEGIN
					SELECT '1' code
						,'User not Found' message
						,NULL id

					RETURN
				END
			END

			BEGIN TRY
				BEGIN TRANSACTION updateAgentDetail

				UPDATE [dbo].[tbl_agent_detail]
				SET [agent_operation_type] = isnull(@agent_operation_type, agent_operation_type)
					,[agent_name] = isnull(@agent_name, agent_name)
					,[agent_phone_no] = isnull(@agent_phone_number, agent_phone_no)
					,[agent_mobile_no] = isnull(@agent_mobile_no, agent_mobile_no)
					,[agent_email_address] = isnull(@agent_email, agent_email_address)
					,[first_name] = isnull(@first_name, first_name)
					,[middle_name] = isnull(@middle_name, middle_name)
					,[last_name] = isnull(@last_name, last_name)
					,[agent_nationality] = isnull(@agent_nationality, agent_nationality)
					,[agent_country] = isnull(@agent_country, agent_country)
					,[agent_country_code] = isnull(@agent_country_code, agent_country_code)
					,[permanent_province] = isnull(@agent_province, [permanent_province])
					,[permanent_district] = isnull(@agent_district, [permanent_district])
					,[permanent_localbody] = isnull(@agent_local_body, [permanent_localbody])
					,[permanent_wardno] = isnull(@agent_ward_number, [permanent_wardno])
					,[permanent_address] = isnull(@agent_street, permanent_address)
					,[web_url] = isnull(@agent_web_url, web_url)
					,[agent_registration_no] = isnull(@agent_registration_no, agent_registration_no)
					,[agent_pan_no] = isnull(@agent_Pan_no, agent_pan_no)
					,[agent_credit_limit] = isnull(@agent_credit_limit, agent_credit_limit)
					,[agent_contract_local_date] = isnull(@agent_contract_date, agent_contract_local_date)
					,[agent_contract_nepali_date] = isnull(dbo.func_get_nepali_date(@agent_contract_date), agent_contract_nepali_date)
					,[agent_logo_img] = isnull(@agent_logo, agent_logo_img)
					,[agent_document_img_front] = isnull(@agent_pan_Certificate, [agent_document_img_front])
					,[agent_document_img_back] = isnull(@agent_reg_certificate, [agent_document_img_back])
					,[contact_person_name] = isnull(@contact_person_name, contact_person_name)
					,[contact_person_mobile_no] = isnull(@contact_person_mobile_number, contact_person_mobile_no)
					,[contact_person_id_type] = isnull(@contact_person_ID_type, contact_person_id_type)
					,[contact_person_id_no] = isnull(@contact_person_ID_no, contact_person_id_no)
					,[contact_id_issue_local_date] = isnull(@contact_person_Id_issue_date, contact_id_issue_local_date)
					,[contact_id_issued_bs_date] = isnull(@contact_person_id_issue_date_nepali, contact_id_issued_bs_date)
					,[contact_id_issued_district] = isnull(@contact_person_id_issue_district, contact_id_issued_district)
					,contact_person_address = isnull(@contact_person_address, contact_person_address)
					,[agent_commission_id] = isnull(@agent_commission_cat_id, agent_commission_id)
					,[is_auto_commission] = isnull(@agent_commission_type, is_auto_commission)
					,[updated_by] = isnull(@action_user, updated_by)
					,[updated_UTC_date] = isnull(GETUTCDATE(), updated_UTC_date)
					,[updated_local_date] = isnull(GETDATE(), updated_local_date)
					,[updated_nepali_date] = isnull(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)
					,[updated_ip] = isnull(@action_ip, updated_ip)
				WHERE agent_id = @agent_id

				UPDATE [dbo].[tbl_user_detail]
				SET [role_id] = isnull(@role_id, role_id)
					,[usr_type_id] = isnull(@usr_type_id, usr_type_id)
					,[usr_type] = isnull(@usr_type, usr_type)
					,[user_name] = isnull(@user_name, user_name)
					,[full_name] = isnull((isnull(@first_name, '') + '' + isnull(@middle_name, '') + '' + isnull(@last_name, '')), full_name)
					,[password] = CASE 
						WHEN @password IS NULL
							THEN password
						ELSE PWDENCRYPT(@password)
						END
					,[user_email] = isnull(@user_email, user_email)
					,[user_mobile_no] = isnull(@user_mobile_number, user_mobile_no)
					,[updated_by] = isnull(@action_user, updated_by)
					,[updated_UTC_date] = isnull(GETUTCDATE(), updated_UTC_date)
					,[updated_local_date] = isnull(GETDATE(), updated_local_date)
					,[updated_nepali_date] = isnull(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)
					,[updated_ip] = isnull(@action_ip, updated_ip)
					,[is_primary] = isnull(@is_primary, is_primary)
					,[browser_info] = isnull(@action_browser, browser_info)
				WHERE user_id = @user_id

				EXEC sproc_error_handler @error_code = '0'
					,@msg = 'Agent updated successfully'
					,@id = NULL;

				COMMIT TRANSACTION updateAgentDetail
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION updateAgentDetail

				SET @desc = 'sql error found:(' + error_message() + ')'

				INSERT INTO tbl_error_log_sql (
					sql_error_desc
					,sql_error_script
					,sql_query_string
					,sql_error_category
					,sql_error_source
					,sql_error_local_date
					,sql_error_UTC_date
					,sql_error_nepali_date
					)
				SELECT @desc
					,'sproc_agent_Detail_v3(Update Agent Detail and user detail:flag ''u'')'
					,'sql'
					,'sql'
					,'sproc_agent_Detail_v3(insert Agent Detail and user detail)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH

			RETURN
				--select '0' code, 'Agent updated succesfully' message, null id  
		END

		--view Distributor user  
		IF @flag = 'vdu'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail with (NOLOCK)
					WHERE agent_id = @agent_id
						AND agent_status = 'y'
					)
			BEGIN
				EXEC sproc_error_handler @error_Code = '1'
					,@Msg = 'Agent Not Found'
					,@id = NULL
			END
			ELSE IF (
					SELECT count(*)
					FROM tbl_user_detail with (NOLOCK)
					WHERE agent_id = @agent_id
					) = 0
			BEGIN
				EXEC sproc_error_handler @error_Code = '1'
					,@Msg = 'NO users found for this agent'
					,@id = @agent_id
			END
			ELSE
			BEGIN
				SELECT user_id
					,user_name
					,user_email
					,user_mobile_no
					,is_primary
					,STATUS
				FROM tbl_user_detail with (NOLOCK)
				WHERE agent_id = @agent_id
			END
		END

		--select all dist  
		IF (@Flag = 's')
		BEGIN
			-- SET @currentdate = dbo.func_get_nepali_date(DEFAULT);    
			SET @sql = 
				'SELECT agent_id,parent_id,agent_code,agent_type,agent_operation_type,agent_name,available_balance,agent_phone_no,agent_mobile_no,agent_email_address,agent_nationality,  
agent_country,permanent_province--agent_province  
 ,permanent_district--agent_district  
 ,permanent_localbody--agent_localbody  
 ,permanent_wardno--agent_wardno  
 ,permanent_address--agent_address  
 ,web_url --agent_web_url  
 --agent_province,agent_district,agent_localbody,agent_wardno,agent_address,  
--agent_web_url,  
agent_registration_no,agent_pan_no,agent_credit_limit,format(agent_contract_local_date,''yyyy-MM-dd'')agent_contract_local_date,agent_contract_nepali_date,agent_logo_img,  
null agent_registeration_cert_image,  
null agent_pan_cert_image,  
contact_person_name,agent_country_code,contact_person_mobile_no,contact_person_id_type,contact_person_id_no,format(contact_id_issue_local_date,''yyyy-MM-dd'')contact_id_issue_local_date,  
contact_id_issued_bs_date,contact_id_issued_district,agent_commission_id,agent_status,is_auto_commission,agent_qr_image,fund_load_reward,txn_reward_point,  
referal_id,agent_referal_id,lock_status,locked_reason,locked_UTC_date,locked_by,created_UTC_date,created_local_date,created_nepali_date,created_by,created_ip,  
created_platform,updated_by,updated_UTC_date,updated_local_date,updated_nepali_date,updated_ip,agent_address,contact_person_address   
FROM tbl_agent_detail with (NOLOCK) WHERE 1=1  '

			--IF (@action_user != 'superadmin')    
			-- AND NOT EXISTS (    
			--  SELECT 'x'    
			--  FROM tbl_agent_detail ad    
			--  JOIN tbl_user_detail ud ON ad.agent_id = ud.agent_id    
			--  WHERE ud.user_name = @action_user    
			--   AND ISNULL(ud.is_primary, 'n') = 'y'    
			--  )    
			--BEGIN    
			-- SET @sql = @sql + ' AND Created_By = ''' + @action_user + '''';    
			--END;    
			--ELSE   
			IF @action_user IS NOT NULL
				AND (
					@parent_Id IS NULL
					AND @agent_id IS NULL
					)
				AND EXISTS (
					SELECT 'x'
					FROM tbl_user_detail
					WHERE (
							usr_type IS NULL
							OR usr_type = 'admin'
							)
						AND user_name = @action_user
					)
			BEGIN
				SET @sql = @sql + ' AND parent_id is null';
			END;

			IF (@agent_type IS NOT NULL)
			BEGIN
				SET @sql = @sql + ' AND agent_type = ''' + @agent_type + '''';
			END;

			IF @agent_id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND Agent_Id = ''' + CAST(@agent_id AS VARCHAR) + '''';
			END;

			IF @parent_Id IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_Id AS VARCHAR) + '''';
			END;

			IF @agent_status IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND agent_status = ''' + @agent_status + '''';
			END;

			IF @agent_mobile_no IS NOT NULL
				OR @agent_email IS NOT NULL
				OR @agent_name IS NOT NULL
			BEGIN
				SET @sql = @sql + ' AND agent_mobile_no LIKE  ''%' + @agent_mobile_no + '%''' --' or agent_email_address LIKE ''%' + @agent_email + '%'' or agent_name LIKE ''%' + @agent_name + '%''';    
			END;

			IF @end_date IS NULL
				SET @end_date = @currentdate;

			IF @from_date IS NOT NULL
				AND @end_date IS NOT NULL
				SET @sql = @sql + ' AND created_local_date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999''';

			PRINT (@sql);

			EXEC (@sql);
		END;

		--select distributor detail  
		IF @flag = 'ds'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail with (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT '1' code
					,'Agent not found ' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT format(agent_contract_local_date, 'yyyy-MM-dd') agent_contract_local_date
					,format(contact_id_issue_local_date, 'yyyy-MM-dd') contact_id_issue_local_date
					,*
				FROM tbl_agent_detail ad with (NOLOCK)
				JOIN tbl_user_detail u with (NOLOCK) ON u.agent_id = ad.agent_id
				WHERE ad.agent_id = @agent_id
			END
		END

		--selct distributor user  
		IF @flag = 'v'
		BEGIN
			IF @agent_id IS NULL
				AND @user_id IS NULL --Get all agent users    
			BEGIN
				SELECT u.[user_id]
					,u.[user_name]
					,u.full_name
					,u.agent_id
					,u.user_mobile_no
					,u.user_email
					,u.STATUS
					,u.usr_type_id
					,u.usr_type
					,b.role_id
					,a.parent_id
					,ad.agent_id AS grand_parent_id
					,gd.gateway_id
				FROM tbl_user_detail u
				JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
				LEFT JOIN tbl_agent_detail ad with (NOLOCK) ON ad.agent_id = a.parent_id
				LEFT JOIN tbl_user_role b with (NOLOCK) ON b.[user_id] = u.[user_id]
				LEFT JOIN tbl_gateway_detail gd with (NOLOCK) ON gd.gateway_id = a.agent_id
					--where u.agent_id = @agent_id and u.user_id =@user_id      
			END
			ELSE IF @user_id IS NOT NULL
				AND @agent_id IS NOT NULL --get agent user by agent_id and user_id    
			BEGIN
				SELECT u.[user_id]
					,u.[user_name]
					,u.full_name
					,u.agent_id
					,u.user_mobile_no
					,u.user_email
					,u.STATUS
					,u.usr_type_id
					,u.usr_type
					,u.is_primary
					,b.role_id
					,a.parent_id
					,ad.agent_id AS grand_parent_id
					,gd.gateway_id
				FROM tbl_user_detail u
				JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
				LEFT JOIN tbl_agent_detail ad with (NOLOCK) ON ad.agent_id = a.parent_id
				LEFT JOIN tbl_user_role b with (NOLOCK) ON b.[user_id] = u.[user_id]
				LEFT JOIN tbl_gateway_detail gd with (NOLOCK) ON gd.gateway_id = a.agent_id
				WHERE u.agent_id = @agent_id
					AND u.user_id = @user_id
			END
			ELSE IF @agent_id IS NOT NULL --get agent user by agent_id    
			BEGIN
				SELECT u.[user_id]
					,u.[user_name]
					,u.full_name
					,u.agent_id
					,u.user_mobile_no
					,u.user_email
					,u.STATUS
					,u.usr_type_id
					,u.usr_type
					,b.role_id
					,a.parent_id
					,ad.agent_id AS grand_parent_id
					,u.is_primary
					,gd.gateway_id
				FROM tbl_user_detail u
				JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
				LEFT JOIN tbl_agent_detail ad with (NOLOCK) ON ad.agent_id = a.parent_id
				LEFT JOIN tbl_user_role b with (NOLOCK) ON b.[user_id] = u.[user_id]
				LEFT JOIN tbl_gateway_detail gd with (NOLOCK) ON gd.gateway_id = a.agent_id
				WHERE u.agent_id = @agent_id
			END
			ELSE IF @user_id IS NOT NULL -- get admin user by user_id    
			BEGIN
				SELECT u.[user_id]
					,u.[user_name]
					,u.full_name
					,u.agent_id
					,u.user_mobile_no
					,u.user_email
					,u.STATUS
					,u.usr_type_id
					,u.usr_type
					,b.role_id
					,NULL parent_id
					,NULL AS grand_parent_id
					,NULL gateway_id
					,u.is_primary
					,u.created_by
					,u.created_local_date
				FROM tbl_user_detail u
				--left join tbl_agent_detail a on a.agent_id = u.agent_id      
				--left join tbl_agent_detail ad on ad.agent_id = a.parent_id      
				LEFT JOIN tbl_user_role b with (NOLOCK) ON b.[user_id] = u.[user_id]
				--LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id       
				WHERE u.user_id = @user_id
					AND agent_id IS NULL
			END
			ELSE -- get all admin users    
			BEGIN
				SELECT u.[user_id]
					,u.[user_name]
					,u.full_name
					,u.agent_id
					,u.user_mobile_no
					,u.user_email
					,u.STATUS
					,u.usr_type_id
					,u.usr_type
					,b.role_id
					,NULL parent_id
					,NULL AS grand_parent_id
					,NULL gateway_id
					,u.is_primary
					,u.created_by
					,u.created_local_date
				FROM tbl_user_detail u
				--left join tbl_agent_detail a on a.agent_id = u.agent_id      
				--left join tbl_agent_detail ad on ad.agent_id = a.parent_id      
				LEFT JOIN tbl_user_role b with (NOLOCK) ON b.[user_id] = u.[user_id]
				--LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id       
				WHERE agent_id IS NULL
			END
		END

		-- assign distributor role  / agent role
		IF @flag = 'dRole'
		BEGIN
			UPDATE tbl_user_detail
			SET role_id = @role_id
				,is_primary = @is_primary
			WHERE user_id = @user_id
				AND agent_id = @agent_id

			SELECT '0' code
				,'Role updated succesfully' message
				,NULL id

			RETURN
		END

		-- get distributor role  / agent role
		IF @flag = 'gRole'
		BEGIN
			SELECT role_id
				,is_primary
				,user_id
				,agent_id
			FROM tbl_user_detail with (NOLOCK)
			WHERE user_id = @user_id
				AND agent_id = @agent_id

			RETURN
		END

		--Block/unblock dist user  
		IF @flag = 'uu' -- disable user with agent id      
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail u with (NOLOCK)
					JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
					WHERE user_id = @user_id
						AND u.agent_id = @agent_id
					)
			BEGIN
				SELECT '1' code
					,'User not found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				UPDATE tbl_user_detail
				SET STATUS = Isnull(@user_status, STATUS)
				WHERE user_id = @user_id
					AND agent_id = @agent_id

				EXEC sproc_error_handler @error_code = '0'
					,@msg = 'user status updated'
					,@id = NULL;
			END
		END

		--insert distributer user  / insert agent user
		IF @flag = 'id'
		BEGIN
			-- check if user already exists                                
			IF EXISTS (
					SELECT TOP 1 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_name = @user_name
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'username already exists'
					,@error_script = 'username already exists'
					,@error_source = 'sproc_user_detail @flag = ''i'''
					,@id = NULL;

				RETURN;
			END;

			IF EXISTS (
					SELECT TOP 1 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_mobile_no = @user_mobile_number
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'mobile/phone number already exists'
					,@error_script = 'mobile/phone number already exists'
					,@error_source = 'sproc_user_detail @flag = ''i'''
					,@id = NULL;

				RETURN;
			END;

			IF EXISTS (
					SELECT TOP 1 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_email = @user_email
					)
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'email id already exists'
					,@error_source = 'sproc_user_detail @flag = ''i'''
					,@id = NULL;

				RETURN;
			END;

			IF @usr_type_id = 1
			BEGIN
				SET @usr_type = 'admin'
				SET @role_id = '1'
			END
			ELSE IF @usr_type_id = 6
			BEGIN
				SET @usr_type = 'walletuser'
				SET @role_id = '6'
			END
			ELSE
			BEGIN
				SET @usr_type = @usr_type
			END

			INSERT INTO dbo.tbl_user_detail (
				[user_name]
				,[password]
				,full_name
				,agent_id
				,user_email
				,user_mobile_no
				,created_by
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_ip
				,created_platform
				,allow_multiple_login
				,STATUS
				,usr_type_id
				,usr_type
				,is_login_enabled
				,is_primary
				,browser_info
				,role_id
				)
			VALUES (
				@user_name
				,pwdencrypt(@password)
				,isnull(@Full_name, isnull(@first_name, '') + ' ' + isnull(@middle_name, '') + '' + isnull(@last_name, ''))
				,@agent_id
				,@user_email
				,@user_mobile_number
				,@action_user
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_ip
				,@action_platform
				,'n'
				,@user_status
				,@usr_type_id
				,@usr_type
				,'y'
				,@is_primary
				,@action_browser
				,@role_id
				);

			EXEC sproc_error_handler @error_code = '0'
				,@msg = 'user created succesfully.'
				,@id = NULL;

			RETURN;
		END;

		--update distributor user  / update agent user
		IF @flag = 'ud'
		BEGIN
			IF @user_id IS NULL
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'user id cannot be null'
					,@id = NULL;

				RETURN;
			END;

			IF @password IS NOT NULL
			BEGIN
				IF (len(@password) < 8)
				BEGIN
					SELECT '1' code
						,'Password must be 8 or more than 8 characters' message
						,NULL id

					RETURN
				END
				ELSE IF (@password <> @confirm_password)
				BEGIN
					SELECT '1' code
						,'Password and Confirm password didn''t match' message
						,NULL id

					RETURN
				END
			END

			--BEGIN TRANSACTION 
			UPDATE dbo.tbl_user_detail
			SET full_name = COALESCE(@full_name, isnull(@first_name, '') + ' ' + isnull(@middle_name, '') + ' ' + isnull(@last_name, ''), full_name)
				,user_name = isnull(@user_name, user_name)
				,password = Isnull(PWDENcrypt(@password), password)
				,agent_id = isnull(@agent_id, agent_id)
				,user_email = isnull(@user_email, user_email)
				,user_mobile_no = isnull(@user_mobile_number, user_mobile_no)
				,role_id = isnull(@role_id, role_id)
				,updated_by = isnull(@action_user, updated_by)
				,updated_UTC_date = isnull(GETUTCDATE(), updated_UTC_date)
				,updated_local_date = isnull(GETDATE(), updated_local_date)
				,updated_nepali_date = isnull(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)
				,STATUS = isnull(@user_status, STATUS)
				,usr_type_id = isnull(@usr_type_id, usr_type_id)
				,usr_type = isnull(@usr_type, usr_type)
				,is_primary = isnull(@is_primary, is_primary)
				,browser_info = isnull(@action_browser, browser_info)
			WHERE user_id = @user_id;

			IF @role_id IS NOT NULL
			BEGIN
				DELETE tbl_user_role
				WHERE user_id = @user_id;

				INSERT INTO tbl_user_role (
					[user_id]
					,role_id
					,created_ip
					,created_by
					,created_UTC_date
					,created_local_date
					,created_nepali_date
					)
				SELECT @user_id
					,@role_id
					,@action_ip
					,@action_user
					,GETUTCDATE()
					,GETDATE()
					,dbo.func_get_nepali_date(DEFAULT);
			END;

			--ROLLBACK;
			EXEC sproc_error_handler @error_code = '0'
				,@msg = 'user succesfully updated'
				,@id = @user_id;

			RETURN;
		END;

		-- admin user / no agent      
		IF @flag = 'e'
		BEGIN
			IF @user_id IS NULL
			BEGIN
				SELECT '1' code
					,'User Id cannot be null' message;

				RETURN;
			END;

			--delete from [dbo].[pp_admin_detail] where userid = @user_id                                
			UPDATE [dbo].tbl_user_detail
			SET STATUS = @user_status
			WHERE user_id = @user_id
				AND agent_id IS NULL;

			EXEC sproc_error_handler @error_code = '0'
				,@msg = 'user status updated'
				,@id = NULL;

			RETURN;
		END;

		IF @flag = 'uu' -- disable user with agent id      
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail u with (NOLOCK)
					JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
					WHERE user_id = @user_id
						AND u.agent_id = @agent_id
					)
			BEGIN
				SELECT '1' code
					,'User not found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				UPDATE tbl_user_detail
				SET STATUS = Isnull(@user_status, STATUS)
				WHERE user_id = @user_id
					AND agent_id = @agent_id

				EXEC sproc_error_handler @error_code = '0'
					,@msg = 'user status updated'
					,@id = NULL;
			END
		END

		IF @flag = 'lglst'
		BEGIN
			SET @sql = 'select user_id,u.full_name,user_email,user_mobile_no,u.created_local_date,u.created_by,status,user_name   
   from tbl_user_detail u   
   left join tbl_agent_detail a on u.agent_id=a.agent_id  where 1=1'

			IF @usr_type <> 'Admin'
				SET @sql = @sql + ' and a.agent_name=''' + @user_name + ''''

			PRINT @sql

			EXEC (@sql)

			RETURN;
		END

		--extend credit limit  
		IF @flag = 'exc'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail with (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT '1' code
					,'Agent Not Found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				UPDATE tbl_agent_detail
				SET agent_credit_limit = isnull(@agent_credit_limit, agent_credit_limit)
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'Credit limit Extended sucessfully' message
					,@agent_id id

				RETURN
			END
		END

		--select agent user
		IF @flag = 'aguser'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail WITH (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT 1 code
					,'Agent Not Found' Message
					,NULL id

				RETURN
			END
			ELSE IF @user_id IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT 'x'
						FROM tbl_user_detail WITH (NOLOCK)
						WHERE user_id = @user_id
						)
				BEGIN
					SELECT 1 code
						,'User Not Found' Message
						,NULL id

					RETURN
				END
			END
			
				SET @sql = '

				Select ad.first_name, ad.middle_name, ad.last_name, u.full_name, u.user_mobile_no,u.user_email, u.created_local_date as CreatedDate,u.status, u.is_primary, u.agent_id, u.user_id, u.usr_type, u.user_name  from tbl_user_detail u  with (NOLOCK)
				join tbl_agent_detail ad with (NOLOCK) on ad.agent_id = u.agent_id
				where 1= 1 '

				IF @agent_id IS NOT NULL
				BEGIN
					SET @sql = @sql + ' and  u.agent_id = ' + cast(@agent_id AS VARCHAR)
				END

				IF @user_id IS NOT NULL
				BEGIN
					SET @sql = @sql + ' and u.user_id = ' + cast(@user_id AS VARCHAR)
				END
				print @sql      
				exec(@sql) 
			
		END

		--disable agent and all users under it  
		IF @flag = 'eau'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail WITH (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT 1 code
					,'Agent not Found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				UPDATE tbl_agent_detail
				SET agent_status = @user_status
				WHERE agent_id = @agent_id

				UPDATE tbl_user_detail
				SET STATUS = @user_status
				WHERE agent_id = @agent_id
			END
		END
	END
END TRY

BEGIN CATCH
	IF @@trancount > 0
		ROLLBACK TRANSACTION;

	SELECT 1 CODE
		,ERROR_MESSAGE() msg
		,NULL id;
END CATCH;
GO


