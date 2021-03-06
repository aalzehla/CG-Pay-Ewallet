USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_products_gateway]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sproc_products_gateway] @flag             char(3)        = null, 
                                            @sno              int            = null, 
                                            @gateway_id        int            = null, 
                                            @product_id        int            = null, 
                                            @action_user       varchar(50)    = null, 
                                            @action_ip_address    varchar(50)    = null, 
                                            @commission_earned decimal(18, 2)  = null, 
                                            @commission_type   varchar(10)    = null, 
                                            @commission       decimal(18, 2)  = null
as
    begin  
        -- set nocount on added to prevent extra result sets from  
        -- interfering with select statements.  
        set nocount on;
        declare @product_name varchar(100), @gateway_name varchar(100);
        begin
            if @flag = 'i'
                begin
                    select @product_name = product_label
                    from tbl_manage_services
                    where product_id = @product_id;
                    if exists
                    (
                        select 'x'
                        from tbl_gateway_detail
                        where gateway_id = @gateway_id
                              and isnull(gateway_status, 'y') = 'n'
                    )
                        begin
                            select '1' code, 
                                   'selected gateway is not active' message, 
                                   null id;
                            return;
                    end;
                    if exists
                    (
                        select 'x'
                        from tbl_gateway_products
                        where product_id = @product_id
                              and gateway_id = @gateway_id
                    )
                        begin
                            select '1' code, 
                                   'gateway for the respective product already exists' message, 
                                   null id;
                            return;
                    end;

                    -- insert into the table for display  
                    --insert into dtaproductsgateway(productid, gatewayid, createdby, createddatelocal, createddateutc, createddatebs, createdip)  
                    --values(@productid, @gatewayid, @actionuser, getdate(), getutcdate(), [dbo].[ufn_getbikramsambatdate](default),@fromipaddress )  

                    insert into tbl_gateway_products
                    (gateway_id, 
                     product_id, 
                     commission_value, 
                     commission_type, 
                     commission_earned, 
                     created_by, 
                     created_local_date, 
                     created_UTC_date, 
                     created_nepali_date, 
                     created_ip
                    )
                    values
                    (@gateway_id, 
                     @product_id, 
                     isnull(@commission, 0), 
                     isnull(@commission_type, 'p'), 
                     isnull(@commission_earned, 0), 
                     @action_user, 
                     getdate(), 
                     getutcdate(), 
                     [dbo].func_get_nepali_date(default), 
                     @action_ip_address
                    );
                    select '0' code, 
                           'gateway updated for the product: ' + @product_name message, 
                           scope_identity() id;
                    return;
            end;
            if @flag = 'd' --delete gateway products
                begin
                    if not exists
                    (
                        select 'x'
                        from tbl_gateway_products
                        where product_id = @product_id
                              and gtw_pid = @sno
                    )
                        begin
                            select '1' code, 
                                   'gateway for the respective product doesn''t exist' message, 
                                   null id;
                            return;
                    end;
                    delete from tbl_gateway_products
                    where product_id = @product_id
                          and gtw_pid = @sno;
                    select '0' code, 
                           'selected gateway for the product has been deleted' message, 
                           null id;
                    return;
            end;
            if @flag = 'u'
                begin
                    if exists
                    (
                        select 'x'
                        from tbl_gateway_products
                        where product_id = @product_id
                              and gateway_id = @gateway_id
                    )
                        begin
                            update tbl_gateway_products
                              set 
                                  commission_value = @commission, 
                                  commission_type = @commission_type
                            where product_id = @product_id
                                  and gateway_id = @gateway_id;
                            select '0' code, 
                                   'commission updated successfully' message, 
                                   null id;
                            return;
                    end;
                    insert into tbl_gateway_products
                    (gateway_id, 
                     product_id, 
                     commission_value, 
                     commission_type
                    )
                    values
                    (@gateway_id, 
                     @product_id, 
                     @commission, 
                     @commission_type
                    );
                    select '0' code, 
                           'commission added successfully' message, 
                           null id;
                    return;
            end;
            if @flag = 's'
                begin
                    if @gateway_id is not null
                        select gp.gateway_id gatewayid, 
                               ms.product_id productid, 
                               product_label servicename, 
                               gp.commission_value commission, 
                               ltrim(gp.commission_type) commissiontype
                        from tbl_gateway_products gp
                             join tbl_manage_services ms on ms.product_id = gp.product_id
                        where gateway_id = @gateway_id
                        order by productid;
                        else
                        select gp.gateway_id gatewayid, 
                               ms.product_id productid, 
                               product_label servicename, 
                               gp.commission_value commission, 
                               ltrim(gp.commission_type) commissiontype
                        from tbl_gateway_products gp
                             join tbl_manage_services ms on ms.product_id = gp.product_id
                        where gateway_id = @gateway_id
                        order by productid;
            end;
        end;
    end;  


GO
