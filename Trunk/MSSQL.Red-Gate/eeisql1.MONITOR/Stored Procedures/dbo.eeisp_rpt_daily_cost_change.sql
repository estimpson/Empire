SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure	[dbo].[eeisp_rpt_daily_cost_change] (@BegDate datetime, @EndDate  datetime, @partType varchar(1))

as
Begin

--Declare Variables 
declare	@datespan		int,
		@AdjBeginDT	datetime,
		@AdjEndDT	datetime

set	@AdjBeginDT =
	(	select	max (time_stamp)
		from	part_historical_daily
		where	time_stamp <= @BegDate)

set	@AdjEndDT =
	(	select	max (time_stamp)
		from	part_historical_daily
		where	time_stamp <= dateadd (ms, -2, @EndDate + 1))

declare @PartSetupDaily table
(	Part varchar (25),
	FromDT datetime,
	ToDT datetime,
	Type char (1) null,
	ProductLine varchar (25) null,
	CostMaterial numeric (20,6) null,
	CostLabor numeric(20,6) null,
	CostBurden numeric(20,6) null,
	primary key (Part, FromDT, ToDT))

declare @PartSetupDaily2 table
(	Part varchar (25),
	FromDT datetime,
	ToDT datetime,
	Type char (1) null,
	ProductLine varchar (25) null,
	CostMaterial numeric (20,6) null,
	CostLabor numeric(20,6) null,
	CostBurden numeric(20,6) null,
	primary key (Part, FromDT, ToDT))

insert	@PartSetupDaily
(	Part,
	Type,
	FromDT,
	ToDT,
	ProductLine,
	CostMaterial,
	CostLabor,
	CostBurden)
select	Part = DailyPart.Part,
	Type = DailyPart.Type,
	FromDT = DailyCost.DateStamp,
	ToDT =
	(	select	min (time_stamp)
		from	part_standard_historical_daily
		where	reason = 'DAILY' and
			time_stamp > DailyCost.DateStamp),
	ProductLine = DailyPart.ProductLine,
	CostMaterial = DailyCost.CostMaterial,
	CostLabor = DailyCost.CostLabor,
	CostBurden = DailyCost.CostBurden
from	(	select	Part = part,
			CostMaterial = material_cum,
			CostLabor = labor_cum,
			CostBurden = burden_cum,
			DateStamp = time_stamp
		from	part_standard_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
			reason = 'DAILY') DailyCost
	join
	(	select	Part = part,
			Type = type,
			ProductLine = product_line,
			DateStamp = time_stamp
		from	part_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
			reason = 'DAILY' and
			type = @PartType) DailyPart on DailyCost.Part = DailyPart.Part and
		DailyCost.DateStamp = DailyPart.DateStamp

insert	@PartSetupDaily2
(	Part,
	Type,
	FromDT,
	ToDT,
	ProductLine,
	CostMaterial,
	CostLabor,
	CostBurden)
select	Part = DailyPart.Part,
	Type = DailyPart.Type,
	FromDT = DailyCost.DateStamp,
	ToDT =
	(	select	min (time_stamp)
		from	part_standard_historical_daily
		where	reason = 'DAILY' and
			time_stamp > DailyCost.DateStamp),
	ProductLine = DailyPart.ProductLine,
	CostMaterial = DailyCost.CostMaterial,
	CostLabor = DailyCost.CostLabor,
	CostBurden = DailyCost.CostBurden
from	(	select	Part = part,
			CostMaterial = material_cum,
			CostLabor = labor_cum,
			CostBurden = burden_cum,
			DateStamp = time_stamp
		from	part_standard_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
			reason = 'DAILY') DailyCost
	join
	(	select	Part = part,
			Type = type,
			ProductLine = product_line,
			DateStamp = time_stamp
		from	part_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
			reason = 'DAILY' and
			type = @PartType) DailyPart on DailyCost.Part = DailyPart.Part and
		DailyCost.DateStamp = DailyPart.DateStamp

Select		DayOne.Part DayOnePart,
			DayOne.FromDT DayOneFromDT,
			DayOne.ToDT DayOneToDT,
			DayOne.Type DayOneType, 
			DayOne.ProductLine DayOneProductLine,
			DayOne.CostMaterial DayOneCostMaterial,
			DayOne.CostLabor DayOneCostLabor,
			DayOne.CostBurden DayOneCostBurden,
			DayTwo.Part DayTwoPart,
			DayTwo.FromDT DayTwoFromDT,
			DayTwo.ToDT DayTwoToDT,
			DayTwo.Type DayTwoType,
			DayTwo.ProductLine DayTwoProductLine,
			DayTWO.CostMaterial DayTWOCostMaterial,
			DayTwo.CostLabor DayTwoCostLabor,
			DayTwo.CostBurden DayTwoCostBurden,
			Inventory.StdQty 
from			@PartSetupDaily DayOne
Full Join		@PartSetupDaily2 DayTwo on DayOne.ToDT = DayTwo.FromDT and DayOne.Part = DayTwo.Part
left Join	(Select	part_historical_daily.time_stamp OHDTimeStamp,
				part_historical_daily.part	ObjectPart,
				sum(Std_quantity) StdQty
		from		object_historical_daily join part_historical_daily on object_historical_daily.part = part_historical_daily.part and object_historical_daily.time_stamp = part_historical_daily.time_stamp and part_historical_daily.type = @PartType
		where	part_historical_daily.time_stamp between @AdjBeginDT and @AdjEndDT and
				part_historical_daily.reason = 'DAILY' and user_defined_status not like 'PRESTOCK%'
		group by	part_historical_daily.part,
				part_historical_daily.time_stamp) Inventory on DayOne.ToDT  = Inventory.OHDTimeStamp and Inventory.ObjectPart = DayOne.Part
		
Where	(DayOne.CostMaterial!=DayTwo.CostMaterial) or
		(DayOne.CostLabor!=DayTwo.CostLabor) or
		(DayOne.CostBurden!=DayTwo.CostBurden) 
order by	DayOne.ToDT, 
		DayOne.Part

end
GO
