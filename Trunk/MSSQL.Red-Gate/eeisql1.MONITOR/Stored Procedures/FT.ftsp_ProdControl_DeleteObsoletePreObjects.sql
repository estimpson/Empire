SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_DeleteObsoletePreObjects]
	@Days int
,	@TranDT datetime out
,	@Result integer out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
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
declare
	@tranType char (1) = 'P'
,	@Remark varchar (10) = 'PREOBJECT'
,	@Notes varchar (50) = 'PREOBJECT delete.'

insert
	audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	operator
,	from_loc
,	to_loc
,	lot
,	weight
,	status
,	unit
,	std_quantity
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight 
)
select
	o.serial
,	@TranDT
,	@TranType
,	o.part
,	-o.quantity
,	@Remark
,	o.operator
,	o.location
,	o.location
,	o.lot
,	o.weight
,	o.status
,	o.unit_measure
,	-o.std_quantity
,	o.plant
,	@Notes
,	o.package_type
,	o.cost
,	o.user_defined_status
,	o.tare_weight
from
	object o
where
	location = 'PREOBJECT'
	and last_date <= @tranDT - @Days

update
	poh
set	Status = poh.Status | 1
from
	FT.PreObjectHistory poh
	join dbo.object o
		on o.serial = poh.Serial
where
	location = 'PREOBJECT'
	and	last_date <= @tranDT - @Days

update
	WODetails
set	QtyLabelled = wd.QtyLabelled - poh.Quantity
from
	dbo.WODetails wd
	join FT.PreObjectHistory poh
		on poh.WODID = wd.ID
	join dbo.object o
		on o.serial = poh.Serial
where
	location = 'PREOBJECT'
	and	last_date <= @tranDT - @Days

delete
	o
from
	dbo.object o
where
	location = 'PREOBJECT'
	and	last_date <= @tranDT - @Days
--- </Body>

if	@TranCount = 0 begin
	commit transaction @ProcName
end

---	<Return>
set	@Result = 0
return
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

declare
	@days int
	
set	@days = 5

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.ftsp_ProdControl_DeleteObsoletePreObjects
	@Days = @days
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
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
