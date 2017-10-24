SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_inventory_reconciliation_summary_all]
(	@Begindate datetime,
	@Throughdate datetime,
	@Ledger varchar(15),
	@PartType char(1),
	@Account varchar(10) )
as

Begin
/*
execute	[EEIUser].[acctg_inventory_reconciliation_summary_all]
	@BeginDate = '2009-05-28',
	@ThroughDate = '2009-05-28',
	@Ledger = 'EEI',
	@PartType =  'R',
	@Account = '151011'
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
Select	*
from		#PartInventoryA
		

Create	table #PartsWithActivity (part varchar(25), Primary key (part))
Insert	#PartsWithActivity
Select	distinct part
from		audit_trail
--WITH (INDEX(idx_audit_trail_date_type_part_std_quantity))
where	date_stamp>= @AdjBeginDT and
		date_stamp<=  @AdjEndDT and
		part != 'PALLET' and
		std_quantity != 0 and
		audit_trail.type not in ('B','C','T','Z','G','H','P')
Union
Select	COALESCE(a.part,b.part)
from	#PartInventoryA a full join
		#PartInventoryB b on a.part = b.part and a.DayofYear+1 = b.DayofYear and a.qty<>b.qty
				

Create  table #PartSetupDailyA
(	Part varchar (25),
	DayofYear int,
	SnapShotDT datetime,
	NextSnapShotDT datetime,
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
	NextSnapShotDT datetime,
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
		A.EndBurdenCUM = B.EndBurdenCUM,
		A.NextSnapShotDT = B.SnapShotDT
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
--WITH (INDEX(idx_audit_trail_date_type_part_std_quantity))
join		#PartsWithActivity PWA on audit_trail.part = pwa.part
where	date_stamp>= @AdjBeginDT and
		date_stamp<=  @AdjEndDT and
	(
		audit_trail.part != 'PALLET' and
		std_quantity != 0 and
		audit_trail.type not in ('B','C','T','Z','G','H','P')
		and
		(audit_trail.type != 'Q' or audit_trail.to_loc = 'S')
		and 
		(audit_trail.type != 'D' or audit_trail.remarks not like 'Scrap%')
	)

group by ft.fn_truncdate('dd', date_stamp),
		audit_trail.part

Create table #DailyAuditTrailDetail (	serial int,
								TransDate	datetime,
								part varchar(25),
								StdQty numeric(20,6) Primary Key (serial, TransDate))
Insert	#DailyAuditTrailDetail
select	serial,
		date_stamp,
		audit_trail.part,
		( CASE WHEN type in ('D','M','Q','S','V','E') THEN -1*std_quantity ELSE std_quantity END)
from		audit_trail
--WITH (INDEX(idx_audit_trail_date_type_part_std_quantity))
join		#PartsWithActivity PWA on audit_trail.part = pwa.part
where	date_stamp>= @AdjBeginDT and
		date_stamp<=  @AdjEndDT and
		(
		audit_trail.part != 'PALLET' and
		std_quantity != 0 and
		audit_trail.type not in ('B','C','T','Z','G','H','P')
		and
		(audit_trail.type != 'Q' or audit_trail.to_loc = 'S')
		and 
		(audit_trail.type != 'D' or audit_trail.remarks not like 'Scrap%')
	)

Create table #BetweenSnapShotsAuditTrailbyPart (	BeginTransDate	datetime,
											NextTransDate	datetime,
											BSSpart varchar(25),
											BSSStdQty numeric(20,6) Primary Key (BeginTransDate, NextTransdate, BSSpart))
insert	#BetweenSnapShotsAuditTrailbyPart
select	b.SnapShotDT,
		b.NextSnapShotDT,
		a.part,
		SUM(StdQty)
From	#DailyAuditTrailDetail a
Join		 #PartSetupDailyA b on a.part = b.part and  a.TransDate between b.SnapShotDT and b.NextSnapShotDT 
join		#PartsWithActivity PWA on a.part = pwa.part

group by b.SnapShotDT,
		b.NextSnapShotDT,
		a.part
								

Create table #PartCalendar (		Part			varchar(25),
							DateStamp	datetime,
							time_stamp1	datetime,
							time_stamp2  datetime,
							 Primary key	(Part, DateStamp)	)

Insert	#PartCalendar
Select	a.part,
		ft.fn_truncdate('dd', dateadd(dd,1,b.SnapshotDT)),
		b.SnapShotDT,
		b.NextSnapShotDT
from		#PartsWithActivity a  cross join
		(	Select distinct SnapShotDT, NextSnapShotDT from #PartSetupDailyA ) b
where	ft.fn_truncdate('dd', dateadd(dd,1,b.SnapshotDT))<= @Throughdate 

--Get GL Cost Transactions for Period


Create table #GLTransactions (	Account		varchar(25),
							DateStamp	datetime,
							GLpart		varchar(25),
							GLExtended	numeric(20,6),
							 Primary key	(Account, DateStamp, GLPart)	)
Insert	#GLTransactions
SELECT	gl_cost_transactions.ledger_account, 
		gl_cost_transactions.transaction_date, 
		document_reference1, 
		Sum(gl_cost_transactions.amount) AS 'Sum of amount'
FROM	dbo.gl_cost_transactions gl_cost_transactions
WHERE	gl_cost_transactions.ledger_account= @Account and

		--gl_cost_transactions.fiscal_year='2009' AND
		gl_cost_transactions.transaction_date>=@Begindate  And
		gl_cost_transactions.transaction_date<=@ThroughDate  AND 
		gl_cost_transactions.update_balances='Y'
GROUP BY	gl_cost_transactions.ledger_account, 
			gl_cost_transactions.transaction_date, 
			document_reference1


Select	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT)) as DateA,
		Account, 
		A.Part,
		A.SnapShotDT,
		A.NextSnapShotDT,
		BeginType,
		EndType,
		BeginProductLine,
		EndProductLine,
		isNull(BeginCostCUM,0) as BeginCostCUM,
		isNull(EndCostCUM,0) as EndCostCUM,
		isNull(BeginMaterialCUM,0) as BeginMaterialCUM,
		isNull(EndMaterialCUM,0)as EndMaterialCUM,
		isNull(BeginLaborCUM,0)as BeginLaborCUM,
		isNull(EndLaborCUM,0)as EndLaborCUM,
		isNull(BeginBurdenCUM,0)as BeginBurdenCUM,
		isNull(EndBurdenCUM,0) as EndBurdenCUM,
		isNull(C.Qty,0) as StartingInventory,
		isNull(D.Qty,0) as EndingInventory,
		(isNull(D.Qty,0)-isNull(C.Qty,0)) as SnapShotDelta,
		isNull(StdQty,0) as DailyAuditTrailStdQty,
		isNull(BSSStdQty,0) as ATBetweenSnapShotQty,		
		isNull(GLExtended,0) as GLExtended,
		isNull(StdQty,0)*isNull(BeginCostCUM,0) as ATExtendedBeginCostCUM,
		isNull(StdQty,0)*isNull(EndCostCUM,0) as ATExtendedEndCostCUM,
		(isNull(D.Qty,0)-isNull(C.Qty,0))*isNull(BeginCostCUM,0) as SnapShotDeltaExtendedBeginCostCUM,
		(isNull(D.Qty,0)-isNull(C.Qty,0))*isNull(EndCostCUM,0) as SnapShotDeltaExtendedEndCostCUM
from		#PartCalendar PC
join		part on PC.part = part.part 
left join	#PartSetupDailyA A on PC.part = A.Part and time_stamp1 = SnapShotDT and time_stamp2 = NextSnapShotDT
left join	#GLTransactions GLtrans on PC.part = GLtrans.GLPart and ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT)) = GLtrans.DateStamp
left join	#BetweenSnapShotsAuditTrailbyPart BSS on A.Part = BSSPart and SnapShotDT = BeginTransDate and NextSnapShotDT = NextTransDate
left join	#DailyAuditTrailbyPart B on A.part = B.part and ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT))=TransDate
left join	#PartinventoryA C on A.part = C.part and SnapShotDT = C.time_stamp
left join	#PartinventoryA D on A.part = D.part and NextSnapShotDT = D.time_stamp
Where	ft.fn_truncdate('dd', dateadd(dd,1,SnapshotDT))<= @Throughdate and
		COALESCE(BeginType,EndType,part.type) = @PartType /*and
		(	BeginType!=EndType or 
			BeginProductLine!=	EndProductLine or
			BeginCostCUM!=EndCostCUM or
			BeginMaterialCUM!=EndMaterialCUM or
			BeginLaborCUM!=EndLaborCUM or
			BeginBurdenCUM!=	EndBurdenCUM or
			round(isNull(BSSStdQty,0),0)!=round((isNull(D.Qty,0)-isNull(C.Qty,0)),0) or
			abs((round(isNull(StdQty,0)*isNull(EndCostCUM,0) ,0)-round(isNull(GLExtended,0),0)))>1
		)*/
order by	3,4


/*Select	*
from		#PartSetupDailyA
order by 1

Select	*
from		#PartCalendar PC

Select	*
from		#PartInventoryA*/

End



GO
