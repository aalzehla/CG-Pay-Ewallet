USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_products_gateway]    Script Date: 28/08/2020 11:57:21 ******/
DROP PROCEDURE [dbo].[sproc_products_gateway]
GO

/****** Object:  StoredProcedure [dbo].[sproc_products_gateway]    Script Date: 28/08/2020 11:57:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sproc_products_gateway] @flag CHAR(3) = NULL
	,@sno INT = NULL
	,@gateway_id INT = NULL
	,@product_id INT = NULL
	,@action_user VARCHAR(50) = NULL
	,@action_ip_address VARCHAR(50) = NULL
	,@commission_earned DECIMAL(18, 2) = NULL
	,@commission_type VARCHAR(10) = NULL
	,@commission DECIMAL(18, 2) = NULL
AS
BEGIN
	-- set nocount on added to prevent extra result sets from  
	-- interfering with select statements.  
	SET NOCOUNT ON;

	DECLARE @product_name VARCHAR(100)
		,@gateway_name VARCHAR(100);

	BEGIN
		IF @flag = 'i'
		BEGIN
			SELECT @product_name = product_label
			FROM tbl_manage_services with (NOLOCK)
			WHERE product_id = @product_id;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_gateway_detail with (NOLOCK)
					WHERE gateway_id = @gateway_id
						AND isnull(gateway_status, 'y') = 'n'
					)
			BEGIN
				SELECT '1' code
					,'selected gateway is not active' message
					,NULL id;

				RETURN;
			END;

			IF EXISTS (
					SELECT 'x'
					FROM tbl_gateway_products with (NOLOCK)
					WHERE product_id = @product_id
						AND gateway_id = @gateway_id
					)
			BEGIN
				SELECT '1' code
					,'gateway for the respective product already exists' message
					,NULL id;

				RETURN;
			END;

			INSERT INTO tbl_gateway_products (
				gateway_id
				,product_id
				,commission_value
				,commission_type
				,commission_earned
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				,created_ip
				)
			VALUES (
				@gateway_id
				,@product_id
				,isnull(@commission, 0)
				,isnull(@commission_type, 'p')
				,isnull(@commission_earned, 0)
				,@action_user
				,getdate()
				,getutcdate()
				,[dbo].func_get_nepali_date(DEFAULT)
				,@action_ip_address
				);

			SELECT '0' code
				,'gateway updated for the product: ' + @product_name message
				,scope_identity() id;

			RETURN;
		END;

		IF @flag = 'd' --delete gateway products
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_gateway_products with (NOLOCK)
					WHERE product_id = @product_id
						AND gtw_pid = @sno
					)
			BEGIN
				SELECT '1' code
					,'gateway for the respective product doesn''t exist' message
					,NULL id;

				RETURN;
			END;

			DELETE
			FROM tbl_gateway_products
			WHERE product_id = @product_id
				AND gtw_pid = @sno;

			SELECT '0' code
				,'selected gateway for the product has been deleted' message
				,NULL id;

			RETURN;
		END;

		IF @flag = 'u'
		BEGIN
			IF EXISTS (
					SELECT 'x'
					FROM tbl_gateway_products with (NOLOCK)
					WHERE product_id = @product_id
						AND gateway_id = @gateway_id
					)
			BEGIN
				UPDATE tbl_gateway_products
				SET commission_value = @commission
					,commission_type = @commission_type
				WHERE product_id = @product_id
					AND gateway_id = @gateway_id;

				SELECT '0' code
					,'commission updated successfully' message
					,NULL id;

				RETURN;
			END;

			INSERT INTO tbl_gateway_products (
				gateway_id
				,product_id
				,commission_value
				,commission_type
				)
			VALUES (
				@gateway_id
				,@product_id
				,@commission
				,@commission_type
				);

			SELECT '0' code
				,'commission added successfully' message
				,NULL id;

			RETURN;
		END;

		IF @flag = 's'
		BEGIN
			IF @gateway_id IS NOT NULL
				SELECT gp.gateway_id gatewayid
					,ms.product_id productid
					,product_label servicename
					,gp.commission_value commission
					,ltrim(gp.commission_type) commissiontype
				FROM tbl_gateway_products gp with (NOLOCK)
				JOIN tbl_manage_services ms with (NOLOCK) ON ms.product_id = gp.product_id
				WHERE gateway_id = @gateway_id
				ORDER BY productid;
			ELSE
				SELECT gp.gateway_id gatewayid
					,ms.product_id productid
					,product_label servicename
					,gp.commission_value commission
					,ltrim(gp.commission_type) commissiontype
				FROM tbl_gateway_products gp with (NOLOCK)
				JOIN tbl_manage_services ms with (NOLOCK) ON ms.product_id = gp.product_id
				WHERE gateway_id = @gateway_id
				ORDER BY productid;
		END;
	END;
END;
GO


