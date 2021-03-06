USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_sms_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sproc_sms_detail] @flag                 char(30), 
                                      @sms_gateway_id         varchar(20)    = null, 
                                      @sms_gateway_name       varchar(100)   = null, 
                                      @sms_gateway_url        varchar(500)   = null, 
                                      @action_user           varchar(100)   = null, 
                                      @sms_gateway_user_name   varchar(500)   = null, 
                                      @sms_gateway_password   varchar(500)   = null, 
                                      @sms_gateway_balance    decimal(18, 2)  = null, 
                                      @sms_gateway_access_code varchar(100)   = null, 
                                      @sms_gateway_status     char(3)        = null, 
                                      @sms_isdirect_gtw       char(3)        = null, 
                                      @sms_category_id                int            = null, 
                                      @sms_country              varchar(100)   = null, 
                                      @sms_operator_id           int            = null, 
                                      @sms_rate              decimal(18, 2)  = null, 
                                      @sms_sender_id          varchar(200)   = null, 
                                      @agent_id              varchar(100)   = null, 
                                      @sms_rate_id            int            = null, 
                                      @sender_id_sno          int            = null, 
                                      @parent_id             int            = null, 
                                      @grand_parent_id            int            = null, 
                                      @page_size             varchar(5)     = 10, 
                                      @offset               varchar(5)     = 0, 
                                      @search               varchar(max)   = null, 
                                      @action_name           varchar(10)    = null
as
    begin
        if @sms_country is null
            begin
                set @sms_country = 'nepal';
        end;
        if @flag = 's'
            begin
                select *
                from tbl_gateway_detail
                where gateway_type = 'sms'; --and status = 'y'
        end; -- sms gateway select 

        if @flag = 'v'
            begin
                if @action_name = 'disable'
                    begin
                        update tbl_gateway_detail
                          set 
                              gateway_status = 'n'
                        where gateway_id = @sms_gateway_id
                              and gateway_type = 'sms';
                        select '0' as code, 
                               'disabled successfully.' as message, 
                               '' as id;
                        return;
                end;
                    else
                    if @action_name = 'enable'
                        begin
                            update tbl_gateway_detail
                              set 
                                  gateway_status = 'y'
                            where gateway_id = @sms_gateway_id
                                  and gateway_type = 'sms';
                            select '0' as code, 
                                   'enabled successfully.' as message, 
                                   '' as id;
                            return;
                    end;
                select '1' as code, 
                       'failed.' as message, 
                       '' as id;
        end; -- gateway enable disable

        if @flag = 'sr'
            begin
                select *
                from tbl_sms_rate
                where sms_rate_id = @sms_rate_id;
        end;
        if @flag = 'srd'
            begin
                select top 1 *
                from tbl_sms_rate
                where sms_rate_id = @sms_rate_id
                order by sms_created_date desc;
        end;
        if @flag = 'rs'
            begin
                insert into tbl_sms_rate
                (sms_com_id, 
                 sms_country, 
                 sms_operator_id, 
                 sms_rate, 
                 sms_created_by, 
                 sms_created_date
                )
                values
                (@sms_gateway_id, 
                 @sms_country, 
                 @sms_operator_id, 
                 @sms_rate, 
                 @action_user, 
                 getdate()
                );
        end; -- sms rate setup

        if @flag = 'us'
            begin
                if @sms_operator_id is not null
                    begin
                        update tbl_sms_rate
                          set 
                              sms_rate = isnull(@sms_rate, 0)
                        where sms_rate_id = @sms_rate_id
                              and sms_operator_id = @sms_operator_id;
                end;
                    else
                    begin
                        update tbl_sms_rate
                          set 
                              sms_rate = isnull(@sms_rate, 0);
                end;
        end; -- sms rate update

        if @flag = 'ds'
            begin
                select *
                from tbl_sms_rate;
                if @sms_rate is null
                    begin
                        select '1' code, 
                               'sms rate id is required' message, 
                               null id;
                        return;
                end;
                    else
                    begin
                        update tbl_sms_rate
                          set 
                              is_deleted = 'y'
                        where sms_rate_id = @sms_rate_id;
                end;
        end;
        if @flag = 'sid'
            begin
                if @agent_id is null
                    begin
                        select '1' code, 
                               'agent id is required' message, 
                               null id;
                        return;
                end;
                if @parent_id is not null
                    begin
                        if not exists
                        (
                            select 'x'
                            from tbl_agent_detail
                            where agent_id = @agent_id
                                  and parent_id = @parent_id
                        )
                            begin
                                select '1' code, 
                                       'agent id and parent id do not match' message, 
                                       null id;
                                return;
                        end;
                end;
                if @grand_parent_id is not null
                    begin
                        if not exists
                        (
                            select 'x'
                            from tbl_agent_detail
                            where agent_id = @agent_id
                                  and parent_id = @grand_parent_id
                        )
                            begin
                                select '1' code, 
                                       'grand parent id and agent id do not match' message, 
                                       null id;
                                return;
                        end;
                end;
                if exists
                (
                    select 'x'
                    from tbl_sms_sender_id_setup
                    where agent_id = @agent_id
                          and sender_id = @sms_sender_id
                )
                    begin
                        select '1' code, 
                               'same sender id for the respective agent already exists' message, 
                               null id;
                        return;
                end;
                insert into tbl_sms_sender_id_setup
                (sender_id, 
                 agent_id, 
                 created_by, 
                 created_local_date, 
                 created_UTC_date
                )
                values
                (@sms_sender_id, 
                 @agent_id, 
                 @action_user, 
                 getdate(), 
                 getutcdate()
                );
        end;-- sms sender id setup

        if @flag = 'uid'
            begin
                if exists
                (
                    select 'x'
                    from tbl_sms_sender_id_setup
                    where agent_id = @agent_id
                          and sender_id = @sms_sender_id
                )
                    begin
                        select '1' code, 
                               'same sender id for the respective agent already exists' message, 
                               null id;
                        return;
                end;
                update tbl_sms_sender_id_setup
                  set 
                      sender_id = @sms_sender_id, 
                      agent_id = @agent_id
                where sender_id_sno = @sender_id_sno;
        end; -- sms sender id update
    end;


GO
