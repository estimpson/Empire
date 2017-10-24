SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreatedRmaEmail]
	@OperatorCode varchar(5)
,	@RmaNumber varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>


---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
declare @history table
(
	ShipperType varchar(20)
,	Shipper varchar(30)
,	Serial varchar(30)
,	Part varchar(30)
,	GlSegment varchar(20)
,	Quantity varchar(20)
,	AuditTrailDate varchar(50)
,	FromLoc varchar(30)
,	ToLoc varchar(30)
)

insert into @history
(
	ShipperType
,	Shipper
,	Serial
,	Part
,	GlSegment
,	Quantity
,	AuditTrailDate
,	FromLoc
,	ToLoc
)
select
	'RMA'
,	at.shipper as Shipper
,	convert(varchar(30), at.serial) as Serial
,	at.part as Part
,	coalesce(lu.GlSegment, '') as GlSegment
,	convert(varchar, convert(decimal(20,2), at.quantity)) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from
	dbo.SerialRmaRtvLookup lu
	join dbo.audit_trail at
		on at.serial = lu.Serial
		and at.[type] = 'U'
where
	lu.RmaRtvNumber = @RmaNumber
order by
	at.[type]
,	at.shipper
,	at.part
,	lu.GlSegment
,	at.serial




/*  Send email  */

declare			
	@EmailAddress nvarchar(max)

select 
	--@EmailAddress = [FT].[fn_ReturnSchedulerEMailAddress] (@scheduler)
	@EmailAddress = 'rlee@empireelect.com'	


declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) 

set @EmailHeader = @RmaNumber

set @EmailBody =
	N'<H1>RMA History</H1>' +
	N'<table border="1">' +
	N'<tr><th>Shipper Type</th><th>Shipper</th>' +
	N'<th>Serial</th><th>Part</th>' +
	N'<th>GL Segment</th><th>Quantity</th>' +
	N'<th>AuditTrail Date</th>' +
	N'<th>From Location</th><th>To Location</th></tr>' +
	CAST ( ( select td = h.ShipperType, '',
					td = h.Shipper, '',
					td = h.Serial, '',
					td = h.Part, '',
					td = h.GlSegment, '',
					td = h.Quantity, '',
					td = h.AuditTrailDate, '',
					td = h.FromLoc, '',
					td = h.ToLoc, ''
			  from
					@history h
			  order by
					h.ShipperType,
					h.Shipper,
					h.Part,
					h.GlSegment, 
					h.Serial
			  FOR XML PATH('tr'), TYPE 
	) as nvarchar(max) ) +
	N'</table>' ;
	
	

exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
,		@recipients = @EmailAddress -- varchar(max)
--,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
, 		@subject = @EmailHeader
,  		@body = @EmailBody
,  		@body_format = 'HTML'
,		@importance = 'High' 	
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
	
GO
