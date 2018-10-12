SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [eeiuser].[acctg_inventory_reconciliation_summary]
(	@Begindate datetime,
	@Throughdate datetime,
	@Ledger varchar(15))
as

Begin
/*
execute	[EEIUser].[acctg_inventory_reconciliation_summary]
	@BeginDate = '2009-04-01',
	@ThroughDate = '2009-04-02',
	@Ledger = 'HONDURAS'
*/
set nocount on
declare	@AdjBeginDT datetime,
		@AdjEndDT datetime,
		@ATBeginDate datetime,
		@ATEndDate datetime		

--	Get the adjusted beginning date and ending date from snapshots in part historical daily.

set	@ATBeginDate =
	(	select	dateadd(dd,1,ft.fn_truncdate('dd',max (time_stamp)))
		from		part_historical_daily
		where	time_stamp <= @BeginDate)

set	@ATEndDate =
	(	select	dateadd(dd,1,ft.fn_truncdate('dd',max (time_stamp)))
		from		part_historical_daily
		where	time_stamp < dateadd(dd,1,@Throughdate))

set	@AdjBeginDT =
	(	select	max (time_stamp)
		from		part_historical_daily
		where	time_stamp <= @BeginDate)

set	@AdjEndDT =
	(	select	max (time_stamp)
		from		part_historical_daily
		where	time_stamp <= dateadd (ms, -2, @Throughdate + 1))



/*Select	@ATBeginDate as ATBeginDate
Select	@ATEndDate  as ATEndDate
Select	@AdjBeginDT  as AdjBeginDT
Select	@AdjEndDT as AdjEndDT*/

-- Get Object Snapshot Data

Create	table #PartInventoryA (	Part			varchar(25),
							DayofYear	int,
							time_stamp	datetime,
							Qty			numeric(20,6) Primary Key (Part, time_stamp))

Create	table #PartInventoryB (	Part			varchar(25),
							DayofYear	int,
							time_stamp	datetime,
							Qty			numeric(20,6) Primary Key (Part, time_stamp))

Insert	#PartInventoryA
Select	part,
		datepart(dy,time_stamp),
		time_stamp,
		isNull(sum(std_quantity),0)
from		object_historical_daily ohd
--(index = _dta_index_object_historical_daily_12_399444597__K1_K6_K19 )
where	part != 'PALLET' and
		ohd.reason = 'Daily'	and 
		isNULL(ohd.user_defined_status, 'XXX') !=  'PRESTOCK' and
		ohd.time_stamp>= @AdjBeginDT and
		ohd.time_stamp<= @AdjEndDT
group by	part,
		time_stamp

Insert	#PartInventoryB
Select	part,
		datepart(dy,time_stamp),
		time_stamp,
		isNull(sum(std_quantity),0)
from		object_historical_daily ohd
--(index = _dta_index_object_historical_daily_12_399444597__K1_K6_K19 )
where	part != 'PALLET' and
		ohd.reason = 'Daily'	and 
		isNULL(ohd.user_defined_status, 'XXX') !=  'PRESTOCK' and
		ohd.time_stamp>= @AdjBeginDT and
		ohd.time_stamp<= @AdjEndDT
group by	part,
		time_stamp
		

Create	table #PartsWithActivity (part varchar(25), Primary key (part))
Insert	#PartsWithActivity
Select	distinct part
from		audit_trail
(index = idx_audit_trail_date_type_part_std_quantity)
where	date_stamp>= @AdjBeginDT and
		date_stamp<=  @AdjEndDT and
		audit_trail.type not in ('B','C','T','Z','G','H','P')
Union
Select	COALESCE(a.part,b.part)
from		#PartInventoryA a join
		#PartInventoryB b on a.part = b.part and a.DayofYear+1 = b.DayofYear and a.qty<>b.qty

--Get Inventory to compare day over day

Create table #inventory (	DateStamp	datetime,
						Part			varchar(25),
						Inventory		numeric(20,6),
						NextInventory	numeric(20,6)	)

Insert	#inventory
Select	dateadd(dd,1,ft.fn_truncdate('dd', a.time_stamp)),
		COALESCE(a.part,b.part),
		isNull(a.qty,0),
		isNull(b.qty,0)
from		#PartInventoryA a join
		#PartInventoryB b on a.part = b.part and a.DayofYear+1 = b.DayofYear

							

Create  table #PartSetupDailyA
(	Part varchar (25),
	DayofYear int,
	SnapShotDT datetime,
	BeginType char (1) null,
	EndType char (1) null,
	BeginProductLine varchar (25) null,
	EndProductLine varchar (25) null,
	BeginCostCUM numeric (20,6) null,
	EndCostCUM numeric (20,6) null,
	BeginMaterialCUM numeric (20,6) null,
	EndMaterialCUM numeric (20,6) null,
	BeginLaborCUM numeric (20,6) null,
	EndLaborCUM numeric (20,6) null,
	BeginBurdenCUM numeric (20,6) null,
	EndBurdenCUM numeric (20,6) null,
	primary key (Part, SnapShotDT))


Create  table #PartSetupDailyB
(	Part varchar (25),
	DayofYear int,
	SnapShotDT datetime,
	BeginType char (1) null,
	EndType char (1) null,
	BeginProductLine varchar (25) null,
	EndProductLine varchar (25) null,
	BeginCostCUM numeric (20,6) null,
	EndCostCUM numeric (20,6) null,
	BeginMaterialCUM numeric (20,6) null,
	EndMaterialCUM numeric (20,6) null,
	BeginLaborCUM numeric (20,6) null,
	EndLaborCUM numeric (20,6) null,
	BeginBurdenCUM numeric (20,6) null,
	EndBurdenCUM numeric (20,6) null,
	primary key (Part, SnapShotDT))

Insert	#PartSetupDailyA
Select	part_historical_daily.Part,
		datepart(dy, part_historical_daily.time_stamp),
		part_historical_daily.time_stamp,
		type,
		NULL,
		product_line,
		NULL,
		cost_cum,
		NULL,
		material_cum,
		NULL,
		labor_cum,
		NULL,
		burden_cum,
		NULL
from		#PartsWithActivity PartswithActivity
join		part_historical_daily on part_historical_daily.part = PartswithActivity.part
join		part_standard_historical_daily on part_historical_daily.part = part_standard_historical_daily.part and part_historical_daily.time_stamp = part_standard_historical_daily.time_stamp
where	part_historical_daily.time_stamp>= @AdjBeginDT and
		part_historical_daily.time_stamp<=@AdjEndDT

Insert	#PartSetupDailyB
Select	part_historical_daily.Part,
		datepart(dy, part_historical_daily.time_stamp),
		part_historical_daily.time_stamp,
		NULL,
		type,
		NULL,
		product_line,
		NULL,
		cost_cum,
		NULL,
		material_cum,
		NULL,
		labor_cum,
		NULL,
		burden_cum
from		#PartsWithActivity PartswithActivity
join		part_historical_daily on part_historical_daily.part = PartswithActivity.part
join		part_standard_historical_daily on part_historical_daily.part = part_standard_historical_daily.part and part_historical_daily.time_stamp = part_standard_historical_daily.time_stamp
where	part_historical_daily.time_stamp>= @AdjBeginDT and
		part_historical_daily.time_stamp<=@AdjEndDT

update	A
set		A.EndType = B.EndType,
		A.EndProductLine = B.EndProductLine,
		A.EndCostCum = B.EndCostCum,
		A.EndMaterialCUM = B.EndMaterialCUM,
		A.EndLaborCUM = B.EndLaborCUM,
		A.EndBurdenCUM = B.EndBurdenCUM
from		#PartSetupDailyA A
join		#PartSetupDailyB B on A.part = B.part and A.DayofYear+1 = B.DayofYear

Create table #DailyAuditTrailbyPart (	TransDate	datetime,
								part varchar(25),
								StdQty numeric(20,6) Primary Key (TransDate, Part))
Insert	#DailyAuditTrailbyPart
select	ft.fn_truncdate('dd', date_stamp),
		audit_trail.part,
		SUM(( CASE WHEN type in ('D','M','Q','S','V','E') THEN -1*std_quantity ELSE std_quantity END))
from		audit_trail
(index = idx_audit_trail_date_type_part_std_quantity)
join		#PartsWithActivity PWA on audit_trail.part = pwa.part
where	date_stamp>= @AdjBeginDT and
		date_stamp<=  @AdjEndDT and
	(
		(audit_trail.type not in ('B','C','T','Z','G','H','P'))
		and
		(audit_trail.type != 'Q' or audit_trail.to_loc = 'S')
		and 
		(audit_trail.type != 'D' or audit_trail.remarks not like 'Scrap%')
	)

group by ft.fn_truncdate('dd', date_stamp),
		audit_trail.part
	
								


Select	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT)) as DateA, 
		A.Part,
		A.SnapShotDT,
		BeginType,
		EndType,
		BeginProductLine,
		EndProductLine,
		BeginCostCUM,
		EndCostCUM,
		BeginMaterialCUM,
		EndMaterialCUM,
		BeginLaborCUM,
		EndLaborCUM,
		BeginBurdenCUM,
		EndBurdenCUM,
		isNull(StdQty,0) as AuditTrailStdQty,
		isNull(Inventory,0) as StartingInventory,
		isNull(NextInventory,0) as EndingInventory
		
from		#PartSetupDailyA A
left join	#DailyAuditTrailbyPart B on A.part = B.part and 	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT))=TransDate
left join	#inventory C on A.part = C.part and 	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT)) = DateStamp
Where	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT))<= @Throughdate and
		(	BeginType!=EndType or 
			BeginProductLine!=	EndProductLine or
			BeginCostCUM!=EndCostCUM or
			BeginMaterialCUM!=EndMaterialCUM or
			BeginLaborCUM!=EndLaborCUM or
			BeginBurdenCUM!=	EndBurdenCUM or
			isNull(StdQty,0)!=(isNull(NextInventory,0)-isNull(Inventory,0))
		)
order by	2,1


/*Select	*
from		#DailyAuditTrailbyPart

Select	*
from		#inventory*/




End

GO
