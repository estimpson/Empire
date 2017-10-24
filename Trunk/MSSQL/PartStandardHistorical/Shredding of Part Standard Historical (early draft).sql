use tempdb
go

/*
drop table dbo.PSH_Headers

select
	RowID = identity(int)
,	TranDT = psh.time_stamp
,	FY = datepart(year, psh.time_stamp)
,	Period = datepart(month, psh.time_stamp)
,	Reason = psh.reason
into
	dbo.PSH_Headers
from
	EEH.dbo.part_standard_historical psh
group by
	psh.time_stamp
,	psh.reason
order by
	psh.time_stamp

create index ix_PSH_Headers_1 on dbo.PSH_Headers(TranDT, RowID)
*/

declare
	@PH_RowID1 int = 1
,	@PH_RowID2 int = 2

select
	IUD = case when psh1.part is null then 'I' when psh2.part is null then 'D' else 'U' end
,	time_stamp = coalesce(psh1.time_stamp, psh2.time_stamp)
,	fiscal_year = coalesce(psh1.fiscal_year, psh2.fiscal_year)
,	period = coalesce(psh1.period, psh2.period)
,	reason = coalesce(psh1.reason, psh2.reason)
,	part = coalesce(psh1.part, psh2.part)
,	price = coalesce(psh1.price, psh2.price)
,	cost = coalesce(psh1.cost, psh2.cost)
,	account_number = coalesce(psh1.account_number, psh2.account_number)
,	material = coalesce(psh1.material, psh2.material)
,	labor = coalesce(psh1.labor, psh2.labor)
,	burden = coalesce(psh1.burden, psh2.burden)
,	other = coalesce(psh1.other, psh2.other)
,	cost_cum = coalesce(psh1.cost_cum, psh2.cost_cum)
,	material_cum = coalesce(psh1.material_cum, psh2.material_cum)
,	burden_cum = coalesce(psh1.burden_cum, psh2.burden_cum)
,	other_cum = coalesce(psh1.other_cum, psh2.other_cum)
,	labor_cum = coalesce(psh1.labor_cum, psh2.labor_cum)
,	flag = coalesce(psh1.flag, psh2.flag)
,	premium = coalesce(psh1.premium, psh2.premium)
,	qtd_cost = coalesce(psh1.qtd_cost, psh2.qtd_cost)
,	qtd_material = coalesce(psh1.qtd_material, psh2.qtd_material)
,	qtd_labor = coalesce(psh1.qtd_labor, psh2.qtd_labor)
,	qtd_burden = coalesce(psh1.qtd_burden, psh2.qtd_burden)
,	qtd_other = coalesce(psh1.qtd_other, psh2.qtd_other)
,	qtd_cost_cum = coalesce(psh1.qtd_cost_cum, psh2.qtd_cost_cum)
,	qtd_material_cum = coalesce(psh1.qtd_material_cum, psh2.qtd_material_cum)
,	qtd_labor_cum = coalesce(psh1.qtd_labor_cum, psh2.qtd_labor_cum)
,	qtd_burden_cum = coalesce(psh1.qtd_burden_cum, psh2.qtd_burden_cum)
,	qtd_other_cum = coalesce(psh1.qtd_other_cum, psh2.qtd_other_cum)
,	planned_cost = coalesce(psh1.planned_cost, psh2.planned_cost)
,	planned_material = coalesce(psh1.planned_material, psh2.planned_material)
,	planned_labor = coalesce(psh1.planned_labor, psh2.planned_labor)
,	planned_burden = coalesce(psh1.planned_burden, psh2.planned_burden)
,	planned_other = coalesce(psh1.planned_other, psh2.planned_other)
,	planned_cost_cum = coalesce(psh1.planned_cost_cum, psh2.planned_cost_cum)
,	planned_material_cum = coalesce(psh1.planned_material_cum, psh2.planned_material_cum)
,	planned_labor_cum = coalesce(psh1.planned_labor_cum, psh2.planned_labor_cum)
,	planned_burden_cum = coalesce(psh1.planned_burden_cum, psh2.planned_burden_cum)
,	planned_other_cum = coalesce(psh1.planned_other_cum, psh2.planned_other_cum)
,	frozen_cost = coalesce(psh1.frozen_cost, psh2.frozen_cost)
,	frozen_material = coalesce(psh1.frozen_material, psh2.frozen_material)
,	frozen_burden = coalesce(psh1.frozen_burden, psh2.frozen_burden)
,	frozen_labor = coalesce(psh1.frozen_labor, psh2.frozen_labor)
,	frozen_other = coalesce(psh1.frozen_other, psh2.frozen_other)
,	frozen_cost_cum = coalesce(psh1.frozen_cost_cum, psh2.frozen_cost_cum)
,	frozen_material_cum = coalesce(psh1.frozen_material_cum, psh2.frozen_material_cum)
,	frozen_burden_cum = coalesce(psh1.frozen_burden_cum, psh2.frozen_burden_cum)
,	frozen_labor_cum = coalesce(psh1.frozen_labor_cum, psh2.frozen_labor_cum)
,	frozen_other_cum = coalesce(psh1.frozen_other_cum, psh2.frozen_other_cum)
,	cost_changed_date = coalesce(psh1.cost_changed_date, psh2.cost_changed_date)
,	qtd_changed_date = coalesce(psh1.qtd_changed_date, psh2.qtd_changed_date)
,	planned_changed_date = coalesce(psh1.planned_changed_date, psh2.planned_changed_date)
,	frozen_changed_date = coalesce(psh1.frozen_changed_date, psh2.frozen_changed_date)
,	LastUser = coalesce(psh1.LastUser, psh2.LastUser)
,	LastChangeOfCost = coalesce(psh1.LastChangeOfCost, psh2.LastChangeOfCost)
from
	(	select
			*
		from
			EEH.dbo.part_standard_historical psh
		where
			psh.time_stamp = (select TranDT from dbo.PSH_Headers where RowID = @PH_RowID1)
	) psh1
	full join
	(	select
			*
		from
			EEH.dbo.part_standard_historical psh
		where
			psh.time_stamp = (select TranDT from dbo.PSH_Headers where RowID = @PH_RowID2)
	) psh2
	on psh2.part = psh1.part
where
	coalesce
	(	binary_checksum
		(	psh2.part
		,	psh2.price
		,	psh2.cost
		,	psh2.account_number
		,	psh2.material
		,	psh2.labor
		,	psh2.burden
		,	psh2.other
		,	psh2.cost_cum
		,	psh2.material_cum
		,	psh2.burden_cum
		,	psh2.other_cum
		,	psh2.labor_cum
		,	psh2.flag
		,	psh2.premium
		,	psh2.qtd_cost
		,	psh2.qtd_material
		,	psh2.qtd_labor
		,	psh2.qtd_burden
		,	psh2.qtd_other
		,	psh2.qtd_cost_cum
		,	psh2.qtd_material_cum
		,	psh2.qtd_labor_cum
		,	psh2.qtd_burden_cum
		,	psh2.qtd_other_cum
		,	psh2.planned_cost
		,	psh2.planned_material
		,	psh2.planned_labor
		,	psh2.planned_burden
		,	psh2.planned_other
		,	psh2.planned_cost_cum
		,	psh2.planned_material_cum
		,	psh2.planned_labor_cum
		,	psh2.planned_burden_cum
		,	psh2.planned_other_cum
		,	psh2.frozen_cost
		,	psh2.frozen_material
		,	psh2.frozen_burden
		,	psh2.frozen_labor
		,	psh2.frozen_other
		,	psh2.frozen_cost_cum
		,	psh2.frozen_material_cum
		,	psh2.frozen_burden_cum
		,	psh2.frozen_labor_cum
		,	psh2.frozen_other_cum
		,	psh2.qtd_changed_date
		,	psh2.planned_changed_date
		,	psh2.frozen_changed_date
		,	psh2.LastUser
		,	psh2.LastChangeOfCost
		)
	,	-1
	) != coalesce
	(	binary_checksum
		(	psh1.part
		,	psh1.price
		,	psh1.cost
		,	psh1.account_number
		,	psh1.material
		,	psh1.labor
		,	psh1.burden
		,	psh1.other
		,	psh1.cost_cum
		,	psh1.material_cum
		,	psh1.burden_cum
		,	psh1.other_cum
		,	psh1.labor_cum
		,	psh1.flag
		,	psh1.premium
		,	psh1.qtd_cost
		,	psh1.qtd_material
		,	psh1.qtd_labor
		,	psh1.qtd_burden
		,	psh1.qtd_other
		,	psh1.qtd_cost_cum
		,	psh1.qtd_material_cum
		,	psh1.qtd_labor_cum
		,	psh1.qtd_burden_cum
		,	psh1.qtd_other_cum
		,	psh1.planned_cost
		,	psh1.planned_material
		,	psh1.planned_labor
		,	psh1.planned_burden
		,	psh1.planned_other
		,	psh1.planned_cost_cum
		,	psh1.planned_material_cum
		,	psh1.planned_labor_cum
		,	psh1.planned_burden_cum
		,	psh1.planned_other_cum
		,	psh1.frozen_cost
		,	psh1.frozen_material
		,	psh1.frozen_burden
		,	psh1.frozen_labor
		,	psh1.frozen_other
		,	psh1.frozen_cost_cum
		,	psh1.frozen_material_cum
		,	psh1.frozen_burden_cum
		,	psh1.frozen_labor_cum
		,	psh1.frozen_other_cum
		,	psh1.qtd_changed_date
		,	psh1.planned_changed_date
		,	psh1.frozen_changed_date
		,	psh1.LastUser
		,	psh1.LastChangeOfCost
		)
	,	-1
	)

select
	*
from
	EEH.dbo.part_standard_historical psh
where
	psh.time_stamp in (select TranDT from dbo.PSH_Headers where RowID in (@PH_RowID1, @PH_RowID2))
	and psh.part = 'ALC0001-HA00'