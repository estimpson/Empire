SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_rpt_materials_running_inventory_Weekly]
       as
begin

--eeisp_rpt_materials_running_inventory_Weekly



-- Get first Day of the week and first day of the month
declare	@ThisSundayDT datetime; set @ThisSundayDT = FT.fn_TruncDate ('wk', getdate ())
declare	@FirstBucketDate datetime; set @FirstBucketDate = dateadd(wk,-1,FT.fn_TruncDate('wk', getdate()))

Create table #Buckets
(	BeginDT	datetime,
	EndDT	datetime, Primary key (BeginDT))

Insert		#Buckets
select		BeginDT = EntryDT,
			EndDT = EntryDT + 7
from			[dbo].[fn_Calendar_StartCurrentMonth] (Null,'wk',1,16)
where		EntryDT >= dateadd(wk,-1,FT.fn_TruncDate('wk', getdate()))

Create table #EEIPartInventory
(	Part		varchar(25),
	NonSecurednorLost	numeric(20,6),
	SecuredorLost	numeric(20,6),
	TotalInventory numeric(20,6), Primary key (part))

Insert		#EEIPartInventory
select		object.part,
			sum(isNull((CASE WHEN isNull((CASE WHEN location like '%Lost%' THEN 'Y' ELSE secured_location END),'N') = 'N' THEN Object.quantity ELSE 0 END ),0)) NonSecuredQuantity,
			sum(isNull((CASE WHEN isNull((CASE WHEN location like '%Lost%' THEN 'Y' ELSE secured_location END),'N') != 'N' THEN Object.quantity ELSE 0 END ),0)) SecuredQuantity,
			sum(isNull(object.quantity,0)) as AllInventory
from			object
join			part on object.part = part.part
left join		location on object.location = location.code
where		part.type = 'F'
group by		object.part

Create table #EEHPartInventory
(	Part		varchar(25),
	NonSecurednorLost	numeric(20,6),
	SecuredorLost	numeric(20,6),
	TotalInventory numeric(20,6), Primary key (part))

Insert		#EEHPartInventory
select		object.part,
			sum(isNull((CASE WHEN isNull((CASE WHEN location like '%Lost%' THEN 'Y' ELSE secured_location END),'N') = 'N' THEN Object.quantity ELSE 0 END ),0)) NonSecuredQuantity,
			sum(isNull((CASE WHEN isNull((CASE WHEN location like '%Lost%' THEN 'Y' ELSE secured_location END),'N') != 'N' THEN Object.quantity ELSE 0 END ),0)) SecuredQuantity,
			sum(isNull(object.quantity,0)) as AllInventory
from			[EEHSQL1].[eeh].[dbo].object object
join			[EEHSQL1].[eeh].[dbo].part part on object.part = part.part
left join		[EEHSQL1].[eeh].[dbo].location location on object.location = location.code
where		part.type = 'F'
group by		object.part		


create table #DailyPOReq 
(	POQty int not null,
	part_number varchar (25) not null, 
	date_due datetime not null , primary key (part_number, date_due))

insert #DailyPOReq


	Select		sum(Balance) as PoQty,
				part_number,
				(CASE WHEN date_due <= ft.fn_truncDate('wk',getdate()) THEN ft.fn_truncDate('wk',getdate()) ELSE  ft.fn_truncDate('wk',dateadd(dd,-8,date_due)) END) as date_due --This is to convert EEI delivery date to EEH ship date
		 from	po_detail
		where	isNULL(balance,0)  >0 and
				date_due > dateadd(dd,-21, @ThisSundayDT)
		group by	part_number,
				(CASE WHEN date_due <= ft.fn_truncDate('wk',getdate()) THEN ft.fn_truncDate('wk',getdate()) ELSE  ft.fn_truncDate('wk',dateadd(dd,-8,date_due)) END)



create table #DailyShipReq
(	ShipQty int not null,
	part_number varchar (25) not null, 
	RequirementDT datetime not null , primary key (part_number, RequirementDT))

insert #DailyShipReq

Select			sum(DailyNoStdPack) as ShipQty,
				part_number,
				(CASE WHEN RequirementDT < FT.fn_TruncDate('wk', getdate()) THEN dateadd(wk,-1,FT.fn_TruncDate('wk', getdate())) ELSE FT.fn_TruncDate('wk', RequirementDT)  END) RequirementDT
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null
		group by	part_number,
				(CASE WHEN RequirementDT < FT.fn_TruncDate('wk', getdate()) THEN dateadd(wk,-1,FT.fn_TruncDate('wk', getdate())) ELSE FT.fn_TruncDate('wk', RequirementDT)  END) 


create table #AvgWeeklyShipReq
(	AvgWeeklyShipQty int not null,
	part_number varchar (25) not null primary key (part_number))

insert #AvgWeeklyShipReq

Select			sum(DailyNoStdPack)/6 as AvgWeeklyShipQty,
				part_number
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null and
				RequirementDT <= dateadd(dd,42, FT.fn_TruncDate('dd', getdate())) 
		group by	part_number

create table #AvgWeeklyShipReqBasePart
(	AvgWeeklyShipQty int not null,
	BasePart varchar (25) not null primary key (BasePart))

insert #AvgWeeklyShipReqBasePart

Select			sum(DailyNoStdPack)/6 as AvgWeeklyShipQtyBasePart,
				substring(part_number, 1,7)
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null and
				RequirementDT <= dateadd(dd,42, FT.fn_TruncDate('dd', getdate())) 
		group by	substring(part_number, 1,7)

create table #BasePartPrice
(	BasePartPrice numeric (20,6) not null,
	BasePartcost numeric (20,6) not null,
	BasePartStdPack numeric (20,6) not null,
	BasePart varchar (25) not null primary key (BasePart))

insert #BasePartPrice

Select	max(isNUll(price,0)),
		max(isNUll(material_cum,0)),
		max(isNUll(standard_pack,0)),
		substring(part.part, 1,7)
				
from		part_standard
join		part on part_standard.part = part.part
join		part_inventory on part.part = part_inventory.part
join		part_eecustom on part.part = part_eecustom.part and currentRevLevel = 'Y'
where	part.part not like '%[-]PT' and 
		part.part not like '%[]-RW' and
		 part.part not like 'PT[-]%'  and
		 part.part not like '%[-]FIX%'  and
		part.type = 'F' 
group by	substring(part.part, 1,7)




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
		BasePartPrice.BasePart
				
from		#BasePartPrice BasePartPrice
left join	#AvgWeeklyShipReqBasePart AvgWeeklyShipReqBasePart on BasePartPrice.BasePart = AvgWeeklyShipReqBasePart.BasePart
order by 1 desc

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
 from #BasePartExtendedPercentage
order by 1 DESC

create table #EEHCost
(	EEHPartSellingPrice numeric (20,6) not null,
	EEHPartMaterialCum numeric (20,6) not null,
	Part varchar (25) not null primary key (Part))

insert #EEHCost

Select	isNUll(price,0),
		isNUll(material_cum,0),
		part.part
				
from		[EEHSQL1].[EEH].[dbo].part_standard part_standard
join		[EEHSQL1].[EEH].[dbo].part  part on part_standard.part = part.part
where	part.part not like '%[-]PT' and 
		part.part not like '%[]-RW' and
		part.part not like 'PT[-]%'  and
		 part.part not like '%[-]FIX%'  and
		part.type = 'F' 

create table #EEHOrders
(	EEHOrderQty numeric (20,6) not null,
	EEHShipDT datetime not null,
	Part varchar (25) not null primary key (Part, EEHShipDT))

insert #EEHOrders
--Now using EEH Container Schedule
Select	isNull(QtySchedule,0) as ProductionQty,
		Container,
		Part		
from		[EEHSQL1].[Monitor].[dbo].[EEH_Schedule_Production]
where	part not like '%[-]PT' and 
		part not like '%[]-RW' and
		part not like 'PT[-]%'  and
		part not like '%[-]FIX%'  

Create table #EEIPartSetups
(	Part		varchar(25),
	Scheduler	varchar(50) NULL,
	CustomerPart	varchar(50) NULL,
	Price		numeric(20,6) NULL,
	SOP			datetime NULL,
	EOP			datetime NULL,
	CurrentRevLevel varchar(50) NULL,
	MinonHand	numeric(20,6) NULL,
	MaxonHand	numeric(20,6) NULL,
	Cost			numeric(20,6) NULL,
	StdPack		numeric(20,6) NULL,
	 Primary key (part))
 Insert	#EEIPartSetups
Select	part_standard.part,
		max(UPPER(scheduler)),
		max(customer_part) ,
		max(price) ,
		max(part_eecustom.prod_start) ,
		max(part_eecustom.prod_end) ,				
		max(CurrentRevLevel) ,
		max((CASE WHEN isNULL(CurrentRevLevel, 'N') = 'Y' THEN min_onhand ELSE 0 END)) ,
		max((CASE WHEN isNULL(CurrentRevLevel, 'N') = 'Y' THEN max_onhand ELSE 0 END )),
		max(cost_cum),
		max(standard_pack)
	from		part_standard
	join		part_inventory on part_standard.part = part_inventory.part
	join		part on part_standard.part = part.part 
	join		part_eecustom on part_standard.part = part_eecustom.part
	join		part_online on part_standard.part = part_online.part
	left join	part_customer on part_standard.part = part_customer.part
	left join	customer on part_customer.customer = customer.customer
	left join	destination on customer.customer = destination.customer 
	where	part.type in( 'F', 'R')
	group by	part_standard.part 

Create table #EEIPartList
(	Part		varchar(25)
	 Primary key (part))

Insert	#EEIPartList
		select	Part = part
		from		part
		where	part.type = 'F' and part in 
		(			Select	part_number from po_detail where balance>  0  and date_due> dateadd(dd, -21, getdate())
			union	Select	part_number from order_detail where quantity>0 and due_date >  dateadd(dd, -21, getdate())
			union	Select part from object 	) 
	


create table #DailyReq 
(	Basepart varchar (25) not null,
	part varchar (25) not null,
	StdPack numeric(20,6) not null, 
	DateStamp datetime not null, 
	EEIInventory int not null, 
	EEISecuredInventory int not null, 
	EEIAllInventory int not null,
	EEHInventory int not null, 
	EEHSecuredInventory int not null, 
	EEHAllInventory int not null,
	POBalance int not null, 
	EEHOrdersQty int not null,
	CustomerDemand int not null, 
	netchange as (EEIInventory + POBalance) - CustomerDemand, 
	netchangeallinv as (EEIAllInventory + POBalance) - CustomerDemand,
	EEHnetchange as (EEIInventory + EEHOrdersQty) - CustomerDemand, 
	EEHnetchangeallinv as (EEIAllInventory + EEHOrdersQty) - CustomerDemand,
	runningtotal int null,
	runningtotalall int null,
	EEHrunningtotal int null,
	EEHrunningtotalall int null,
	BasePartrunningtotal int null,
	BasePartrunningtotalall int null,
	EEHBasePartrunningtotal int null,
	EEHBasePartrunningtotalall int null,
	Scheduler varchar(25) null,
	CustomerPart varchar(25) null,
	Price numeric (20,6) Null,
	Cost	numeric(20,6) null,
	EEHPartSellingPrice numeric (20,6) Null,
	EEHPartMaterialCum numeric(20,6) Null,
	SOP datetime null,
	EOP datetime null,
	MinOnHand int null,
	MaxonHand int null,
	CurrentRevLevel  varchar(2) null, 
	StartingInventory numeric(20,6) null,
	StatringInventoryDollars numeric(20,6) null,
	AllStartingInventory numeric(20,6) null,
	AllStartingInventoryDollars numeric(20,6) null,
	AverageWeeklyDemand numeric(20,6) null, primary key (part, datestamp))



insert  #DailyReq (	BasePart,
				part,	
				StdPack,		
				DateStamp,
				POBalance,
				EEHOrdersQty,
				CustomerDemand,
				EEIInventory,
				EEISecuredInventory,
				EEIAllInventory,
				EEHInventory,
				EEHSecuredInventory, 
				EEHAllInventory,
				Scheduler,
				CustomerPart,
				Price,
				Cost,
				EEHPartSellingPrice,
				EEHPartMaterialCUM,
				SOP,
				EOP,
				CurrentRevLevel,
				MinonHand,
				MaxonHand,
				StatringInventoryDollars,
				AllStartingInventoryDollars,
				AverageWeeklyDemand
			) 



select	substring(partlist.Part,1,7) ,
		PArtList.Part,
		StdPack,
		BeginDT, 
		POBalance = coalesce (PoQty, 0),
		EEHOrdersQty = coalesce (EEHOrderQty, 0),
		CustomerDemand = coalesce (ShipQty, 0),
		EEIInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEIpartInventory.NonSecurednorLost ELSE 0 END ),0),
		EEISecuredInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEIpartInventory.SecuredorLost ELSE 0 END ),0),
		EEIAllInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEIpartInventory.TotalInventory ELSE 0 END ),0),
		EEHInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEHpartInventory.NonSecurednorLost ELSE 0 END ),0),
		EEHSecuredInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEHpartInventory.SecuredorLost ELSE 0 END ),0),
		EEHAllInventory = coalesce ((CASE WHEN BeginDT = @FirstBucketDate THEN EEHpartInventory.TotalInventory ELSE 0 END ),0),
		Scheduler = PartSetups.Scheduler,
		CustomerPart = PartSetups.CustomerPart,
		Price = PartSetups.Price,
		Cost = PartSetups.Cost,
		EEHPartSellingPrice = EEHPartSellingPrice,
		EEHPartMaterialCUM = EEHPartMaterialCUM,
		SOP = PartSetups.SOP,
		EOP = PartSetups.EOP,
		CurrentRevLevel = PartSetups.CurrentRevLevel,
		MinonHand = PartSetups.MinonHand,
		MaxonHand = PartSetups.MaxonHand,
		StartingInventoryDollars = coalesce (EEIpartInventory.NonSecurednorLost,0)*partSetups.cost,
		AllStartingInventoryDollars =  coalesce (EEIpartInventory.TotalInventory,0)*partSetups.cost,
	AvgWeeklyShipQty
from			#EEIPartList PartList
cross join		#Buckets Buckets
left join		#EEIPartSetups PartSetups on PartList.Part = PartSetups.Part
left join		#DailyShipReq eei_daily_ship_requirements on Buckets.BeginDT = RequirementDT and eei_daily_ship_requirements.part_number = PartList.part
left join		#DailyPOReq eei_daily_po_requirements on Buckets.BeginDT = date_due and eei_daily_po_requirements.part_number = PartList.part
left join		#AvgWeeklyShipReq AvgWeeklyShipReq on PartList.part = AvgWeeklyShipReq.part_number
left join		#EEHCost EEHCost on PartList.part =EEHCost.part
left join		#EEHOrders EEHOrders on PartList.part = EEHOrders.Part and  Buckets.BeginDT = EEHShipDT
left join		#EEIPartInventory EEIPartInventory on PartList.part = EEIPartInventory.Part
left join		#EEHPartInventory EEHPartInventory on PartList.part = EEHPartInventory.Part



--Select * from  #DailyReq

update	#DailyReq
set		runningtotal = (select sum (netchange) from #DailyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		runningtotalall = (select sum (netchangeallinv) from #DailyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		BasePartrunningtotal = (select sum (netchange) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		BasePartrunningtotalall = (select sum (netchangeallinv) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		EEHrunningtotal = (select sum (EEHnetchange) from #DailyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		EEHrunningtotalall = (select sum (EEHnetchangeallinv) from #DailyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		EEHBasePartrunningtotal = (select sum (EEHnetchange) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp),
		EEHBasePartrunningtotalall = (select sum (EEHnetchangeallinv) from #DailyReq t2 where t1.Basepart = t2.Basepart and t1.datestamp >= t2.datestamp)
from		#DailyReq t1


Select	isNULL(Scheduler, '_N/A') as Scheduler,
		substring(part,1,3) as	CustomerCode,
		DailyReq.BasePart as	BasePart,
		Part,
		DateStamp,
		CustomerDemand,
		POBalance,
		EEHordersQty,

		EEIInventory ,
		EEISecuredInventory ,
		EEIAllInventory ,
		EEHInventory ,
		EEHSecuredInventory ,
		EEHAllInventory ,
		

		(CASE WHEN RunningTotal<0 THEN 0 ELSE RunningTotal END) as EEII,
		(CASE WHEN RunningTotalAll<0 THEN 0 ELSE RunningTotalAll END) as EEIIA,
		(CASE WHEN (RunningTotal*Cost)<=0 THEN 0 ELSE RunningTotal*Cost END) as EEII_EEIMAtCum,
		(CASE WHEN (RunningTotalAll*Cost)<=0 THEN 0 ELSE RunningTotalAll*Cost END) as EEIIA_EEIMAtCum,		
		(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) as EEII_BP,
		(CASE WHEN BasePartRunningTotalAll<0 THEN 0 ELSE BasePartRunningTotalAll END) as EEIIA_BP,
		(CASE WHEN (BasePartRunningTotal*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotal*BasePartcost END) as EEII_BP_EEIMAtCum,
		(CASE WHEN (BasePartRunningTotalAll*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotalAll*BasePartcost END) as EEIIA_BP_EEIMAtCum,

		(CASE WHEN (RunningTotal*Price)<=0 THEN 0 ELSE RunningTotal*Price END) as EEII_EEIPrice,
		(CASE WHEN (RunningTotalAll*Price)<=0 THEN 0 ELSE RunningTotalAll*Price END) as EEIIA_EEIPrice,		
		(CASE WHEN (BasePartRunningTotal*BasePartPrice)<=0 THEN 0 ELSE BasePartRunningTotal*BasePartPrice END) as EEII_BP_EEIPrice,
		(CASE WHEN (BasePartRunningTotalAll*BasePartPrice)<=0 THEN 0 ELSE BasePartRunningTotalAll*BasePartPrice END) as EEIIA_BP_EEIPrice,

		(CASE WHEN (RunningTotal*EEHPartMaterialCUM)<=0 THEN 0 ELSE RunningTotal*EEHPartMaterialCUM END) as EEII_EEHMatCUM,
		(CASE WHEN (RunningTotalAll*EEHPartMaterialCUM)<=0 THEN 0 ELSE RunningTotalAll*EEHPartMaterialCUM END) as EEIIA_EEHMatCUM,		
		(CASE WHEN (BasePartRunningTotal*EEHPartMaterialCUM)<=0 THEN 0 ELSE BasePartRunningTotal*EEHPartMaterialCUM END) as EEII_BP_EEHMatCUM,
		(CASE WHEN (BasePartRunningTotalAll*EEHPartMaterialCUM)<=0 THEN 0 ELSE BasePartRunningTotalAll*EEHPartMaterialCUM END) as EEIIA_BP_EEHMatCUM,	

		
		(CASE WHEN EEHRunningTotal<0 THEN 0 ELSE EEHRunningTotal END) as EEHI,
		(CASE WHEN EEHRunningTotalAll<0 THEN 0 ELSE EEHRunningTotalAll END) as EEHIA,
		(CASE WHEN (EEHRunningTotal*Cost)<=0 THEN 0 ELSE EEHRunningTotal*Cost END) as EEHI_EEIMAtCum,
		(CASE WHEN (EEHRunningTotalAll*Cost)<=0 THEN 0 ELSE EEHRunningTotalAll*Cost END) as EEHIA_EEIMAtCum,		
		(CASE WHEN EEHBasePartRunningTotal<0 THEN 0 ELSE EEHBasePartRunningTotal END) as EEHI_BP,
		(CASE WHEN EEHBasePartRunningTotalAll<0 THEN 0 ELSE EEHBasePartRunningTotalAll END) as EEHIA_BP,
		(CASE WHEN (EEHBasePartRunningTotal*BasePartcost)<=0 THEN 0 ELSE EEHBasePartRunningTotal*BasePartcost END) as EEHI_BP_EEIMAtCum,
		(CASE WHEN (EEHBasePartRunningTotalAll*BasePartcost)<=0 THEN 0 ELSE EEHBasePartRunningTotalAll*BasePartcost END) as EEHIA_BP_EEIMAtCum,

		(CASE WHEN (EEHRunningTotal*Price)<=0 THEN 0 ELSE EEHRunningTotal*Price END) as EEHI_EEIPrice,
		(CASE WHEN (EEHRunningTotalAll*Price)<=0 THEN 0 ELSE EEHRunningTotalAll*Price END) as EEHIA_EEIPrice,		
		(CASE WHEN (EEHBasePartRunningTotal*BasePartPrice)<=0 THEN 0 ELSE EEHBasePartRunningTotal*BasePartPrice END) as EEHI_BP_EEIPrice,
		(CASE WHEN (EEHBasePartRunningTotalAll*BasePartPrice)<=0 THEN 0 ELSE EEHBasePartRunningTotalAll*BasePartPrice END) as EEHIA_BP_EEIPrice,

		(CASE WHEN (EEHRunningTotal*EEHPartMaterialCUM)<=0 THEN 0 ELSE EEHRunningTotal*EEHPartMaterialCUM END) as EEHI_EEHMatCUM,
		(CASE WHEN (EEHRunningTotalAll*EEHPartMaterialCUM)<=0 THEN 0 ELSE EEHRunningTotalAll*EEHPartMaterialCUM END) as EEHIA_EEHMatCUM,		
		(CASE WHEN (EEHBasePartRunningTotal*EEHPartMaterialCUM)<=0 THEN 0 ELSE EEHBasePartRunningTotal*EEHPartMaterialCUM END) as EEHI_BP_EEHMatCUM,
		(CASE WHEN (EEHBasePartRunningTotalAll*EEHPartMaterialCUM)<=0 THEN 0 ELSE EEHBasePartRunningTotalAll*EEHPartMaterialCUM END) as EEHIA_BP_EEHMatCUM,


		CustomerPart,
		Price,
		Cost,
		convert( varchar (20),SOP, 111) as StartofProduction,
		convert( varchar (20),EOP, 111) as EndofProduction,
		CurrentRevLevel,
		(Select program from FlatCSM where 	basePart = substring(part,1,7)) as CSMProgram,
		(Select vehicle from FlatCSM where 	basePart = substring(part,1,7)) as CSMVehicle,
		(Select oem from FlatCSM where 	basePart = substring(part,1,7)) as CSMOEM,
		MinonHand,
		MaxonHand,
		(MaxOnHand*Cost) as MaxOnHandCost,
		dbo.IsDateLastDayOfMonth(DATEStamp) as LastDOMIndicator,
		StatringInventoryDollars,
		AllStartingInventoryDollars,
		AverageWeeklyDemand,
		StdPack,
		BasePartStdPack,
		(CASE WHEN RunningPercent <= 80 THEN 'A' WHEN RunningPercent>80 and RunningPercent<= 95 THEN 'B' ELSE 'C' END) as CalculatedPartClassification,
		(CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartQty ELSE  18*DailyBasePartQty END) as CalculatedMinQty,
		(CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent <= 95 THEN 17*DailyBasePartQty ELSE  20*DailyBasePartQty END) as CalculatedMaxQty,		
		ceiling((CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartQty ELSE  18*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack as CalculatedMinQtyStdPack,
		ceiling((CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN 17*DailyBasePartQty ELSE  20*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack as CalculatedMaxQtyStdPack,

		 [dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartQty ELSE  18*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack) as CalculatedMinQtyStdPackVar,
		 [dbo].[fn_GreaterOf](0,(CASE WHEN BasePartRunningTotal<0 THEN 0 ELSE BasePartRunningTotal END) - ceiling((CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartQty WHEN RunningPercent>80 and RunningPercent<= 95 THEN 17*DailyBasePartQty ELSE  20*DailyBasePartQty END)/nullif(BasePartStdPack,0))*BasePartStdPack ) as CalculatedMaxQtyStdPackVar,
	
		(CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartExtended ELSE  18*DailyBasePartExtended END) as CalculatedMinExt,		
		(CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent <= 95 THEN 17*DailyBasePartExtended ELSE  20*DailyBasePartExtended END) as CalculatedMaxExt,
		ceiling((CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartExtended ELSE  18*DailyBasePartExtended END)/nullif(BasePartStdPack,0))*BasePartStdPack as CalculatedMinExtStdPack,
		ceiling((CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent<= 95 THEN 17*DailyBasePartExtended ELSE  20*DailyBasePartExtended END)/nullif(BasePartStdPack,0))*BasePartStdPack as CalculatedMaxExtStdPack,
		 [dbo].[fn_GreaterOf](0,(CASE WHEN (BasePartRunningTotalAll*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotalAll*BasePartcost END) - ceiling((CASE WHEN RunningPercent <= 80 THEN 14*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent<= 95 THEN 15*DailyBasePartExtended ELSE  18*DailyBasePartExtended END)/nullif(BasePartStdPack,0))*BasePartStdPack )as CalculatedMinExtStdPackVar,
		 [dbo].[fn_GreaterOf](0,(CASE WHEN (BasePartRunningTotalAll*BasePartcost)<=0 THEN 0 ELSE BasePartRunningTotalAll*BasePartcost END) - ceiling((CASE WHEN RunningPercent <= 80 THEN 15*DailyBasePartExtended WHEN RunningPercent>80 and RunningPercent<= 95 THEN 17*DailyBasePartExtended ELSE  20*DailyBasePartExtended END)/nullif(BasePartStdPack,0))*BasePartStdPack) as CalculatedMaxExtStdPackVar
from		#DailyReq DailyReq
left join	#BasePartExtendedRunningPercentage BPRP on  DailyReq.BasePart = BPRP.BasePart
left join	#BasePartPrice BPP on  DailyReq.BasePart = BPP.BasePart
where	datepart(dw,DateStamp) = 1
order by 4

end

GO
