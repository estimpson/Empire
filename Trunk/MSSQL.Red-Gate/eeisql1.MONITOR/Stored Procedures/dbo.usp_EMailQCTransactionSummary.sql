SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[usp_EMailQCTransactionSummary]
--	@Param1 [scalar_data_type] ( = [default_value] ) ...
	@TranDT DATETIME OUT
,	@Result INTEGER OUT
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	@Result = 999999
SET	ANSI_WARNINGS ON

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname  = N'#AuditTrailQualityTransactions',
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
ELSE BEGIN
	SAVE TRAN @ProcName
END
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

DECLARE
	@DayTimePrior DATETIME
	
	SELECT @DayTimePrior = DATEADD(MINUTE,-30, GETDATE())
	
	--Get Audit Trail for QC Tranactions
	
		
	SELECT 
		a.part, 
		p.name,
		COALESCE(e.name, a.operator) AS Employee,
		CASE a.from_loc 
		WHEN 'A' THEN 'Approved'
		WHEN 'H' THEN 'Hold'
		WHEN 'S' THEN 'Scrapped'
		WHEN 'O' THEN 'Obsolete'
		WHEN 'R' THEN 'Rejected'
		ELSE to_loc
		END AS FromStatus,
		CASE to_loc 
		WHEN 'A' THEN 'Approved'
		WHEN 'H' THEN 'Hold'
		WHEN 'S' THEN 'Scrapped'
		WHEN 'O' THEN 'Obsolete'
		WHEN 'R' THEN 'Rejected'
		ELSE to_loc
		END AS ToStatus,
		a.user_Defined_status AS UserDefinedStatus,
		COALESCE(a.notes, '') AS Note,
		SUM(std_quantity) AS Quantity
	INTO
		#AuditTrailQualityTransactions	
	FROM
		dbo.audit_trail a
	LEFT JOIN
		dbo.employee e ON e.operator_code = a.operator
	JOIN part p ON p.part = a.part
	WHERE
		a.date_stamp > @DayTimePrior AND
		a.type = 'Q'
	GROUP BY
		a.part, 
		p.name,
		COALESCE(e.name, a.operator),
		CASE a.from_loc 
		WHEN 'A' THEN 'Approved'
		WHEN 'H' THEN 'Hold'
		WHEN 'S' THEN 'Scrapped'
		WHEN 'O' THEN 'Obsolete'
		WHEN 'R' THEN 'Rejected'
		ELSE to_loc
		END,
		CASE to_loc 
		WHEN 'A' THEN 'Approved'
		WHEN 'H' THEN 'Hold'
		WHEN 'S' THEN 'Scrapped'
		WHEN 'O' THEN 'Obsolete'
		WHEN 'R' THEN 'Rejected'
		ELSE to_loc
		END ,
		a.user_Defined_status,
		COALESCE(a.notes,'')
		
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #AuditTrailQualityTransactions )	

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#AuditTrailQualityTransactions'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[Part], [Employee]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Quality Transaction Alert (SQLJob:EMailAlertQCTransactions)' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = 'wwilcox@empireelect.com;nmcdonald@empireelect.com;Shipping@empireelect.com;EEISchedulers@empire.hn' -- varchar(max)
	,	@copy_recipients = 'dwest@empireelect.com;aboulanger@fore-thought.com' -- varchar(max)
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,	@importance = 'High'  -- varchar(6)	



		
		
END					

--- </Body>

---	<Return>
SET	@Result = 0
RETURN
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go


begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_EMailQCTransactionSummary
	--@Param1 = @Param1
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	commit
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/









GO
