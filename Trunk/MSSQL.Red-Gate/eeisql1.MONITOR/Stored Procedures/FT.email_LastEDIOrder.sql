SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [FT].[email_LastEDIOrder]
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
	@RowCount INTEGER
    
	IF OBJECT_ID('#EmailEDIMissingSchedules') IS NOT NULL  
    DROP TABLE #EmailEDIMissingSchedules

	IF OBJECT_ID('#LastEDIOrder') IS  NULL  
    CREATE TABLE #LastEDIOrder
	 ( 
	[order_no] [NUMERIC](8, 0) NOT NULL,
	[blanket_part] [VARCHAR](25) NULL,
	[customer_part] [VARCHAR](50) NULL,
	[customer_po] [VARCHAR](30) NULL,
	[TradingPartner] [VARCHAR](150) NULL,
	[destination] [VARCHAR](20) NULL,
	[EDIShipToID] [VARCHAR](25) NULL,
	[scheduler] [VARCHAR](15) NULL,
	[DateOfLastEDIOrder] [VARCHAR](25) NOT NULL,
	[DaysSinceLastEDIOrder] [INT] NOT NULL,
	[TotalOrderQty] [DECIMAL](38, 6) NULL,
	[FirstDueDate] [DATETIME] NULL,
	[LastDueDate] [DATETIME] NULL,
	[SchedulerEMAIL]  [VARCHAR](255) NULL)

		

			
		TRUNCATE TABLE #LastEDIOrder

		INSERT #LastEDIOrder
		        ( order_no ,
		          blanket_part ,
		          customer_part ,
		          customer_po ,
				  TradingPartner,
		          destination ,
		          EDIShipToID ,
		          scheduler ,
		          DateOfLastEDIOrder ,
		          DaysSinceLastEDIOrder ,
		          TotalOrderQty ,
		          FirstDueDate ,
		          LastDueDate ,
		          SchedulerEMAIL
		        )
				 SELECT *,
				 [FT].[fn_ReturnSchedulerEMailAddress] (ledio.scheduler)
				 FROM	
				  ft.vwlastEDIOrder ledio
				  WHERE ledio.TotalOrderQty > 1
					
		

IF EXISTS (SELECT 1 FROM #LastEDIOrder)
		DECLARE @EmailAddress varchar(255),
						@TradingPartner VARCHAR(50)
			
		DECLARE EmailAddress CURSOR LOCAL FOR
			SELECT
				DISTINCT SchedulerEMAIL, TradingPartner
			FROM
				#LastEDIOrder
		
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
		
	

		
		SELECT *
		INTO #EmailEDIMissingSchedules
		FROM #LastEDIOrder ems
		WHERE ems.SchedulerEmail = @EmailAddress AND
						ems.TradingPartner = @TradingPartner
	 	

		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#EmailEDIMissingSchedules'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,   @OrderBy = ' [TradingPartner], [Destination], [Customer_Part]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Missing Releases for : ' + @TradingPartner 

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
					
	DROP TABLE  #EmailEDIMissingSchedules

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
