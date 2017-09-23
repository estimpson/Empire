SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE	procedure [dbo].[eeisp_rpt_eeiQtyforecast_CSMProgramDistribution]

as

Begin

Declare		@PriorMonth	datetime,
			@Month0		datetime,
			@Month1		datetime,
			@Month2		datetime,
			@Month3		datetime,
			@Month4		datetime,
			@Month5		datetime,
			@Month6		datetime,
			@Month7		datetime,
			@Month8		datetime,
			@Month9		datetime,
			@Month10	datetime,
			@Month11	datetime,
			@Month12	datetime,
			@Month13	datetime,
			@Month14	datetime,
			@Month15	datetime,	
			@Month16	datetime,
			@Month17	datetime,
			@Month18	datetime

Select		@Month0 = ft.fn_truncdate('mm', getdate())
Select		@PriorMonth = dateadd(mm,-1, @Month0)
Select		@Month1 = dateadd(mm,1, @Month0)
Select		@Month2 = dateadd(mm,2, @Month0)
Select		@Month3 = dateadd(mm,3, @Month0)
Select		@Month4 = dateadd(mm,4, @Month0)
Select		@Month5 = dateadd(mm,5, @Month0)
Select		@Month6 = dateadd(mm,6, @Month0)
Select		@Month7 = dateadd(mm,7, @Month0)
Select		@Month8 = dateadd(mm,8, @Month0)
Select		@Month9 = dateadd(mm,9, @Month0)
Select		@Month10 = dateadd(mm,10, @Month0)
Select		@Month11 = dateadd(mm,11, @Month0)
Select		@Month12 = dateadd(mm,12, @Month0)
Select		@Month13 = dateadd(mm,13, @Month0)
Select		@Month14 = dateadd(mm,14, @Month0)
Select		@Month15 = dateadd(mm,15, @Month0)
Select		@Month16 = dateadd(mm,16, @Month0)
Select		@Month17 = dateadd(mm,17, @Month0)




			

Create	table #MonthlyForecastandHistory (	BasePart varchar(25),
									MonthDue Datetime,
									Qty numeric(20,6),
									Extended numeric(20,6))
									
Create	table #MonthlySales (		BasePart varchar(25),
									MonthDue Datetime,
									Qty numeric(20,6),
									Extended numeric(20,6))
									
									
Insert	#MonthlyForecastandHistory

Select	BasePart,
		ft.fn_truncdate('mm', date_due) as MonthDue,
		sum(qty_projected) as Qty,
		sum(Extended) as Extended
from	vw_eei_sales_forecast
where	date_due> dateadd(wk,-4, getdate())
group by BasePart,
		ft.fn_truncdate('mm', date_due)
		
UNION	ALL		
Select	BasePart,
		ft.fn_truncdate('mm', date_shipped) as MonthDue,
		sum(qty_shipped) as Qty,
		sum(Extended) as Extended
from	vw_eei_sales_history
where	date_shipped>= @PriorMonth
group by	BasePart,
			ft.fn_truncdate('mm', date_shipped)
			
Insert	#MonthlySales
Select	BasePart,
		MonthDue,
		Sum(Qty),
		Sum(Extended)
from	#MonthlyForecastandHistory
group	by BasePart,
		MonthDue
		
Truncate table BasePartCSMPlantProgramBadgeNamePlateDistribution
Insert	BasePartCSMPlantProgramBadgeNamePlateDistribution
Select	*

from	vw_eei_BasePartCSMPlantProgramBadgeNamePlateDistribution

		
--drop table 	DistributedForeCast	
Truncate table DistributedForeCast
INSERT INTO [MONITOR].[dbo].[DistributedForeCast]
			([Customer]
           ,[base_part]
           ,[EmpireSOP]
           ,[EmpireEOP]
           ,[CSMSOP]
           ,[CSMEOP]
           ,[Customerpart]
           ,[empire_market_segment]
           ,[empire_application]
           ,[AssemblyPlant]
           ,[Program]
           ,[Badge]
           ,[NamePlate]
           ,[Dec09DistributedQty]
           ,[Dec09DistributedDollars]
           ,[Jan10DistributedQty]
           ,[Jan10DistributedDollars]
           ,[Feb10DistributedQty]
           ,[Feb10DistributedDollars]
           ,[Mar10DistributedQty]
           ,[Mar10DistributedDollars]
           ,[Apr10DistributedQty]
           ,[Apr10DistributedDollars]
           ,[May10DistributedQty]
           ,[May10DistributedDollars]
           ,[Jun10DistributedQty]
           ,[Jun10DistributedDollars]
           ,[Jul10DistributedQty]
           ,[Jul10DistributedDollars]
           ,[Aug10DistributedQty]
           ,[Aug10DistributedDollars]
           ,[Sep10DistributedQty]
           ,[Sep10DistributedDollars]
           ,[Oct10DistributedQty]
           ,[Oct10DistributedDollars]
           ,[Nov10DistributedQty]
           ,[Nov10DistributedDollars]
           ,[Dec10DistributedQty]
           ,[Dec10DistributedDollars]
           ,[Jan11DistributedQty]
           ,[Jan11DistributedDollars]
           ,[Feb11DistributedQty]
           ,[Feb11DistributedDollars]
           ,[Mar11DistributedQty]
           ,[Mar11DistributedDollars])
           		
Select	Customer,
		base_part,
		EmpireSOP,
		EmpireEOP,
		CSMSOP,
		CSMEOP,
		(select max(customer_part) 
			from	order_header
			where	order_no = (Select max(order_no) from order_header where left(Blanket_part,7) = base_part))Customerpart,
		empire_market_segment,
		empire_application,
		AssemblyPlant,
		Program,
		Badge,
		NamePlate,
		(Select (CASE WHEN Dec09CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Dec09Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @PriorMonth) as PriorMonthDistributedQty,
		(Select (CASE WHEN Dec09CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Dec09Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @PriorMonth) as PriorMonthDistributedDollars,
		(Select (CASE WHEN Jan10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Jan10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month0) as CurrentMonthDistributedQty,
		(Select (CASE WHEN Jan10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Jan10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month0) as CurrentMonthDistributedDollars,
		(Select (CASE WHEN Feb10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Feb10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month1) as Month1DistributedQty,
		(Select (CASE WHEN Feb10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Feb10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month1) as Month1DistributedDollars,
		(Select (CASE WHEN Mar10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Mar10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month2) as Month2DistributedQty,
		(Select (CASE WHEN Mar10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Mar10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month2) as Month2DistributedDollars,
		(Select (CASE WHEN Apr10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Apr10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month3) as Month3DistributedQty,
		(Select (CASE WHEN Apr10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Apr10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month3) as Month3DistributedDollars,
		(Select (CASE WHEN May10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*May10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month4) as Month4DistributedQty,
		(Select (CASE WHEN May10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*May10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month4) as Month4DistributedDollars,
		(Select	(CASE WHEN Jun10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Jun10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month5) as Month5DistributedQty,
		(Select (CASE WHEN Jun10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Jun10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month5) as Month5DistributedDollars,
		(Select (CASE WHEN Jul10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Jul10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month6) as Month6DistributedQty,
		(Select (CASE WHEN Jul10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Jul10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month6) as Month6DistributedDollars,
		(Select (CASE WHEN Aug10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Aug10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month7) as Month7DistributedQty,
		(Select (CASE WHEN Aug10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Aug10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month7) as Month7DistributedDollars,
		(Select (CASE WHEN Sep10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Sep10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month8) as Month8DistributedQty,
		(Select (CASE WHEN Sep10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Sep10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month8) as Month8DistributedDollars,		
		(Select (CASE WHEN Oct10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Oct10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month9) as Month9DistributedQty,
		(Select (CASE WHEN Oct10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Oct10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month9) as Month9DistributedDollars,
		(Select (CASE WHEN Nov10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Nov10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month10) as Month10DistributedQty,
		(Select (CASE WHEN Nov10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Nov10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month10) as Month10DistributedDollars,
		(Select (CASE WHEN Dec10CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Dec10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month11) as Month11DistributedQty,
		(Select (CASE WHEN Dec10CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Dec10Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month11) as Month11DistributedDollars,
		(Select (CASE WHEN Jan11CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Jan11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month12) as Month12DistributedQty,
		(Select (CASE WHEN Jan11CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Jan11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month12) as Month12DistributedDollars,
		(Select (CASE WHEN Feb11CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Feb11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month13) as Month13DistributedQty,
		(Select (CASE WHEN Feb11CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Feb11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month13) as Month13DistributedDollars,
		(Select (CASE WHEN Mar11CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Mar11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month14) as Month14DistributedQty,
		(Select (CASE WHEN Mar11CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Mar11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month14) as Month14DistributedDollars
	--	,(Select (CASE WHEN Apr11CSM = 0 then Qty*EvenCSMDistribution ELSE Qty*Apr11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month15) as Month15DistributedQty
	--	,(Select (CASE WHEN Apr11CSM = 0 then Extended*EvenCSMDistribution ELSE Extended*Apr11Dist END ) from #MonthlySales where BasePart = base_part and MonthDue = @Month15) as Month15DistributedDollars
		

		
From	(Select	*,
		1.00000/(	select	count(1) 
	from	BasePartCSMPlantProgramBadgeNamePlateDistribution D1 
	where	D1.Base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part)as EVENCSMDistribution,
		ceiling(isNull((select sum(Jul09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Jul09CSM,
		ceiling(isNull((select sum(Aug09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Aug09CSM,
		ceiling(isNull((select sum(Sep09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Sep09CSM,
		ceiling(isNull((select sum(Oct09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Oct09CSM,
		ceiling(isNull((select sum(Nov09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Nov09CSM,
		ceiling(isNull((select sum(Dec09Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Dec09CSM,
		ceiling(isNull((select sum(Jan10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Jan10CSM,
		ceiling(isNull((select sum(Feb10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Feb10CSM,
		ceiling(isNull((select sum(Mar10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Mar10CSM,
		ceiling(isNull((select sum(Apr10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Apr10CSM,
		ceiling(isNull((select sum(May10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as May10CSM,
		ceiling(isNull((select sum(Jun10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Jun10CSM,
		ceiling(isNull((select sum(Jul10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Jul10CSM,
		ceiling(isNull((select sum(Aug10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Aug10CSM,
		ceiling(isNull((select sum(Sep10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Sep10CSM,
		ceiling(isNull((select sum(Oct10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Oct10CSM,
		ceiling(isNull((select sum(Nov10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Nov10CSM,
		ceiling(isNull((select sum(Dec10Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Dec10CSM,
		ceiling(isNull((select sum(Jan11Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Jan11CSM,
		ceiling(isNull((select sum(Feb11Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Feb11CSM,
		ceiling(isNull((select sum(Mar11Dist) from  BasePartCSMPlantProgramBadgeNamePlateDistribution d2 where d2.base_part = BasePartCSMPlantProgramBadgeNamePlateDistribution.base_part),0)) as Mar11CSM
		
		
		
from	BasePartCSMPlantProgramBadgeNamePlateDistribution) aBasePartCSMPlantProgramBadgeNamePlateDistribution


	UNION 
		
Select	Left(part_eecustom.part,3) as Customer,
		Left(part_eecustom.part,7) as Part,
		NULL,
		NULL,
		NULL,
		NULL,
		max(customerpart) as CustomerPart,
		'No CSM Association',
		'No CSM Association',
		'No CSM Association',
		'No CSM Association',
		'No CSM Association',
		'No CSM Association',
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @PriorMonth) as PriorMonthDistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @PriorMonth) as PriorMonthDistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month0) as CurrentMonthDistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month0) as CurrentMonthDistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month1) as Month1DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month1) as Month1DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month2) as Month2DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month2) as Month2DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month3) as Month3DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month3) as Month3DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month4) as Month4DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month4) as Month4DistributedDollars,
		
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month5) as Month5DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month5) as Month5DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month6) as Month6DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month6) as Month6DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month7) as Month7DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month7) as Month7DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month8) as Month8DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month8) as Month8DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month9) as Month9DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month9) as Month9DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month10) as Month10DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month10) as Month10DistributedDollars,		
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month11) as Month11DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month11) as Month11DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month12) as Month12DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month12) as Month12DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month13) as Month13DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month13) as Month13DistributedDollars,
		(Select Qty*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month14) as Month14DistributedQty,
		(Select Extended*1 from #MonthlySales where BasePart = Left(part,7) and MonthDue = @Month14) as Month14DistributedDollars
	
from	(Select part, prod_end, prod_start, ( Select customer_part 
									from order_header 
									where order_no = (Select max(order_no) 
									from order_header where blanket_part = peec1.part )) CustomerPart from [dbo].[part_eecustom] peec1
			union
		 Select	part,prod_end, prod_start, ( Select customer_part 
									from order_header 
									where order_no = (Select max(order_no) 
									from order_header where blanket_part = peec2.part )) CustomerPart from [ES3_BK].[dbo].[part_eecustom] peec2) part_eecustom
where	Left(part,7) not in (Select base_part from dbo.BasePartCSMPlantProgramBadgeNamePlateDistribution) and
		Left(part,7)  in ( Select BasePart from #MonthlySales)
		group by Left(part_eecustom.part,3),
		Left(part_eecustom.part,7)

Create table #sop_eop
	( 
	   base_part varchar(25) primary key
	  ,sop datetime
	  ,eop datetime
	  ,csm_sop datetime
	  ,csm_eop datetime
	  ,empire_sop datetime
	  ,empire_eop datetime
	)
	  
	insert #sop_eop
	
	select		base_part, 
				min(isnull(csm_sop,empire_sop)) as sop, 
				max(isnull(csm_eop, empire_eop)) as eop, 
				min(csm_sop) as csm_sop, 
				max(csm_eop) as csm_eop, 
				min(empire_sop) as empire_sop, 
				max(empire_eop) as empire_eop 
				
	from		eeiuser.acctg_csm_vw_select_csmDemandwitheeiadjustments_dw3
	
	group by	base_part

		
UPDATE [MONITOR].[dbo].[DistributedForeCast] 
set csmsop = b.csm_sop, csmeop = b.csm_eop, empiresop = b.empire_sop, empireeop = b.empire_eop
from [MONITOR].[dbo].[DistributedForeCast] a left join #sop_eop b on a.base_part = b.base_part
		
		
		
		
Select	*
from	DistributedForeCast
			
		
End








GO
