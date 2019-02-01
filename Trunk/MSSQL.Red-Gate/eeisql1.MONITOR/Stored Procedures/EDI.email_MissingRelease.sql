SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [EDI].[email_MissingRelease]
	@TranDT DATETIME = NULL OUT
,	@Result INTEGER = NULL OUT

AS
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

	IF OBJECT_ID('#EDIMissingSchedules') IS  NULL  
    CREATE TABLE #EDIMissingSchedules
	 ( 
		TradingPartner VARCHAR(50),
		LastSchedDT DATETIME ,
		SchedType VARCHAR(10),
		ReleaseImportDT DATETIME,
		ReleaseNo VARCHAR(50),
		ShipToCode VARCHAR(50),
		Destination VARCHAR(50),
		Scheduler VARCHAR(50),
		SchedulerEmailAddress VARCHAR(255),
		CustomerPart VARCHAR(50),
		CustomerPO VARCHAR(50),
		ShpDT DATETIME,
		CusQty INT,
		lstAccumCust INT,
		lstQtyCust INT,
		lstShipIDCust VARCHAR(50),
		Last3Shipments VARCHAR(255))

		IF OBJECT_ID('#EDIMissingSchedules') IS  NULL  
    CREATE TABLE #EmailEDIMissingSchedules
	 ( 
		TradingPartner VARCHAR(50),
		LastSchedDT DATETIME ,
		SchedType VARCHAR(10),
		ReleaseImportDT DATETIME,
		ReleaseNo VARCHAR(50),
		ShipToCode VARCHAR(50),
		Destination VARCHAR(50),
		Scheduler VARCHAR(50),
		SchedulerEmailAddress VARCHAR(255),
		CustomerPart VARCHAR(50),
		CustomerPO VARCHAR(50),
		ShpDT DATETIME,
		CusQty INT,
		lstAccumCust INT,
		lstQtyCust INT,
		lstShipIDCust VARCHAR(50),
		Last3Shipments VARCHAR(255))

			--IF OBJECT_ID('#EDIMissingSchedules') IS  NOT NULL  
			TRUNCATE TABLE #EDIMissingSchedules

		INSERT  #EDIMissingSchedules
		SELECT * FROM EDI2040ic.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDI3060ic.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDI3030ic.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDI3040ic.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDI5050ic.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDIADAC.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDIChryslerIC.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDIFordIC.[fn_DemandAnalysis] ( )
		UNION
		SELECT * FROM EDIAutolIv.[fn_DemandAnalysis] ( )

IF EXISTS (SELECT 1 FROM #EDIMissingSchedules)
		DECLARE @EmailAddress varchar(255),
						@TradingPartner VARCHAR(50)
			
		DECLARE EmailAddress CURSOR LOCAL FOR
			SELECT
				DISTINCT SchedulerEmailAddress, TradingPartner
			FROM
				#EDIMissingSchedules
		
		OPEN EmailAddress
		WHILE		
		1 = 1 
		BEGIN	
	
		
		FETCH
			EmailAddress
		INTO
			@EmailAddress,
			@TradingPartner

		
		IF	@@FETCH_STATUS != 0 BEGIN
			BREAK
		END
		
	

		Insert #EmailEDIMissingSchedules
		SELECT *
		FROM #EDIMissingSchedules ems
		WHERE ems.SchedulerEmailAddress = @EmailAddress AND
						ems.TradingPartner = @TradingPartner
	 	

		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#EmailEDIMissingSchedules'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,   @OrderBy = ' [TradingPartner],  [SchedType], [Destination], [CustomerPart], [shpDT]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Missing Releases for : ' + @TradingPartner --+ ' ---TESTING ONLY--- '

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailAddress -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject =  @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 
					
	

		END
		
		close EmailAddress
		DEALLOCATE EmailAddress

		






/* End E-Mail and Exceptions */


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

begin transaction
go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI4010.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


go

commit transaction
--rollback transaction

go

set statistics io off
set statistics time off
go

}

Results {
}
*/


































































GO
