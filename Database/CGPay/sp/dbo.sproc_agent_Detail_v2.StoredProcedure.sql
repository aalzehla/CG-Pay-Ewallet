USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_agent_Detail_v2]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sproc_agent_Detail_v2]
	@flag char(3) = null,
	@action_user varchar(50) =  null,
	@user_id int  =  null,
	@agent_id int  = null,
	@parent_id int =  null,
	@agent_type varchar(20) = null,
	@agent_operation_type char(1) =  null,
	@agent_name varchar(512) =  null,
	@agent_phone_number varchar(15) =  null,
	@agent_mobile_no varchar(10) = nul,
	@agent_email varchar(512) =  null,
	@agent_web_url varchar(512) = null,
	@agent_registration_no varchar(512) = null,
	@agent_Pan_no varchar(512) = null,
	@agent_contract_date datetime =  null,
	@agent_province varchar(512) =  null,
	@agent_district varchar(512) = null,
	@agent_local_body varchar(512) = null,
	@agent_ward_number int = null,
	@agent_street varchar(512) = null,
	@agent_country varchar(512) = null,
	@agent_credit_limit decimal(18,2) = null,
	@agent_balance decimal(18,2) = null,
	@agent_logo varchar(max) = null,
	@agent_reg_certificate varchar(max) = null,
	@agent_pan_Certificate varchar(max) = null,
	@agent_commission_cat_id int  =  null,
	-----user details-------
	@user_name varchar(50) =  null,
	@password varchar(512) = null,
	@confirm_password varchar(512) = null,
	@first_name varchar(512) = null,
	@middle_name varchar(512) = null,
	@last_name varchar(512) = null,
	@user_mobile_number varchar(10) = null,
	@user_email varchar(512) = null,
	----contact person for business agent
	@contact_person_name varchar(512) = null,
	@contact_person_mobile_number varchar(10) = null,
	@contact_person_ID_type varchar(512) = null,
	@contact_person_ID_no varchar(512) = null,
	@contact_person_Id_issue_date varchar(512) = null,
	@contact_person_id_issue_date_nepali varchar(512) =  null,
	@contact_person_id_expiry_date varchar(512) = null,
	@contact_person_id_expiry_date_nepali varchar(512) = null,
	@contact_person_id_issue_district varchar(512) = null

	as
	set nocount on;

	DECLARE @action_agent_type VARCHAR(20), @action_parent_id INT, @action_agent_id INT, @action_grand_parent_id INT,@contract_nepali_date VARCHAR(10),@id INT ,@usr_type VARCHAR(20)  
	DECLARE @sql NVARCHAR(MAX),@currentdate DATETIME,@last_online DATETIME  ,@agent_code varchar(512) ,@agent_country_code char(3)

	Begin try
		begin
			  IF (@action_user IS NULL) AND @flag != 'drole' AND @flag != 'gdrole' and @flag!='arole'
				BEGIN  
				   EXEC sproc_error_handler @error_code = '1'  
					,@Msg = 'UserName is required'  
					,@id = NULL;  
  
					 RETURN;  
				END; 
		

		SELECT @action_agent_type = A.agent_type  
			   ,@action_parent_id = A.parent_id  
			   ,@action_agent_id = U.agent_id  
			   ,@action_grand_parent_id = ad.parent_id  
		FROM [dbo].tbl_user_detail AS U  
		LEFT JOIN tbl_agent_detail AS A ON U.agent_id = A.agent_id  
		LEFT JOIN tbl_agent_detail AS ad ON ad.agent_id = A.parent_id  
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
				EXEC sproc_error_handler @error_code = '1'  
				 ,@Msg = 'PARENT ID DID NOT MATCH'  
				 ,@id = @action_user;  
			   END; 

		
		--sub distributor not allowed to create distributor
		   IF (  
			 @action_agent_type in ('subdistributor','agent','subagent')  
			 AND @agent_type = 'distributor'  
			 )  
		   BEGIN  
			EXEC sproc_error_handler @error_Code = '1'  
			 ,@Msg = 'YOUR ARE NOT ALLOWED TO CREATE DISTRIBUTOR'  
			 ,@id = @agent_id;  
		   END; 
		End		
	end


	 IF @agent_contract_date IS NOT NULL  
		SET @contract_nepali_date = dbo.func_get_nepali_date(@agent_contract_date);

	if @flag = 'i'
	begin
		   SELECT @agent_id = MAX(agent_id) FROM tbl_agent_detail;  
  
		   SELECT @agent_code = RIGHT('0000000000' + CAST((ISNULL(@agent_id, 0) + 1) AS VARCHAR(10)), 10);  
  
		   SET @agent_country = ISNULL(@agent_country, 'Nepal');  
		   SET @agent_country_code = ISNULL(@agent_country_code, 'NPL');  
	
			   IF EXISTS (SELECT 'x' FROM tbl_agent_detail WHERE agent_email_address = @agent_email)  
			   BEGIN  
				SELECT '1' Code  
				 ,'Email Address already exists' Message  
				 ,NULL id;  
  
				RETURN;  
			   END;
	
			IF EXISTS ( SELECT 'x' FROM tbl_agent_detail WHERE agent_mobile_no = @agent_mobile_no )  
		   BEGIN  
			SELECT '1' Code  
			 ,'Mobile Number already exists' Message  
			 ,NULL id;  
  
			RETURN;  
		   END;  
	
		   IF @agent_commission_cat_id IS NULL  
		   BEGIN  
			SELECT @agent_commission_cat_id = category_id  
			FROM tbl_commission_category  
			WHERE category_name = 'Default';  
		   END;  
	


		
	end




	END TRY  
  
	BEGIN CATCH  
	 IF @@trancount > 0  
	  ROLLBACK TRANSACTION;  
  
	 SELECT 1 CODE,ERROR_MESSAGE() msg ,NULL id;  
	END CATCH;        
		  




GO
