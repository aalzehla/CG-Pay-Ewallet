USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_gateway_products_commission]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sproc_gateway_products_commission] @flag char(3) = null
	,@gtw_pid int = null
	,@gateway_id int = null
	,@product_id int = null
	,@commission float = null
	,@commission_type varchar(100) = null
	,@ipaddress varchar(100)=null
	,@createdby varchar(100)=null
as
begin
	-- set nocount on added to prevent extra result sets from  
	-- interfering with select statements.  
	set nocount on;

	if @flag = 'i'
	begin
		if exists (
				select 'x'
				from tbl_gateway_products
				where product_id = @product_id
					and gateway_id = @gateway_id
				)
		begin
			update tbl_gateway_products
			set commission_value = @commission
				,commission_type = @commission_type
				,updated_by=@createdby
				,updated_ip=@ipaddress
				,updated_local_date=getdate()
				,updated_UTC_date=GETUTCDATE()
			where product_id = @product_id
				and gateway_id = @gateway_id

			select '0' code
				,'commission updated successfully' message
				,null id

			return
		end

		insert into tbl_gateway_products(
			gateway_id
			,product_id
			,commission_value
			,commission_type
			,created_by
			,created_ip
			,created_local_date
			,created_UTC_date
			--,created_nepali_date
			)
		values (
			@gateway_id
			,@product_id
			,@commission
			,@commission_type
			,@createdby
			,@ipaddress
			,GETDATE()
			,GETUTCDATE()
			)

		select '0' code
			,'commission added successfully' message
			,null id

		return
	end

	if @flag = 's'
	begin
		--select @gatewayid gatewayid  
		-- ,productid productid  
		-- ,productlabel servicename  
		-- ,null commission  
		-- ,null commissiontype  
		--from dtamanageservices  
		--where productid not in (  
		--  select productid  
		--  from dtagatewayproducts  
		--  where gatewayid = @gatewayid  
		--  )  
		--union  
		--select gp.gatewayid gatewayid  
		-- ,ms.productid productid  
		-- ,ms.productlabel servicename  
		-- ,gp.commission commission  
		-- ,ltrim(gp.commissiontype) commissiontype  
		--from dtagatewayproducts gp  
		--join dtamanageservices ms on ms.productid = gp.productid  
		--where gp.gatewayid = @gatewayid  
		--order by productid  
		if @product_id is null
			select  gp.gtw_pid gatewayproductid,
			gp.gateway_id gatewayid
				,ms.product_id productid
				,product_label servicename
				,gp.commission_value commission
				,ltrim(gp.commission_type) commissiontype
			from tbl_gateway_products gp
			join tbl_manage_services ms on ms.product_id = gp.product_id
			where  ms.primary_gateway=@gateway_id
			or ms.secondary_gateway=@gateway_id
			order by productid
		else
			select  gp.gtw_pid gatewayproductid,gp.gateway_id gatewayid
				,ms.product_id productid
				,product_label servicename
				,gp.commission_value commission
				,ltrim(gp.commission_type) commissiontype
			from tbl_gateway_products gp
			join tbl_manage_services ms on ms.product_id = gp.product_id
			where gp.product_id = @product_id
			order by productid
	end
end


GO
