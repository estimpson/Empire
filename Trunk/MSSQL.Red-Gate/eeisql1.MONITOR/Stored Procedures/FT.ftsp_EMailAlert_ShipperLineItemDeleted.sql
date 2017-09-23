SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [FT].[ftsp_EMailAlert_ShipperLineItemDeleted] 

--Returns reduced shipper_detail data in an EMail aleret sent to EEI Schedulers
		 @shipper INT
		,@order_number INT
		,@part_original VARCHAR(25)
		,@SchedulerInitials VARCHAR(15)
		,@TranDT DATETIME OUT
		,@Result INTEGER OUT
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	@Result = 999999
SET	ANSI_WARNINGS ON

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname  = N'#DeletedLineItem',
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

-- Get ShipperDetail and Current Inventory for Short Shipment
	

	DECLARE		@SchedulerEmailAddress VARCHAR(MAX)
				
		
	SELECT 
		@shipper AS ShipperID,
		@order_number AS OrderNumber,
		@part_original AS PartNumber,
		@SchedulerInitials AS Scheduler

INTO
		#DeletedLineItem

	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #DeletedLineItem )	

SELECT @SchedulerInitials
		= MIN(Scheduler)
	FROM
		#DeletedLineItem

		SELECT @SchedulerEmailAddress
		= [FT].[fn_ReturnSchedulerEMailAddress] ( @SchedulerInitials)

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#DeletedLineItem'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[PartNumber], [Scheduler]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Deleted Shipper Line Item Alert (Sent Based on Delete Trigger on Shipper_Detail) ' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'DBMail'-- sysname
	,		@recipients = @SchedulerEmailAddress -- varchar(max)
--	,		@recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	,		@copy_recipients = 'dwest@empireelect.com;aboulanger@fore-thought.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,			@importance = 'High'  -- varchar(6)	



		
		
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
		@ProcReturn = ft.ftsp_EMailAlert_ShipperQtyRequiredEdit 
		@shipper  = 74751
	,	@order_number = 19922
	,	@part_original  = 'PET0051-HD08'
	,	@TranDT = @TranDT out
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
