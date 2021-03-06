USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_static_data_setup]    Script Date: 8/10/2020 10:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sproc_static_data_setup] (
	@flag CHAR(30)
	,@sdata_type_id INT = NULL
	,@svalue VARCHAR(200) = NULL
	,@slabel VARCHAR(200) = NULL
	,@sdatarowid INT = NULL
	,@ssubvalue VARCHAR(200) = NULL
	,@ssublabel VARCHAR(200) = NULL
	,@createdby VARCHAR(50) = NULL
	,@status VARCHAR(10) = NULL
	,@sdatatype NVARCHAR(200)=Null
	,@additional_value1 NVARCHAR(200)=Null
	,@additional_value2 NVARCHAR(200)=Null
	,@additional_value3 NVARCHAR(200)=Null
	,@additional_value4 NVARCHAR(200)=Null
	)
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @sdatatype NVARCHAR(200);

	--IF @sdata_type_id IS NOT NULL
	--BEGIN
	--	SELECT @sdatatype = static_data_name
	--	FROM tbl_static_data_type
	--	WHERE sdata_type_id = @sdata_type_id;
	--END;

	IF @flag = 'u'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_static_data
				WHERE static_data_row_id = @sdatarowid
					AND sdata_type_id = @sdata_type_id
				)
		BEGIN
			UPDATE tbl_static_data
			SET static_data_label = isnull(@slabel, static_data_label)
				,static_data_value = isnull(@svalue, static_data_value)
				,static_data_description = isnull(@sdatatype, static_data_description)
				,additional_value1 = isnull(@additional_value1, additional_value1)
				,additional_value2 = isnull(@additional_value2, additional_value2)
				,additional_value3 = isnull(@additional_value3, additional_value3)
				,additional_value4 = isnull(@additional_value4, additional_value4)
				,updated_by = @createdby
				,updated_local_date = GETDATE()
				,updated_nepali_date = [dbo].func_get_nepali_date(DEFAULT)
				,updated_UTC_date = GETUTCDATE()
			WHERE static_data_row_id = @sdatarowid
				AND sdata_type_id = @sdata_type_id

			SELECT '0' AS errorcode
				,'Update Successfully' message
				,NULL AS id;

			RETURN;
		END

		SELECT '1' AS errorcode
			,'Data Not Found' message
			,NULL AS id;
	END

	IF @flag = 'i'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_static_data
				WHERE static_data_value = @svalue
					AND static_data_label = @slabel
					AND sdata_type_id = @sdata_type_id
				)
		BEGIN
			INSERT INTO tbl_static_data (
				sdata_type_id
				,static_data_value
				,static_data_label
				,static_data_description
				,additional_value1
				,additional_value2
				,additional_value3
				,additional_value4
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				)
			VALUES (
				@sdata_type_id
				,@svalue
				,@slabel
				,@sdatatype
				,@additional_value1
				,@additional_value2
				,@additional_value3
				,@additional_value4
				,getutcdate()
				,getdate()
				,[dbo].func_get_nepali_date(DEFAULT)
				,@createdby
				);

			--IF @ssublabel IS NOT NULL
			--	AND @ssubvalue IS NOT NULL
			--BEGIN
			--	IF NOT EXISTS (
			--			SELECT 'x'
			--			FROM tbl_sub_static_data
			--			WHERE sub_data_value = @ssubvalue
			--				AND sub_data_label = @ssublabel
			--				AND sub_id = @svalue
			--			)
			--	BEGIN
			--		INSERT INTO tbl_sub_static_data (
			--			sub_id
			--			,sub_data_value
			--			,sub_data_label
			--			,additional_value
			--			,decription
			--			)
			--		VALUES (
			--			@svalue
			--			,@ssubvalue
			--			,@ssublabel
			--			,NULL
			--			,'branch'
			--			);
			--	END;
			--END;

			SELECT '0' AS errorcode
				,'inserted successfully' message
				,NULL AS id;
		END;
		ELSE
		BEGIN
			--IF @ssublabel IS NOT NULL
			--	AND @ssubvalue IS NOT NULL
			--BEGIN
			--	IF NOT EXISTS (
			--			SELECT 'x'
			--			FROM tbl_sub_static_data
			--			WHERE sub_data_value = @ssubvalue
			--				AND sub_data_label = @ssublabel
			--				AND sub_id = @sdata_type_id
			--			)
			--	BEGIN
			--		INSERT INTO tbl_sub_static_data (
			--			sub_id
			--			,sub_data_value
			--			,sub_data_label
			--			,additional_value
			--			,decription
			--			)
			--		VALUES (
			--			@svalue
			--			,@ssubvalue
			--			,@ssublabel
			--			,NULL
			--			,'branch'
			--			);
			--	END;
			--END;

			SELECT '0' AS errorcode
				,'already exists' message
				,NULL AS id;
		END;
	END;

	IF @flag = 'st'
	BEGIN
		SELECT sdata_type_id
			,static_data_description
			,static_data_name
		FROM tbl_static_data_type
	END

	IF @flag = 'stid'
	BEGIN
		SELECT sdata_type_id
			,static_data_description
			,static_data_name
		FROM tbl_static_data_type
		WHERE sdata_type_id = @sdata_type_id
	END

	IF @flag = 'sdlst'
	BEGIN
		SELECT static_data_row_id
			,sdata_type_id
			,static_data_value
			,static_data_label
			,static_data_description
			,is_deleted
		FROM tbl_static_data
		WHERE sdata_type_id = @sdata_type_id
	END

	IF @flag = 'sdid'
	BEGIN
		SELECT static_data_row_id
			,sdata_type_id
			,static_data_value
			,static_data_label
			,static_data_description
			,additional_value1
			,additional_value2
			,additional_value3
			,additional_value4
		FROM tbl_static_data
		WHERE sdata_type_id = @sdata_type_id
			AND static_data_row_id = @sdatarowid
	END

	IF @flag = 'd'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_static_data
				WHERE static_data_row_id = @sdatarowid
					AND sdata_type_id = @sdata_type_id
				)
		BEGIN
			UPDATE tbl_static_data
			SET is_deleted = @status
				,updated_by = @createdby
				,updated_local_date = GETDATE()
				,updated_nepali_date = [dbo].func_get_nepali_date(DEFAULT)
				,updated_UTC_date = GETUTCDATE()
			WHERE static_data_row_id = @sdatarowid
				AND sdata_type_id = @sdata_type_id

			SELECT '0' AS errorcode
				,'Update Successfully' message
				,NULL AS id;

			RETURN;
		END

		SELECT '1' AS errorcode
			,'Data Not Found' message
			,NULL AS id;
	END
END;


