SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreatedRmaRtvSummary]
	@OperatorCode varchar(5)
,	@RmaRtvNumber varchar(50)
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

declare @shippers table
(
	ShipperType varchar(10)
,	Shipper varchar(30)
,	Part varchar(30)
,	GlSegment varchar(20)
,	TotalSerials int
,	TotalQuantity decimal(20,6)
)

-- RMA Shippers
insert into @shippers
(
	ShipperType
,	Shipper
,	Part
,	GlSegment
,	TotalSerials
,	TotalQuantity
)
select
	ShipperType = 'RMA'
,	at.shipper as Shipper
,	at.part as Part
,	lu.GlSegment as GlSegment
,	count(at.serial) as TotalSerials
,	sum(at.quantity) as TotalQuantity
from
	dbo.SerialRmaRtvLookup lu
	join dbo.audit_trail at
		on at.serial = lu.Serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = ('U')
	and at.date_stamp = (	
			select	max(at2.date_stamp) 
			from	audit_trail at2 
			where	at2.type = 'U' 
					and at2.serial = at.serial )
group by
	at.shipper
,	at.part
,	lu.GlSegment


-- RTV Shippers (there will be no audit trail records at this point, not until after shipout)
insert into @shippers
(
	ShipperType
,	Shipper
,	Part
,	GlSegment
,	TotalSerials
,	TotalQuantity
)
select
	ShipperType = 'RTV'
,	convert(varchar(30), o.shipper) as Shipper
,	o.part as Part
,	lu.GlSegment as GlSegment
,	count(o.serial) as TotalSerials
,	sum(o.quantity) as TotalQuantity
from
	dbo.SerialRmaRtvLookup lu
	join dbo.object o
		on o.serial = lu.Serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and convert(varchar(30), o.shipper) not in ( select	s.Shipper from	@shippers s )
group by
	o.shipper
,	o.part
,	lu.GlSegment


select
	ShipperType
,	Shipper
,	Part
,	GlSegment
,	TotalSerials
,	TotalQuantity
from
	@shippers
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
