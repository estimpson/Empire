SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreatedRmaRtvHistoryByDates]
	@OperatorCode varchar(5)
,	@StartDate datetime
,	@EndDate datetime
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
	case
		when at.[type] = 'U' then 'RMA'
		else 'Rtv'
	end as [Type]
,	at.shipper as Shipper
,	at.serial as Serial
,	at.part as Part
,	coalesce(lu.GlSegment, '') as GlSegment
,	convert(varchar, convert(decimal(20,2), at.quantity) ) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from
	dbo.audit_trail at
	left join dbo.SerialRmaRtvLookup lu
		on lu.Serial = at.serial
where
	at.date_stamp between @StartDate and @EndDate
	and at.[type] in ('U', 'V')
order by
	at.[type]
,	at.shipper
,	at.part
,	lu.GlSegment
,	at.serial



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
	'W2' as [Type]
,	at.shipper as Shipper
,	convert(varchar(30), at.serial) as Serial
,	at.part as Part
,	lu.GlSegment as GlSegment
,	convert(varchar, convert(decimal(20,2), at.quantity)) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from
	dbo.SerialRmaRtvLookup lu
	join dbo.audit_trail at
		on at.serial = lu.Serial
		and at.[type] = ('W2')
		and at.quantity > 0
where
	at.date_stamp between @StartDate and @EndDate
order by
	at.[type]
,	at.shipper
,	at.part
,	lu.GlSegment
,	at.serial



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
	'W2 un-bulbed' as [Type]
,	at.shipper as Shipper
,	convert(varchar(30), at.serial) as Serial
,	at.part as Part
,	lu.GlSegment as GlSegment
,	convert(varchar, convert(decimal(20,2), at.quantity)) as Quantity
,	convert(varchar, convert(datetime, at.date_stamp, 100) ) as AuditTrailDate
,	at.from_loc as FromLoc
,	at.to_loc as ToLoc
from
	dbo.SerialRmaRtvLookup lu
	join dbo.audit_trail at
		on at.serial = lu.Serial
		and at.[type] = ('W2')
		and at.quantity < 0
where
	at.date_stamp between @StartDate and @EndDate
order by
	at.[type]
,	at.shipper
,	at.part
,	lu.GlSegment
,	at.serial



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
-- Honduras RMA
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
	eehsql1.eeh.dbo.audit_trail at
	join eehsql1.eeh.dbo.part p
		on p.part = at.part
	join eehsql1.eeh.dbo.product_line pl
		on p.product_line = pl.id
where 
	at.date_stamp between @StartDate and @EndDate
	and at.[type] = 'U' 
order by
	at.[type]
,	at.shipper
,	at.part
,	pl.gl_segment 
,	at.serial



-- Return
select
	ShipperType
,	Shipper
,	Serial
,	Part
,	GlSegment
,	Quantity
,	AuditTrailDate
,	FromLoc
,	ToLoc
from
	@history
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
