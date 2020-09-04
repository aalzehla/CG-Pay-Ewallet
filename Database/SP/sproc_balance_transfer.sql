USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_balance_transfer]    Script Date: 22/08/2020 20:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [dbo].[sproc_balance_transfer] @flag CHAR(5)
	,@agent_id INT = NULL
	,@amount DECIMAL(18, 2) = NULL
	,@remarks VARCHAR(500) = NULL
	,@bank_id VARCHAR(10) = NULL
	,@bank_name VARCHAR(100) = NULL
	,@type CHAR(3) = NULL
	,@action_user VARCHAR(20) = NULL
	,@created_ip VARCHAR(20) = NULL
	,@from_date DATETIME = NULL
	,@to_date DATETIME = NULL
	,@created_platform VARCHAR(50) = NULL
	,@scharge DECIMAL(18, 2) = NULL
	,@bonus_amt DECIMAL(18, 2) = NULL
	,@sender_id INT = NULL
	,@reciever_id INT = NULL
	,@grand_parent_id INT = NULL
	,@parent_id INT = NULL
	,@subscriber VARCHAR(100) = NULL
	,@balance_id INT = NULL
	,@description VARCHAR(500) = NULL
	,@bt_purpose VARCHAR(60) = NULL
	,@user_name VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @agent_name VARCHAR(100)
		,@desc VARCHAR(MAX)
		,@agent_old_balance MONEY
		,@sql VARCHAR(MAX)
		,@remarks_agent VARCHAR(MAX)
		,@agent_current_balance DECIMAL(18, 2)
		,@subscriber_no VARCHAR(100)
		,@txn_id INT
		,@sender_name VARCHAR(100)
	DECLARE @agent_parent_Id INT
		,@agent_parent_balance DECIMAL(18, 2)
		,@email_id VARCHAR(50)
		,@user_id INT
		,@user_mobile_number VARCHAR(20)
		,@reciever_agent_id INT
		,@reciever_full_name VARCHAR(50)
		,@reciever_email VARCHAR(50)
		,@remarks_agent_sender VARCHAR(max)
	DECLARE @user_email VARCHAR(50)
		,@user_full_name VARCHAR(100)
		,@sender_agent_id INT
	DECLARE @avaliable_balance DECIMAL(18, 2)
	--for notification json  
	DECLARE @notiId INT;
	DECLARE @dataPayload VARCHAR(max);

	SELECT @agent_parent_Id = parent_id
		,@agent_old_balance = ISNULL(available_balance, 0)
		,@agent_name = agent_name
	FROM tbl_agent_Detail with (NOLOCK)
	WHERE Agent_id = @agent_id

	SELECT @agent_parent_balance = ISNULL(available_balance, 0)
	FROM tbl_agent_Detail with (NOLOCK)
	WHERE Agent_id = @agent_parent_Id

	IF @amount < 0
	BEGIN
		SET @amount = @amount * - 1;
	END;

	IF @bank_id IS NOT NULL
	BEGIN
		SELECT @bank_name = funding_bank_name
		FROM tbl_funding_bank_account
		WHERE funding_bank_id = @bank_id
	END

	BEGIN TRY
		IF @flag = 't'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION distributorbalancetransfer

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'distributor id can''t be null' message
						,NULL id

					ROLLBACK TRANSACTION

					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less than ''0''' message
						,NULL id

					ROLLBACK TRANSACTION

					RETURN
				END

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					,txn_mode
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,'CR'
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to distributor: ' + @agent_name message
					,NULL id

				COMMIT TRANSACTION distributorbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION distributorbalancetransfer

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
					,'sproc_balance_transfer(distributor balance transfer:flag ''i'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(distributor balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- update balance for distributor by admin                

		IF @flag = 'rt'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION distributorbalanceretrieve

				SELECT @agent_name = ad.agent_name
					,@agent_old_balance = isnull(available_balance, 0)
				FROM tbl_agent_detail ad with (NOLOCK)
				JOIN tbl_agent_balance ab with (NOLOCK) ON ad.agent_id = ab.agent_id
				WHERE ad.agent_id = @agent_id;

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less  than 0' message
						,NULL id
				ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount > isnull(@agent_old_balance, 0)
				BEGIN
					SELECT '1' code
						,'distributor balance is less than the amount for retrieval' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					,txn_mode
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'npr'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,'DR'
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) - @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully retrieved balance of ' + cast(@amount AS VARCHAR) + ' from distributor: ' + @agent_name message
					,NULL id

				--exec spa_email_request @flag='brd', @previous_balance=@distibutoroldbalance,@current_balance=@newdisbalance, @distributor_id=@distributer_id, @amount=@amount, @bankname=@bank_name                     
				--return                    
				COMMIT TRANSACTION distributorbalanceretrieve
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION distributorbalanceretrieve

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
					,'sproc_balance_transfer(distributor balance retrieve:flag ''rt'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(distributor balance retrieve)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) + error_line() message
					,NULL id
			END CATCH
		END -- retrieve distributor balance  by admin                    

		IF @flag = 'r'
		BEGIN
			SET @sql = ' select balance_id, ab.agent_id, ab.agent_name, amount, CASE when ab.txn_type = UPPER(''T'')then                
    ad.available_balance - amount                
    else                 
    ad.available_balance + amount                
end Agent_old_balance, fb.funding_bank_branch, fb.funding_account_number,bank_name,                
 txn_type, agent_remarks, txn_mode,                
 Isnull(ad.available_balance,0)as New_Balance,                
 ab.created_by,                 
 ab.created_local_Date as Created_date,                
 ab.created_nepali_Date                 
 from tbl_agent_balance ab with(NOLOCK)               
 join tbl_agent_detail ad with (NOLOCK) on ad.agent_id  = ab.agent_id                
 left join tbl_funding_bank_account fb with (NOLOCK) on fb.funding_bank_id = ab.bank_id                 
 where 1 = 1'

			IF @balance_id IS NOT NULL
			BEGIN
				SET @sql += 'and balance_id= ' + Cast(@balance_id AS VARCHAR)
			END

			IF @type IS NOT NULL
			BEGIN
				SET @sql += ' and txn_type=' + @type
			END

			IF @agent_id IS NOT NULL
			BEGIN
				SET @sql += ' and ab.agent_id = ' + cast(@agent_id AS VARCHAR)
			END

			IF @bank_id IS NOT NULL
			BEGIN
				SET @sql += ' and ab.bank_id = ' + cast(@bank_id AS VARCHAR)
			END

			IF @action_user IS NOT NULL
			BEGIN
				SET @sql += ' and ab.created_by = ''' + @action_user + ''''
			END

			IF @from_date IS NOT NULL
				AND @to_date IS NOT NULL
			BEGIN
				SET @sql += ' and ab.created_local_date between ''' + convert(VARCHAR(10), @from_date, 101) + ''' and ''' + convert(VARCHAR(10), dateadd(dd, 1, @to_date), 101) + ''''
			END

			SET @sql += 'order by ab.created_local_date desc'

			PRINT @sql

			EXEC (@sql)
		END --distributor balance report                  

		IF @flag = 'm'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION merchantbalancetransfer

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'merchant id can''t be null' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less than ''0''' message
						,NULL id
					ROLLBACK TRANSACTION
					RETURN
				END

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'npr'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to merchant: ' + @agent_name message
					,NULL id

				--exec spa_email_request @flag='btd', @previous_balance=@distibutoroldbalance,@current_balance=@newdisbalance, @distributor_id=@distributer_id, @amount=@amount, @bankname=@bank_name                     
				--return                          
				COMMIT TRANSACTION merchantbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION merchantbalancetransfer

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
					,'sproc_balance_transfer(merchant balance transfer:flag ''m'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(merchant balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- update balance for merchant by distibutor                  

		IF @flag = 'rm'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION merchantbalanceretrieve

				SELECT @agent_old_balance = isnull(available_balance, 0)
				FROM tbl_agent_detail with (NOLOCK)
				WHERE agent_id = @agent_id

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less  than 0' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount > isnull(@agent_old_balance, 0)
				BEGIN
					SELECT '1' code
						,'merchant balance is less than the amount for retrieval' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				INSERT INTO tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) - @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully retrieved balance ' + cast(@amount AS VARCHAR) + ' from merchant: ' + @agent_name message
					,NULL id

				--exec spa_email_request @flag='brd', @previous_balance=@distibutoroldbalance,@current_balance=@newdisbalance, @distributor_id=@distributer_id, @amount=@amount, @bankname=@bank_name                     
				--return                    
				COMMIT TRANSACTION merchantbalanceretrieve
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION merchantbalanceretrieve

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
					,'sproc_balance_transfer(merchant balance retrieve:flag ''rm'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(merchant balance retrieve)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- retrieve merchant balance by distributor                  

		IF @flag = 'st'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION subdistributorbalancetransfer

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'sub distributor id can''t be null' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less than ''0''' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'npr'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to sub-distributor: ' + @agent_name message
					,NULL id

				--exec spa_email_request @flag='btd', @previous_balance=@distibutoroldbalance,@current_balance=@newdisbalance, @distributor_id=@distributer_id, @amount=@amount, @bankname=@bank_name                     
				--return                          
				COMMIT TRANSACTION subdistributorbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION subdistributorbalancetransfer

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
					,'sproc_balance_transfer(sub distributor balance transfer:flag ''st'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(sub distributor balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- update balance for sub distributor by distributor                  

		IF @flag = 'rs'
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION subdistributorbalanceretrieve

				SELECT @agent_old_balance = isnull(available_balance, 0)
				FROM tbl_agent_detail with (NOLOCK)
				WHERE agent_id = @agent_id

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'amount can''t be less  than 0' message
						,NULL id
					ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount > isnull(@agent_old_balance, 0)
				BEGIN
					SELECT '1' code
						,'sub distributor balance is less than the amount for retrieval' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					)
				VALUES (
					@agent_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) - @amount
				WHERE agent_id = @agent_id

				SELECT '0' code
					,'successfully retrieved balance of ' + cast(@amount AS VARCHAR) + ' from sub-distributor: ' + @agent_name message
					,NULL id

				--exec spa_email_request @flag='brd', @previous_balance=@distibutoroldbalance,@current_balance=@newdisbalance, @distributor_id=@distributer_id, @amount=@amount, @bankname=@bank_name                     
				--return                    
				COMMIT TRANSACTION subdistributorbalanceretrieve
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION subdistributorbalanceretrieve

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
					,'sproc_balance_transfer(sub distributor balance retrieve:flag ''rs'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(sub distributor balance retrieve)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- retrieve sub distributor balance                      

		IF @flag = 'at' -- agent Balance Transfer by admin                
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION Agentbalancetransfer

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'Agent id can''t be null' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'Amount can''t be less than ''0''' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @agent_parent_Id IS NOT NULL
				BEGIN
					IF @amount > @agent_parent_balance
					BEGIN
						SELECT '1' Code
							,'Parent Distributor Balance is less the Transfer Amount' Message
							,NULL id
							ROLLBACK TRANSACTION
						RETURN
					END
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].tbl_agent_balance (
						agent_id
						,agent_name
						,bank_id
						,bank_name
						,[amount]
						,txn_type
						,currency_code
						,agent_remarks
						,created_by
						,created_local_date
						,created_UTC_date
						,created_nepali_date
						,created_ip
						,txn_mode
						,agent_parent_id
						)
					VALUES (
						@agent_id
						,@agent_name
						,@bank_id
						,@bank_name
						,@amount
						,@type
						,'NPR'
						,@remarks
						,@action_user
						,getdate()
						,getutcdate()
						,[dbo].func_get_nepali_date(DEFAULT)
						,@created_ip
						,'CR'
						,@agent_parent_Id
						)

					UPDATE tbl_agent_detail
					SET available_balance = isnull(available_balance, 0) + @amount
					WHERE agent_id = @agent_id
						--and Parent_id = @agent_parent_Id                
				END

				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to Agent: ' + @agent_name message
					,NULL id

				COMMIT TRANSACTION Agentbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION Agentbalancetransfer

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
					,'sproc_balance_transfer(Agent balance transfer:flag ''i'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(Agent balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END

		IF @flag = 'ar' -- agent Balance Retrieve by admin                
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION AgentbalanceRetrieve

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'Agent id can''t be null' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'Amount can''t be less than ''0''' message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END

				IF @amount > @agent_old_balance
				BEGIN
					SELECT '1' Code
						,'Agent Balance is less the Retieval Amount' Message
						,NULL id
						ROLLBACK TRANSACTION
					RETURN
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].tbl_agent_balance (
						agent_id
						,agent_name
						,bank_id
						,bank_name
						,[amount]
						,txn_type
						,currency_code
						,agent_remarks
						,created_by
						,created_local_date
						,created_UTC_date
						,created_nepali_date
						,created_ip
						,txn_mode
						,agent_parent_id
						)
					VALUES (
						@agent_id
						,@agent_name
						,@bank_id
						,@bank_name
						,@amount
						,@type
						,'NPR'
						,@remarks
						,@action_user
						,getdate()
						,getutcdate()
						,[dbo].func_get_nepali_date(DEFAULT)
						,@created_ip
						,'DR'
						,@agent_parent_Id
						)

					UPDATE tbl_agent_detail
					SET available_balance = isnull(available_balance, 0) - @amount
					WHERE agent_id = @agent_id

					--and Parent_id = @agent_parent_Id                
					UPDATE tbl_agent_detail
					SET available_balance = isnull(available_balance, 0) + @amount
					WHERE agent_id = @agent_parent_Id
				END

				SELECT '0' code
					,'successfully Retrieved balance of ' + cast(@amount AS VARCHAR) + ' from Agent: ' + @agent_name message
					,NULL id

				COMMIT TRANSACTION AgentbalanceRetrieve
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION AgentbalanceRetrieve

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
					,'sproc_balance_transfer(Agent balance retrieve:flag ''i'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(Agent balance retrieve)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END

		IF @flag = 're'
		BEGIN
			SET @sql = 
				' select balance_id, ab.agent_id, ab.agent_name,                
   adt.full_name as Parent_Distributor,                
   amount,                 
      CASE when ab.txn_type = UPPER(''T'')then                
      ad.available_balance - amount                
      else                 
      ad.available_balance + amount                
      end Agent_old_balance, fb.funding_bank_branch, fb.funding_account_number,bank_name,                
   case when txn_type = ''Dig'' then ''Fund Load ''
	when txn_type = ''mp'' then ''Merchant Payment''
	when txn_type = ''p2p'' then ''Peer to Peer''
	when txn_type = ''r'' then ''Retrieve''
	when txn_type = ''T'' then ''Transfer''
	else ''Balance Transfer'' end txn_type, agent_remarks, txn_mode,                
   Isnull(ad.available_balance,0)as New_Balance,                
   ab.created_by,                 
   ab.created_local_Date as Created_date,                
   ab.created_nepali_Date                 
   from tbl_agent_balance ab  with (NOLOCK)               
   join tbl_agent_detail ad with (NOLOCK) on ad.agent_id  = ab.agent_id                
  left join tbl_agent_detail adt with (NOLOCK) on adt.agent_id  =  ab.agent_parent_id                
   left join tbl_funding_bank_account fb with (NOLOCK) on fb.funding_bank_id = ab.bank_id                 
   where 1 = 1'

			IF @balance_id IS NOT NULL
			BEGIN
				SET @sql += 'and balance_id= ' + Cast(@balance_id AS VARCHAR)
			END

			IF @type IS NOT NULL
			BEGIN
				SET @sql += ' and txn_type=' + @type
			END

			IF @agent_id IS NOT NULL
			BEGIN
				SET @sql += ' and ab.agent_id = ' + cast(@agent_id AS VARCHAR)
			END

			--IF @agent_parent_Id IS NOT NULL  
			--BEGIN  
			-- SET @sql += ' and adt.parent_id= ' + cast(@agent_parent_Id AS VARCHAR)  
			--END  
			IF @bank_id IS NOT NULL
			BEGIN
				SET @sql += ' and ab.bank_id = ' + cast(@bank_id AS VARCHAR)
			END

			IF @action_user IS NOT NULL
			BEGIN
				SET @sql += ' and ab.created_by = ''' + @action_user + ''''
			END

			IF @from_date IS NOT NULL
				AND @to_date IS NOT NULL
			BEGIN
				SET @sql += ' and ab.created_local_date between ''' + convert(VARCHAR(10), @from_date, 101) + ''' and ''' + convert(VARCHAR(10), dateadd(dd, 1, @to_date), 101) + ''''
			END

			SET @sql += ' order by ab.created_local_date desc'

			PRINT @sql

			EXEC (@sql)
		END --Agent balance report                

		IF @flag = 'trq'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_name = @action_user
					)
			BEGIN
				SELECT '1' code
					,'User not Found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT @sender_id = user_id
					,@user_full_name = full_name
				FROM tbl_user_detail with (NOLOCK)
				WHERE user_name = @action_user
			END

			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_mobile_no = @subscriber
						OR user_email = @subscriber
					)
			BEGIN
				SELECT '1' code
					,'Requested User Not Found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT @reciever_id = user_id
					,@agent_id = agent_id
					,@email_id = user_email
				FROM tbl_user_detail with (NOLOCK)
				WHERE user_mobile_no = @subscriber
					OR user_email = @subscriber
			END

			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,read_status
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				)
			VALUES (
				'Balance Transfer Request'
				,'Requested by ' + @user_full_name + ' of ' + cast(@amount AS VARCHAR) + ' NPR ' + @description
				,'Balance_Transfer'
				,'n'
				,@reciever_id
				,@agent_id
				,@sender_id
				,'n'
				,@action_user
				,GETDATE()
				,GETUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				)

			EXEC sproc_email_request @flag = 'bt'
				,@agent_id = @agent_id
				,@email_id = @email_id
				,@amount = @amount
				,@subscriber_no = @subscriber

			SELECT '0' code
				,'Succesfully sent Balance Request to User: ' + @subscriber message
				,@sender_id id

			RETURN
		END -- user to user balance request      

		IF @flag = 'trf'
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_name = @action_user
					)
			BEGIN
				SELECT '1' code
					,'User not found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT @sender_id = user_id
					,@user_mobile_number = user_mobile_no
					,@user_email = user_email
					,@user_full_name = u.full_name
					,@sender_agent_id = u.agent_id
					,@agent_current_balance = Isnull(a.available_balance, 0)
					,@grand_parent_id = ad.agent_id
					,@parent_id = a.parent_id
				FROM tbl_user_detail u with (NOLOCK)
				JOIN tbl_agent_Detail a with (NOLOCK) ON a.agent_id = u.agent_id
				LEFT JOIN tbl_agent_detail ad with (NOLOCK) ON ad.agent_id = a.parent_id
				WHERE user_name = @action_user
			END

			IF NOT EXISTS (
					SELECT *
					FROM tbl_user_detail with (NOLOCK)
					WHERE user_mobile_no = @subscriber
						OR user_email = @subscriber
					)
			BEGIN
				SELECT '1' code
					,'Receiving User Not found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT @reciever_id = user_id
					,@reciever_agent_id = agent_id
					,@reciever_full_name = full_name
					,@reciever_email = u.user_email
				FROM tbl_user_detail u with (NOLOCK)
				WHERE user_mobile_no = @subscriber
					OR user_email = @subscriber
			END

			IF @amount < 0
			BEGIN
				SELECT '1' code
					,'Amount should be more than 0' message
					,NULL id

				RETURN
			END

			IF @agent_current_balance < @amount
			BEGIN
				SELECT '1' code
					,'Sender''s balance is less the amount to be transfered' message
					,NULL id

				RETURN
			END

			SET @remarks_agent = 'Balance transfered by ' + @user_full_name + ' of ' + cast(@amount AS VARCHAR) + ' NPR'
			SET @remarks_agent_sender = 'Balance transfered to ' + @reciever_full_name + ' of ' + cast(@amount AS VARCHAR) + ' NPR'

			BEGIN TRY
				BEGIN TRANSACTION usertouserbalancetrf

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + @amount
				WHERE agent_id = @reciever_agent_id

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) - @amount
				WHERE agent_id = @sender_agent_id

				INSERT INTO tbl_agent_notification (
					notification_subject
					,notification_body
					,notification_type
					,notification_status
					,notification_to
					,agent_id
					,user_id
					,read_status
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					'Balance Transfer'
					,@remarks_agent
					,'Balance_Transfer'
					,'n'
					,@reciever_id
					,@sender_agent_id
					,@sender_id
					,'n'
					,@action_user
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					) --- notification for receiver (receiving user)    

				INSERT INTO tbl_agent_balance (
					agent_id
					,agent_name
					,amount
					,currency_code
					,agent_parent_id
					,txn_type
					,created_by
					,created_UTC_date
					,created_local_date
					,created_nepali_date
					,created_ip
					,created_platform
					,user_id
					,agent_remarks
					,txn_id
					,txn_mode
					)
				VALUES (
					cast(@sender_agent_id AS VARCHAR)
					,@user_full_name
					,@amount
					,'NPR'
					,@parent_id
					,'p2p'
					,@action_user
					,getutcdate()
					,getdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,@created_platform
					,@reciever_id
					,@remarks_agent_sender
					,@txn_id
					,'DR'
					)

				--set @txn_id = scope_identity()                
				-- insert into agent balance table for user transfered to                  
				INSERT INTO tbl_agent_balance (
					agent_id
					,agent_name
					,amount
					,currency_code
					,agent_parent_id
					,txn_type
					,created_by
					,created_UTC_date
					,created_local_date
					,created_nepali_date
					,created_ip
					,created_platform
					,user_id
					,agent_remarks
					,txn_id
					,txn_mode
					)
				VALUES (
					@reciever_agent_id
					,@reciever_full_name
					,@amount
					,'NPR'
					,@parent_id
					,'p2p'
					,@action_user
					,getutcdate()
					,getdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,@created_platform
					,@sender_id
					,@remarks_agent
					,@txn_id
					,'CR'
					)

				COMMIT TRANSACTION usertouserbalancetrf

				SELECT '0' code
					,@remarks_agent_sender message
					,NULL id
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION usertouserbalancetrf

				SET @desc = 'sql error found:(' + cast(error_message() AS VARCHAR) + ')' + ' at ' + cast(error_line() AS VARCHAR)

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
					,'sproc_balance_transfer(user to user balance trf:flag ''trf'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer((user to user balance trf)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END -- user to user  balance trf                  

		IF @flag = 'aw' -- agent to wallet balance transfer      
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION Agenttowalletbalancetransfer

				IF @action_user IS NULL
				BEGIN
					SELECT '1' code
						,'Agent id can''t be null' message
						,NULL id

					RETURN
				END
				ELSE
				BEGIN
					SELECT @sender_agent_id = u.agent_id
						,@sender_name = u.full_name
						,@sender_id = u.user_id
					FROM tbl_user_detail u
					JOIN tbl_agent_detail ad with (NOLOCK)
					ON ad.agent_id = u.agent_id
					WHERE user_name = @action_user
						OR user_mobile_no = @action_user
						OR user_email = @action_user
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'Amount can''t be less than ''0''' message
						,NULL id

					RETURN
				END

				SELECT @reciever_agent_id = ad.agent_id
					,@reciever_full_name = ad.full_name
					,@reciever_id = u.user_id
				FROM tbl_user_detail u with (NOLOCK)
				JOIN tbl_agent_detail ad with (NOLOCK)  ON ad.agent_id = u.agent_id
				WHERE user_name = @user_name
					OR user_mobile_no = @user_name
					OR user_email = @user_name

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					,txn_mode
					,agent_parent_id
					)
				VALUES (
					@reciever_agent_id
					,@reciever_full_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,'CR'
					,@agent_parent_Id
					)

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					,txn_mode
					,agent_parent_id
					)
				VALUES (
					@sender_agent_id
					,@sender_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@action_user
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,'DR'
					,@agent_parent_Id
					)

				--deduct balance tranfer for agent      
				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) - @amount
				WHERE agent_id = @sender_agent_id

				--add balance to transfer user      
				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + @amount
				WHERE agent_id = @reciever_agent_id

				--and Parent_id = @agent_parent_Id                
				INSERT INTO tbl_agent_notification (
					notification_subject
					,notification_body
					,notification_type
					,notification_status
					,notification_to
					,agent_id
					,user_id
					,read_status
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					'Balance Transfer'
					,'Balance transfered by ' + @sender_name + ' of ' + cast(@amount AS VARCHAR) + ' NPR'
					,'Balance_Transfer'
					,'n'
					,@reciever_id
					,@reciever_agent_id
					,@sender_id
					,'n'
					,@action_user
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					) --- notification for receiver (receiving user)    

				--insert into tbl_agent_notification(    
				-- notification_subject,     
				-- notification_body,     
				-- notification_type,     
				-- notification_status,     
				-- notification_to,     
				-- agent_id,    
				-- user_id,     
				-- read_status,    
				-- created_by,    
				-- created_local_date,     
				-- created_UTC_date,     
				-- created_nepali_date)      
				-- values(    
				-- 'Balance Transfer',    
				-- 'Balance transfered to ' + @reciever_full_name + '(id: ' + cast(@reciever_id as varchar) + ') of ' + cast(@amount as varchar) + ' NPR' ,     
				-- 'Balance_Transfer',     
				-- 'Y',    
				-- @sender_agent_id,    
				-- @sender_agent_id,    
				-- @sender_id,     
				-- 'n',    
				-- @action_user,     
				-- GETDATE(),     
				-- GETUTCDATE(),     
				-- dbo.func_get_nepali_date(default)    
				-- )   ---  notification for sender (Sending user)                 
				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to Agent: ' + @reciever_full_name message
					,NULL id

				COMMIT TRANSACTION Agenttowalletbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION Agenttowalletbalancetransfer

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
					,'sproc_balance_transfer(Agent to wallet user balance transfer:flag ''awu'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(Agent to wallet user balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END

		IF @flag = 'awu' -- walletUser Balance Transfer by admin                
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION Walletuserbalancetransfer

				IF @action_user IS NULL
				BEGIN
					SELECT '1' code
						,'Action User can''t be null' message
						,NULL id

					RETURN
				END
				ELSE
				BEGIN
					SELECT @sender_name = u.full_name
						,@sender_id = u.user_id
					FROM tbl_user_detail u with (NOLOCK)
					-- JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id  
					WHERE user_name = @action_user
				END

				IF @agent_id IS NULL
				BEGIN
					SELECT '1' code
						,'Agent id can''t be null' message
						,NULL id

					RETURN
				END

				IF @amount < 0
				BEGIN
					SELECT '1' code
						,'Amount can''t be less than ''0''' message
						,NULL id

					RETURN
				END

				SELECT @user_id = u.user_id
					,@agent_name = u.full_name
					,@user_mobile_number = u.user_mobile_no
					,@avaliable_balance = isnull(a.available_balance, 0)
				FROM tbl_agent_detail a with (NOLOCK)
				JOIN tbl_user_detail u with (NOLOCK)
				ON a.agent_id = u.agent_id
				WHERE a.agent_id = @agent_id

				INSERT INTO [dbo].tbl_agent_balance (
					agent_id
					,user_id
					,agent_name
					,bank_id
					,bank_name
					,[amount]
					,txn_type
					,currency_code
					,agent_remarks
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					,created_ip
					,txn_mode
					,agent_parent_id
					)
				VALUES (
					@agent_id
					,@user_id
					,@agent_name
					,@bank_id
					,@bank_name
					,@amount
					,@type
					,'NPR'
					,@remarks
					,@sender_id
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)
					,@created_ip
					,'CR'
					,@agent_parent_Id
					)

				UPDATE tbl_agent_detail
				SET available_balance = isnull(available_balance, 0) + isnull(@amount, 0)
				WHERE agent_id = @agent_id

				--and Parent_id = @agent_parent_Id       
				INSERT INTO tbl_agent_notification (
					notification_subject
					,notification_body
					,notification_type
					,notification_status
					,notification_to
					,agent_id
					,user_id
					,Remaining_Balance
					,read_status
					,created_by
					,created_local_date
					,created_UTC_date
					,created_nepali_date
					)
				VALUES (
					'Balance Transfer'
					,'Balance transfered by CGPAY Pay Admin of ' + cast(@amount AS VARCHAR) + ' NPR'
					,'Balance_Transfer'
					,'n'
					,@user_id
					,@agent_id
					,@sender_id
					,@avaliable_balance + isnull(@amount, 0)
					,'n'
					,'admin'
					,GETDATE()
					,GETUTCDATE()
					,dbo.func_get_nepali_date(DEFAULT)
					) --- notification for receiver (receiving user)    

				SET @notiId = @@IDENTITY
				SET @dataPayload = dbo.func_notification_payload(@notiId, @user_mobile_number, @amount);

				UPDATE tbl_agent_notification
				SET data_payload = @dataPayload
				WHERE notification_id = @notiId

				SELECT '0' code
					,'successfully transfered balance of ' + cast(@amount AS VARCHAR) + ' to Agent: ' + @agent_name message
					,NULL id

				COMMIT TRANSACTION Walletuserbalancetransfer
			END TRY

			BEGIN CATCH
				IF @@trancount > 0
					ROLLBACK TRANSACTION Walletuserbalancetransfer

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
					,'sproc_balance_transfer(Wallet User balance transfer:flag ''awu'')'
					,'sql'
					,'sql'
					,'sproc_balance_transfer(Wallet User balance transfer)'
					,getdate()
					,getutcdate()
					,[dbo].func_get_nepali_date(DEFAULT)

				SELECT '1' code
					,'errorid: ' + cast(scope_identity() AS VARCHAR) message
					,NULL id
			END CATCH
		END
	END TRY

	BEGIN CATCH
		IF @@trancount > 0
			ROLLBACK TRANSACTION

		SELECT 1 code
			,error_message() message
			,NULL id
	END CATCH
END;
GO


