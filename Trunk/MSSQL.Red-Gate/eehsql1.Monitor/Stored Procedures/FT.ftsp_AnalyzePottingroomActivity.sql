SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_AnalyzePottingroomActivity]
(	@BasePart char (7),
	@BeginDT datetime,
	@EndDT datetime)
as
/*
execute	Monitor.FT.ftsp_AnalyzePottingRoomActivity
	@BasePart = 'AUT0047',
	@BeginDT = '2008-07-22 20:30',
	@EndDT = '2008-07-26'

*/
declare	@PottingTrans table
(	ID int identity primary key,
	HourlyBucket datetime,
	Machine varchar (10),
	Loaded int,
	Unloaded int,
	TotalLoaded int,
	Completed int,
	TotalCompleted int,
	Balance int,
	ReportedLost int,
	LostReturned int,
	unique
	(	Machine,
		HourlyBucket))

insert	@PottingTrans
(	HourlyBucket,
	Machine)
select	*
from	EEH.FT.fn_Calendar(@BeginDT, @EndDT, 'hour', 1, null) Hours
	cross join
	(	select distinct
			Machine = location.group_no
		from	audit_trail
			join location on to_loc = location.code
		where	audit_trail.type = 'T' and
			date_stamp between @BeginDT and @EndDT and
			part like 'PRE-' + @BasePart + '%' and
			to_loc in (select machine_no from machine) and
			to_loc not like 'LOST%') Machines
order by
	Machine,
	EntryDT

update	@PottingTrans
set	Loaded = coalesce (
	(	select	sum (Transfer.std_quantity + coalesce (UndoJC.std_quantity, 0))
		from	audit_trail Transfer
			join location on Transfer.to_loc = location.code
			left join audit_trail UndoJC on Transfer.serial = UndoJC.serial and UndoJC.type = 'J' and UndoJC.std_quantity < 0
		where	Transfer.type = 'T' and
			Transfer.date_stamp between HourlyBucket and dateadd (hour, 1, HourlyBucket) and
			Transfer.part like 'PRE-' + @BasePart + '%' and
			location.group_no = Machine), 0),
	Unloaded = coalesce (
	(	select	sum (std_quantity)
		from	audit_trail
			join location on from_loc = location.code
		where	audit_trail.type = 'T' and
			date_stamp between HourlyBucket and dateadd (hour, 1, HourlyBucket) and
			part like 'PRE-' + @BasePart + '%' and
			to_loc != 'LOST-POT' and
			location.group_no = Machine and
			(select group_no from location where from_loc = code) != Machine), 0),
--	TotalLoaded = coalesce (
--	(	select	sum (Transfer.std_quantity + coalesce (UndoJC.std_quantity, 0))
--		from	audit_trail Transfer
--			join location on Transfer.to_loc = location.code
--			left join audit_trail UndoJC on Transfer.serial = UndoJC.serial and UndoJC.type = 'J' and UndoJC.std_quantity < 0
--		where	Transfer.type = 'T' and
--			Transfer.date_stamp between @BeginDT and dateadd (hour, 1, HourlyBucket) and
--			Transfer.part like 'PRE-' + @BasePart + '%' and
--			location.group_no = Machine), 0) - coalesce (
--	(	select	sum (std_quantity)
--		from	audit_trail
--			join location on from_loc = location.code
--		where	audit_trail.type = 'T' and
--			date_stamp between @BeginDT and dateadd (hour, 1, HourlyBucket) and
--			part like 'PRE-' + @BasePart + '%' and
--			to_loc != 'LOST-POT' and
--			location.group_no = Machine and
--			(select group_no from location where from_loc = code) != Machine), 0),
	Completed = coalesce (
	(	select	sum (std_quantity)
		from	audit_trail
		where	type = 'J' and
			date_stamp between HourlyBucket and dateadd (hour, 1, HourlyBucket) and
			part like 'POT-' + @BasePart + '%' and
			from_loc = Machine), 0),
--	TotalCompleted = coalesce (
--	(	select	sum (std_quantity)
--		from	audit_trail
--		where	type = 'J' and
--			date_stamp between @BeginDT and dateadd (hour, 1, HourlyBucket) and
--			part like 'POT-' + @BasePart + '%' and
--			from_loc = Machine), 0),
	ReportedLost = coalesce (
	(	select	sum (std_quantity)
		from	audit_trail
			join location on from_loc = location.code
		where	audit_trail.type = 'T' and
			date_stamp between HourlyBucket and dateadd (hour, 1, HourlyBucket) and
			part like 'PRE-' + @BasePart + '%' and
			to_loc = 'LOST-POT' and
			location.group_no = Machine), 0),
	LostReturned = coalesce (
	(	select	sum (std_quantity)
		from	audit_trail
			join location on from_loc = location.code
		where	audit_trail.type = 'T' and
			date_stamp between HourlyBucket and dateadd (hour, 1, HourlyBucket) and
			part like 'PRE-' + @BasePart + '%' and
			from_loc = 'LOST-POT' and
			location.group_no = Machine), 0)

update	@PottingTrans
set	TotalLoaded = (select sum (Loaded) - sum (Unloaded) from @PottingTrans where Machine = PottingTrans.Machine and HourlyBucket <= PottingTrans.HourlyBucket),
	TotalCompleted = (select sum (Completed) from @PottingTrans where Machine = PottingTrans.Machine and HourlyBucket <= PottingTrans.HourlyBucket)
from	@PottingTrans PottingTrans

update	@PottingTrans
set	Balance = TotalLoaded - TotalCompleted

select	*
from	@PottingTrans

/*
select	LoadTime = ft.fn_TruncDate('hour', min (date_stamp)),
	FromLOC = from_loc,
	ToLOC = to_loc,
	QtyTransfer = sum (std_quantity)
from	audit_trail
where	type = 'T' and
	date_stamp between @BeginDT and @EndDT and
	part like 'PRE-' + @BasePart + '%' and
	to_loc in (select machine_no from machine)
group by
	from_loc,
	to_loc,
	datepart (hour, date_stamp)
order by
	1, 2, 3
*/
GO
