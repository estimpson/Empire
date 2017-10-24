SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [FT].[csp_AutoPOGennoXRtRebuild]
--	<Debug>
(	@Debug integer = 0 )
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
execute	FT.csp_AutoPOGen
--<Debug>
	@Debug = 1
--</Debug>
commit

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
--	IX.	Finished
*/
set nocount on

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ( )
	select	@ProcStartDT = GetDate ( )
	print	'AutoPOGen START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

create table #NetMPS
(	ID integer identity primary key,
	OrderNo integer default (-1) not null,
	LineID integer not null,
	Part varchar (25) not null,
	RequiredDT DateTime default (GetDate ( )) not null,
	Balance numeric (30,12) not null,
	OnHandQty numeric (30,12) default (0) not null,
	WIPQty numeric (30,12) default (0) not null,
	LowLevel integer not null,
	Sequence integer not null )

create index idx_#NetMPS_1 on #NetMPS ( LowLevel, Part )
create index idx_#NetMPS_2 on #NetMPS ( Part, RequiredDT, Balance )

create table #OnHand
(	Part varchar (25),
	OnHand numeric (30,12),
	LowLevel integer )

create index idx_#OnHand_1 on #OnHand ( LowLevel, Part, OnHand )

create table #X
(	OrderNo integer,
	LineID integer,
	Sequence integer,
	WIPQty numeric (30,12) )

create index idx_#X_1 on #X ( OrderNo, LineID, Sequence )

create table #WkNMPS
(	Part varchar (25),
	WeekNo integer,
	Balance numeric (30,12 ) )

create index idx_#WkNMPS_1 on #WkNMPS ( Part, WeekNo, Balance )

--	<Tran>
if @@TranCount = 0
	begin transaction AutoPOGenA
save transaction AutoPOGenA
--	</Tran>

--	Declarations.
declare	@ProcResult integer,
	@Error integer

--	I.	Populate Expanded Router Temporary Datastructure.
--	Expand part routers on all parts with current sales orders.
--	<Debug>
--if @Debug & 1 = 1
--	print	'Regenerate XRt..'
----	</Debug>
--execute	@ProcResult = FT.ftsp_RebuildXRt
--	@Debug = @Debug
--
--select	@Error = @@Error
--
--if @ProcResult != 0 or @Error != 0
--begin
----	<Debug>
--	if @Debug & 1 = 1
--	begin
--		print	'!!!!Regenerate failed.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--		print	'!!!!Proc Result.   ' + Convert ( varchar, @ProcResult )
--		print	'!!!!Error Code.   ' + Convert ( varchar, @Error )
--	end
----	</Debug>
----	<Tran>
--	rollback transaction AutoPOGenA
----	</Tran>
--	return -1
--end
--
----	<Debug>
--if @Debug & 1 = 1
--	print	'XRt regenerated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
----	</Debug>
--
----	<Debug>
--if @Debug & 1 = 1
--begin
--	print	'Build MPS..'
--	select	@StartDT = GetDate ( )
--end
--	</Debug>
--	II.	Populate Demand Temporary Datastructure.
--	Demand generated from sales order requirements and minimum on hand
--	quantities in conjunction with expanded part routers.
insert	#NetMPS
(	LineID,
	Part,
	RequiredDT,
	Balance,
	LowLevel,
	Sequence )
select	LineID =
	(	select	min ( ID )
		from	FT.XRt
		where	TopPart = POH.Part ),
	Part = XRt.ChildPart,
	RequiredDT = DateAdd ( day, -XBufferTime, GetDate ( ) ),
	Balance = MinOnHand * XQty,
	LowLevel =
	(	select	max ( XRT1.BOMLevel )
		from	FT.XRt XRT1
		where	XRT1.ChildPart = XRt.ChildPart ),
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
	Sequence )
select	OrderNo,
	LineID,
	Part = XRt.ChildPart,
	RequiredDT = DateAdd ( day, -XBufferTime, ShipDT ),
	Balance = StdQty * XQty,
	LowLevel =
	(	select	max ( XRT1.BOMLevel )
		from	FT.XRt XRT1
		where	XRT1.ChildPart = XRt.ChildPart ),
	Sequence
from	FT.vwSOD SOD
	join FT.XRt XRt on SOD.Part = XRt.TopPart

--	<Debug>
if @Debug & 1 = 1
	print	'MPS built.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	III.	Populate On Hand Temporary Datastructure.
insert	#OnHand
(	Part,
	OnHand,
	LowLevel )
select	vwPOH.Part,
	max ( vwPOH.OnHand ),
	max ( #NetMPS.LowLevel )
from	FT.vwPOH vwPOH
	join #NetMPS on vwPOH.Part = #NetMPS.Part
where	vwPOH.OnHand > 0
group by
	vwPOH.Part

--	IV.	Temporary Datastructure Used to Assign WIP On Hand.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Netout..'
	select	@StartDT = GetDate ( )
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
		print	'!!!!Netout failed.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
		print	'!!!!Proc Result.   ' + Convert ( varchar, @ProcResult )
		print	'!!!!Error Code.   ' + Convert ( varchar, @Error )
	end
--	</Debug>
--	<Tran>
	rollback transaction AutoPOGenA
--	</Tran>
	return -1
end
--	<Debug>
if @Debug & 1 = 1
	print	'Netted.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	VI.	Consolidate Temporary Weekly Netout.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Calc weekly Net..'
	select	@StartDT = GetDate ( )
end
--	</Debug>
insert	#WkNMPS
(	Part,
	WeekNo,
	Balance )
select	Part,
	0,
	Sum ( Balance )
from	#NetMPS
where	DateDiff ( week, GetDate ( ), RequiredDT ) <= 0
group by
	Part
union all
select	Part,
	DateDiff ( week, GetDate ( ), RequiredDT ),
	Sum ( Balance )
from	#NetMPS
where	DateDiff ( week, GetDate ( ), RequiredDT ) > 0
group by
	Part,
	DateDiff ( week, GetDate ( ), RequiredDT )
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
	StandardPack )
select	#WkNMPS.Part,
	WeekNo,
	PONumber = PPrA.DefaultPO,
	PriorDemandAccum = IsNull (
	(	select	Sum ( WkNMPS1.Balance )
		from	#WkNMPS WkNMPS1
		where	WkNMPS1.Part = #WkNMPS.Part and
			WkNMPS1.WeekNo < #WkNMPS.WeekNo ), 0 ),
	PostDemandAccum = IsNull (
	(	select	Sum ( WkNMPS1.Balance )
		from	#WkNMPS WkNMPS1
		where	WkNMPS1.Part = #WkNMPS.Part and
			WkNMPS1.WeekNo <= #WkNMPS.WeekNo ), 0 ),
	DeliveryDW = convert ( integer, PPrA.DeliveryDW ),
	FrozenWeeks = PPrA.FrozenWeeks,
	RoudingMethod =
	(	case	PPrA.RoundingMethod
			when 'U' then 1
			when 'D' then -1
			else 0
		end ),
	StandardPack = PPrA.StandardPack
from	#WkNMPS
	join FT.vwPPrA PPrA on #WkNMPS.Part = PPrA.Part

--	<Debug>
if @Debug & 1 = 1
	print	'Weekly calculated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	<Debug>
if @Debug & 4 = 4
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
		select	@StartDT = GetDate ( )
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
			print	'!!!!Create PO Sched failed.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
			print	'!!!!Proc Result.   ' + Convert ( varchar, @ProcResult )
			print	'!!!!Error Code.   ' + Convert ( varchar, @Error )
		end
	--	</Debug>
	--	<Tran>
		rollback transaction AutoPOGenA
	--	</Tran>
		return -1
	end
	--	<Debug>
	if @Debug & 1 = 1
		print	'PO Sched created.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
	--	</Debug>
end

--	IX.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>


GO
