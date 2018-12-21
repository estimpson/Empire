SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_Web_SalesForecastUpdated_GetSalesForecastUpdated]
	@EopYear int
,	@Filter int -- 1=show all, 2=verified only, 3=non-verified only
as
set nocount on
set ansi_warnings off


--- <Body>
if (@Filter = 1) begin -- Show all

	with cte_BaseParts (BasePart)
	as
	(
		select
			sf.base_part as BasePart
		from
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			year(sf.empire_eop) = @EopYear
			or year(sf.mid_model_year) = @EopYear 
			or year(sf.CSM_eop) = @EopYear
		group by
			sf.base_part		
	)

	select
		row_number() over(order by sf.base_part) as RowId
	,	sf.status as Status
	,	sf.parent_customer as ParentCustomer
	,	sf.program as Program
	,	sf.vehicle as Vehicle
	,	sf.base_part as BasePart
	,	sf.empire_sop as EmpireSop
	,	sf.mid_model_year as MidModelYear
	,	sf.empire_eop as EmpireEop
	,	sf.empire_eop_note as EmpireEopNote
	,	sf.verified_eop as VerifiedEop
	,	sf.verified_eop_date as VerifiedEopDate
	,	sf.CSM_sop as CsmSop
	,	sf.CSM_eop as CsmEop
	,	sf.Cal_16_Sales as Sales2016
	,	sf.Cal_17_Sales as Sales2017
	,	sf.Cal_18_Sales as Sales2018
	,	sf.Cal_19_Sales as Sales2019
	,	sf.Cal_20_Sales as Sales2020
	,	sf.Cal_21_Sales as Sales2021
	,	sf.Cal_22_Sales as Sales2022
	,	sf.Cal_23_Sales as Sales2023
	,	sf.Cal_24_Sales as Sales2024
	,	sf.Cal_25_Sales as Sales2025
	,	b.SchedulerResponsible
	,	a.RfMpsLink
	,	a.SchedulingTeamComments
	,	a.MaterialsComments
	,	b.ShipToLocation
	,	a.FgInventoryAfterBuildout
	,	b.CostEach
	,	a.ExcessFgAfterBuildout
	,	a.ExcessRmAfterBuildout
	,	a.ProgramExposure
	,	a.DateToSendCoLetter
	,	a.ObsolescenceCost
	from
		eeiuser.acctg_csm_vw_select_sales_forecast sf
		join cte_BaseParts bp
			on bp.BasePart = sf.base_part
		outer apply 
			(	select
					*
				from
					eeiuser.BasePartCloseouts bpc
				where
					bpc.BasePart = sf.base_part ) a
		outer apply
			(	select
					FX.ToList(distinct convert(decimal(10,4), oh.price)) as CostEach
				,	FX.ToList(distinct od.destination) as ShipToLocation
				,	FX.ToList(distinct e.name) as SchedulerResponsible
				from 
					dbo.order_header oh
					join dbo.order_detail od
						on od.order_no = oh.order_no
					join dbo.destination d
						on d.destination = od.destination
					join dbo.employee e
						on e.operator_code = d.scheduler
				where
					left(oh.blanket_part, 7) = sf.base_part
					and oh.customer_po <> 'Samples' ) b
--	where
--		year(sf.empire_eop) = @EopYear
--		or year(sf.mid_model_year) = @EopYear 
--		or year(sf.CSM_eop) = @EopYear

end
else if (@Filter = 2) begin -- Show verified only

	with cte_BaseParts (BasePart)
	as
	(
		select
			sf.base_part as BasePart
		from
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			year(sf.verified_eop_date) = @EopYear
		group by
			sf.base_part		
	)

	select
		row_number() over(order by sf.base_part) as RowId
	,	sf.status as Status
	,	sf.parent_customer as ParentCustomer
	,	sf.program as Program
	,	sf.vehicle as Vehicle
	,	sf.base_part as BasePart
	,	sf.empire_sop as EmpireSop
	,	sf.mid_model_year as MidModelYear
	,	sf.empire_eop as EmpireEop
	,	sf.empire_eop_note as EmpireEopNote
	,	sf.verified_eop as VerifiedEop
	,	sf.verified_eop_date as VerifiedEopDate
	,	sf.CSM_sop as CsmSop
	,	sf.CSM_eop as CsmEop
	,	sf.Cal_16_Sales as Sales2016
	,	sf.Cal_17_Sales as Sales2017
	,	sf.Cal_18_Sales as Sales2018
	,	sf.Cal_19_Sales as Sales2019
	,	sf.Cal_20_Sales as Sales2020
	,	sf.Cal_21_Sales as Sales2021
	,	sf.Cal_22_Sales as Sales2022
	,	sf.Cal_23_Sales as Sales2023
	,	sf.Cal_24_Sales as Sales2024
	,	sf.Cal_25_Sales as Sales2025
	,	b.SchedulerResponsible
	,	a.RfMpsLink
	,	a.SchedulingTeamComments
	,	a.MaterialsComments
	,	b.ShipToLocation
	,	a.FgInventoryAfterBuildout
	,	b.CostEach
	,	a.ExcessFgAfterBuildout
	,	a.ExcessRmAfterBuildout
	,	a.ProgramExposure
	,	a.DateToSendCoLetter
	from
		eeiuser.acctg_csm_vw_select_sales_forecast sf
		join cte_BaseParts bp
			on bp.BasePart = sf.base_part
		outer apply 
			(	select
					*
				from
					eeiuser.BasePartCloseouts bpc
				where
					bpc.BasePart = sf.base_part ) a
		outer apply
			(	select
					FX.ToList(distinct convert(decimal(10,4), oh.price)) as CostEach
				,	FX.ToList(distinct od.destination) as ShipToLocation
				,	FX.ToList(distinct e.name) as SchedulerResponsible
				from 
					dbo.order_header oh
					join dbo.order_detail od
						on od.order_no = oh.order_no
					join dbo.destination d
						on d.destination = od.destination
					join dbo.employee e
						on e.operator_code = d.scheduler
				where
					left(oh.blanket_part, 7) = sf.base_part
					and oh.customer_po <> 'Samples' ) b
--	where
--		year(sf.verified_eop_date) = @EopYear

end
else if (@Filter = 3) begin -- Show non-verified only

	with cte_BaseParts (BasePart)
	as
	(
		select
			sf.base_part as BasePart
		from
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			sf.verified_eop_date is null
			and (
				year(sf.empire_eop) = @EopYear
				or year(sf.mid_model_year) = @EopYear 
				or year(sf.CSM_eop) = @EopYear )
		group by
			sf.base_part		
	)

	select
		row_number() over(order by sf.base_part) as RowId
	,	sf.status as Status
	,	sf.parent_customer as ParentCustomer
	,	sf.program as Program
	,	sf.vehicle as Vehicle
	,	sf.base_part as BasePart
	,	sf.empire_sop as EmpireSop
	,	sf.mid_model_year as MidModelYear
	,	sf.empire_eop as EmpireEop
	,	sf.empire_eop_note as EmpireEopNote
	,	sf.verified_eop as VerifiedEop
	,	sf.verified_eop_date as VerifiedEopDate
	,	sf.CSM_sop as CsmSop
	,	sf.CSM_eop as CsmEop
	,	sf.Cal_16_Sales as Sales2016
	,	sf.Cal_17_Sales as Sales2017
	,	sf.Cal_18_Sales as Sales2018
	,	sf.Cal_19_Sales as Sales2019
	,	sf.Cal_20_Sales as Sales2020
	,	sf.Cal_21_Sales as Sales2021
	,	sf.Cal_22_Sales as Sales2022
	,	sf.Cal_23_Sales as Sales2023
	,	sf.Cal_24_Sales as Sales2024
	,	sf.Cal_25_Sales as Sales2025
	,	b.SchedulerResponsible
	,	a.RfMpsLink
	,	a.SchedulingTeamComments
	,	a.MaterialsComments
	,	b.ShipToLocation
	,	a.FgInventoryAfterBuildout
	,	b.CostEach
	,	a.ExcessFgAfterBuildout
	,	a.ExcessRmAfterBuildout
	,	a.ProgramExposure
	,	a.DateToSendCoLetter
	from
		eeiuser.acctg_csm_vw_select_sales_forecast sf
		join cte_BaseParts bp
			on bp.BasePart = sf.base_part
		outer apply 
			(	select
					*
				from
					eeiuser.BasePartCloseouts bpc
				where
					bpc.BasePart = sf.base_part ) a
		outer apply
			(	select
					FX.ToList(distinct convert(decimal(10,4), oh.price)) as CostEach
				,	FX.ToList(distinct od.destination) as ShipToLocation
				,	FX.ToList(distinct e.name) as SchedulerResponsible
				from 
					dbo.order_header oh
					join dbo.order_detail od
						on od.order_no = oh.order_no
					join dbo.destination d
						on d.destination = od.destination
					join dbo.employee e
						on e.operator_code = d.scheduler
				where
					left(oh.blanket_part, 7) = sf.base_part
					and oh.customer_po <> 'Samples' ) b
--	where
--		sf.verified_eop_date is null
--		and (
--				year(sf.empire_eop) = @EopYear
--				or year(sf.mid_model_year) = @EopYear 
--				or year(sf.CSM_eop) = @EopYear )

end
--- </Body>
GO
