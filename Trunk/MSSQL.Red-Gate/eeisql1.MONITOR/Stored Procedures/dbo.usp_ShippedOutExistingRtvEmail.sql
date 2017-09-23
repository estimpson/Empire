SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_ShippedOutExistingRtvEmail]
	@OperatorCode varchar(5)
,	@Shipper varchar(20)
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

declare @serialsList table
(
	Serial int
)


insert into @serialsList
(
	Serial
)
select
	at.serial
from
	dbo.audit_trail at
where
	at.shipper = @Shipper
	and at.[type] = 'V'
	

	
-- If this shipper was created using RMA Maintenance, then shipped out at a later time, it would have an assigned number
declare 
	@RmaRtvNumber varchar(50)
	
select
	@RmaRtvNumber = lu.RmaRtvNumber
from
	dbo.SerialRmaRtvLookup lu
where
	lu.RowCreateUser = @OperatorCode
	and lu.Serial = (
			select	
				max(sl.Serial)
			from	
				@serialsList sl )



-- Troy RTV
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
	'RTV'
,	at.shipper
,	convert(varchar(30), at.serial) as Serial
,	at.part
,	coalesce(lu.GlSegment, '')
,	convert(varchar, convert(decimal(20,2), at.quantity)) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from
	dbo.audit_trail at
	join @serialsList sl
		on sl.Serial = at.serial
	left join dbo.SerialRmaRtvLookup lu
		on lu.Serial = sl.Serial
where
	lu.RowCreateUser = @OperatorCode
	and at.[type] = 'V'
order by
	at.part
,	at.serial
	

-- Honduras RMA
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
	'RMA Honduras'
,	at.shipper as Shipper 
,	convert(varchar(30), at.serial) as Serial
,	at.part as Part
,	pl.gl_segment as GlSegment
,	convert(varchar, convert(decimal(20,2), at.quantity)) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate 
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from 
	@serialsList sl
	join eehsql1.eeh.dbo.audit_trail at 
		on at.serial = sl.Serial
		and at.[type] = 'U' 
	join eehsql1.eeh.dbo.part p
		on p.part = at.part
	join eehsql1.eeh.dbo.product_line pl
		on p.product_line = pl.id
order by
	at.part
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


if (@RmaRtvNumber <> '') begin

	set @EmailHeader = 'RTV'
	
end
else begin

	set @EmailHeader = @RmaRtvNumber
	
end

	
set @EmailBody =
	N'<H1>RTV History</H1>' +
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
