SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE PROCEDURE [FT].[ftsp_EMailAlert_ShipperCreation] 

--Returns  shipper_detail data in an EMail aleret sent to EEI Schedulers and EEIShipping; it is called by insert trigger on shipper table
		 @shipper INT
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
	@TableName sysname  = N'#Shipment',
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
	

	DECLARE		 @SchedulerEmailAddress VARCHAR(MAX)
				,@SchedulerInitials VARCHAR(MAX)
				,@ShippingEmailAddress VARCHAR(MAX)
				,@EmailRecipients VARCHAR(MAX)
		
	SELECT   
		   s.id
		  ,s.destination AS Destination
		  ,s.date_stamp as ScheduledShipDate
		  ,s.ship_via as ShipVia
		  ,s.plant
		  ,s.notes		
		,  d.scheduler AS Scheduler
INTO
		#Shipment
FROM 
	shipper s 
JOIN
		destination d ON d.destination = s.destination
	WHERE s.id = @shipper and
			s.destination not like 'EMPHON%'
		
	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #Shipment)	
BEGIN
SELECT @SchedulerInitials
		= MIN(Scheduler)
	FROM
		#Shipment

		SELECT @SchedulerEmailAddress
		= [FT].[fn_ReturnSchedulerEMailAddress] ( @SchedulerInitials)

SELECT @ShippingEmailAddress
= CASE  WHEN plant = 'EEA' then 'mcalix@empireelect.com;JBucy@empireelect.com'
		WHEN plant = 'EEP' then 'RDominguez@empireelect.com;LQuintero@trans-expedite.com;RGarcia@trans-expedite.com'
		When plant = 'EEI' then 'shipping@empireelect.com'
		ELSE ''
		END
From
	#Shipment 


Select @EmailRecipients = @SchedulerEmailAddress+';'+@ShippingEmailAddress

		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#Shipment'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[Scheduler]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Shipment Scheduling Alert (Sent Based on Insert Trigger on Shipper) ' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailRecipients -- varchar(max)
--	,		@recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	,		@copy_recipients = 'dwest@empireelect.com;aboulanger@fore-thought.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High'  -- varchar(6)	



		
		
	
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
