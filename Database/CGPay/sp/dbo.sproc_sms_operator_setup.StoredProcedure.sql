USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_sms_operator_setup]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sproc_sms_operator_setup]
(@flag        varchar(3), 
 @operator_id  int          = null, 
 @country     varchar(100) = null, 
 @country_code varchar(5)   = null, 
 @sms_operator_name        varchar(20)  = null, 
 @start_number varchar(50)  = null, 
 @pmt_gateway    int          = null, 
 @sms_gateway    int          = null, 
 @min         int          = null, 
 @max         int          = null, 
 @created_by   varchar(20)  = null, 
 @action_user  varchar(100) = null
)
as
    begin
        if @flag = 'i'
            begin
                insert into tbl_sms_operator_setup
                (sms_country, 
                 sms_country_code, 
                 sms_operator_id, 
                 sms_starting_number, 
                 sms_primary_gateway, 
                 sms_secondary_gateway, 
                 sms_min_length, 
                 sms_max_length, 
                 sms_created_date, 
                 sms_created_by, 
                 sms_updated_date, 
                 sms_updated_by
                )
                values
                (@country, 
                 @country_code, 
                 @sms_operator_name, 
                 @start_number, 
                 @pmt_gateway, 
                 @sms_gateway, 
                 @min, 
                 @max, 
                 getutcdate(), 
                 @created_by, 
                 null, 
                 null
                );
        end;
            else
            if @flag = 'u'
                begin
                    update tbl_sms_operator_setup
                      set 
                          sms_country = isnull(@country, sms_country), 
                          sms_country_code = isnull(@country_code, sms_country_code), 
                          sms_operator_name = isnull(@sms_operator_name, sms_operator_name), 
                          sms_starting_number = isnull(@start_number, sms_starting_number), 
                          sms_primary_gateway = isnull(@pmt_gateway, sms_primary_gateway), 
                          sms_secondary_gateway = isnull(@sms_gateway, sms_secondary_gateway), 
                          sms_min_length = isnull(@min, sms_min_length), 
                          sms_max_length = isnull(@max, sms_max_length), 
                          sms_updated_by = @action_user, 
                          sms_updated_date = getdate()
                    where sms_operator_id = @operator_id;
            end;
                else
                if @flag = 's'
                    begin
                        if @operator_id is null
                            begin
                                select *
                                from tbl_sms_operator_setup;
                        end;
                            else
                            begin
                                select *
                                from tbl_sms_operator_setup
                                where sms_operator_id = @operator_id;
                        end;
                end;
    end;


GO
