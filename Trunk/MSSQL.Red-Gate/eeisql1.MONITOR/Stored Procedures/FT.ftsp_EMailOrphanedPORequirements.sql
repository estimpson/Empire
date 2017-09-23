SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [FT].[ftsp_EMailOrphanedPORequirements]

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
	@TableName sysname  = N'#OrphanedPOs',
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
	
	SELECT 
	po_number AS  PONumber,
	part_number AS PartNumber,
	SUM(balance) AS TotalOpenQty
INTO
		#OrphanedPOs
FROM po_detail
		WHERE
				balance > 0 AND
				NOT EXISTS (SELECT 1 FROM order_detail WHERE order_detail.part_number = po_detail.part_number) 
GROUP BY
		po_number,
		part_number
				
		
	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #OrphanedPOs )	

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#OrphanedPOs'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[PartNumber]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'POs to EEH That Have Zero Sales Order Requirements Alert (SQLJob:EMailAlertEEHPOsWithoutSalesDemand) ' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = 'mminth@empireelect.com;jstoehr@empireelect.com;gurbina@empireelect.com;shesse@empireelect.com' -- varchar(max)
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
