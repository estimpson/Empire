SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE procedure [dbo].[eeisp_rpt_materials_daily_running_inventory_DaySpecified_BasePart_eeiInventoryOnly_test] (@EnteredDT datetime, @MaxAClass int, @MinAClass int, @MaxBClass int, @MinBClass int, @MaxCClass int, @MinCClass int, @POOffsetDays int)
       as
begin

--eeisp_rpt_materials_daily_running_inventory_DaySpecified_BasePart_eeiInventoryOnly_test '2010/8/27', 10, 5,15,10,25,15,0



-- Get first Day of the week and first day of the month
declare	@ThisSundayDT datetime; set @ThisSundayDT = FT.fn_TruncDate ('wk', getdate ())
declare	@FirstBucketDate datetime; set @FirstBucketDate = FT.fn_TruncDate ('mm', getdate ())

Create table #Buckets
(	BeginDT	datetime,
	EndDT	datetime, Primary key (BeginDT))

Insert		#Buckets
select		BeginDT = EntryDT,
			EndDT = EntryDT + 1
from			[dbo].[fn_Calendar_StartCurrentMonth] (Null,'dd',1,120)
where		EntryDT >= FT.fn_TruncDate('mm', getdate())

--Get Base Part Demand
create table #DailyPOReq 
(	POQty int not null,
	BasePart varchar (25) not null, 
	date_due datetime not null , primary key (Basepart, date_due))

insert #DailyPOReq

	Select		sum(Balance) as PoQty,
				LEFT(part_number,7),
				dateadd(dd,(ISNULL(@POOffsetDays,0))*-1,date_due) as date_due --This is to convert EEI delivery date to EEH ship date
		 from	po_detail
		 JOIN	part ON po_detail.part_number = part.part
		where	isNULL(balance,0)  >0 and
				date_due > dateadd(dd,-21, '2010-07-18') AND
				part.type = 'F' AND
				part.class != 'I'
		group by	LEFT(part_number,7),
					dateadd(dd,(ISNULL(@POOffsetDays,0))*-1,date_due) 
					
SELECT	* FROM #DailyPOReq WHERE BasePart = 'AUT0035'
					
--Get Base part Projected Inventory


create table #EEIProjectedInventory 
(	Qty int not null,
	Basepart varchar (25) not null, 
	ProjectedDT datetime not null , primary key (Basepart, ProjectedDT))

insert #EEIProjectedInventory 

	Select		sum(object.Quantity),
				LEFT(object.part,7),
				(CASE	WHEN datepart(d,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) = 6 
						THEN dateadd(dd,2,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) 
						WHEN datepart(d,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) = 1  
						THEN dateadd(dd,1,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp)))
						ELSE dateadd(dd,0,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp)))END)
		 from	audit_trail
		join	object on audit_trail.serial = object.serial
		where	audit_trail.type = 'R' and
				(object.location like '%TRAN%' or object.location  like '%AIR%') and
				date_stamp in ( Select max(date_stamp) from audit_trail where type = 'R' and date_stamp>= dateadd(dd, -30, getdate()) group by serial, type )
		group by	LEFT(object.part,7),
					(CASE	WHEN datepart(d,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) = 6 
						THEN dateadd(dd,2,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) 
						WHEN datepart(d,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp))) = 1  
						THEN dateadd(dd,1,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp)))
						ELSE dateadd(dd,0,FT.fn_TruncDate('dd', dateadd(dd,(CASE WHEN object.location like '%AIR%' THEN 1 ELSE 9 END),date_stamp)))END)
order by 3 asc

SELECT	* FROM #EEIProjectedInventory  WHERE Basepart = 'AUT0035'


create table #DailyShipReq
(	ShipQty int not null,
	Basepart varchar (25) not null, 
	RequirementDT datetime not null , primary key (BasePart, RequirementDT))

insert #DailyShipReq

Select			sum(DailyNoStdPack) as ShipQty,
				LEFT(part_number,7),
				(CASE WHEN RequirementDT < FT.fn_TruncDate('dd', getdate()) THEN FT.fn_TruncDate('dd', getdate()) ELSE RequirementDT END) RequirementDT
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null
		group by	LEFT(part_number,7),
				(CASE WHEN RequirementDT < FT.fn_TruncDate('dd', getdate()) THEN FT.fn_TruncDate('dd', getdate()) ELSE RequirementDT END) order by 2
SELECT	* FROM #DailyShipReq WHERE basepart = 'AUT0035'
create table #AvgWeeklyShipReqBasepart
(	AvgWeeklyShipQty int not null,
	BasePart varchar (25) not null primary key (BasePart))

insert #AvgWeeklyShipReqBAsePArt

Select			sum(DailyNoStdPack)/6 as AvgWeeklyShipQty,
				LEFT(part_number,7)
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null and
				RequirementDT <= dateadd(dd,42, FT.fn_TruncDate('dd', getdate())) 
		group by	LEFT(part_number,7)
SELECT	* FROM #AvgWeeklyShipReqBasepart WHERE BasePart = 'AUT0035'

create table #BasePartSetups
	
(	BasePart varchar (25) not null primary key ,
	CustomerPart varchar(50) NULL,
	Scheduler varchar(15) NULL,
	BasePartPrice numeric (20,6) not null,
	BasePartcost numeric (20,6) not null,
	SOP datetime NULL,
	EOP datetime NULL,
	CurrentRevLevel varchar(2) NULL,
	MinOnHand numeric(20,6) NULL,
	MaxOnHand numeric (20,6) NULL,
	BasePartStdPack numeric (20,6) not null,
	PartClassification char(1) Null
	)

insert #BasePartSetups

Select			LEFT(part_standard.part,7) as PSPart,
				max(customer_part) CustomerPart,
				max(UPPER(scheduler)) scheduler,				
				isNull(avg(price),0) as Price,
				ISNULL(avg(cost_cum),0) as Cost,
				max(part_eecustom.prod_start) as SOP,
				max(part_eecustom.prod_end) as EOP,
				max(CurrentRevLevel) as CurrentRevLevel,
				ISNULL(max((CASE WHEN isNULL(CurrentRevLevel, 'N') = 'Y' THEN min_onhand ELSE 0 END)),0) as MinOnHand,
				ISNULL(max((CASE WHEN isNULL(CurrentRevLevel, 'N') = 'Y' THEN max_onhand ELSE 0 END )),0) as MaxOnHand,				
				ISNULL(max(standard_pack),1) as StdPAck,
				MIN(ISNULL((CASE WHEN part.class NOT in ('P','M') THEN 'O' WHEN part_eecustom.ServicePart = 'Y' THEN 'S' ELSE 'A' END), 'X')) AS PartClass
	from		part_standard
	join		part_inventory on part_standard.part = part_inventory.part
	join		part on part_standard.part = part.part 
	join		part_online on part_standard.part = part_online.part
	LEFT join	part_eecustom on part_standard.part = part_eecustom.part AND CurrentRevLevel = 'Y'
	left join	part_customer on part_standard.part = part_customer.part
	left join	customer on part_customer.customer = customer.customer
	left join	destination on customer.customer = destination.customer 
	where		part.part not like '%[-]PT%' and 
				part.part not like '%[-]RW%' and
				part.part not like 'PT[-]%'  and
				part.part not like '%[-]FIX%'  and
				part.type = 'F' 
	group by	LEFT(part_standard.part,7)
	
	
create table #BasePartInventory
	
(	BasePart varchar (25) not null primary key ,
	Inventory numeric (20,6) null
	)
INSERT #BasePartInventory
SELECT	LEFT(part,7),
		SUM(quantity)
from	object 
left join	location on object.location = location.code 
WHERE ( isNULL(secured_location, 'N') != 'Y' or location not like '%LOST%' or location not like '%TRAN%' or  location not like '%AIR%')
GROUP BY LEFT(part,7)

          
	
create table #BasePartAllInventory
	
(	BasePart varchar (25) not null primary key ,
	AllInventory numeric (20,6) null
	)
INSERT #BasePartAllInventory
SELECT	LEFT(part,7),
		SUM(quantity)
from	object 
left join	location on object.location = location.code 
WHERE ( location not like '%TRAN%' or  location not like '%AIR%')
GROUP BY LEFT(part,7)


          

create table #BasePartExtended
(	BasePartQty numeric(20,6) not null,
	BasePartExtended numeric (20,6) not null,
	BasePart varchar (25),
	id	int identity not null, primary key (BasePart))

insert #BasePartExtended
		(	BasePartQty,
			BasePartExtended,
			BasePart)

Select	isNULL(AvgWeeklyShipQty,0),
		isNULL(AvgWeeklyShipQty*BasePartPrice,0),
		BPS.BasePart
				
from		#BasePartSetups BPS
left join	#AvgWeeklyShipReqBasePart AvgWeeklyShipReqBasePart on BPS.BasePart = AvgWeeklyShipReqBasePart.Basepart
order by 2 desc

create table #BasePartExtendedPercentage
(	
	BasePartQty numeric(20,6) not null,
	BasePartExtended numeric (20,6) not null,
	BasePart varchar (25),
	id int , 
	TotalAvgWeekWeeklySales numeric(20,6),
	PercentageofWeeklySales numeric(20,6) primary key (BasePart))

insert #BasePartExtendedPercentage
		(	BasePartQty,
			BasePartExtended,
			BasePart,
			id, 
			TotalAvgWeekWeeklySales,
			PercentageofWeeklySales )
Select	*,
		(Select sum(BasePartExtended) from #BasePartExtended) as Total,
		BAsePartExtended/(Select sum(BasePartExtended) from #BasePartExtended)*100 as Percentage
from		#BasePartExtended BasePartExtended




create table #BasePartExtendedRunningPercentage
(	BasePartQty numeric(20,6) not null,
	BasePartExtended numeric (20,6) ,
	DailyBasePartQty numeric (20,6),
	DailyBasePartExtended numeric (20,6),
	BasePart varchar (25) not Null,
	id int , 
	TotalAvgWeekWeeklySales numeric(20,6),
	PercentageofWeeklySales numeric(20,6),
	RunningPercent numeric(20,6), primary key (BasePart))

insert #BasePartExtendedRunningPercentage
		(	BasePartQty ,
			BasePartExtended,
			DailyBasePartQty,
			DailyBasePartExtended,
			BasePart,
			id, 
			TotalAvgWeekWeeklySales,
			PercentageofWeeklySales,
			RunningPercent  )
Select		BasePartQty,
			BasePartExtended,
			BasePartQty/5,
			BasePartExtended/5,
			BasePart,
			id, 
			TotalAvgWeekWeeklySales,
			PercentageofWeeklySales , (Select sum(PercentageofWeeklySales) from  #BasePartExtendedPercentage BP2 where BP2.id <=#BasePartExtendedPercentage.id )
 from		#BasePartExtendedPercentage
order by 2 DESC

Select * from  #BasePartExtendedRunningPercentage WHERE BasePart = 'AUT0035' order by 6 ASC
create table #DailyReq 
(	Basepart varchar (25) not null,
	PartClassification char(1) NULL,
	StdPack numeric(20,6) not null, 
	DateStamp datetime not null, 
	EndDate datetime  NULL,
	Inventory int not null, 
	AllInventory int not null,
	POBalance int not null,
	EEIProjectedInventory int null, 
	CustomerDemand int not null, 
	netchange as ( ISNULL(Inventory,0) + ISNULL(POBalance,0) + 0) - ISNULL(CustomerDemand,0), 
	netchangeallinv as ( ISNULL(AllInventory,0) + ISNULL(POBalance,0) + 0) - ISNULL(CustomerDemand,0),
	runningtotal int null,
	runningtotalall int null,
	BasePartrunningtotal int null,
	BasePartrunningtotalall int null,
	Scheduler varchar(25) null,
	CustomerPart varchar(25) null,
	Price numeric (20,6) Null,
	Cost	numeric(20,6),
	SOP datetime null,
	EOP datetime null,
	MinOnHand int null,
	MaxonHand int null,
	CurrentRevLevel  varchar(2) null, 
	StartingInventory numeric(20,6),
	StatringInventoryDollars numeric(20,6),
	AllStartingInventory numeric(20,6),
	AllStartingInventoryDollars numeric(20,6),
	AverageWeeklyDemand numeric(20,6), primary key (Basepart, datestamp))



insert  #DailyReq (	BasePart,
				PartClassification,
				StdPack,		
				DateStamp,
				EndDate,
				POBalance,
				CustomerDemand,
				Inventory,
				AllInventory,
				EEIProjectedInventory,
				Scheduler,
				CustomerPart,
				Price,
				Cost,
				SOP,
				EOP,
				CurrentRevLevel,
				MinonHand,
				MaxonHand,
				StartingInventory,
				StatringInventoryDollars,
				AllStartingInventory,
				AllStartingInventoryDollars,
				AverageWeeklyDemand
			) 


select	PartList.BasePart,
		PartSetups.PartClassification,
		ISNULL(BasePartStdPack,1),
		BeginDT,
		ENdDT, 
		POBalance = coalesce (PoQty, 0),
		CustomerDemand = coalesce (ShipQty, 0),
		Inventory = ISNULL((CASE WHEN BeginDT = @FirstBucketDate THEN Inventory ELSE 0 END),0),
		AllInventory = ISNULL((CASE WHEN BeginDT = @FirstBucketDate THEN AllInventory ELSE 0 END),0),
		EEIProjectedInventory = isNull(EEIProjectedInventory.Qty,0),
		Scheduler = PartSetups.Scheduler,
		CustomerPart = PartSetups.CustomerPart,
		Price = PartSetups.BasePartPrice,
		Cost = PartSetups.BasePartCost,
		SOP = PartSetups.SOP,
		EOP = PartSetups.EOP,
		CurrentRevLevel = PartSetups.CurrentRevLevel,
		MinonHand = PartSetups.MinonHand,
		MaxonHand = PartSetups.MaxonHand,
		StartingInventory = ISNULL(Inventory,0),
		StartingInventoryDollars = ISNULL(Inventory,0)*partSetups.BasePartcost,
		AllStartingInventory = ISNULL(AllInventory,0),
		AllStartingInventoryDollars = ISNULL(AllInventory,0)*partSetups.BasePartcost,
	AvgWeeklyShipQty
from
	(	select		DISTINCT BasePart =  LEFT(part,7)
		from		part
		where	part.type = 'F' and part in 
		(			Select	part_number from po_detail where balance>  0  and date_due> dateadd(dd, -21, getdate())
			union	Select	part_number from order_detail where quantity>0 and due_date >  dateadd(dd, -21, getdate())
			union	Select	part from object 	) 
	)	PartList
LEFT JOIN	#BasePartInventory BPI ON PartList.BasePArt = BPI.Basepart
LEFT JOIN	#basePartAllInventory BPIA ON PartList.BasePart = BPIA.Basepart
left join	#BasePartSetups PartSetups on PartList.BasePart = PartSetups.BasePart
cross join	#Buckets Buckets
left join	#DailyShipReq eei_daily_ship_requirements on Buckets.BeginDT = RequirementDT and eei_daily_ship_requirements.BasePart = PartList.Basepart
left join	#DailyPOReq eei_daily_po_requirements on Buckets.BeginDT = date_due and eei_daily_po_requirements.BasePart = PartList.Basepart
left join	#AvgWeeklyShipReqBasePart AvgWeeklyShipReq on PartList.Basepart = AvgWeeklyShipReq.BasePart
left join	#EEIProjectedInventory  EEIProjectedInventory on Buckets.BeginDT=ProjectedDT and   EEIProjectedInventory.Basepart = PartList.Basepart
WHERE		EndDT <= DATEADD(dd,1,@EnteredDT)

--Select * FROM #DailyReq WHERE Basepart = 'ALC0030'
SELECT	* FROM	#DailyShipReq WHERE basepart = 'AUT0035'




update	#DailyReq
set		runningtotal = (select sum (netchange) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		runningtotalall = (select sum (netchangeallinv) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		BasePartrunningtotal = (select sum (netchange) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		BasePartrunningtotalall = (select sum (netchangeallinv) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp)
from		#DailyReq t1

Select * FROM #DailyReq WHERE Basepart = 'AUT0035'


Select	substring(DailyReq.Basepart,1,3) as	CustomerCode,
		DailyReq.BasePart as	BasePart,
		MAX(DailyReq.PartClassification) AS PartClassification,
		max((CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END)) as BasePArtRunningTotal,
		max((CASE WHEN BasePartRunningTotalAll<0 THEN 0 ELSE BasePartRunningTotalAll END)) as BasePartRunningTotalAll,
		
		max((CASE WHEN (BasePartRunningTotal*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotal*BasePartcost END)) as BasePartExtendedCost,
		max((CASE WHEN (BasePartRunningTotalAll*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotalAll*BasePartcost END)) as BasePartExtendedCostAll,
		
		max(BasePartStdPack) as BasePartStdPack,
		
		max((CASE WHEN RunningPercent <= 80 THEN 'A' WHEN RunningPercent>80 and RunningPercent<= 95 THEN 'B' ELSE 'C' END)) as CalculatedPartClass,
		
		max((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)) as CalculatedMinQty,
		max((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent <= 95 THEN @MaxBClass*DailyBasePartQty ELSE  @MaxCClass*DailyBasePartQty END)) as CalculatedMaxQty,
				
		max(ceiling((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack)as CalculatedMinQtyStdPack,
		max(ceiling((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MaxBClass*DailyBasePartQty ELSE @MaxCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack) as CalculatedMaxQtyStdPack,
		
		max([dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack)) as CalculatedMinQtyStdPackVar,
		max([dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MaxBClass*DailyBasePartQty ELSE  @MaxCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack )) as CalculatedMaxQtyStdPackVar,
	
		max((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)* BasePartcost) as CalculatedMinExt,		
		max((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent <= 95 THEN @MaxBClass*DailyBasePartQty ELSE  @MaxCClass*DailyBasePartQty END)*BasepartCost) as CalculatedMaxExt,
		
		max(ceiling((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack)*MAX(BasePartCost) as CalculatedMinExtStdPack,
		max(ceiling((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MaxBClass*DailyBasePartQty ELSE @MaxCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack)*MAX(BasePartCost) as CalculatedMaxExtStdPack,
		
		max([dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN @MinAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MinBClass*DailyBasePartQty ELSE  @MinCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack))*MAX(BasepartCost) as CalculatedMinExtStdPackVar,
		max([dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN @MaxAClass*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN @MaxBClass*DailyBasePartQty ELSE  @MaxCClass*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack ))*MAX(BasepartCost) as CalculatedMaxExtStdPackVar,
		max(@EnteredDT) EvaluationDate,
		max(@maxAClass) MaxDaysA,
		max(@maxBClass) MaxDaysB,
		max(@maxCClass) MaxDaysC,
		max(@minAClass) MinDaysA,
		max(@minBClass) MinDaysB,
		max(@minCClass) MinDaysC,
		MAX(@POOffsetDays) POOffSetDays
from		#DailyReq DailyReq
left join	#BasePartExtendedRunningPercentage BPRP on  DailyReq.BasePart = BPRP.BasePart
left join	#BasePartSetups BPP on  DailyReq.BasePart = BPP.BasePart
where		ENDdate = (select max(EndDate) from #DailyReq where dateStamp<=@EnteredDT) AND DailyReq.BasePart = 'AUT0035'
group by	substring(DailyReq.BasePart,1,3) ,
			DailyReq.BasePart
order by 4

end






GO
