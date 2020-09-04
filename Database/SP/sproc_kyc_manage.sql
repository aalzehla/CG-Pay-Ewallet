USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_kyc_manage]    Script Date: 27/08/2020 13:20:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE OR ALTER       PROCEDURE [dbo].[sproc_kyc_manage] @flag CHAR(5) = NULL
	,@mode CHAR(5) = NULL
	,@user_id INT = NULL
	,@agent_id INT = NULL
	,@action_user VARCHAR(100) = NULL
	,@action_ip_address VARCHAR(20) = NULL
	,@created_platform VARCHAR(20) = NULL
	,@agent_type VARCHAR(200) = NULL
	,@nationality VARCHAR(200) = NULL
	,@first_name VARCHAR(200) = NULL
	,@middle_name VARCHAR(200) = NULL
	,@last_name VARCHAR(200) = NULL
	,@full_name VARCHAR(200) = NULL
	,@dob_eng DATE = NULL
	,@dob_nep VARCHAR(200) = NULL
	,@gender VARCHAR(200) = NULL
	,@occupation VARCHAR(200) = NULL
	,@marital_status VARCHAR(200) = NULL
	,@spouse_name VARCHAR(200) = NULL
	,@father_name VARCHAR(200) = NULL
	,@mother_name VARCHAR(200) = NULL
	,@grand_father_name VARCHAR(200) = NULL
	,@email_address VARCHAR(50) = NULL
	,@province VARCHAR(200) = NULL
	,@district VARCHAR(200) = NULL
	,@local_body VARCHAR(200) = NULL
	,@ward_no INT = NULL
	,@address VARCHAR(200) = NULL
	,@temp_province VARCHAR(200) = NULL
	,@temp_district VARCHAR(200) = NULL
	,@temp_local_body VARCHAR(200) = NULL
	,@temp_ward_no INT = NULL
	,@temp_address VARCHAR(200) = NULL
	,@contact_id_type VARCHAR(200) = NULL
	,@contact_id_no VARCHAR(200) = NULL
	,@contact_id_issued_date DATE = NULL
	,@contact_id_issued_date_nep VARCHAR(10) = NULL
	,@contact_id_issued_district VARCHAR(200) = NULL
	,@logo_img VARCHAR(1000) = NULL
	,@ppPhoto_img VARCHAR(1000) = NULL
	,@id_front_img VARCHAR(1000) = NULL
	,@id_back_photo_img VARCHAR(1000) = NULL
	,@mobile_no VARCHAR(10) = NULL
	,@country VARCHAR(100) = NULL
	,@password VARCHAR(500) = NULL
	,@device_id VARCHAR(30) = NULL
	,@m_pin VARCHAR(10) = NULL
	,@latitude VARCHAR(200) = NULL
	,@longitude VARCHAR(200) = NULL
	,@phone_no VARCHAR(200) = NULL
	,@pan_no VARCHAR(200) = NULL
	,@web_url VARCHAR(200) = NULL
	,@registration_no VARCHAR(200) = NULL
	,@credit_limit DECIMAL(18, 2) = NULL
	,@support_staff VARCHAR(200) = NULL
	,@contract_date DATETIME = NULL
	,@contact_name VARCHAR(200) = NULL
	,@parent_id INT = NULL
	,@grand_parent_id INT = NULL
	,@id_type_id VARCHAR(200) = NULL
	,@id_type VARCHAR(200) = NULL
	,@id_number VARCHAR(200) = NULL
	,@id_issuedate_local DATETIME = NULL
	,@id_issue_date_nepali DATETIME = NULL
	,@id_expiry_date_local DATETIME = NULL
	,@id_expiry_date_nepali DATETIME = NULL
	,@id_issue_by VARCHAR(200) = NULL
	,@id_issue_district VARCHAR(200) = NULL
	,@file_path VARCHAR(1000) = NULL
	,@file_extension VARCHAR(200) = NULL
	,@is_deleted VARCHAR(200) = NULL
	,@remarks VARCHAR(200) = NULL
	,@registration_type VARCHAR(200) = NULL
	,@from_date varchar(20) = null
	,@to_date varchar(20) = null
	,@kyc_status varchar(20) = null
AS
	declare @sql varchar(max)
--flag       
--  i: insert KYC Details by Admin      
--    list : display list of KYC filled      
--    v : view detail of KYC filled      
--    u : update KYC/ by admin      
--    a : approve KYC      
--    r : reject KYC      
BEGIN
	SET NOCOUNT ON;

	--flag i --  insert kyc by admin customer      
	DECLARE @id INT
		,@country_code CHAR(3);
	--for notification json  
	DECLARE @notiId INT;
	DECLARE @dataPayload VARCHAR(max);
	DECLARE @checkDOB datetime

	SELECT @user_id = ud.user_id
	FROM tbl_user_detail ud with (NOLOCK)
	INNER JOIN tbl_agent_detail ta with (NOLOCK) ON ta.agent_id = ud.agent_id
	WHERE ta.agent_id = @agent_id

	IF @flag = 'i'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_kyc_documents with (NOLOCK)
				WHERE agent_id = @agent_id
				)
		BEGIN
			SELECT '1' code
				,'KYC Documents already exists for the Agent' message
				,NULL id;

			RETURN;
		END;

		----- insert into agentdetail table      
		INSERT INTO dbo.tbl_agent_detail (
			first_name
			,middle_name
			,last_name
			,date_of_birth_eng
			,date_of_birth_nep
			,[gender]
			,[occupation]
			,[marital_status]
			,[spouse_name]
			,[father_name]
			,[mother_name]
			,[grand_father_name]
			,agent_country
			,permanent_province
			,permanent_district
			,permanent_localbody
			,permanent_wardno
			,permanent_address
			,[temporary_province]
			,[temporary_district]
			,[temporary_localbody]
			,[temporary_wardno]
			,[temporary_address]
			,agent_phone_no
			,agent_email_address
			,agent_mobile_no
			,created_UTC_date
			,created_local_date
			,created_nepali_date
			,created_by
			,created_ip
			,created_platform
			,kyc_status
			)
		VALUES (
			@first_name
			,@middle_name
			,@last_name
			,@dob_eng
			,@dob_nep
			,--dbo.func_get_nepali_date(@dob_eng),      
			@gender
			,@occupation
			,@marital_status
			,@spouse_name
			,@father_name
			,@mother_name
			,@grand_father_name
			,@country
			,@province
			,@district
			,@local_body
			,@ward_no
			,@address
			,@temp_province
			,@temp_district
			,@temp_local_body
			,@temp_ward_no
			,@temp_address
			,@phone_no
			,@email_address
			,@mobile_no
			,GETUTCDATE()
			,GETDATE()
			,[dbo].func_get_nepali_date(DEFAULT)
			,@action_user
			,@action_ip_address
			,@created_platform
			,'Approved'
			);

		---------------------------      
		SELECT @agent_id = SCOPE_IDENTITY();

		INSERT INTO tbl_kyc_documents (
			[agent_id]
			,[Identification_type]
			,[Identification_NO]
			,[Identification_issued_date]
			,[Identification_issued_date_nepali]
			,[Identification_expiry_date]
			,[identification_expiry_date_nepali]
			,[Identification_issued_place]
			,[Identification_photo_Logo]
			,[Id_document_front]
			,[Id_document_back]
			,[created_by]
			,[created_UTC_date]
			,[created_local_date]
			,[created_nepali_date]
			)
		VALUES (
			@agent_id
			,@id_type
			,@id_number
			,@id_issuedate_local
			,@id_issue_date_nepali
			,@id_expiry_date_local
			,@id_expiry_date_nepali
			,@id_issue_district
			,@ppPhoto_img
			,@id_front_img
			,@id_back_photo_img
			,@action_user
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			);

		---- insert into kyc detail table      
		--insert into dbo.tbl_kyc_approval_detail      
		--(agent_id,       
		-- created_UTC_date,       
		-- created_local_date,       
		-- created_nepali_date,                     -- created_by,       
		-- remarks       
		--)      
		--values      
		--(@agent_id,       
		-- getutcdate(),       
		-- getdate(),       
		-- [dbo].func_get_nepali_date(default),       
		-- @action_user,       
		-- isnull(@remarks,'Approved')                 
		--);      
		SELECT '0' code
			,'inserted successfully.' message
			,NULL id;

		RETURN;
	END;

	IF @flag = 'u' -- update KYC for Agent By Admin      
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_agent_detail with (NOLOCK)
				WHERE agent_id = @agent_id
					AND kyc_status = 'Approved'
				)
		BEGIN
			SELECT '1' Code
				,'Kyc already approved for this agent' Message
				,NULL id;

			RETURN;
		END;

		set @checkDOB = DATEADD(YEAR,-18, convert(date,format(GETDATE(),'yyyy-MM-dd'),120))


		if (@dob_eng < @checkDOB)
		Begin
			Select 1 code, 'User must be 18 Years or more' Message, null id
			return
		End


		UPDATE [dbo].[tbl_agent_detail]
		SET [first_name] = ISNULL(@first_name, [first_name])
			,[middle_name] = ISNULL(@middle_name, [middle_name])
			,[last_name] = ISNULL(@last_name, [last_name])
			,[date_of_birth_eng] = ISNULL(@dob_eng, [date_of_birth_eng])
			,[date_of_birth_nep] = ISNULL(@dob_nep, [date_of_birth_nep])
			,--ISNULL(dbo.func_get_nepali_date(@dob_eng),[date_of_birth_nep])       
			[gender] = ISNULL(@gender, [gender])
			,[occupation] = ISNULL(@occupation, [occupation])
			,[marital_status] = ISNULL(@marital_status, [marital_status])
			,[spouse_name] = ISNULL(@spouse_name, [spouse_name])
			,[father_name] = ISNULL(@father_name, [father_name])
			,[mother_name] = ISNULL(@mother_name, [mother_name])
			,[grand_father_name] = ISNULL(@grand_father_name, [grand_father_name])
			,[agent_nationality] = ISNULL(@nationality, [agent_nationality])
			,[agent_country] = ISNULL(@country, [agent_country])
			,[permanent_province] = ISNULL(@province, [permanent_province])
			,[permanent_district] = ISNULL(@district, [permanent_district])
			,[permanent_localbody] = ISNULL(@local_body, [permanent_localbody])
			,[permanent_wardno] = ISNULL(@ward_no, [permanent_wardno])
			,[permanent_address] = ISNULL(@address, [permanent_address])
			,[temporary_province] = ISNULL(@temp_province, [temporary_province])
			,[temporary_district] = ISNULL(@temp_district, [temporary_district])
			,[temporary_localbody] = ISNULL(@temp_local_body, [temporary_localbody])
			,[temporary_wardno] = ISNULL(@temp_ward_no, [temporary_wardno])
			,[temporary_address] = ISNULL(@temp_address, [temporary_address])
			,[agent_phone_no] = ISNULL(@phone_no, [agent_phone_no])
			,[agent_email_address] = ISNULL(@email_address, [agent_email_address])
			,[updated_by] = ISNULL(@action_user, [updated_by])
			,[updated_UTC_date] = ISNULL(GETUTCDATE(), [updated_UTC_date])
			,[updated_local_date] = ISNULL(GETDATE(), [updated_local_date])
			,[updated_nepali_date] = ISNULL(dbo.func_get_nepali_date(DEFAULT), [updated_nepali_date])
			,[updated_ip] = ISNULL(@action_ip_address, [updated_ip])
			,[agent_mobile_no] = ISNULL(@mobile_no, [agent_mobile_no])
			,[kyc_status] = ISNULL('Pending', KYC_status)
		WHERE agent_id = @agent_id;

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_kyc_documents with (NOLOCK)
				WHERE agent_id = @agent_id
				)
		BEGIN
			INSERT INTO tbl_kyc_documents (
				[agent_id]
				,[Identification_type]
				,[Identification_NO]
				,[Identification_issued_date]
				,[Identification_issued_date_nepali]
				,[Identification_expiry_date]
				,[identification_expiry_date_nepali]
				,[Identification_issued_place]
				,[Identification_photo_Logo]
				,[Id_document_front]
				,[Id_document_back]
				,[KYC_Verified]
				,[created_by]
				,[created_UTC_date]
				,[created_local_date]
				,[created_nepali_date]
				)
			VALUES (
				@agent_id
				,@id_type
				,@id_number
				,@id_issuedate_local
				,@id_issue_date_nepali
				,@id_expiry_date_local
				,@id_expiry_date_nepali
				,@id_issue_district
				,@ppPhoto_img
				,@id_front_img
				,@id_back_photo_img
				,'Pending'
				,@action_user
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				);
		END;
		ELSE
		BEGIN
			UPDATE tbl_kyc_documents
			SET Identification_type = ISNULL(@id_type, Identification_type)
				,[Identification_NO] = ISNULL(@id_number, Identification_NO)
				,[Identification_issued_date] = ISNULL(@id_issuedate_local, Identification_issued_date)
				,[Identification_issued_date_nepali] = ISNULL(@id_issue_date_nepali, Identification_issued_date_nepali)
				,[Identification_expiry_date] = ISNULL(@id_expiry_date_local, Identification_expiry_date)
				,[identification_expiry_date_nepali] = ISNULL(@id_expiry_date_nepali, identification_expiry_date_nepali)
				,[Identification_issued_place] = ISNULL(@id_issue_district, Identification_issued_place)
				,[Identification_photo_Logo] = ISNULL(@ppPhoto_img, Identification_photo_Logo)
				,[Id_document_front] = ISNULL(@id_front_img, Id_document_front)
				,[Id_document_back] = ISNULL(@id_back_photo_img, Id_document_back)
				,[KYC_Verified] = 'Pending'
			WHERE agent_id = @agent_id
		END;

		---- insert into kyc detail table      
		--           insert into dbo.tbl_kyc_approval_detail      
		--           (agent_id,       
		--            created_UTC_date,       
		--            created_local_date,       
		--            created_nepali_date,       
		--            created_by,       
		--            remarks       
		--           )      
		--           values      
		--           (@agent_id,       
		--            getutcdate(),       
		--            getdate(),       
		--            [dbo].func_get_nepali_date(default),       
		--            @action_user,       
		--            isnull(@remarks,'Approved')                 
		--           );      
		SELECT '0' Code
			,'KYC Update Successfull' Message
			,NULL id;

		RETURN;
	END;

	IF @flag = 'list'
	BEGIN
	if @from_date is not null 
	  begin
		--set @from_date =  Convert(date,(DATEADD(Hour,-1, GETDATE())),120)-- as varchar)
		set @from_date = convert(date, @from_date, 120)

	  end
	--else
	--  begin
	--	set @from_date = convert(date, @from_date, 120)
	--  end

	if @to_date is null
	  begin
		set @to_date = Convert(date,(DATEADD(hour,0,GETDATE())),120)-- as varchar)
		--set @to_date = convert(date, @to_date, 120)

	  end
	else
	  begin
		set @to_date = convert(date, @to_date, 120)
	  end

	  set @sql ='SELECT ad.agent_id AS [AgentId]
			,agent_mobile_no AS Mobile
			,agent_email_address AS Email
			,ad.created_local_date AS [SubmittedDate]
			,ISNULL(kyc_status, ''Pending'') AS [KYCStatus]
			FROM tbl_agent_detail ad with (NOLOCK)
			JOIN tbl_kyc_documents kd with (NOLOCK) ON kd.agent_id = ad.agent_id
			WHERE  KYc_status <> ''N'' and ad.agent_type NOT LIKE ''%distributor%''';

		IF (@kyc_status IS NOT NULL)
		BEGIN
			SET @sql = @sql + ' AND KYC_Status = ''' + @kyc_status + '''';
		END;


				IF (@email_address IS NOT NULL)
		BEGIN
			SET @sql = @sql + ' AND agent_email_address = ''' + @email_address + '''';
		END;

				IF (@mobile_no IS NOT NULL)
		BEGIN
			SET @sql = @sql + ' AND agent_mobile_no = ''' + @mobile_no + '''';
		END;

		if(@from_date is not null and @to_date is not null)
		begin
			set @sql = @sql + ' and ad.created_local_date between '''+ @from_date + ''' and '''+ @to_date +' 23:59:59.997'''; 
			set @sql = @sql +  ' order by ad.created_local_date desc'
		end
		

		print @sql
		exec (@sql)
	END;

	IF @flag = 'v'
	BEGIN
		IF @agent_id IS NULL
		BEGIN
			SELECT 1 Code
				,'Agent Id is required' Message
				,NULL id;

			RETURN;
		END

		SELECT first_name
			,middle_name
			,last_name
			,format(date_of_birth_eng, 'yyyy-MM-dd') date_of_birth_eng
			,date_of_birth_nep
			,gender
			,occupation
			,marital_status
			,spouse_name
			,father_name
			,mother_name
			,grand_father_name
			,agent_nationality
			,agent_country
			,permanent_province
			,permanent_district
			,permanent_localbody
			,permanent_wardno
			,permanent_address
			,temporary_province
			,temporary_district
			,temporary_localbody
			,temporary_wardno
			,temporary_address
			,agent_phone_no
			,agent_email_address
			,agent_mobile_no
			,admin_remarks
			,ISNULL(kd.KYC_Verified, 'N') AS [kyc_status]
			,kd.Identification_type
			,kd.Identification_NO
			,kd.Identification_issued_date
			,kd.Identification_issued_date_nepali
			,kd.Identification_expiry_date
			,kd.identification_expiry_date_nepali
			,kd.Identification_issued_place
			,kd.Identification_photo_Logo
			,kd.Id_document_front
			,kd.Id_document_back
			,ad.agent_type
			,ad.agent_id
		FROM tbl_agent_detail ad with (NOLOCK)
		LEFT JOIN tbl_kyc_documents kd with (NOLOCK) ON kd.agent_id = ad.agent_id
		-- join tbl_kyc_approval_detail kad on kad.agent_id = ad.agent_id    
		WHERE
			--ad.kyc_status = 'Approved'       
			--AND isnull(kad.action_status,'Pending') not in ('Rejected','pending')    
			-- AND     
			ad.agent_id = @agent_id
		ORDER BY kd.created_local_date DESC;
	END;--     

	IF @flag = 'r'
	BEGIN
		IF @agent_id IS NULL
		BEGIN
			SELECT '1' COde
				,'Agent Id is required' Message
				,NULL id;

			RETURN;
		END;

		IF @remarks IS NULL
		BEGIN
			SELECT '1' Code
				,'Remarks is required' Message
				,NULL id

			RETURN
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_agent_detail with (NOLOCK)
				WHERE isnull(kyc_status, 'Pending') = 'Approved'
					AND agent_id = @agent_id
				)
		BEGIN
			UPDATE tbl_agent_detail
			SET kyc_status = 'Rejected'
				,admin_remarks = @remarks
			WHERE agent_id = @agent_id;

			UPDATE tbl_kyc_documents
			SET KYC_Verified = 'Rejected'
			WHERE agent_id = @agent_id;

			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_kyc_approval_detail with (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				INSERT INTO tbl_kyc_approval_detail (
					agent_id
					,action_status
					,remarks
					,created_by
					,created_ip
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					@agent_id
					,'Rejected'
					,@remarks
					,@action_user
					,@action_ip_address
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					);
			END;

			-- insert into tbl_agent_notification  
			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,read_status
				)
			VALUES (
				'KYC'
				,'KYC Rejected, ' + @remarks
				,'KYC_Transaction'
				,'n'
				--,@agent_id  
				,@user_id
				,@agent_id
				,@user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,'n'
				)

			SET @notiId = @@IDENTITY
			SET @dataPayload = dbo.func_notification_payload(@notiId, NULL, NULL);

			UPDATE tbl_agent_notification
			SET data_payload = @dataPayload
			WHERE notification_id = @notiId

			SELECT '0' Code
				,'KYC Rejected, ' + @remarks Message
				,NULL id;

			RETURN;
		END;
		ELSE
		BEGIN
			SELECT '1' Code
				,'KYC Already Approved' Message
				,NULL id;

			RETURN;
		END;
	END;

	IF @flag = 'a'
	BEGIN
		IF @agent_id IS NULL
		BEGIN
			SELECT '1' COde
				,'Agent Id is required' Message
				,NULL id;

			RETURN;
		END;

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_agent_detail with (NOLOCK)
				WHERE kyc_status = 'Approved'
					AND agent_id = @agent_id
				)
		BEGIN
			UPDATE tbl_agent_detail
			SET kyc_status = 'Approved'
				,admin_remarks = @remarks
			WHERE agent_id = @agent_id;

			UPDATE tbl_kyc_documents
			SET KYC_Verified = 'Approved'
			WHERE agent_id = @agent_id;

			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_kyc_approval_detail with (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				INSERT INTO tbl_kyc_approval_detail (
					agent_id
					,action_status
					,remarks
					,created_by
					,created_ip
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					@agent_id
					,'Approved'
					,@remarks
					,@action_user
					,@action_ip_address
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					);
			END
			ELSE
			BEGIN
				UPDATE tbl_kyc_approval_detail
				SET action_status = ISNULL('Approved', action_status)
					,remarks = ISNULL(@remarks, remarks)
					,created_by = ISNULL(@action_user, created_by)
					,created_ip = ISNULL(@action_ip_address, created_ip)
					,created_local_date = ISNULL(GETDATE(), created_local_date)
					,created_UTC_date = ISNULL(GETUTCDATE(), created_UTC_date)
					,created_nepali_date = ISNULL(dbo.func_get_nepali_date(DEFAULT), created_nepali_date)
				WHERE agent_id = @agent_id
			END

			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,read_status
				)
			VALUES (
				'KYC'
				,'Your KYC has been Approved'
				,'KYC_Transaction'
				,'n'
				--,@agent_id  
				,@user_id
				,@agent_id
				,@user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,'n'
				)

			SET @notiId = @@IDENTITY
			SET @dataPayload = dbo.func_notification_payload(@notiId, NULL, NULL);

			UPDATE tbl_agent_notification
			SET data_payload = @dataPayload
			WHERE notification_id = @notiId

			SELECT '0' Code
				,'KYC Approved succesfully' Message
				,NULL id;

			RETURN;
		END;
		ELSE
		BEGIN
			SELECT '1' COde
				,'KYC Already Approved' Message
				,NULL id;

			RETURN;
		END;
	END;
END;



GO


