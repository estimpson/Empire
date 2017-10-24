SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_EMailFISInventoryIdle]

--Looks for Inventory in FIS Locations that have not been touched in past 30 days. returns data in an EMail aleret sent to EEI Schedulers

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
	@TableName sysname  = N'#FISInventoryIdle',
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
	
	SELECT @EvaluateDate = DATEADD(DAY,-31, GETDATE())
	
	--Get Audit Trail for QC Tranactions
	
		
	SELECT 
		part, 
		location, 
		SUM(quantity) AS Quantity, 
		Operator AS Employee
INTO
		#FISInventoryIdle
FROM object
		WHERE 
				object.location LIKE '%FIS%'
				AND object.part != 'PALLET'
				AND object.last_date <= @EvaluateDate
GROUP BY part,
				location,
				Operator
		
	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #FISInventoryIdle )	

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#FISInventoryIdle'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[Part], [Employee]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'FIS Idle Alert (SQLJob:EMailAlertFISIdle) - Inventory Located In FIS Locations That Have No Activity Within The Last 30 Days' 

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
	@ProcReturn = dbo.usp_EMailFISInventoryIdle
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
