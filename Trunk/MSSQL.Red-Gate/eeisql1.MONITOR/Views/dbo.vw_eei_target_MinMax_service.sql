SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_target_MinMax_service]
as
select	BasePartSales,
		Ceiling((BasePartQty/8.6)/StdPack)*StdPack as AvgWeeklyDemand,
		ceiling(Inventory/(CASE WHEN (Ceiling((BasePartQty/60)/StdPack)*StdPack)= 0 THEN 1 ELSE (Ceiling((BasePartQty/60)/StdPack)*StdPack) END )) as DaysOnHand,
		BasePart,
		Sales,
		PercentofTotalSales,
		AccumulativePercent,
		(CASE WHEN isNULL(MinDaysFixed,0) >0 THEN MindaysFixed WHEN AccumulativePercent <= 30 THEN 7 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 10 ELSE 13 END) as MINTargetDays,
		(CASE WHEN isNULL(MaxDaysFixed,0) >0 THEN MaxDaysFixed WHEN AccumulativePercent <= 30 THEN 8 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 15 ELSE 18 END) as MAXTargetDays,
		Ceiling(isNULL((CASE WHEN AccumulativePercent <= 30 THEN (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MinDaysFixed,0) >0 THEN MindaysFixed WHEN AccumulativePercent <= 30 THEN 7 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 10 ELSE 13 END))) WHEN  (AccumulativePercent >30 and AccumulativePercent<=90) THEN (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MinDaysFixed,0) >0 THEN MindaysFixed WHEN AccumulativePercent <= 30 THEN 7 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 10 ELSE 13 END))) ELSE (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MinDaysFixed,0) >0 THEN MindaysFixed WHEN AccumulativePercent <= 30 THEN 7 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 10 ELSE 13 END))) END),0)/ StdPack)*StdPack as MinTarget,
		Ceiling(isNULL((CASE WHEN AccumulativePercent <= 30 THEN (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MaxDaysFixed,0) >0 THEN MaxDaysFixed WHEN AccumulativePercent <= 30 THEN 8 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 15 ELSE 18 END))) WHEN  (AccumulativePercent >30 and AccumulativePercent<=90) THEN (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MaxDaysFixed,0) >0 THEN MaxDaysFixed WHEN AccumulativePercent <= 30 THEN 8 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 15 ELSE 18 END))) ELSE (Select sum(quantity) from order_detail where substring(part_number, 1, (PATINDEX( '%-%',part_number))-1)= BasePart and due_date> '2000-01-01' and due_date<= [dbo].[fnDateaftinWeekdays](getdate(), (CASE WHEN isNULL(MaxDaysFixed,0) >0 THEN MaxDaysFixed WHEN AccumulativePercent <= 30 THEN 8 WHEN (AccumulativePercent >30 and AccumulativePercent<=90) THEN 15 ELSE 18 END))) END),0)/StdPack)*StdPack as MAXTarget,
		StdPack,
		Inventory,
		Team,
		CustomerCode,
		Scheduler,
		UnitCostAccum
		
from	vw_eei_Target_forcasted_sales_accumulativepercent_service
GO
