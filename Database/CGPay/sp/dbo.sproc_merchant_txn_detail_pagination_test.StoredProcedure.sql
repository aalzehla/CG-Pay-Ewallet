USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_merchant_txn_detail_pagination_test]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  
	

 PROCEDURE [dbo].[sproc_merchant_txn_detail_pagination_test] @datatable BIT = 1
	,@txn_from VARCHAR(10) = NULL
	,@txn_to VARCHAR(10) = NULL
	,@page_number INT = 0
	,@no_of_records VARCHAR(10) = NULL
	,@user_name VARCHAR(20) = NULL
	,@flag CHAR = NULL
	,@txn_id INT = NULL
	,@user_id INT = NULL
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
				,@user_id = user_id
			FROM tbl_user_detail WITH (NOLOCK)
			WHERE user_email = @user_name
				OR user_mobile_no = @user_name

			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_agent_balance WITH (NOLOCK)
					WHERE agent_id = @agent_id
					)
			BEGIN
				SELECT '0' code
					,'No transaction found' message
					,NULL id

				RETURN
			END

			SELECT isnull(ad.first_name, '') + ' ' + isnull(ad.middle_name, '') + ' ' + isnull(ad.last_name, '') AS farmerName
				,ad.agent_name AS Company
				,isnull(ab.amount, 0) Amount
				,ab.agent_remarks AS description
				,cast(ab.created_local_date AS VARCHAR) AS CreatedDate
				,ab.balance_id AS txn_id
				,ab.created_platform
				,ab.balance_id
				,ROW_NUMBER() OVER (
					ORDER BY ab.created_local_date DESC
					) AS row_id
			INTO #temp
			FROM tbl_agent_balance ab WITH (NOLOCK)
			JOIN tbl_user_detail ud WITH (NOLOCK) ON ud.agent_id = ab.agent_id
			JOIN tbl_agent_detail ad WITH (NOLOCK) ON ad.agent_id = ab.agent_id
			WHERE
			--ab.agent_id = @agent_id
				--AND 
				ab.user_id = @user_id
				AND (txn_mode = 'DR')
				AND CASE 
					WHEN @txn_id IS NOT NULL
						THEN @txn_id
					ELSE ab.balance_id
					END = ab.balance_id
					and ab.txn_type = 'mp'
			ORDER BY ab.created_local_date DESC

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
