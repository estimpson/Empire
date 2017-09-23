SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE	view [dbo].[vw_eei_BasePartCSMPlantProgramBadgeNamePlateDistribution]

as

Select	CUSTOMER,
		BP.Base_Part,
		BPAssemblyProgramBadgeVehicle.EmpireSOP,
		BPAssemblyProgramBadgeVehicle.EmpireEOP,
		CSMSOP,
		CSMEOP,
		Empire_market_segment,
		Empire_application,
		BPAssemblyProgramBadgeVehicle.AssemblyPlant as AssemblyPlant,
		BPAssemblyProgramBadgeVehicle.Program as Program,
		BPAssemblyProgramBadgeVehicle.Badge as Badge,
		BPAssemblyProgramBadgeVehicle.NamePlate as NamePlate,
		isNull((BPAssemblyProgramBadgeVehicle.Jan_09/nullif(BP.Jan_09,0)),0) as Jan09Dist,
		isNUll((BPAssemblyProgramBadgeVehicle.Feb_09/nullif(BP.Feb_09,0)),0) as Feb09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Mar_09/nullif(BP.Mar_09,0)),0) as Mar09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Apr_09/nullif(BP.Apr_09,0)),0)as Apr09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.May_09/nullif(BP.May_09,0)),0) as May09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jun_09/nullif(BP.Jun_09,0)),0) as Jun09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jul_09/nullif(BP.Jul_09,0)),0) as Jul09Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Aug_09/nullif(BP.Aug_09,0)),0)as Aug09Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Sep_09/nullif(BP.Sep_09,0)),0)as Sep09Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Oct_09/nullif(BP.Oct_09,0)),0)as Oct09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Nov_09/nullif(BP.Nov_09,0)),0)as Nov09Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Dec_09/nullif(BP.Dec_09,0)),0) as Dec09Dist,
		
		isNull((BPAssemblyProgramBadgeVehicle.Jan_10/nullif(BP.Jan_10,0)),0) as Jan10Dist,
		isNUll((BPAssemblyProgramBadgeVehicle.Feb_10/nullif(BP.Feb_10,0)),0) as Feb10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Mar_10/nullif(BP.Mar_10,0)),0) as Mar10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Apr_10/nullif(BP.Apr_10,0)),0)as Apr10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.May_10/nullif(BP.May_10,0)),0) as May10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jun_10/nullif(BP.Jun_10,0)),0) as Jun10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jul_10/nullif(BP.Jul_10,0)),0) as Jul10Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Aug_10/nullif(BP.Aug_10,0)),0)as Aug10Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Sep_10/nullif(BP.Sep_10,0)),0)as Sep10Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Oct_10/nullif(BP.Oct_10,0)),0)as Oct10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Nov_10/nullif(BP.Nov_10,0)),0)as Nov10Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Dec_10/nullif(BP.Dec_10,0)),0) as Dec10Dist,
		
		
		isNull((BPAssemblyProgramBadgeVehicle.Jan_11/nullif(BP.Jan_11,0)),0) as Jan11Dist,
		isNUll((BPAssemblyProgramBadgeVehicle.Feb_11/nullif(BP.Feb_11,0)),0) as Feb11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Mar_11/nullif(BP.Mar_11,0)),0) as Mar11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Apr_11/nullif(BP.Apr_11,0)),0)as Apr11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.May_11/nullif(BP.May_11,0)),0) as May11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jun_11/nullif(BP.Jun_11,0)),0) as Jun11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Jul_11/nullif(BP.Jul_11,0)),0) as Jul11Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Aug_11/nullif(BP.Aug_11,0)),0)as Aug11Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Sep_11/nullif(BP.Sep_11,0)),0)as Sep11Dist,
		isnull((BPAssemblyProgramBadgeVehicle.Oct_11/nullif(BP.Oct_11,0)),0)as Oct11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Nov_11/nullif(BP.Nov_11,0)),0)as Nov11Dist,
		isNull((BPAssemblyProgramBadgeVehicle.Dec_11/nullif(BP.Dec_11,0)),0) as Dec11Dist,
		
		(Select COALESCE(avg(alternate_price), avg(part_standard.price)) from part_standard left join order_detail on part_standard.part = order_detail.part_number where left( part, 7 )= BP.Base_Part and part not like '%-PT%' ) as AvgPrice
		
		
FROM		[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP]  BP
JOIN		[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_assemblyPlt_program_badge_nameplate] BPAssemblyProgramBadgeVehicle on BP.base_part =  BPAssemblyProgramBadgeVehicle.base_part
left join	[EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP_EmpireAdjust] BPEA on BP.base_part =  BPEA.base_part
left join	[dbo].[vw_CSM_basePartAudit] BPA on BP.Base_Part = BPA.Base_part and 
			BPAssemblyProgramBadgeVehicle.Program = BPA.Program and
			BPAssemblyProgramBadgeVehicle.AssemblyPlant = BPA.Assembly_Plant and
			BPAssemblyProgramBadgeVehicle.Badge = BPA.Badge and
			BPAssemblyProgramBadgeVehicle.NamePlate = BPA.NamePlate



GO
