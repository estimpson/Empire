SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_GetBlanketOrderDistributedReleases]
	@TranDT datetime = null out
,	@Result int out
,	@Debug int = 1
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
	@AlternateOrders table
(	OrderType char(1)
,	ActiveOrderNo int
,	ActivePart varchar(25)
,	AlternateOrderNo int
,	AlternatePart varchar(25)
,	primary key
	(	ActiveOrderNo
	,	OrderType
	,	AlternateOrderNo
	)
)

insert
	@AlternateOrders
select
	OrderType
,	ActiveOrderNo
,	ActivePart
,	AlternateOrderNo
,	AlternatePart
from
	dbo.BlanketOrderAlternates boa
where
	boa.ActiveOrderNo in
		(	select
				bore.ActiveOrderNo
			from
				##BlanketOrderReleases_Edit bore
			where
				bore.SPID = @@SPID
		)
order by
	boa.ActiveOrderNo
,	boa.OrderType
,	boa.AlternatePart

declare
	@InventoryPartList table
(	Part varchar(25) primary key
)

insert
	@InventoryPartList
select distinct
	xr.ChildPart
from
	FT.XRt xr
	join dbo.part p
		on p.part = xr.ChildPart
where
	xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and p.commodity in ('FINISHED GOODS', 'COMPONENTS')
	and xr.TopPart not like 'NAL%'

insert
	@InventoryPartList
select distinct
	xr.ChildPart
from
	FT.XRt xr
where
	xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and xr.TopPart like 'NAL%'
		and xr.ChildPart in (select blanket_part from dbo.order_header oh)

declare
	@NetMPS table
(	ID int identity primary key
,	ActiveOrderNo int
,	OrderNo int default (-1) not null
,	LineID int not null
,	Part varchar(25) not null
,	RequiredDT datetime not null
,	GrossDemand numeric(30,12) not null
,	Balance numeric(30,12) not null
,	OnHandQty numeric(30,12) default (0) not null
,	OtherOnHandQty numeric(30,12) default(0) not null
,	InTransitQty numeric(30,12) default (0) not null
,	WIPQty numeric(30,12) default (0) not null
,	OtherWIPQty numeric(30,12) default(0) not null
,	LowLevel int not null
,	Sequence int not null
,	Plant varchar(10) not null
)

/*	Non-NAL*/
insert
	@NetMPS
(	ActiveOrderNo
,	OrderNo
,	LineID
,	Part
,	RequiredDT
,	GrossDemand
,	Balance
,	LowLevel
,	Sequence
,	Plant
)
select
	ActiveOrderNo = ao.ActiveOrderNo
,	OrderNo = ao.AlternateOrderNo
,	LineID = od.id
,	Part = xr.ChildPart
,	RequiredDT = od.due_date
,	GrossDemand = od.std_qty * xr.XQty
,	Balance = od.std_qty * xr.XQty
,	LowLevel = (select max(BOMLevel) from FT.XRt where TopPart in (select AlternatePart from @AlternateOrders ao) and ChildPart = xr.ChildPart)
,	Sequence = xr.Sequence
,	Plant = coalesce(lMfg.plant, ohActive.plant, 'EEI')
from
	dbo.order_detail od
	join dbo.order_header ohActive
		on ohActive.destination = od.destination
		and ohActive.customer_part = od.customer_part
		and left(ohActive.blanket_part,7) = left(od.part_number,7)
		and ohActive.status = 'A'
	join dbo.edi_setups es
		on es.destination = od.destination
	join @AlternateOrders ao
		on ao.ActiveOrderNo = ohActive.order_no
		and ao.ActiveOrderNo not in
		(	select
		 		bore.ActiveOrderNo
		 	from
		 		##BlanketOrderReleases_Edit bore
		 	where
		 		bore.SPID = @@SPID
		 )
	join FT.XRt xr
		on xr.TopPart = ao.AlternatePart
	join dbo.part p
		on p.part = xr.ChildPart
	left join dbo.part_machine pm
		on pm.part = xr.TopPart
		and pm.sequence = 1
	left join dbo.location lMfg
		on lMfg.code = pm.machine
where
	xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and xr.BOMLevel < 2
	and p.commodity in ('FINISHED GOODS', 'COMPONENTS')
	and od.destination != 'EMPIREALABAMA'
	and xr.TopPart not like 'NAL%'

/*	NAL*/
insert
	@NetMPS
(	ActiveOrderNo
,	OrderNo
,	LineID
,	Part
,	RequiredDT
,	GrossDemand
,	Balance
,	LowLevel
,	Sequence
,	Plant
)
select
	ActiveOrderNo = ao.ActiveOrderNo
,	OrderNo = ao.AlternateOrderNo
,	LineID = od.id
,	Part = xr.ChildPart
,	RequiredDT = od.due_date
,	GrossDemand = od.std_qty * xr.XQty
,	Balance = od.std_qty * xr.XQty
,	LowLevel = (select max(BOMLevel) from FT.XRt where TopPart in (select AlternatePart from @AlternateOrders ao) and ChildPart = xr.ChildPart)
,	Sequence = xr.Sequence
,	Plant = coalesce(lMfg.plant, ohActive.plant, 'EEI')
from
	dbo.order_detail od
	join dbo.order_header ohActive
		on ohActive.destination = od.destination
		and ohActive.customer_part = od.customer_part
		and left(ohActive.blanket_part,7) = left(od.part_number,7)
		and ohActive.status = 'A'
	join dbo.edi_setups es
		on es.destination = od.destination
	join @AlternateOrders ao
		on ao.ActiveOrderNo = ohActive.order_no
		and ao.ActiveOrderNo not in
		(	select
		 		bore.ActiveOrderNo
		 	from
		 		##BlanketOrderReleases_Edit bore
		 	where
		 		bore.SPID = @@SPID
		 )
	join FT.XRt xr
		on xr.TopPart = ao.AlternatePart
	left join dbo.part_machine pm
		on pm.part = xr.TopPart
		and pm.sequence = 1
	left join dbo.location lMfg
		on lMfg.code = pm.machine
where
	xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and xr.BOMLevel < 2
	and od.destination != 'EMPIREALABAMA'
	and xr.TopPart like 'NAL%'
		and xr.ChildPart in (select blanket_part from dbo.order_header oh)

/*	Non-NAL*/
insert
	@NetMPS
(	ActiveOrderNo
,	OrderNo
,	LineID
,	Part
,	RequiredDT
,	GrossDemand
,	Balance
,	LowLevel
,	Sequence
,	Plant
)
select
	ActiveOrderNo = ao.ActiveOrderNo
,	OrderNo = ao.AlternateOrderNo
,	LineID = -bore.RowID
,	Part = xr.ChildPart
,	RequiredDT = bore.ReleaseDT
,	GrossDemand = bore.QtyRelease * xr.XQty
,	Balance = bore.QtyRelease * xr.XQty
,	LowLevel = (select max(BOMLevel) from FT.XRt where TopPart in (select AlternatePart from @AlternateOrders ao) and ChildPart = xr.ChildPart)
,	Sequence = xr.Sequence
,	Plant = coalesce(lMfg.plant, ohAlternate.Plant, 'EEI')
from
	##BlanketOrderReleases_Edit bore
	join @AlternateOrders ao
		on ao.ActiveOrderNo = bore.ActiveOrderNo
	join dbo.order_header ohAlternate
		on ohAlternate.order_no = ao.AlternateOrderNo
	join FT.XRt xr
		on xr.TopPart = ao.AlternatePart
	join dbo.part p
		on p.part = xr.ChildPart
	left join dbo.part_machine pm
		on pm.part = xr.TopPart
		and pm.sequence = 1
	left join dbo.location lMfg
		on lMfg.code = pm.machine
where
	bore.SPID = @@SPID
	and xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and xr.BOMLevel < 2
	and p.commodity in ('FINISHED GOODS', 'COMPONENTS')
	and xr.TopPart not like 'NAL%'

/*	NAL*/
insert
	@NetMPS
(	ActiveOrderNo
,	OrderNo
,	LineID
,	Part
,	RequiredDT
,	GrossDemand
,	Balance
,	LowLevel
,	Sequence
,	Plant
)
select
	ActiveOrderNo = ao.ActiveOrderNo
,	OrderNo = ao.AlternateOrderNo
,	LineID = -bore.RowID
,	Part = xr.ChildPart
,	RequiredDT = bore.ReleaseDT
,	GrossDemand = bore.QtyRelease * xr.XQty
,	Balance = bore.QtyRelease * xr.XQty
,	LowLevel = (select max(BOMLevel) from FT.XRt where TopPart in (select AlternatePart from @AlternateOrders ao) and ChildPart = xr.ChildPart)
,	Sequence = xr.Sequence
,	Plant = coalesce(lMfg.plant, ohAlternate.Plant, 'EEI')
from
	##BlanketOrderReleases_Edit bore
	join @AlternateOrders ao
		on ao.ActiveOrderNo = bore.ActiveOrderNo
	join dbo.order_header ohAlternate
		on ohAlternate.order_no = ao.AlternateOrderNo
	join FT.XRt xr
		on xr.TopPart = ao.AlternatePart
	left join dbo.part_machine pm
		on pm.part = xr.TopPart
		and pm.sequence = 1
	left join dbo.location lMfg
		on lMfg.code = pm.machine
where
	bore.SPID = @@SPID
	and xr.TopPart in (select AlternatePart from @AlternateOrders ao)
	and xr.BOMLevel < 2
	and xr.TopPart like 'NAL%'
		and xr.ChildPart in (select blanket_part from dbo.order_header oh)

if	@Debug != 0 begin
	select
		*
	from
		@NetMPS nm
	where
		nm.ActiveOrderNo in
		(	select
				bore.ActiveOrderNo
			from
				##BlanketOrderReleases_Edit bore
			where
				SPID = @@SPID
		)
	order by
		nm.ActiveOrderNo
	,	nm.LineID
	,	nm.RequiredDT
	,	nm.OrderNo
	,	nm.Sequence
end

declare @Inventory table
(	Part varchar(25)
,	Plant varchar(10)
,	OnHand numeric(30,12)
,	LowLevel int
)

insert
	@Inventory
(	Part
,	Plant
,	OnHand
,	LowLevel
)
select
	Part = part
,	Plant = coalesce(lInv.plant, 'EEI')
,	OnHand = sum(o.std_quantity)
,	LowLevel =
	(	select
			max(LowLevel)
		from
			@NetMPS
		where
			Part = o.part
	)
from
	dbo.object o
	left join dbo.location lInv
		on lInv.code = o.location
where
	o.status in ('A', 'H')
	and o.type is null
	and o.part in (select Part from @NetMPS)
	and coalesce(lInv.secured_location, 'N') != 'Y'
group by
	o.part
,	lInv.plant

if	@Debug != 0 begin
	select
		*
	from
		@Inventory i
	order by
		i.Part
	,	case when i.Plant not like 'TRAN-%' then 0 else 1 end
end

declare @X table
(	Part varchar(25) not null
,	InvPlant varchar(10) not null
,	MfgPlant varchar(10) not null
,	OnhandQty numeric(20,6) not null
,	ActiveOrderNo int not null
,	OrderNo int not null
,	LineID int not null
,	Sequence int not null
,	WIPQty numeric(30,12) not null
)

declare
	@LowLevel int = 0
,	@MaxLowLevel int

set	@MaxLowLevel =
	(	select
			max(LowLevel)
		from
			@NetMPS
	)

while
	@LowLevel <= @MaxLowLevel begin

	declare	PartsOnHand cursor local for
	select
		Part
	,	Plant
	,	OnHand
	from
		@Inventory
	where
		OnHand > 0
		and LowLevel = @LowLevel
	order by
		Part
	,	case when Plant not like 'TRAN-%' then 0 else 1 end
		
	declare
		@Part varchar(25)
	,	@InvPlant varchar(10)
	,	@OnHandQty numeric(30,12)
	
	open
		PartsOnHand
	
	while
		1 = 1 begin	
		
		fetch
			PartsOnHand
		into
			@Part
		,	@InvPlant
		,	@OnHandQty
		
		if	@@FETCH_STATUS != 0 begin
			break
		end
		
		declare	Requirements cursor local for
		select
			nm.ID
		,	nm.Balance
		,	nm.ActiveOrderNo
		,	nm.OrderNo
		,	nm.LineID
		,	nm.Sequence
		,	nm.Plant
		from
			@NetMPS nm
		where
			nm.Part = @Part
			and nm.Balance > 0
			and @InvPlant in (nm.Plant, 'TRAN-' + nm.Plant)
		order by
			RequiredDT asc
		
		declare
			@ReqID integer
		,   @Balance numeric(30,12)
		,   @ActiveOrderNo integer
		,   @OrderNo integer
		,   @LineID integer
		,   @Sequence integer
		,	@MfgPlant varchar(10)
		
		open
			Requirements
		
		while
			1 = 1
			and @OnHandQty > 0 begin

			fetch
				Requirements
			into
				@ReqID
			,	@Balance
			,	@ActiveOrderNo
			,	@OrderNo
			,	@LineID
			,	@Sequence
			,	@MfgPlant

			if	@@FETCH_STATUS != 0 begin
				break
			end
			
			if	@InvPlant like 'TRAN-%' begin
				print 'InvPlant: ' + @InvPlant
				print 'MfgPlant: ' + @MfgPlant
				print '	Balance: ' + convert(varchar, @Balance)
				print '	OnHand: ' + convert(varchar, @OnHandQty)
			end
			
			if	@Balance > @OnHandQty begin
				update
					nm
				set
					Balance = @Balance - @OnHandQty
				,	OnHandQty = nm.OnHandQty + case when nm.OrderNo = @OrderNo then @OnHandQty else 0 end
				,	OtherOnHandQty = nm.OtherOnHandQty + case when nm.OrderNo = @OrderNo then 0 else @OnHandQty end
				from
					@NetMPS nm
				where
					nm.ActiveOrderNo = @ActiveOrderNo
					and nm.LineID = @LineID
					and nm.Sequence = @Sequence
				
				insert
					@X
				(	Part
				,	InvPlant
				,	MfgPlant
				,	OnhandQty
				,	ActiveOrderNo
				,	OrderNo
				,	LineID
				,	Sequence
				,	WIPQty
				)
				select
					Part = @Part
				,	InvPlant = @InvPlant
				,	MfgPlant = @MfgPlant
				,	OnhandQty = @OnHandQty
				,	ActiveOrderNo = @ActiveOrderNo
				,	OrderNo = @OrderNo
				,	LineID = @LineID
				,	Sequence = @Sequence + Sequence
				,	WIPQty = @OnHandQty * XQty
				from
					FT.XRt xr
				where
					TopPart = @Part
--					and Sequence > 0
				
				set	@Balance = @Balance - @OnHandQty
				set	@OnHandQty = 0
			end
			else begin
				update
					nm
				set
					Balance = 0
				,	OnHandQty = nm.OnHandQty + case when nm.OrderNo = @OrderNo then @Balance else 0 end
				,	OtherOnHandQty = nm.OtherOnHandQty + case when nm.OrderNo = @OrderNo then 0 else @Balance end
				from
					@NetMPS nm
				where
					nm.ActiveOrderNo = @ActiveOrderNo
					and nm.LineID = @LineID
					and nm.Sequence = @Sequence
				
				insert
					@X
				(	Part
				,	InvPlant
				,	MfgPlant
				,	OnhandQty
				,	ActiveOrderNo
				,	OrderNo
				,	LineID
				,	Sequence
				,	WIPQty
				)
				select
					Part = @Part
				,	InvPlant = @InvPlant
				,	MfgPlant = @MfgPlant
				,	OnhandQty = @Balance
				,	ActiveOrderNo = @ActiveOrderNo
				,	OrderNo = @OrderNo
				,	LineID = @LineID
				,	Sequence = @Sequence + Sequence
				,	WIPQty = @Balance * XQty
				from
					FT.XRt xr
				where
					TopPart = @Part
--					and Sequence > 0
				
				set	@OnHandQty = @OnHandQty - @Balance
				set @Balance = 0
			end
		end
		close
			Requirements
		deallocate
			Requirements

	end
	close
		PartsOnHand
	deallocate
		PartsOnHand

	set	@LowLevel = @LowLevel + 1

	update
		nm
	set	WIPQty = coalesce(
		(	select
				sum(x.WIPQty)
			from
				@X x
			where
				x.ActiveOrderNo = nm.ActiveOrderNo
				and x.OrderNo = nm.OrderNo
				and x.LineID = nm.LineID
				and x.Sequence = nm.Sequence
				and x.Sequence > 0
		), 0)
	,	OtherWIPQty = coalesce(
		(	select
				sum(x.WIPQty)
			from
				@X x
			where
				x.ActiveOrderNo = nm.ActiveOrderNo
				and x.OrderNo != nm.OrderNo
				and x.LineID = nm.LineID
				and x.Sequence = nm.Sequence
				and x.Sequence > 0
		), 0)
	from
		@NetMPS nm
	where
		LowLevel = @LowLevel
	
	update
		nmps
	set	Balance = Balance - (WIPQty + OtherWIPQty)
	from
		@NetMPS nmps
	where
		LowLevel = @LowLevel
end


if	@Debug != 0 begin
	select
		*
	from
		@X x
	where
		x.OrderNo = 15572

	select
		*
	from
		@NetMPS nm
	where
		nm.OrderNo = 15572
	order by
		nm.ActiveOrderNo
	,	nm.LineID
	,	nm.RequiredDT
	,	nm.OrderNo
	,	nm.Sequence

	select
		nm.ActiveOrderNo
	,	nm.LineID
	,	nm.RequiredDT
	,	nm.OrderNo
	,	OpenBalance = case when nm.OrderNo = nm.ActiveOrderNo then Balance else 0 end
	,	AssignedDemand = OnHandQty + WIPQty
	from
		@NetMPS nm
	where
		nm.OrderNo = 15572
		and nm.Sequence =
		(	select
				max(nm1.Sequence)
			from
				@NetMPS nm1
			where
				nm1.OrderNo = nm.OrderNo
		)
		and
		(	case when nm.OrderNo = nm.ActiveOrderNo then Balance else 0 end > 0
			or OnHandQty + WIPQty > 0
		)
		and
		nm.ActiveOrderNo in
		(	select
				bore.ActiveOrderNo
			from
				##BlanketOrderReleases_Edit bore
			where
				SPID = @@SPID
		)
	order by
		nm.ActiveOrderNo
	,	nm.LineID
	,	nm.RequiredDT
	,	nm.OrderNo
end

--drop table ##BlanketOrderDistributeReleases_Edit
if	object_id('tempdb.dbo.##BlanketOrderDistributeReleases_Edit') is null begin

	create table ##BlanketOrderDistributeReleases_Edit
	(	SPID int default @@SPID
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	ActiveOrderNo int
	,	OrderNo int
	,	ReleaseNo varchar(30)
	,	ReleaseDT datetime
	,	ReleaseType char(1)
	,	QtyRelease numeric(20,6)
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	SPID
		,	ActiveOrderNo
		,	OrderNo
		,	ReleaseNo
		,	ReleaseDT
		)
	)
end

delete
	##BlanketOrderDistributeReleases_Edit
where
	SPID = @@SPID

insert
	##BlanketOrderDistributeReleases_Edit
(	ActiveOrderNo
,	OrderNo
,	ReleaseNo
,	ReleaseDT
,	ReleaseType
,	QtyRelease
)
select
	nm.ActiveOrderNo
,	nm.OrderNo
,	bore.ReleaseNo
,	nm.RequiredDT
,	bore.ReleaseType
,	QtyRelease = sum (case when nm.OrderNo = nm.ActiveOrderNo then Balance else 0 end) + sum(OnHandQty + WIPQty)
from
	@NetMPS nm
	join ##BlanketOrderReleases_Edit bore
		on bore.SPID = @@SPID
		and bore.ActiveOrderNo = nm.ActiveOrderNo
		and bore.ReleaseDT = nm.RequiredDT
		and -bore.RowID = nm.LineID
where
	nm.Sequence =
	(	select
			max(nm1.Sequence)
		from
			@NetMPS nm1
		where
			nm1.OrderNo = nm.OrderNo
	)
	and
	(	case when nm.OrderNo = nm.ActiveOrderNo then Balance else 0 end > 0
		or OnHandQty + WIPQty > 0
	)
	and
	nm.ActiveOrderNo in
	(	select
			bore.ActiveOrderNo
		from
			##BlanketOrderReleases_Edit bore
		where
			SPID = @@SPID
	)
group by
	nm.ActiveOrderNo
,	nm.RequiredDT
,	nm.OrderNo
,	bore.ReleaseNo
,	bore.ReleaseType
order by
	nm.ActiveOrderNo
,	nm.RequiredDT
,	nm.OrderNo
,	bore.ReleaseNo

if	@Debug != 0 begin
	select
		*
	from
		##BlanketOrderDistributeReleases_Edit
end
--- </Body>

---	<Return>
if	@TranCount = 0 begin
	commit tran @ProcName
end

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

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_GetBlanketOrderDistributedReleases
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

--commit

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
