SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_cost_change_by_part] (@startDT datetime,  @part varchar(25))
as
--eeisp_rpt_cost_change_by_part '2008/11/01', '19177533'
Begin
create table #DayCost (
		Id Int identity,
		Time_stamp datetime,
		Part varchar(25),
		Cost numeric(20,6),
		Material numeric(20,6),
		Labor numeric(20,6),
		burden numeric(20,6),
		other numeric(20,6),
		cost_cum numeric(20,6),
		Material_cum numeric(20,6),
		Labor_cum numeric(20,6),
		burden_cum numeric(20,6),
		other_cum numeric(20,6), Primary Key (id))
		
Insert	#DayCost (Time_stamp,
		Part,
		Cost,
		Material,
		Labor,
		burden,
		other,
		cost_cum,
		Material_cum,
		Labor_cum,
		burden_cum ,
		other_cum )
Select	Time_stamp,
		Part,
		Cost,
		Material,
		Labor,
		burden,
		other,
		cost_cum,
		Material_cum,
		Labor_cum,
		burden_cum ,
		other_cum from part_standard_historical_daily where time_stamp in (Select time_stamp  from part_standard_historical_daily where time_stamp>= @startDT) and part = @part
		order by time_stamp

create table #DayCost2 (
		Id Int identity,
		Time_stamp datetime,
		Part varchar(25),
		Cost numeric(20,6),
		Material numeric(20,6),
		Labor numeric(20,6),
		burden numeric(20,6),
		other numeric(20,6),
		cost_cum numeric(20,6),
		Material_cum numeric(20,6),
		Labor_cum numeric(20,6),
		burden_cum numeric(20,6),
		other_cum numeric(20,6), Primary Key (id))
		
Insert	#DayCost2 (Time_stamp,
		Part,
		Cost,
		Material,
		Labor,
		burden,
		other,
		cost_cum,
		Material_cum,
		Labor_cum,
		burden_cum ,
		other_cum )
Select	Time_stamp,
		Part,
		Cost,
		Material,
		Labor,
		burden,
		other,
		cost_cum,
		Material_cum,
		Labor_cum,
		burden_cum ,
		other_cum from part_standard_historical_daily where time_stamp in (Select time_stamp  from part_standard_historical_daily where time_stamp>=@startDT+1) and part = @part
		order by time_stamp

Select	dayCost.time_stamp,
		DayCost2.time_stamp,
		DayCost2.Part,
		DayCost.Cost,
		DayCost2.Cost Cost2,
		dayCost.Material ,
		dayCost2.Material Material2,
		dayCost.Labor,
		dayCost2.Labor Labor2,
		DayCost.burden,
		DayCost2.burden burden2,
		DayCost.other,
		DayCost2.other other2,
		DayCost.cost_cum,
		DayCost2.cost_cum cost_cum2,
		DayCost.Material_cum,
		DayCost2.Material_cum material_cum2,
		DayCost.Labor_cum,
		DayCost2.Labor_cum labor_cum2,
		DayCost.burden_cum ,
		DayCost2.burden_cum burden_cum2,
		DayCost.other_cum,
		DayCost2.other_cum other_cum2
		 
from		#DayCost2 dayCost2
left join	#DayCost DayCost on dayCost2.id = DayCost.id
where	(isNULL(dayCost.Cost_cum,0)!=isNULL(DayCost2.cost_cum,0)) or 
		(isNULL(dayCost.Material_cum,0)!=isNULL(DayCost2.Material_cum,0))
order by 1

end

GO
