SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[csp_AutoPOGen]
--	<Debug>
(	@Debug integer = 0)
--	</Debug>
as
/*
Arguments:
None

Result set:
None

Description:
Calculate net requirements for raw materials from sales orders and minimum on
hand settings in combination with flow router data.  Use netted requirements to
create a PO schedule.

Example:
begin transaction
execute	FT.csp_AutoPOGen_Test
--<Debug>
	@Debug = 13
--</Debug>
commit
--rollback

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Populate Expanded Router Temporary Datastructure.
--	II.	Populate Demand Temporary Datastructure.
--	III.	Temporary Datastructure Used to Assign WIP On Hand.
--	IV.	Temporary Datastructure Used to Assign WIP On Hand.
--	V.	Netout.
--	VI.	Consolidate Temporary Weekly Netout.
--	VII.	Refresh Permanent Weekly Netout.
--	VIII.	Create New PO Schedule.
--	IX.	Store NetMPS.
--	X.	Store inventory.
--	XI.	Store inventory allocation.
--	XII.	Finished
*/
set nocount on

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ()
	select	@ProcStartDT = GetDate ()
	print	'AutoPOGen START.   ' + Convert (varchar (50), @ProcStartDT)
end
--</Debug>

create table #NetMPS
(	ID integer identity primary key,
	OrderNo integer default (-1) not null,
	LineID integer not null,
	Part varchar (25) not null,
	RequiredDT DateTime default (GetDate ()) not null,
	Balance numeric (30,12) not null,
	OnHandQty numeric (30,12) default (0) not null,
	WIPQty numeric (30,12) default (0) not null,
	LowLevel integer not null,
	Sequence integer not null)

create index idx_#NetMPS_1 on #NetMPS (LowLevel, Part)
create index idx_#NetMPS_2 on #NetMPS (Part, RequiredDT, Balance)

create table #Inventory
(	Part varchar (25),
	Location varchar (10),
	OnHand numeric (30,12))

create table #OnHand
(	Part varchar (25),
	OnHand numeric (30,12),
	LowLevel integer)

create index idx_#OnHand_1 on #OnHand (LowLevel, Part, OnHand)

create table #X
(	Part varchar (25),
	OnhandQty numeric (20,6),
	OrderNo integer,
	LineID integer,
	Sequence integer,
	WIPQty numeric (30,12))

create index idx_#X_1 on #X (OrderNo, LineID, Sequence)

create table #WkNMPS
(	Part varchar (25),
	WeekNo integer,
	Balance numeric (30,12))

create index idx_#WkNMPS_1 on #WkNMPS (Part, WeekNo, Balance)

--	<Tran>
if @@TranCount = 0
	begin transaction AutoPOGenA
save transaction AutoPOGenA
--	</Tran>

--	Declarations.
declare	@ProcResult integer,
	@Error integer

--	<Debug>
if @Debug & 4 = 4
begin
	if @Debug & 1 = 1
		print	'Incremental update XRt skipped.'
end
else
begin
	--	I.	Populate Expanded Router Temporary Datastructure.
	--	Expand part routers on all parts with current sales orders.
	--	<Debug>
	if @Debug & 1 = 1
		print	'Incremental update XRt..'
	--	</Debug>
	execute	@ProcResult = FT.ftsp_IncUpdXRt
		@Debug = @Debug

	select	@Error = @@Error

	if @ProcResult != 0 or @Error != 0
	begin
	--	<Debug>
		if @Debug & 1 = 1
		begin
			print	'!!!!Incremental update failed.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
			print	'!!!!Proc Result.   ' + Convert (varchar, @ProcResult)
			print	'!!!!Error Code.   ' + Convert (varchar, @Error)
		end
	--	</Debug>
	--	<Tran>
		rollback transaction AutoPOGenA
	--	</Tran>
		return -1
	end

	--	<Debug>
	if @Debug & 1 = 1
		print	'XRt updated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
	--	</Debug>
end

--	II.	Populate Demand Temporary Datastructure.
--	Demand generated from sales order requirements and minimum on hand
--	quantities in conjunction with expanded part routers.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Build MPS..'
	select	@StartDT = GetDate ()
end
--	</Debug>
insert	#NetMPS
(	LineID,
	Part,
	RequiredDT,
	Balance,
	LowLevel,
	Sequence)
select	LineID =
	(	select	min (ID)
		from	FT.XRt
		where	TopPart = POH.Part),
	Part = XRt.ChildPart,
	RequiredDT = DateAdd (day, -XBufferTime, GetDate ()),
	Balance = MinOnHand * XQty,
	LowLevel =
	(	select	max (XRT1.BOMLevel)
		from	FT.XRt XRT1
		where	XRT1.ChildPart = XRt.ChildPart),
	Sequence
from	FT.vwPOH POH
	join FT.XRt XRt on POH.Part = XRt.TopPart
where	MinOnHand > 0

insert	#NetMPS
(	OrderNo,
	LineID,
	Part,
	RequiredDT,
	Balance,
	LowLevel,
	Sequence)
select	OrderNo,
	LineID,
	Part = XRt.ChildPart,
	RequiredDT = DateAdd (day, -XBufferTime, ShipDT),
	Balance = StdQty * XQty,
	LowLevel =
	(	select	max (XRT1.BOMLevel)
		from	FT.XRt XRT1
		where	XRT1.ChildPart = XRt.ChildPart),
	Sequence
from	FT.vwSOD SOD
	join FT.XRt XRt on SOD.Part = XRt.TopPart

--	<Debug>
if @Debug & 1 = 1
	print	'MPS built.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>

--	III.	Populate On Hand Temporary Datastructure.
insert	#Inventory
(	Part,
	Location,
	OnHand)
select	Part,
	Location,
	OnHand
from	FT.vwPLOH

insert	#OnHand
(	Part,
	OnHand,
	LowLevel)
select	Inventory.Part,
	sum (Inventory.OnHand),
	(	select	max (LowLevel)
		from	#NetMPS
		where	Part = Inventory.Part)
from	#Inventory Inventory
	join location on Inventory.Location = location.code and
		isnull (location.secured_location, 'N') = 'N'
where	Inventory.OnHand > 0 and
	Inventory.Part in
	(	select	Part
		from	#NetMPS)
group by
	Inventory.Part

--	IV.	Temporary Datastructure Used to Assign WIP On Hand.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Netout..'
	select	@StartDT = GetDate ()
end
--	</Debug>

--	V.	Netout.
execute	@ProcResult = FT.csp_Netout
	@Debug = @Debug

select	@Error = @@Error

if @ProcResult != 0 or @Error != 0
begin
--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'!!!!Netout failed.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
		print	'!!!!Proc Result.   ' + Convert (varchar, @ProcResult)
		print	'!!!!Error Code.   ' + Convert (varchar, @Error)
	end
--	</Debug>
--	<Tran>
	rollback transaction AutoPOGenA
--	</Tran>
	return -1
end
--	<Debug>
if @Debug & 1 = 1
	print	'Netted.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>

--	VI.	Consolidate Temporary Weekly Netout.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Calc weekly Net..'
	select	@StartDT = GetDate ()
end
--	</Debug>
insert	#WkNMPS
(	Part,
	WeekNo,
	Balance)
select	Part,
	0,
	Sum (Balance)
from	#NetMPS
where	DateDiff (week, GetDate (), RequiredDT) <= 0
group by
	Part
union all
select	Part,
	DateDiff (week, GetDate (), RequiredDT),
	Sum (Balance)
from	#NetMPS
where	DateDiff (week, GetDate (), RequiredDT) > 0
group by
	Part,
	DateDiff (week, GetDate (), RequiredDT)
order by
	1,
	2

--	VII.	Refresh Permanent Weekly Netout.
truncate table
	FT.WkNMPS

insert	FT.WkNMPS
(	Part,
	WeekNo,
	PONumber,
	PriorDemandAccum,
	PostDemandAccum,
	DeliveryDW,
	FrozenWeeks,
	RoundingMethod,
	StandardPack)
select	#WkNMPS.Part,
	WeekNo,
	PONumber = PPrA.DefaultPO,
	PriorDemandAccum = IsNull (
	(	select	Sum (WkNMPS1.Balance)
		from	#WkNMPS WkNMPS1
		where	WkNMPS1.Part = #WkNMPS.Part and
			WkNMPS1.WeekNo < #WkNMPS.WeekNo), 0),
	PostDemandAccum = IsNull (
	(	select	Sum (WkNMPS1.Balance)
		from	#WkNMPS WkNMPS1
		where	WkNMPS1.Part = #WkNMPS.Part and
			WkNMPS1.WeekNo <= #WkNMPS.WeekNo), 0),
	DeliveryDW = convert (integer, PPrA.DeliveryDW),
	FrozenWeeks = PPrA.FrozenWeeks,
	RoudingMethod =
	(	case	PPrA.RoundingMethod
			when 'U' then 1
			when 'D' then -1
			else 0
		end),
	StandardPack = PPrA.StandardPack
from	#WkNMPS
	join FT.vwPPrA PPrA on #WkNMPS.Part = PPrA.Part

--	<Debug>
if @Debug & 1 = 1
	print	'Weekly calculated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>

--	<Debug>
if @Debug & 8 = 8
begin
	if @Debug & 1 = 1
		print	'Create new PO Schedule skipped.'
end
else
begin
	--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'Create new PO Schedule..'
		select	@StartDT = GetDate ()
	end
	--	</Debug>
	--	VIII.	Create New PO Schedule.
	execute	@ProcResult = FT.csp_CreatePOSched
		@Debug = @Debug

	select	@Error = @@Error

	if @ProcResult != 0 or @Error != 0
	begin
	--	<Debug>
		if @Debug & 1 = 1
		begin
			print	'!!!!Create PO Sched failed.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
			print	'!!!!Proc Result.   ' + Convert (varchar, @ProcResult)
			print	'!!!!Error Code.   ' + Convert (varchar, @Error)
		end
	--	</Debug>
	--	<Tran>
		rollback transaction AutoPOGenA
	--	</Tran>
		return -1
	end
	--	<Debug>
	if @Debug & 1 = 1
		print	'PO Sched created.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
	--	</Debug>
end


--	IX.	Store NetMPS.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Store NetMPS..'
	select	@StartDT = GetDate ()
end
--	</Debug>

if	Object_ID ('FT.NetMPS_New') is not null begin
	drop table FT.NetMPS_New
end

create table FT.NetMPS_New
(	ID integer primary key,
	OrderNo integer default (-1) not null,
	LineID integer not null,
	Part varchar (25) not null,
	RequiredDT DateTime default (GetDate ()) not null,
	Balance numeric (30,12) not null,
	OnHandQty numeric (30,12) default (0) not null,
	WIPQty numeric (30,12) default (0) not null,
	LowLevel integer not null,
	Sequence integer not null)

insert	FT.NetMPS_New
select	*
from	#NetMPS

if	Object_ID ('FT.NetMPS') is not null begin
	execute	sp_rename
		'FT.NetMPS',
		'NetMPS_Old'
end

execute	sp_rename
	'FT.NetMPS_New',
	'NetMPS'

if	Object_ID ('FT.NetMPS_Old') is not null begin
	drop table FT.NetMPS_Old
end

create index idx_NetMPS_1 on FT.NetMPS (LowLevel, Part)
create index idx_NetMPS_2 on FT.NetMPS (Part, RequiredDT, Balance)

--	X.	Store inventory.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Store inventory..'
	select	@StartDT = GetDate ()
end
--	</Debug>

if	Object_ID ('FT.Inventory_New') is not null begin
	drop table FT.Inventory_New
end

create table FT.Inventory_New
(	ID integer identity primary key,
	Part varchar (25) not null,
	Location varchar (10) null,
	OnHand numeric (20,6) null)

insert	FT.Inventory_New
(	Part,
	Location,
	OnHand)
select	Part,
	Location,
	OnHand
from	#Inventory

if	Object_ID ('FT.Inventory') is not null begin
	execute	sp_rename
		'FT.Inventory',
		'Inventory_Old'
end

execute	sp_rename
	'FT.Inventory_New',
	'Inventory'

if	Object_ID ('FT.Inventory_Old') is not null begin
	drop table FT.Inventory_Old
end

--	XI.	Store inventory allocation.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Store inventory allocation..'
	select	@StartDT = GetDate ()
end
--	</Debug>

if	Object_ID ('FT.InventoryAllocation_New') is not null begin
	drop table FT.InventoryAllocation_New
end

create table FT.InventoryAllocation_New
(	ID integer identity primary key,
	Part varchar (25),
	OnhandQty numeric (20,6),
	OrderNo integer,
	LineID integer,
	Sequence integer,
	WIPQty numeric (30,12))

insert	FT.InventoryAllocation_New
(	Part,
	OnhandQty,
	OrderNo,
	LineID,
	Sequence,
	WIPQty)
select	Part,
	OnhandQty,
	OrderNo,
	LineID,
	Sequence,
	WIPQty
from	#X

/*select	*
from	FT.InventoryAllocation_New*/

if	Object_ID ('FT.InventoryAllocation') is not null begin
	execute	sp_rename
		'FT.InventoryAllocation',
		'InventoryAllocation_Old'
end

execute	sp_rename
	'FT.InventoryAllocation_New',
	'InventoryAllocation'

if	Object_ID ('FT.InventoryAllocation_Old') is not null begin
	drop table FT.InventoryAllocation_Old
end

create index idx_InventoryAllocation_1 on FT.InventoryAllocation (OrderNo, LineID, Sequence)

--	XII.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert (varchar, DateDiff (ms, @ProcStartDT, GetDate ())) + ' ms'
end
--</Debug>
GO
