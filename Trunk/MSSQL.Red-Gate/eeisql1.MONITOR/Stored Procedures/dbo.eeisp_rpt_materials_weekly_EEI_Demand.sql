SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_weekly_EEI_Demand]
       as
begin

--[dbo].[eeisp_rpt_materials_weekly_EEI_Demand]



-- Get first Day of the week and first day of the month
declare	@ThisSundayDT datetime; set @ThisSundayDT = FT.fn_TruncDate ('wk', getdate ())
declare	@FirstBucketDate datetime; set @FirstBucketDate = FT.fn_TruncDate ('wk', getdate ())

Create table #Buckets
(	Part varchar(25),
	BeginDT	datetime, Primary key (Part, BeginDT))

Insert		#Buckets
select		Part,
			BeginDT =  FT.fn_TruncDate('wk',EntryDT)
from			Part
cross join		[dbo].[fn_Calendar_StartCurrentMonth] (Null,'wk',1,26)
where		EntryDT >= FT.fn_TruncDate('wk', getdate()) and
			part.type = 'F' and part in (	Select part from object 
									union all
									select part_number from po_detail where balance>0 and date_due >= dateadd(dd, -30, getdate())
									union all
									Select part_number from order_detail where eeiQty>0 and due_date >= dateadd(dd, -30, getdate())
									union all
									Select part_number from  [EEHSQL1].[EEH].[dbo].order_detail where Quantity > 0 and   due_date >= dateadd(dd, -30, getdate()) )


create table #EEIEEHPriceCost
(	Part varchar (25) not null,
	EEIPrice numeric(20,6) not null,
	EEIMaterialCum numeric(20,6) not null,
	EEHPrice numeric(20,6) not null,
	EEHMaterialCum numeric(20,6) not null,  primary key (part))

insert	#EEIEEHPriceCost
Select	part.part,
		isnull(EEIPS.Price,0),
		isnull(EEIPS.Material_cum,0),
		isnull(EEHPS.Price,0),
		isnull(EEHPS.Material_cum,0)
from		part
join		part_standard EEIPS on part.part = EEIPS.part
left join	[EEHSQL1].[EEH].[dbo].part_standard EEHPS on part.part = EEHPS.part
where	part.type = 'F'	

create table #EEIInventory
(	Part varchar (25) not null,
	DateStamp datetime not Null,
	InventoryQty int not null,
	AllInventoryQty int not null,  primary key (part))

insert	#EEIInventory

Select	part.part,
		FT.fn_TruncDate('wk', getdate()) as DateStamp,
		isNull(SUM((CASE WHEN isNULL(secured_location, 'N') = 'Y' or location like '%LOST%' THEN 0 ELSE quantity END)),0) as Inventory,
		isNull(SUM((CASE WHEN isNULL(secured_location, 'N') = 'Y' or location like '%LOST%' THEN quantity ELSE quantity END)),0) as AllInventory
		
				
from		part
join		part_standard EEIPS on part.part = EEIPS.Part
left join	object on part.part = object.part
left join	location on object.location = location.code
where	part.type = 'F'
group by part.part


create table #EEIWeeklyShipReq
(	ShipQty int not null,
	part varchar (25) not null, 
	RequirementDT datetime not null , primary key (part, RequirementDT))

insert #EEIWeeklyShipReq

Select			isnull(sum(DailyNoStdPack),0) as ShipQty,
				part_number,
				(CASE WHEN RequirementDT < FT.fn_TruncDate('dd', getdate()) THEN FT.fn_TruncDate('wk', getdate()) ELSE FT.fn_TruncDate('wk',RequirementDT) END) RequirementDT
				
		 from	vw_eei_daily_ship_requirements
		where	RequirementDT is not Null
		group by	part_number,
				(CASE WHEN RequirementDT < FT.fn_TruncDate('dd', getdate()) THEN FT.fn_TruncDate('wk', getdate()) ELSE FT.fn_TruncDate('wk',RequirementDT) END)


create table #EEIWeeklyPOReq 
(	POQty int not null,
	Part varchar (25) not null, 
	date_due datetime not null , primary key (part, date_due))

insert #EEIWeeklyPOReq

	Select		isNull(sum(Balance),0)as PoQty,
				part_number,
				(CASE  WHEN (FT.fn_TruncDate('wk', dateadd(dd,-8,(case when date_due< getdate() then getdate() else date_due end)))) < FT.fn_TruncDate('wk', getdate()) THEN FT.fn_TruncDate('wk', getdate()) ELSE    (FT.fn_TruncDate('wk', dateadd(dd,-8,(case when date_due< getdate() then getdate() else date_due end)))) END      ) as date_due --This is to convert EEI delivery date to EEH ship date
		 from	po_detail
		join		part on po_detail.part_number = part.part
		where	isNULL(balance,0)  >0 and
				date_due > dateadd(dd,-21, getdate())
		group by	part_number,
				(CASE  WHEN (FT.fn_TruncDate('wk', dateadd(dd,-8,(case when date_due< getdate() then getdate() else date_due end)))) < FT.fn_TruncDate('wk', getdate()) THEN FT.fn_TruncDate('wk', getdate()) ELSE    (FT.fn_TruncDate('wk', dateadd(dd,-8,(case when date_due< getdate() then getdate() else date_due end)))) END      ) 



create table #EEHWeeklyOrderReq 
(	OrderQty int not null,
	Part varchar (25) not null, 
	date_due datetime not null , primary key (part, date_due))

insert	#EEHWeeklyOrderReq 

	Select	isNull(QtySchedule,0) as ProductionQty,
			Part,
			Container
			
from		[EEHSQL1].[Monitor].[dbo].[EEH_Schedule_Production]
where	part not like '%[-]PT' and 
		part not like '%[]-RW' and
		part not like 'PT[-]%'  and
		part not like '%[-]FIX%'  



create table #WeeklyReq 
(	part varchar (25) not null,
	DateStamp datetime not null,
	EEIPrice numeric (20,6) not null,
	EEIMaterialCum numeric (20,6) not Null,
	EEHPrice numeric (20,6) not null,
	EEHMaterialCum numeric (20,6) not Null,	
	EEIInventory int not null, 
	EEIAllInventory int not null,
	EEIPriceInventory int not null,
	EEIPriceAllInventory int not null,
	EEIMaterialCumInventory int not null,
	EEIMaterialCumAllInventory int not null,
	EEHPriceInventory int not null,
	EEHPriceAllInventory int not null,	
	EEHMaterialCumInventory int not null,
	EEHMaterialCumAllInventory int not null,
	EEIPOQty int not null, 
	EEHOrderQty int not null,
	EEIShipQty int not null,
	
	--Inventory 
	NCEEIInvEEIPO as (EEIInventory + EEIPOQty) - EEIShipQty, 
	NCEIInvEEHOrder as (EEIInventory + EEHOrderQty) - EEIShipQty, 
	NCEEIAllInvEEIPO as (EEIAllInventory + EEIPOQty) - EEIShipQty, 
	NCEEIAllInvEEHOrder as (EEIAllInventory + EEHOrderQty) - EEIShipQty,

	--Inventory @ EEIPrice
	NCEEIInvEEIPOEEIPrice as (EEIInventory*EEIPrice + EEIPOQty*EEIPrice) - EEIShipQty*EEIPrice, 
	NCEEIInvEEHOrderEEIPrice as (EEIInventory*EEIPrice + EEHOrderQty*EEIPrice) - EEIShipQty*EEIPrice, 
	NCEEIAllInvEEIPOEEIPrice as (EEIAllInventory*EEIPrice + EEIPOQty*EEIPrice) - EEIShipQty*EEIPrice, 
	NCEEIAllInvEEHOrderEEIPrice as (EEIAllInventory*EEIPrice + EEHOrderQty*EEIPrice) - EEIShipQty*EEIPrice,

	--Inventory @ EEIMaterialCum
	NCEEIInvEEIPOEEIMC as (EEIInventory*EEIMaterialCum + EEIPOQty*EEIMaterialCum) - EEIShipQty*EEIMaterialCum, 
	NCEEIInvEEHOrderEEIMC as (EEIInventory*EEIMaterialCum + EEHOrderQty*EEIMaterialCum) - EEIShipQty*EEIMaterialCum, 
	NCEEIAllInvEEIPOEEIMC as (EEIAllInventory*EEIMaterialCum + EEIPOQty*EEIMaterialCum) - EEIShipQty*EEIMaterialCum, 
	NCEEIAllInvEEHOrderMC as (EEIAllInventory*EEIMaterialCum + EEHOrderQty*EEIMaterialCum) - EEIShipQty*EEIMaterialCum,

	--Inventory @ EEHPrice
	NCEEIInvEEIPOEEHPrice as (EEIInventory*EEHPrice + EEIPOQty*EEHPrice) - EEIShipQty*EEHPrice, 
	NCEEIInvEEHOrderEEHPrice as (EEIInventory*EEHPrice + EEHOrderQty*EEHPrice) - EEIShipQty*EEHPrice, 
	NCEEIAllInvEEIPOEEHPrice as (EEIAllInventory*EEHPrice + EEIPOQty*EEHPrice) - EEIShipQty*EEHPrice, 
	NCEEIAllInvEEHOrderEEHPrice as (EEIAllInventory*EEHPrice + EEHOrderQty*EEHPrice) - EEIShipQty*EEHPrice,

	--Inventory @ EEHMaterialCum
	NCEEIInvEEIPOEEHMC as (EEIInventory*EEHMaterialCUM + EEIPOQty*EEHMaterialCUM) - EEIShipQty*EEHMaterialCUM, 
	NCEEIInvEEHOrderEEHMC as (EEIInventory*EEHMaterialCUM + EEHOrderQty*EEHMaterialCUM) - EEIShipQty*EEHMaterialCUM, 
	NCEEIAllInvEEIPOEEHMC as (EEIAllInventory*EEHMaterialCUM + EEIPOQty*EEHMaterialCUM) - EEIShipQty*EEHMaterialCUM, 
	NCEEIAllInvEEHOrderEEHMC as (EEIAllInventory*EEHMaterialCUM + EEHOrderQty*EEHMaterialCUM) - EEIShipQty*EEHMaterialCUM,

	
	--Inventory Running Total
	RTEEIInvEEIPO int null, 
	RTEEIInvEEHOrder int null, 
	RTEEIAllInvEEIPO int null, 
	RTEEIAllInvEEHOrder int null,

	--Inventory @ EEIPrice Running Total
	RTEEIInvEEIPOEEIPrice int null, 
	RTEEIInvEEHOrderEEIPrice int null, 
	RTEEIAllInvEEIPOEEIPrice int null, 
	RTEEIAllInvEEHOrderEEIPrice int null,

	--Inventory @ EEIMaterialCum Running Total
	RTEEIInvEEIPOEEIMC int null, 
	RTEEIInvEEHOrderEEIMC int null, 
	RTEEIAllInvEEIPOEEIMC int null, 
	RTEEIAllInvEEHOrderEEIMC int null,

	--Inventory @ EEHPrice Running Total
	RTEEIInvEEIPOEEHPrice int null, 
	RTEEIInvEEHOrderEEHPrice int null, 
	RTEEIAllInvEEIPOEEHPrice int null, 
	RTEEIAllInvEEHOrderEEHPrice int null,

	--Inventory @ EEHMaterialCum Running Total
	RTEEIInvEEIPOEEHMC int null, 
	RTEEIInvEEHOrderEEHMC int null, 
	RTEEIAllInvEEIPOEEHMC int null, 
	RTEEIAllInvEEHOrderEEHMC int null, primary key (part, datestamp))



insert  #WeeklyReq (	part ,
				DateStamp,
				EEIPrice,
				EEIMaterialCum,
				EEHPrice,
				EEHMaterialCum,	
				EEIInventory, 
				EEIAllInventory,
				EEIPriceInventory,
				EEIPriceAllInventory,
				EEIMaterialCumInventory,
				EEIMaterialCumAllInventory,
				EEHPriceInventory,
				EEHPriceAllInventory,	
				EEHMaterialCumInventory,
				EEHMaterialCumAllInventory,
				EEIPOQty, 
				EEHOrderQty,
				EEIShipQty
			) 


Select	Buckets.Part,
		Buckets.BeginDT,
		isNull(PriceCost.EEIPrice,0),
		isNull(PriceCost.EEIMaterialCum,0),
		isNull(PriceCost.EEHPrice,0),
		isNull(PriceCost.EEHMaterialCum,0),
		isNull(InventoryQty,0),
		isNull(AllInventoryQty,0),
		isNull(InventoryQty*EEIPrice,0),
		isNull(AllInventoryQty*EEIPrice,0),
		isNull(InventoryQty*EEIMaterialCum,0),
		isNull(AllInventoryQty*EEIMaterialCum,0),
		isnull(InventoryQty*EEHPrice,0),
		isnull(AllInventoryQty*EEHPrice,0),
		isnull(InventoryQty*EEHMaterialCum,0),
		isNull(AllInventoryQty*EEHMaterialCum,0),
		isNull(POqty,0),
		isNull(OrderQty,0),
		isNull(ShipQty,0)
		
		
		
from		#Buckets Buckets
left join	#EEIWeeklyPOReq PO on Buckets.BeginDT = PO.Date_due and Buckets.Part = PO.Part
left join	#EEHWeeklyOrderReq SO on Buckets.BeginDT = SO.Date_due and Buckets.Part = SO.Part
left join	#EEIInventory Inventory on Buckets.BeginDT = Inventory.DateStamp and Buckets.Part = Inventory.Part
left join	#EEIWeeklyShipReq Demand on Buckets.BeginDT = RequirementDT and Buckets.Part = Demand.Part
left join	#EEIEEHPriceCost PriceCost on Buckets.Part = PriceCost.Part


update	#WeeklyReq
set		RTEEIInvEEIPO = (select sum (NCEEIInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		RTEEIAllInvEEIPO = (select sum (NCEEIAllInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		RTEEIInvEEHOrder = (select sum (NCEIInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),
		RTEEIAllInvEEHOrder = (select sum (NCEEIAllInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp),

		RTEEIInvEEIPOEEIPrice = (select sum (NCEEIInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIPrice, 
		RTEEIAllInvEEIPOEEIPrice = (select sum (NCEEIAllInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIPrice, 
		RTEEIInvEEHOrderEEIPrice = (select sum (NCEIInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIPrice, 
		RTEEIAllInvEEHOrderEEIPrice = (select sum (NCEEIAllInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIPrice,

		RTEEIInvEEIPOEEIMC = (select sum (NCEEIInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIMaterialCum, 
		RTEEIAllInvEEIPOEEIMC = (select sum (NCEEIAllInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIMaterialCum, 
		RTEEIInvEEHOrderEEIMC = (select sum (NCEIInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIMaterialCum, 
		RTEEIAllInvEEHOrderEEIMC = (select sum (NCEEIAllInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEIMaterialCum,
		
		RTEEIInvEEIPOEEHPrice = (select sum (NCEEIInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHPrice, 
		RTEEIAllInvEEIPOEEHPrice = (select sum (NCEEIAllInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHPrice, 
		RTEEIInvEEHOrderEEHPrice = (select sum (NCEIInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHPrice, 
		RTEEIAllInvEEHOrderEEHPrice = (select sum (NCEEIAllInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHPrice,

		RTEEIInvEEIPOEEHMC = (select sum (NCEEIInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHMaterialCum, 
		RTEEIAllInvEEIPOEEHMC = (select sum (NCEEIAllInvEEIPO) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHMaterialCum, 
		RTEEIInvEEHOrderEEHMC = (select sum (NCEIInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHMaterialCum, 
		RTEEIAllInvEEHOrderEEHMC = (select sum (NCEEIAllInvEEHOrder) from #WeeklyReq t2 where t1.part = t2.part and t1.datestamp >= t2.datestamp)*EEHMaterialCum
from		#WeeklyReq t1


Select			part ,
				DateStamp,
				EEIPrice,
				EEIMaterialCum,
				EEHPrice,
				EEHMaterialCum,	
				EEIInventory, 
				EEIAllInventory,
				EEIPriceInventory,
				EEIPriceAllInventory,
				EEIMaterialCumInventory,
				EEIMaterialCumAllInventory,
				EEHPriceInventory,
				EEHPriceAllInventory,	
				EEHMaterialCumInventory,
				EEHMaterialCumAllInventory,
				EEIPOQty, 
				EEHOrderQty,
				EEIShipQty,
				(CASE WHEN RTEEIInvEEIPO<0 THEN 0 ELSE RTEEIInvEEIPO END) as RTEEIInvEEIPO,
				(CASE WHEN RTEEIAllInvEEIPO<0 THEN 0 ELSE RTEEIAllInvEEIPO END) as RTEEIAllInvEEIPO,
				(CASE WHEN RTEEIInvEEHOrder<0 THEN 0 ELSE RTEEIInvEEHOrder END) as RTEEIInvEEHOrder,
				(CASE WHEN RTEEIAllInvEEHOrder<0 THEN 0 ELSE RTEEIAllInvEEHOrder END) as RTEEIAllInvEEHOrder,

				(CASE WHEN RTEEIInvEEIPOEEIPrice<0 THEN 0 ELSE RTEEIInvEEIPOEEIPrice END) as RTEEIInvEEIPOEEIPrice,
				(CASE WHEN RTEEIAllInvEEIPOEEIPrice<0 THEN 0 ELSE RTEEIAllInvEEIPOEEIPrice END) as RTEEIAllInvEEIPOEEIPrice,
				(CASE WHEN RTEEIInvEEHOrderEEIPrice<0 THEN 0 ELSE RTEEIInvEEHOrderEEIPrice END) as RTEEIInvEEHOrderEEIPrice,
				(CASE WHEN RTEEIAllInvEEHOrderEEIPrice<0 THEN 0 ELSE RTEEIAllInvEEHOrderEEIPrice END) as RTEEIAllInvEEHOrderEEIPrice,

				(CASE WHEN RTEEIInvEEIPOEEIMC<0 THEN 0 ELSE RTEEIInvEEIPOEEIMC END) as RTEEIInvEEIPOEEIMC,
				(CASE WHEN RTEEIAllInvEEIPOEEIMC<0 THEN 0 ELSE RTEEIAllInvEEIPOEEIMC END) as RTEEIAllInvEEIPOEEIMC,
				(CASE WHEN RTEEIInvEEHOrderEEIMC<0 THEN 0 ELSE RTEEIInvEEHOrderEEIMC END) as RTEEIInvEEHOrderEEIMC,
				(CASE WHEN RTEEIAllInvEEHOrderEEIMC<0 THEN 0 ELSE RTEEIAllInvEEHOrderEEIMC END) as RTEEIAllInvEEHOrderEEIMC,

				(CASE WHEN RTEEIInvEEIPOEEHMC<0 THEN 0 ELSE RTEEIInvEEIPOEEHMC END) as RTEEIInvEEIPOEEHMC,
				(CASE WHEN RTEEIAllInvEEIPOEEHMC<0 THEN 0 ELSE RTEEIAllInvEEIPOEEHMC END) as RTEEIAllInvEEIPOEEHMC,
				(CASE WHEN RTEEIInvEEHOrderEEHMC<0 THEN 0 ELSE RTEEIInvEEHOrderEEHMC END) as RTEEIInvEEHOrderEEHMC,
				(CASE WHEN RTEEIAllInvEEHOrderEEHMC<0 THEN 0 ELSE RTEEIAllInvEEHOrderEEHMC END) as RTEEIAllInvEEHOrderEEHMC
				/*(CASE WHEN (RunningTotal*Cost)<=0 THEN 0 ELSE RunningTotal*Cost END) as EEII_EEIMAtCum,
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
		(CASE WHEN (EEHBasePartRunningTotalAll*EEHPartMaterialCUM)<=0 THEN 0 ELSE EEHBasePartRunningTotalAll*EEHPartMaterialCUM END) as EEHIA_BP_EEHMatCUM,*/

from		#WeeklyReq WeeklyReq

end
GO
