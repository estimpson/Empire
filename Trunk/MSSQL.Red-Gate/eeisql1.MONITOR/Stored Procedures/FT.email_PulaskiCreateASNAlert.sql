SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[email_PulaskiCreateASNAlert]
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
    DROP TABLE #EmailPulaskiAlert

	IF OBJECT_ID('#PulaskiAlert') IS  NULL  
    CREATE TABLE #PulaskiAlert
	 ( 
	[Note] VARCHAR(255) NULL,
	[parent_serial] [NUMERIC](10, 0) NULL,
	[Serial] [INT] NOT NULL,
	[part] [VARCHAR](25) NOT NULL,
	[quantity] [NUMERIC](20, 6) NULL,
	[date_stamp] [DATETIME] NOT NULL,
	[customer_part] [VARCHAR](35) NULL,
	[ShipTo] [VARCHAR](20) NULL,
	[EDIShipToID] [VARCHAR](20) NULL,
	[TradingPartner] [VARCHAR](20) NULL, 
	[SchedulerEmail] [NVARCHAR](MAX) NULL,
	[partQtyOnPallet] [NUMERIC](38, 6) NULL,
	[partQty] [NUMERIC](38, 6) NULL
	)

		

			
		TRUNCATE TABLE #PulaskiAlert

		INSERT #PulaskiAlert
		   ([Note] 
			, [parent_serial]
           ,[Serial]
           ,[part]
           ,[quantity]
           ,[date_stamp]
           ,[customer_part]
           ,[ShipTo]
           ,[EDIShipToID]
		   ,[TradingPartner]
           ,[SchedulerEmail]
           ,[partQtyOnPallet]
           ,[partQty]
		        )
			SELECT 
			at.notes,
			parent_serial, 
			Serial, 
			part, 
			at.quantity, 
			date_stamp , 
			salesOrder.customer_part, 
			salesOrder.destination AS ShipTo,
			salesOrder.parent_destination AS EDIShipToID,
			'ALC PULASKI',
			[FT].[fn_ReturnSchedulerEMailAddress] (FT.fn_ReturnScheduler(salesOrder.destination)) AS SchedulerEmail,
			PartQuantityOnPallet.partQtyOnPallet, 
			PartQuantity.partQty
		
	FROM audit_trail at  
OUTER APPLY ( 
	SELECT TOP 1 customer_part , order_header.destination, es.parent_destination
	FROM order_header
	JOIN edi_setups es ON es.destination = order_header.destination
	WHERE blanket_part = at.part AND es.parent_destination = 'PU21'  ) salesOrder
OUTER APPLY ( 
	SELECT SUM(quantity) AS partQtyOnPallet
	FROM dbo.audit_trail at2
	WHERE at2.to_loc = 'ALC-INTRAN'  
	AND at2.from_loc != 'ALC-INTRAN' 
	AND at2.parent_serial = at.parent_serial
	AND at2.part = AT.part
	AND type = 'T' 
	AND date_stamp>= DATEADD(minute, -15, getdate())
	 ) PartQuantityOnPallet
	OUTER APPLY ( 
	SELECT SUM(quantity) AS partQty
	FROM dbo.audit_trail at2
	WHERE at2.to_loc = 'ALC-INTRAN'  
	AND at2.from_loc != 'ALC-INTRAN' 
	AND at2.part = AT.part
	AND type = 'T' 
	AND date_stamp>=  DATEADD(minute, -15, getdate())
	 ) PartQuantity
	 OUTER APPLY ( 
	SELECT TOP 1 at3.notes
	FROM dbo.audit_trail at3
	WHERE at3.to_loc = 'ALC-INTRAN'  
	AND at3.from_loc != 'ALC-INTRAN' 
	AND at3.part = AT.part
	AND type = 'T' 
	AND NULLIF(at3.notes,'') IS NOT NULL
	AND date_stamp>=  DATEADD(minute, -15, getdate())
	 ) Partnote
	WHERE to_loc = 'ALC-INTRAN'  
	AND from_loc != 'ALC-INTRAN' 
	AND type = 'T' 
	AND date_stamp>=  DATEADD(minute, -15, getdate())
	ORDER BY 3, 1, 2
					
		

IF EXISTS (SELECT 1 FROM #PulaskiAlert)
		DECLARE @EmailAddress varchar(255),
						@TradingPartner VARCHAR(50)
			
		DECLARE EmailAddress CURSOR LOCAL FOR
			SELECT
				DISTINCT SchedulerEMAIL, TradingPartner
			FROM
				#PulaskiAlert
		
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
		
	

		
		--SELECT 
		--		ems.Note ,
		--		ems.parent_serial ,
  --             ems.Serial ,
  --             ems.part ,
  --             ems.quantity ,
  --             ems.date_stamp ,
  --             ems.customer_part ,
  --             ems.ShipTo ,
  --             ems.EDIShipToID ,
  --             ems.TradingPartner ,
  --             ems.SchedulerEmail ,
  --             ems.partQtyOnPallet ,
  --             ems.partQty
		SELECT  note = MAX(ems.Note),
						ems.customer_part,
						ems.EDIShipToID,
						ems.TradingPartner,
						ems.SchedulerEmail,
						partquantity = SUM(ems.quantity) 

		INTO #EmailPulaskiAlert
		FROM #PulaskiAlert ems
		WHERE ems.SchedulerEmail = @EmailAddress AND
						ems.TradingPartner = @TradingPartner
			GROUP BY ems.customer_part,
						ems.EDIShipToID,
						ems.TradingPartner,
						ems.SchedulerEmail
	 	

		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#EmailPulaskiAlert'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,   @OrderBy = ' [Customer_Part]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Send Portal ASN for Trading Partner : ' + @TradingPartner /*+ ' ---TESTING ONLY--- '*/

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
					
	DROP TABLE  #EmailPulaskiAlert

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
