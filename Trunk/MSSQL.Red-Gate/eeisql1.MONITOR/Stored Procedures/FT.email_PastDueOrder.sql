SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [FT].[email_PastDueOrder]
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
    
	IF OBJECT_ID('#EmailPastDueOrders') IS NOT NULL  
    DROP TABLE #EmailPastDueOrders

	IF OBJECT_ID('#LastEDIOrder') IS  NULL  
    CREATE TABLE #PastDueOrders
	 ( 
	[order_no] [NUMERIC](8, 0) NOT NULL,
	[blanket_part] [VARCHAR](25) NULL,
	[customer_part] [VARCHAR](50) NULL,
	[customer_po] [VARCHAR](30) NULL,
	[Customer] [VARCHAR](150) NULL,
	[destination] [VARCHAR](20) NULL,
	[EDIShipToID] [VARCHAR](25) NULL,
	[scheduler] [VARCHAR](15) NULL,
	[ReleaseDueDate] [DATETIME] NULL,
	[OrderReleaseQty] NUMERIC (20,6) NULL,
	[ShipDay] [VARCHAR](15) NULL,
	[NextShipper] INT NULL,
	[ScheduledShipDT] [DATETIME] NULL,
	[ScheduledShipQty]  NUMERIC (20,6) NULL,
	[StagedShipQty]  NUMERIC (20,6) NULL,
	[AvailableInventory]  NUMERIC (20,6) NULL,
	[SchedulerEMAIL]  [VARCHAR](255) NULL)

		

			
		TRUNCATE TABLE #PastDueOrders

		INSERT #PastDueOrders
		        ( order_no ,
		          blanket_part ,
		          customer_part ,
		          customer_po ,
		          Customer ,
		          destination ,
		          EDIShipToID ,
		          scheduler ,
		          ReleaseDueDate ,
		          OrderReleaseQty ,
		          ShipDay ,
		          NextShipper ,
		          ScheduledShipDT ,
		          ScheduledShipQty ,
		          StagedShipQty ,
		          AvailableInventory ,
		          SchedulerEMAIL
		        )
		
		 
				 SELECT *,
				 [FT].[fn_ReturnSchedulerEMailAddress] (pdorder.scheduler)
				 FROM	
				[FT].[vwPastDueOrder] pdorder
				  
					
		

IF EXISTS (SELECT 1 FROM #PastDueOrders)
		DECLARE @EmailAddress varchar(255),
						@TradingPartner VARCHAR(50)
			
		DECLARE EmailAddress CURSOR LOCAL FOR
			SELECT
				DISTINCT SchedulerEMAIL
			FROM
				#PastDueOrders
		
		OPEN EmailAddress
		WHILE		
		1 = 1 
		BEGIN	
	
		
		FETCH
			EmailAddress
		INTO
			@EmailAddress

		
		IF	@@FETCH_STATUS != 0 BEGIN
			BREAK
		END
		
	

		
		SELECT *
		INTO #EmailPastDueOrders
		FROM #PastDueOrders ems
		WHERE ems.SchedulerEmail = @EmailAddress 
	 	

		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#EmailPastDueOrders'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,   @OrderBy = ' [Destination], [Customer_Part],[order_no],[ReleaseDueDate]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Past Due Releases for date :   ' + (SELECT CONVERT(VARCHAR(25), GETDATE(), 113))

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailAddress -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com;iaragon@empireelect.com' -- varchar(max)
	, 		@subject =  @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 
					
	DROP TABLE  #EmailPastDueOrders

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
