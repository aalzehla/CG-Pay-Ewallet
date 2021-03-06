USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_KYC_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE           PROCEDURE [dbo].[apiproc_KYC_detail]
	@Flag char(3),
	@user_id int = null,
	@user_name varchar(512) = null,
	@agent_id int  = null,
	@first_name varchar(512) = null,
	@middle_name  varchar(512) = null,
	@last_name varchar(512) = null,
	@gender varchar(512) = null,
	@dob_english datetime = null,
	@dob_nepali varchar(512) = null,
	@phone_no varchar(512) = null,
	@mobile_no varchar(512) = null,
	@email_address varchar(512) = null,
	@occupation varchar(512) = null,
	@marital_status varchar(512) = null,
	@spouse_name varchar(512) = null,
	@fathers_name varchar(512) = null,
	@mothers_name varchar(512) = null,
	@grand_fathers_name varchar(512) = null,
	@nationality varchar(512) = null,
	@country varchar(512) = null,
	@permanent_province varchar(512) = null,
	@permanent_district varchar(512) = null,
	@permanent_local_body varchar(512) = null,
	@permanent_ward_no varchar(512) = null,
	@permanent_address varchar(512) = null,
	@temporary_province varchar(512) = null,
	@temporary_district varchar(512) = null,
	@temporary_local_body varchar(512) = null,
	@temporary_ward_no varchar(512) = null,
	@temporary_address varchar(512) = null,
	@id_type varchar(512) = null,
	@id_no varchar(512) = null,
	@id_issued_district varchar(512) = null,
	@id_issued_date_english datetime = null,
	@id_issued_date_nepali varchar(512) = null,
	@id_expiry_date_english datetime = null,
	@id_expiry_issued_date_nepali varchar(512) = null,
	@id_front_image varchar(max) = null,
	@id_back_image varchar(max) = null,
	@user_pp_image varchar(max) = null,
	@action_user varchar(512) =  null,
	@encrypted_identification_photo_log varchar(512) =  null,
	@encrypted_identification_photo_logs varchar(512) = null,
	@encrypted_id_document_front varchar(512) =  null,
	@encrypted_id_document_back varchar(512) =  null,
	@search_field1 varchar(512) = null,
	@occupation_param  varchar(5) = null
	
AS
BEGIN

set nocount on;
	declare @username  varchar(512)
	select @agent_id = u.agent_id, @user_id = u.user_id, @username =u.user_name from tbl_user_detail u join tbl_agent_detail ad on ad.agent_id = u.agent_id where u.user_mobile_no = @user_name or u.user_email = @user_name

	if @Flag = 'i' -- insert kyc details
	begin
		UPDATE [dbo].[tbl_agent_detail]
   SET 
		[first_name]			= ISNULL(ISNULL(@first_name,''),first_name)
      ,[middle_name]			= ISNULL(ISNULL(@middle_name,''),middle_name) 
      ,[last_name]				= ISNULL(ISNULL(@last_name,''),last_name)
      ,[date_of_birth_eng]		= ISNULL(@dob_english,date_of_birth_eng)
      ,[date_of_birth_nep]		= ISNULL(@dob_nepali,date_of_birth_nep)
      ,[gender]					= ISNULL(@gender,gender)
      ,[agent_phone_no]			= ISNULL(@phone_no,agent_phone_no)
      ,[agent_mobile_no]		= ISNULL(@mobile_no,agent_mobile_no)
      ,[agent_email_address]	= ISNULL(@email_address,agent_email_address)
      ,[occupation]				= ISNULL(@occupation,occupation)
      ,[marital_status]			= ISNULL(@marital_status,marital_status) 
      ,[spouse_name]			= ISNULL(@spouse_name,spouse_name)
      ,[father_name]			= ISNULL(@fathers_name,father_name) 
      ,[mother_name]			= ISNULL(@mothers_name,mother_name) 
      ,[grand_father_name]		= ISNULL(@grand_fathers_name,grand_father_name) 
      ,[agent_nationality]		= ISNULL(@nationality,agent_nationality) 
      ,[agent_country]			= ISNULL(@country,agent_country) 
      ,[permanent_province]		= ISNULL(@permanent_province,permanent_province) 
      ,[permanent_district]		= ISNULL(@permanent_district,permanent_district) 
      ,[permanent_localbody]	= ISNULL(@permanent_local_body,permanent_localbody) 
      ,[permanent_wardno]		= ISNULL(@permanent_ward_no,permanent_wardno)
      ,[permanent_address]		= ISNULL(@permanent_address,permanent_address)
      ,[temporary_province]		= ISNULL(@temporary_province,temporary_province)
      ,[temporary_district]		= ISNULL(@temporary_district,temporary_district)
      ,[temporary_localbody]	= ISNULL(@temporary_local_body,temporary_localbody) 
      ,[temporary_wardno]		= ISNULL(@temporary_ward_no,temporary_wardno) 
      ,[temporary_address]		= ISNULL(@temporary_address,temporary_address) 
      ,[full_name]				= ISNULL(ISNULL(@first_name,'') + ISNULL(@middle_name,'') +  ISNULL(@last_name,''),full_name) 
      ,[updated_by]				= ISNULL(@action_user,updated_by)
      ,[updated_UTC_date]		= ISNULL(GETUTCDATE(),updated_UTC_date) 
      ,[updated_local_date]		= ISNULL(GETDATE(),updated_local_date)
      ,[updated_nepali_date]	= ISNULL(dbo.func_get_nepali_date(default),updated_nepali_date)
	  ,kyc_status				= 'Pending'
		where agent_id = @agent_id

		UPDATE [dbo].[tbl_kyc_documents]
   SET
      [user_name]							= ISNULL(@username, user_name)
      ,[Identification_type]				= ISNULL(@id_type,Identification_type)
      ,[Identification_NO]					= ISNULL(@id_no,Identification_NO)
      ,[Identification_issued_date]			= ISNULL(@id_issued_date_english,Identification_issued_date)
      ,[Identification_issued_date_nepali]	= ISNULL(@id_issued_date_nepali,Identification_issued_date_nepali)
      ,[Identification_expiry_date]			= ISNULL(@id_expiry_date_english,Identification_expiry_date)
      ,[Identification_expiry_date_nepali]	= ISNULL(@id_expiry_issued_date_nepali,Identification_expiry_date_nepali)
      ,[Identification_issued_place]		= ISNULL(@id_issued_district,Identification_issued_place)
      ,[Identification_photo_Logo]			= ISNULL(@user_pp_image,Identification_photo_Logo)
      ,[Id_document_front]					= ISNULL(@id_front_image,Id_document_front)
      ,[Id_document_back]					= ISNULL(@id_back_image,Id_document_back)
      ,[updated_by]							= ISNULL(@action_user,updated_by)
      ,[updated_UTC_date]					= ISNULL(GETUTCDATE(),updated_UTC_date)
      ,[updated_local_date]					= ISNULL(GETDATE(),updated_local_date)
      ,[updated_nepali_date]				= ISNULL(dbo.func_get_nepali_date(default),updated_nepali_date)
      ,[encrypted_identification_photo_log] = ISNULL( @encrypted_identification_photo_log,encrypted_identification_photo_log)
      ,[encrypted_id_document_front]		= ISNULL(@encrypted_id_document_front,encrypted_id_document_front)
      ,[encrypted_id_document_back]			= ISNULL(@encrypted_id_document_back,encrypted_id_document_back)
		where agent_id  = @agent_id


		select '0' code, 'KYC details submitted succesfull' message, @agent_id id
		return

	end

	if @Flag = 'f' --file upload
	begin
		UPDATE [dbo].[tbl_kyc_documents]
			SET		[Identification_photo_Logo]				= ISNULL(@user_pp_image,Identification_photo_Logo)
					,[Id_document_front]					= ISNULL(@id_front_image,Id_document_front)
					,[Id_document_back]						= ISNULL(@id_back_image,Id_document_back)
					,[encrypted_identification_photo_log]	= ISNULL(@encrypted_identification_photo_log,encrypted_identification_photo_log)
					,[encrypted_id_document_front]			= ISNULL(@encrypted_id_document_front,encrypted_id_document_front)
					,[encrypted_id_document_back]			= ISNULL(@encrypted_id_document_back,encrypted_id_document_back)
		where agent_id  = @agent_id
		select '0' code, 'KYC Image Upload Succesfull' message, @agent_id id
   
	end

	--get district
	if @flag = 'dis'      
 begin      
  declare @districtsql varchar(max) = '';      
      
     
  set @districtsql += 'select distinct (a.district) value';      
  set @districtsql += ',a.district text';      
  set @districtsql += ' from tbl_state_local_nepal a(nolock) where country_code= ''np'' ';      
      
  if @search_field1 is not null      
   set @districtsql += ' and province_code=''' + @search_field1 + '''';      
  set @districtsql += ' order by a.district';      
      
  print (@districtsql);      
      
  exec (@districtsql);      
 end      
                                      ;          
	

	--get local level
	if @flag = 'loc'      
 begin 
	declare @localSql varchar(max) = '';

set @localSql += 'select distinct  local_level  value'
  set @localSql +=' ,local_level   text'   
  set @localSql += ' from tbl_state_local_nepal(nolock)  where country_code= ''np''';
  
  if @search_field1 is not null
  begin
	  set @localSql += ' and district = isnull('''+@search_field1+''', district)'  
  end
  set @localSql += '  order by value' 
   print (@localSql);      
      
  exec (@localSql);
       
 end      

 --get occupation
 	if @flag = 'oc'
	begin --13
	if(@occupation_param = 1)
	begin
	select static_data_value as value, static_data_label as text from tbl_static_data where sdata_type_id = 13
	end
		
	end

	-- get Kyc Details
	if @Flag = 'gk'
	begin

		if nullif(@user_name,'') is null
		begin
			select '105' code, 'Username is required!' message, null id
			return
		end

		if @agent_id is null
		begin
			select 104 Code, 'User Not Found!' Message, null id
			return
		end

		
		SELECT ad.full_name
	,ad.first_name
	,ad.middle_name
	,ad.last_name
	,format(ad.date_of_birth_eng, 'yyyy-MM-dd') date_of_birth_eng
	,ad.date_of_birth_nep
	,ad.gender
	,ad.occupation
	,ad.father_name
	,ad.mother_name
	,ad.grand_father_name
	,ad.permanent_province
	,ad.permanent_district
	,ad.permanent_localbody
	,ad.permanent_wardno
	,ad.permanent_address
	,ad.temporary_province
	,ad.temporary_district
	,ad.temporary_localbody
	,ad.temporary_wardno
	,ad.temporary_address
	,ad.agent_nationality
	,ad.agent_country
	,k.Id_document_back
	,k.Id_document_front
	,k.Identification_photo_Logo
	,k.Identification_type
	,k.Identification_issued_date
	,k.Identification_issued_date_nepali
	,k.Identification_NO
	,k.Identification_expiry_date
	,k.Identification_expiry_date_nepali
	,k.KYC_Verified
	,k.Identification_issued_place
FROM tbl_user_detail u
JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id
JOIN tbl_kyc_documents k ON k.agent_id = u.agent_id
WHERE u.user_id = @user_id


		--where k.KYC_Verified  =  'Approved'
	end


END






GO
