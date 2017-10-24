SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure	[dbo].[eeisp_rpt_material_cum_change] ( @evaluatedate datetime )
as

begin

declare	@daypriortimestamp	datetime,
		@daytimestamp		datetime

Select	@daypriortimestamp =	(Select max(time_stamp) from part_standard_historical where time_stamp < @evaluatedate)
Select	@daytimestamp =		(Select min(time_stamp) from part_standard_historical where time_stamp > @evaluatedate)
	

Select	newcost.material_cum,
		priorcost.material_cum,
		inventory.std_quantity,
		inventory.serial,
		inventory.part,
		inventory.location,
		newcost.material_cum-priorcost.material_cum as material_cum_diff,
		(newcost.material_cum-priorcost.material_cum)*inventory.std_quantity as material_cum_diff_extended
from		(Select	serial,
				part,
				std_quantity,
				location
		from		object_historical_daily
		where	time_stamp = @daypriortimestamp)  inventory
join		(Select	material_cum,
				part
		from		part_standard_historical_daily
		where	time_stamp = @daypriortimestamp) priorCost on inventory.part = priorcost.part
join		(Select	material_cum,
				part
		from		part_standard_historical_daily
		where	time_stamp = @daytimestamp) newCost on inventory.part = newcost.part
where	newcost.material_cum != priorcost.material_cum

end
GO
