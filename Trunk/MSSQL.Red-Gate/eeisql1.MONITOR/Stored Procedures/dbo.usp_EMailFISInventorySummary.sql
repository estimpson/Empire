SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_EMailFISInventorySummary]

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
	@TableName sysname  = N'#FISInventory',
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
	@EvaluateDate DATETIME
	
	SELECT @EvaluateDate = DATEADD(HOUR,-24, GETDATE())
	
	--Get Audit Trail for QC Tranactions
	
		
	SELECT 
		part, 
		to_loc, 
		SUM(quantity) AS Quantity, 
		Operator AS Employee
INTO
		#FISInventory
FROM audit_trail 
		WHERE 
				EXISTS (SELECT 1 FROM object WHERE object.serial = audit_trail.serial AND object.location LIKE '%FIS%') 
				AND audit_trail.date_stamp >= DATEADD(HOUR, -24, GETDATE()) 
				AND to_loc LIKE '%FIS%' 
				AND audit_trail.part != 'PALLET'
GROUP BY part, to_loc, operator
		
	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #FISInventory )	

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#FISInventory'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[Part], [Employee]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'FIS Transaction Alert (SQLJob:EMailAlertFISTransactions) - Inventory Located In FIS Locations Placed There Within The Past 24 Hours' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = 'Shipping@empireelect.com;mminth@empireelect.com;jstoehr@empireelect.com;gurbina@empireelect.com;shesse@empireelect.com' -- varchar(max)
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
	@ProcReturn = dbo.usp_EMailFISInventorySummary
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
