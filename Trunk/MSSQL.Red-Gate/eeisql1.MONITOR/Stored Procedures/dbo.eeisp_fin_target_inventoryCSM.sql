SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
execute	eeisp_fin_target_inventoryCSM
	@ServiceFlag = 'Y',
	@WeeksDemand = 4,
	@DynamicMinMax = 'Y'

select	CostOfPart, cost, *
from	eei_finished_goods_targetCSM

*/

CREATE procedure [dbo].[eeisp_fin_target_inventoryCSM]
(	@ServiceFlag char(1),
	@WeeksDemand numeric (20,6),
	@DynamicMinMax char(1))
as
begin transaction

delete	eei_finished_goods_targetCSM

create table #appinventory
(	part varchar(25),
	approved numeric(20,6))

create table #nonappinventory
(	part varchar(25),
	nonapproved numeric(20,6))

insert	#appinventory
select	object.part,
	sum (quantity)
from	object
	join part on object.part = part.part
	join location on object.location = location.code
where	object.status = 'A' and
	part.class = 'P' and
	part.type = 'F' and
	location.plant in ('EEI', 'INTRANSIT', 'INTRANSIT2')
group by
	object.part

insert	#nonappinventory
select	object.part,
	sum (quantity)
from	object
	join part on object.part = part.part
	join location on object.location = location.code
where	object.status <> 'A' and
	part.class = 'P' and
	part.type = 'F' and
	location.plant in ('EEI', 'INTRANSIT', 'INTRANSIT2')
group by
	object.part

insert	eei_finished_goods_targetCSM
select	basepart,
	part,
	team_no,
	customer_group,
	customer_code,
	scheduler,
	CostOfPart,
	min_oh,
	max_oh,
	approved_inv,
	nonapproved_inv,
	standard_pack,
	total_inventory,
	avg_weekly_demand,
	target_variance =
	case	when total_inventory > min_oh and total_inventory < max_oh then 0
		when total_inventory < min_oh then total_inventory - min_oh
		else total_inventory - max_oh
	end,
	NextCSMMonth,
	FollowingCSMMonth,
	CSMAvgWeekly
from	(	select	basepart,
			part,
			team_no,
			customer_group,
			customer_code,
			scheduler,
			CostOfPart,
			min_oh =
			case	when @DynamicMinMax = 'Y' then avg_weekly_demand * 1.5
				else IsNull (min_onhand, 0)
			end,
			max_oh =
			case	when @DynamicMinMax = 'Y' then avg_weekly_demand * 3
				else IsNull (max_onhand, 0)
			end,
			approved_inv,
			nonapproved_inv,
			standard_pack,
			total_inventory = approved_inv + nonapproved_inv,
			avg_weekly_demand,
			NextCSMMonth,
			FollowingCSMMonth = dateadd (mm, 2, NextCSMMonth),
			CSMAvgWeekly =
			(	select	sum (PartsPerProgram*TakeRate*allocation*units)
				from	csmprogrameeipart
					join csmMnemonicSales on csmprogrameeipart.CSMprogram = csmMnemonicSales.program and
						csmprogrameeipart.CSMnemonic=csmMnemonicSales.Mnemonic
				where	csmprogrameeipart.PART = part and
					CurrentRevLevel = 'Y' and
					salesperiod >= NextCSMMonth and salesperiod < dateadd (mm, 2, NextCSMMonth)) / 8
		from	(	select	basepart =
					case	when patindex('%-%',part.part) < 6 then part.part
	 					else substring(part.part,1,patindex('%-%',part.part)-1)
					end,
					part.part,
					part_eecustom.team_no,
					part_eecustom.CurrentRevLevel,
					customer_group = IsNull (
					(	select	max (custom2)
						from	customer,
							part_customer
						where	part_customer.part = part.part and
							part_customer.customer = customer.customer and
							part_customer.customer not in ('EEH', 'EEI')), '_ Customer Group Not Specified'),
					customer_code = IsNull (
					(	select	max (customer)
						from	part_customer
						where	part_customer.part = part.part and
							part_customer.customer not in ('EEH', 'EEI')), '_ Customer not specified for part'),
					scheduler = IsNull (
					(	select	max (scheduler)
						from	destination,
							part_customer
						where	part_customer.part = part.part and
							part_customer.customer not in ('EEH', 'EEI') and
							part_customer.customer = destination.customer), '_ Scheduler not specified'),
					CostOfPart =
					(	select	max (part_standard.Cost_cum)
						from	part_standard,
							part_eecustom peecustom2
						where	peecustom2.part = part_standard.part and
							peecustom2.part = part_eecustom.part and
							IsNull (peecustom2.currentrevlevel, 'N') = 'Y'),
					part_online.min_onhand,
					part_online.max_onhand,
					approved_inv = IsNull (#appinventory.approved,0),
					nonapproved_inv = IsNull (#nonappinventory.nonapproved,0),
					part_inventory.standard_pack,
					avg_weekly_demand= IsNull (
					(	select	sum (order_detail.quantity)
						from	order_detail
						where	part_number = part.part and
							order_detail.quantity > 1 and
							order_detail.due_date <= dateadd(wk, @WeeksDemand, getdate ())) / @WeeksDemand, 1),
					NextCSMMonth =
					(	select	min (SalesPeriod)
						from	csmprogrameeipart
							join csmMnemonicSales on csmprogrameeipart.CSMprogram = csmMnemonicSales.program and
								csmprogrameeipart.CSMnemonic = csmMnemonicSales.Mnemonic
						where	csmprogrameeipart.part = part_eecustom.part and
							part_eecustom.CurrentRevLevel = 'Y' and
							salesperiod > getdate ())
				from	part
					join part_eecustom on part.part = part_eecustom.part
					join part_inventory on part.part = part_inventory.part
					join part_online on part.part = part_online.part
					join part_standard on part.part = part_standard.part
					left outer join #nonappinventory on part.part = #nonappinventory.part
					left outer join #appinventory on part.part = #appinventory.part
				where	part.class = 'P' and
					part.type = 'F' and
					part.part not like '%PT' and
					IsNull (servicePart, 'N') = @ServiceFlag and
					IsNull (part_eecustom.prod_start, getdate ()) <= getdate ()) eei_finished_goods_targetCSM) eei_finished_goods_targetCSM
order by
	2,3,4,1

drop table #appinventory
drop table #nonappinventory

commit

select	team_no,
	basepart,
	customergroup,
	planner,
	partstdcost,
	Kmin,
	Kmax,
	Total_inventory,
	avgweeklydemand,
	pos_variance,
	neg_variance,
	pos_percentVariance =
	case	when pos_variance > 0 and Kmax > 0 then pos_variance / Kmax
		else 0
	end * 100,
	neg_percentVariance =
	case	when neg_variance < 0 and Kmin > 0 then neg_variance / Kmin
		else 0
	end * 100,
	std_pack,
	service_inventory_flag,
	CSMMonthOne,
	CSMMonthTwo,
	CSMWeeklyAvg
from	(	select	team_no,
			basepart,
			customergroup,
			planner = max (scheduler),
			partstdcost = max (cost),
			Kmin = max ([min]),
			Kmax = max ([max]),
			Total_inventory = sum (total_inv),
			avgweeklydemand =
			case	when max (avgweeklydemand) = 0 then 1
				else max (avgweeklydemand)
			end,
			pos_variance =
			case	when sum (total_inv) > max ([max]) then sum (total_inv) - max ([max])
				else 0
			end,
			neg_variance =
			case	when sum (total_inv) < max ([min]) then sum (total_inv) - max ([min])
					else 0
			end,
			std_pack = max (std_Pack),
			service_inventory_flag =
			case	when sum (total_inv) > 0 and @ServiceFlag = 'Y' then 1
				when sum (total_inv) >= 0 and @ServiceFlag = 'N' then 1
				else 0
			end,
			CSMMonthOne = max (CSMMonthOne),
			CSMMonthTwo = max (CSMMonthTwo),
			CSMWeeklyAvg = min (CSMWeeklyAvg)
		from	eei_finished_goods_targetCSM
		group by
			team_no,
			basepart,
			customergroup) eei_finished_goods_targetCSM
order by
	1,2
GO
