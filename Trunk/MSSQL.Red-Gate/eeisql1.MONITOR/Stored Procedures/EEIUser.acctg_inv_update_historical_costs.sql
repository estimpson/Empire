SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_inv_update_historical_costs] @part varchar(25), @time_stamp datetime

-- Created by: DW 2016-10-10 09:30 
-- Dependency:  None 
-- Use: This procedure is called manually to update the part_standard_historical and part_standard_historical_daily tables after correcting the current part_standard 
-- An example would be after rolling up a bulbed part; you can call this procedure to update the historical tables to make such change retroactive to a certain date.

-- exec eeiuser.acctg_inv_update_historical_costs 'NAL1029-AC03', '2016-09-01 00:00:00'

as
begin

declare @a table 
(
  part varchar(25)
, price decimal(18,6)
, material decimal(18,6)
, labor decimal(18,6)
, burden decimal(18,6)
, other decimal(18,6)
, cost decimal(18,6)
, material_cum decimal(18,6)
, labor_cum decimal(18,6)
, burden_cum decimal(18,6)
, other_cum decimal(18,6)
, cost_cum decimal(18,6)
, frozen_material_cum decimal(18,6)
)

insert into @a
select part, price, material, labor, burden, other, cost, material_cum, labor_cum, burden_cum, other_cum, cost_cum, frozen_material_cum from part_standard where part = @part

update b
set b.price = a.price,
	b.material = a.material,
	b.labor = a.labor,
	b.burden = a.burden,
	b.other = a.other,
	b.cost = a.cost,
	b.material_cum = a.material_cum,
	b.labor_cum = a.labor_cum,
	b.burden_cum = a.burden_cum,
	b.other_cum = a.other_cum,
	b.cost_cum = a.cost_cum,
	b.frozen_material_cum = a.frozen_material_cum
from historicaldata.dbo.part_standard_historical b
join @a a on b.part = a.part
where b.time_stamp >= @time_stamp
and b.part = @part

update b
set b.price = a.price,
	b.material = a.material,
	b.labor = a.labor,
	b.burden = a.burden,
	b.other = a.other,
	b.cost = a.cost,
	b.material_cum = a.material_cum,
	b.labor_cum = a.labor_cum,
	b.burden_cum = a.burden_cum,
	b.other_cum = a.other_cum,
	b.cost_cum = a.cost_cum,
	b.frozen_material_cum = a.frozen_material_cum
from historicaldata.dbo.part_standard_historical_daily b
join @a a on b.part = a.part
where b.time_stamp >= @time_stamp
and b.part = @part

end



GO
