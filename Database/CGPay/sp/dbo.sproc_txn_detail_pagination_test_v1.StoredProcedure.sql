USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_txn_detail_pagination_test_v1]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sproc_txn_detail_pagination_test_v1] @datatable BIT = 1
	,@txn_from VARCHAR(10) = NULL
	,@txn_to VARCHAR(10) = NULL
	,@page_number INT = 0
	,@no_of_records VARCHAR(10) = NULL
	,@user_name VARCHAR(20) = NULL
	,@flag CHAR = NULL
AS
BEGIN
	IF (@flag = 's')
	BEGIN
		DECLARE @sql NVARCHAR(max) = ''

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_email = @user_name
					OR user_mobile_no = @user_name
				)
		BEGIN
			SELECT '104' code
				,'Username is required' Message
				,NULL id
		END
		ELSE
		BEGIN
			DECLARE @agent_id VARCHAR(10);

			SELECT @agent_id = agent_id
			FROM tbl_user_detail
			WHERE user_email = @user_name
				OR user_mobile_no = @user_name

			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_transaction
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT '1' code
					,'No transaction found' message
					,NULL id

				RETURN
			END

			SELECT ROW_NUMBER() OVER (
					ORDER BY t.created_local_date DESC
					) AS row_id
				,*
				into #temp
			FROM (
				SELECT product_id
					,product_label
					,t.agent_id
					,subscriber_no
					,t.amount
					,t.STATUS
					,t.created_local_date
				FROM tbl_transaction t
				INNER JOIN tbl_user_detail ud ON ud.agent_id = t.agent_id
				INNER JOIN tbl_transaction_commission tc ON tc.txn_id = t.txn_id
				WHERE ud.agent_id = @agent_id
				
				UNION ALL
				
				SELECT ''
					,ab.agent_remarks
					,ad.agent_id
					,''
					,ab.amount
					,''
					,ab.created_local_date
				FROM tbl_agent_balance ab WITH (NOLOCK)
				JOIN tbl_user_detail ud WITH (NOLOCK) ON ud.agent_id = ab.agent_id
				JOIN tbl_agent_detail ad WITH (NOLOCK) ON ad.agent_id = ab.agent_id
				WHERE ud.agent_id = @agent_id
					
				) t
			ORDER BY t.created_local_date DESC

			DECLARE @pgno VARCHAR(10)

			IF @page_number = 0
				OR @page_number < 0
				SET @page_number = 1
			SET @pgno = cast(@page_number - 1 AS VARCHAR)

			EXEC sproc_pagination '#temp'
				,@datatable
				,@pgno
				,@no_of_records

			DROP TABLE #temp
		END
	END
END


GO
