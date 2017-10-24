
/*
Create Procedure.EEH.FT.usp_Costing_CalculatePartHistorical.sql
*/

use EEH
go

if	objectproperty(object_id('FT.usp_Costing_CalculatePartHistorical'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_Costing_CalculatePartHistorical
end
go

create procedure FT.usp_Costing_CalculatePartHistorical
	@TranDT datetime = null out
,	@Result integer = null out
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
	@snapshotDT datetime
,	@reason varchar(50)
,	@snapshotRowID int

select top 1
	@snapshotDT = csp.SnapshotDT
,	@reason = csp.Reason
,	@snapshotRowID = csp.RowID
from
	FT.Costing_Snapshots_P csp
where
	SnapshotDT >
		(	select
				coalesce(max(csp.SnapshotDT), '2000-01-01')
			from
				FT.Costing_PartHistorical cph
				join FT.Costing_Snapshots_P csp
					on cph.LastSnapshotRowID = csp.RowID
		)
order by
	1
,	2

if	@snapshotDT is null return

create table
	#PHNew
(	Part varchar(25) null
,	Name varchar(100) not null
,	CrossRef varchar(50) null
,	PartClass char(1) null
,	PartType char(1) null
,	Commodity varchar(30) null
,	GroupTechnology varchar(30) null
,	ProductLine varchar(30) null
,	BinCheckSum int
)

if	@reason = 'DAILY' begin

	insert
		#PHNew
	(	Part
	,	Name
	,	CrossRef
	,	PartClass
	,	PartType
	,	Commodity
	,	GroupTechnology
	,	ProductLine
	)
	select
		Part = phd.part
	,	Name = phd.name
	,	CrossRef = phd.cross_ref
	,	PartClass = phd.class
	,	PartType = phd.type
	,	Commodity = phd.commodity
	,	GroupTechnology = phd.group_technology
	,	ProductLine = phd.product_line
	from
		dbo.part_historical_daily phd
	where
		phd.time_stamp = @snapshotDT
		and phd.reason = @reason
	order by
		phd.part
end
if	not exists
	(	select
			*
		from
			#PHNew pn
	) begin

	insert
		#PHNew
	(	Part
	,	Name
	,	CrossRef
	,	PartClass
	,	PartType
	,	Commodity
	,	GroupTechnology
	,	ProductLine
	)
	select
		Part = phd.part
	,	Name = phd.name
	,	CrossRef = phd.cross_ref
	,	PartClass = phd.class
	,	PartType = phd.type
	,	Commodity = phd.commodity
	,	GroupTechnology = phd.group_technology
	,	ProductLine = phd.product_line
	from
		dbo.part_historical phd
	where
		phd.time_stamp = @snapshotDT
		and phd.reason = @reason
	order by
		phd.part
end

if	not exists
	(	select
			*
		from
			#PHNew pn
	) begin

	insert
		#PHNew
	(	Part
	,	Name
	,	CrossRef
	,	PartClass
	,	PartType
	,	Commodity
	,	GroupTechnology
	,	ProductLine
	)
	select
		Part = phd.part
	,	Name = phd.name
	,	CrossRef = phd.cross_ref
	,	PartClass = phd.class
	,	PartType = phd.type
	,	Commodity = phd.commodity
	,	GroupTechnology = phd.group_technology
	,	ProductLine = phd.product_line
	from
		dbo.part_historical_daily phd
	where
		phd.time_stamp = @snapshotDT
		and phd.reason = @reason
	order by
		phd.part
end

update
	pn
set	BinCheckSum = binary_checksum(*)
from
	#PHNew pn

create index ix_#PHNew_1 on #PHNew (Part, BinCheckSum)

insert
	FT.Costing_PartHistorical
(	Part
,	BeginDT
,	EndDT
,	Name
,	CrossRef
,	PartClass
,	PartType
,	Commodity
,	GroupTechnology
,	ProductLine
,	BinCheckSum
,	LastSnapshotRowID
)
select
	pn.Part
,	BeginDT = @snapshotDT
,	EndDT = @snapshotDT
,   pn.Name
,   pn.CrossRef
,   pn.PartClass
,   pn.PartType
,   pn.Commodity
,   pn.GroupTechnology
,   pn.ProductLine
,   pn.BinCheckSum
,	LastSnapshotRowID = @snapshotRowID
from
	#PHNew pn
	left join FT.Costing_PartHistorical cph
		on cph.LastSnapshotRowID = @snapshotRowID - 1
		and cph.Part = pn.Part
where
	coalesce (cph.BinCheckSum, -1) != pn.BinCheckSum
	or coalesce (cph.Name, '') != coalesce(pn.Name, '')
	or coalesce (cph.CrossRef, '') != coalesce(pn.CrossRef, '')
	or coalesce (cph.PartClass, '') != coalesce(pn.PartClass, '')
	or coalesce (cph.PartType, '') != coalesce(pn.PartType, '')
	or coalesce (cph.Commodity, '') != coalesce(pn.Commodity, '')
	or coalesce (cph.GroupTechnology, '') != coalesce(pn.GroupTechnology, '')
	or coalesce (cph.ProductLine, '') != coalesce(pn.ProductLine, '')
order by
	1
,	2

update
	cph
set	EndDT = @snapshotDT
,	LastSnapshotRowID = @snapshotRowID
from
	#PHNew pn
	left join FT.Costing_PartHistorical cph
		on cph.LastSnapshotRowID = @snapshotRowID - 1
		and cph.Part = pn.Part
where
	coalesce (cph.BinCheckSum, -1) = pn.BinCheckSum
	and coalesce (cph.Name, '') = coalesce(pn.Name, '')
	and coalesce (cph.CrossRef, '') = coalesce(pn.CrossRef, '')
	and coalesce (cph.PartClass, '') = coalesce(pn.PartClass, '')
	and coalesce (cph.PartType, '') = coalesce(pn.PartType, '')
	and coalesce (cph.Commodity, '') = coalesce(pn.Commodity, '')
	and coalesce (cph.GroupTechnology, '') = coalesce(pn.GroupTechnology, '')
	and coalesce (cph.ProductLine, '') = coalesce(pn.ProductLine, '')

drop table
	#PHNew
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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_CalculatePartHistorical
	@Param1 = @Param1
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
go

declare
	@startDT datetime = getdate()

while
	exists
	(	select top 1
			*
		from
			FT.Costing_Snapshots_P csp
		where
			SnapshotDT >
				(	select
						coalesce(max(csp.SnapshotDT), '2000-01-01')
					from
						FT.Costing_PartHistorical cph
						join FT.Costing_Snapshots_P csp
							on cph.LastSnapshotRowID = csp.RowID
				)
	) begin

	begin transaction

	execute
		FT.usp_Costing_CalculatePartHistorical

	commit

	print 'loop'
end
go

select top 1000
	*
from
	FT.Costing_PartHistorical cph
order by
	1, 2

select
	count(*)
,	max(EndDT)
,	max(LastSnapshotRowID)
from
	FT.Costing_PartHistorical cph
