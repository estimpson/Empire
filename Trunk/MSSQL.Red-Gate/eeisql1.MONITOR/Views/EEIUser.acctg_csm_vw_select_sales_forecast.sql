SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select * from [EEIUser].[acctg_csm_vw_select_sales_forecast] where mc_last_updated = 'Current Cost 2018-10-08' and isnull(cal_19_TotalDemand,0) > 0 and isnull(cal_19_mc,0)=0


CREATE view [EEIUser].[acctg_csm_vw_select_sales_forecast]
as 

/* UPDATES:

   DAN WEST 11-04-2013
	Updated the view to use the new table structure eeiuser.acctg_csm_base_part_attributes

   DAN WEST 02-16-2017
	ROLLED OVER YEAR TO 2017, EXTENDED MONTHLY DETAIL TO 2019, ADDED YEAR 2024
   
   DAN WEST 01-30-2018
	ROLLED OVER YEAR TO 2018, EXTENDED MONTHLY DETAIL TO 2020, ADDED YEAR 2025


   DEPENDENCIES:

   Dependency in Monitor Database (EEH) dbo.eeisp_rpt_materials_CSM_RawPart_Demand...
*/


/* LEVEL 1 */



select	 cc.[base_part]

		,(case when pp.include = 0 then 'Post 9/18 Program' else 'Pre 9/18 Program' end) as award_category

		,zz.[family]
		,zz.[customer]
		,zz.[parent_customer]
		,zz.[product_line]
		,zz.[empire_market_segment]
		,zz.[empire_market_subsegment]
		,zz.[empire_application]
		,zz.[salesperson]
		,zz.[date_of_award]
		,zz.[type_of_award]
		,zz.[mid_model_year]
		,zz.[empire_eop_note]
		,zz.[verified_eop]
		,zz.[verified_eop_date]
		
		,[mnemonic]		
		,[version]
		,[platform]
		,[program]
		,[manufacturer]
		,[badge]
		,[vehicle]
		,[assembly_plant]
		,[product_type]
		,[global_segment]
		,[regional_segment]
		,(case when (datediff(d,isnull([EMPIRE_eop],[CSM_eop]),getdate()) > 90) then 'Service' else (case when (datediff(d,isnull([EMPIRE_eop],[CSM_eop]),getdate()) between -180 and 90) then 'Closeout' else (case when (datediff(d,isnull([EMPIRE_sop],[CSM_sop]),getdate()) between -180 and 90) then 'Launch' else (case when (datediff(d,isnull([EMPIRE_sop],[CSM_sop]),getdate()) < -180) then 'Pre-Launch' else 'Production' end)end)end)end) as status
		,[CSM_sop]
		,[CSM_eop]
		,[csm_sop] as 'CSM_sop_display'
		,[csm_eop] as 'CSM_eop_display'
		,zz.[empire_sop]
		,zz.[empire_eop]		
		,isnull(zz.[EMPIRE_sop],[CSM_sop]) as [sop]
		,isnull(zz.[EMPIRE_eop],[CSM_eop]) as [eop]
		,isnull(zz.[EMPIRE_sop],[CSM_sop]) as [sop_display]
		,isnull(zz.[EMPIRE_eop],[CSM_eop]) as [eop_display]
		,datediff(mm,isnull(zz.[empire_sop],[csm_sop]),isnull(zz.[empire_eop],[csm_eop])) as [empire_duration_mo]
		,MC.lastupdated as mc_last_updated
		,MC.partusedforcost as mc_part_used_for_cost

		,[qty_per]
		,[take_rate]
		,[family_allocation]
		
	--,[Jan_10_CSMdemand]
	--,[Feb_10_CSMdemand]
	--,[Mar_10_CSMdemand]
	--,[Apr_10_CSMdemand]
	--,[May_10_CSMdemand]
	--,[Jun_10_CSMdemand]
	--,[Jul_10_CSMdemand]
	--,[Aug_10_CSMdemand]
	--,[Sep_10_CSMdemand]
	--,[Oct_10_CSMdemand]
	--,[Nov_10_CSMdemand]
	--,[Dec_10_CSMdemand]
	--,[Cal_10_CSMdemand]
		
	--,[Jan_11_CSMdemand]
	--,[Feb_11_CSMdemand]
	--,[Mar_11_CSMdemand]
	--,[Apr_11_CSMdemand]
	--,[May_11_CSMdemand]
	--,[Jun_11_CSMdemand]
	--,[Jul_11_CSMdemand]
	--,[Aug_11_CSMdemand]
	--,[Sep_11_CSMdemand]
	--,[Oct_11_CSMdemand]
	--,[Nov_11_CSMdemand]
	--,[Dec_11_CSMdemand]
	--,[Cal_11_CSMdemand]
		
	--,[Jan_12_CSMdemand]
	--,[Feb_12_CSMdemand]
	--,[Mar_12_CSMdemand]
	--,[Apr_12_CSMdemand]
	--,[May_12_CSMdemand]
	--,[Jun_12_CSMdemand]
	--,[Jul_12_CSMdemand]
	--,[Aug_12_CSMdemand]
	--,[Sep_12_CSMdemand]
	--,[Oct_12_CSMdemand]
	--,[Nov_12_CSMdemand]
	--,[Dec_12_CSMdemand]
	--,[Cal_12_CSMdemand]
		
	--,[Jan_13_CSMdemand]
	--,[Feb_13_CSMdemand]
	--,[Mar_13_CSMdemand]
	--,[Apr_13_CSMdemand]
	--,[May_13_CSMdemand]
	--,[Jun_13_CSMdemand]
	--,[Jul_13_CSMdemand]
	--,[Aug_13_CSMdemand]
	--,[Sep_13_CSMdemand]
	--,[Oct_13_CSMdemand]
	--,[Nov_13_CSMdemand]
	--,[Dec_13_CSMdemand]
	--,[Cal_13_CSMdemand]
		
	--,[Jan_14_CSMdemand]
	--,[Feb_14_CSMdemand]
	--,[Mar_14_CSMdemand]
	--,[Apr_14_CSMdemand]
	--,[May_14_CSMdemand]
	--,[Jun_14_CSMdemand]
	--,[Jul_14_CSMdemand]
	--,[Aug_14_CSMdemand]
	--,[Sep_14_CSMdemand]
	--,[Oct_14_CSMdemand]
	--,[Nov_14_CSMdemand]
	--,[Dec_14_CSMdemand]
	--,[Cal_14_CSMdemand]

	--,[Jan_15_CSMdemand]
	--,[Feb_15_CSMdemand]
	--,[Mar_15_CSMdemand]
	--,[Apr_15_CSMdemand]
	--,[May_15_CSMdemand]
	--,[Jun_15_CSMdemand]
	--,[Jul_15_CSMdemand]
	--,[Aug_15_CSMdemand]
	--,[Sep_15_CSMdemand]
	--,[Oct_15_CSMdemand]
	--,[Nov_15_CSMdemand]
	--,[Dec_15_CSMdemand]
	--,[Cal_15_CSMdemand]
		
	--,[Jan_16_CSMdemand]
	--,[Feb_16_CSMdemand]
	--,[Mar_16_CSMdemand]
	--,[Apr_16_CSMdemand]
	--,[May_16_CSMdemand]
	--,[Jun_16_CSMdemand]
	--,[Jul_16_CSMdemand]
	--,[Aug_16_CSMdemand]
	--,[Sep_16_CSMdemand]
	--,[Oct_16_CSMdemand]
	--,[Nov_16_CSMdemand]
	--,[Dec_16_CSMdemand]
	--,[Cal_16_CSMdemand]

	--,[Jan_17_CSMdemand]
	--,[Feb_17_CSMdemand]
	--,[Mar_17_CSMdemand]
	--,[Apr_17_CSMdemand]
	--,[May_17_CSMdemand]
	--,[Jun_17_CSMdemand]
	--,[Jul_17_CSMdemand]
	--,[Aug_17_CSMdemand]
	--,[Sep_17_CSMdemand]
	--,[Oct_17_CSMdemand]
	--,[Nov_17_CSMdemand]
	--,[Dec_17_CSMdemand]
	--,[Cal_17_CSMdemand]		

	--,[Jan_18_CSMdemand]
	--,[Feb_18_CSMdemand]
	--,[Mar_18_CSMdemand]
	--,[Apr_18_CSMdemand]
	--,[May_18_CSMdemand]
	--,[Jun_18_CSMdemand]
	--,[Jul_18_CSMdemand]
	--,[Aug_18_CSMdemand]
	--,[Sep_18_CSMdemand]
	--,[Oct_18_CSMdemand]
	--,[Nov_18_CSMdemand]
	--,[Dec_18_CSMdemand]
	--,[Cal_18_CSMdemand]

	--,[Jan_19_CSMdemand]
	--,[Feb_19_CSMdemand]
	--,[Mar_19_CSMdemand]
	--,[Apr_19_CSMdemand]
	--,[May_19_CSMdemand]
	--,[Jun_19_CSMdemand]
	--,[Jul_19_CSMdemand]
	--,[Aug_19_CSMdemand]
	--,[Sep_19_CSMdemand]
	--,[Oct_19_CSMdemand]
	--,[Nov_19_CSMdemand]
	--,[Dec_19_CSMdemand]
	--,[Cal_19_CSMdemand]

	--,[Jan_20_CSMdemand]
	--,[Feb_20_CSMdemand]
	--,[Mar_20_CSMdemand]
	--,[Apr_20_CSMdemand]
	--,[May_20_CSMdemand]
	--,[Jun_20_CSMdemand]
	--,[Jul_20_CSMdemand]
	--,[Aug_20_CSMdemand]
	--,[Sep_20_CSMdemand]
	--,[Oct_20_CSMdemand]
	--,[Nov_20_CSMdemand]
	--,[Dec_20_CSMdemand]
	--,[Cal_20_CSMdemand]
	
	--,[Cal_21_CSMdemand]
	--,[Cal_22_CSMdemand]
	--,[Cal_23_CSMdemand]	
	--,[Cal_24_CSMdemand]
	--,[Cal_25_CSMdemand]
					
	--,[Jan_10_factor]
	--,[Feb_10_factor]
	--,[Mar_10_factor]
	--,[Apr_10_factor]
	--,[May_10_factor]
	--,[Jun_10_factor]
	--,[Jul_10_factor]
	--,[Aug_10_factor]
	--,[Sep_10_factor]
	--,[Oct_10_factor]
	--,[Nov_10_factor]
	--,[Dec_10_factor]
		
	--,[Jan_11_factor]
	--,[Feb_11_factor]
	--,[Mar_11_factor]
	--,[Apr_11_factor]
	--,[May_11_factor]
	--,[Jun_11_factor]
	--,[Jul_11_factor]
	--,[Aug_11_factor]
	--,[Sep_11_factor]
	--,[Oct_11_factor]
	--,[Nov_11_factor]
	--,[Dec_11_factor]
		
	--,[Jan_12_factor]
	--,[Feb_12_factor]
	--,[Mar_12_factor]
	--,[Apr_12_factor]
	--,[May_12_factor]
	--,[Jun_12_factor]
	--,[Jul_12_factor]
	--,[Aug_12_factor]
	--,[Sep_12_factor]
	--,[Oct_12_factor]
	--,[Nov_12_factor]
	--,[Dec_12_factor]
		
	--,[Jan_13_factor]
	--,[Feb_13_factor]
	--,[Mar_13_factor]
	--,[Apr_13_factor]
	--,[May_13_factor]
	--,[Jun_13_factor]
	--,[Jul_13_factor]
	--,[Aug_13_factor]
	--,[Sep_13_factor]
	--,[Oct_13_factor]
	--,[Nov_13_factor]
	--,[Dec_13_factor]
		
	--,[Jan_14_factor]
	--,[Feb_14_factor]
	--,[Mar_14_factor]
	--,[Apr_14_factor]
	--,[May_14_factor]
	--,[Jun_14_factor]
	--,[Jul_14_factor]
	--,[Aug_14_factor]
	--,[Sep_14_factor]
	--,[Oct_14_factor]
	--,[Nov_14_factor]
	--,[Dec_14_factor]

	--,[Jan_15_factor]
	--,[Feb_15_factor]
	--,[Mar_15_factor]
	--,[Apr_15_factor]
	--,[May_15_factor]
	--,[Jun_15_factor]
	--,[Jul_15_factor]
	--,[Aug_15_factor]
	--,[Sep_15_factor]
	--,[Oct_15_factor]
	--,[Nov_15_factor]
	--,[Dec_15_factor]

	--,[Jan_16_factor]
	--,[Feb_16_factor]
	--,[Mar_16_factor]
	--,[Apr_16_factor]
	--,[May_16_factor]
	--,[Jun_16_factor]
	--,[Jul_16_factor]
	--,[Aug_16_factor]
	--,[Sep_16_factor]
	--,[Oct_16_factor]
	--,[Nov_16_factor]
	--,[Dec_16_factor]		

	--,[Jan_17_factor]
	--,[Feb_17_factor]
	--,[Mar_17_factor]
	--,[Apr_17_factor]
	--,[May_17_factor]
	--,[Jun_17_factor]
	--,[Jul_17_factor]
	--,[Aug_17_factor]
	--,[Sep_17_factor]
	--,[Oct_17_factor]
	--,[Nov_17_factor]
	--,[Dec_17_factor]

	--,[Jan_18_factor]
	--,[Feb_18_factor]
	--,[Mar_18_factor]
	--,[Apr_18_factor]
	--,[May_18_factor]
	--,[Jun_18_factor]
	--,[Jul_18_factor]
	--,[Aug_18_factor]
	--,[Sep_18_factor]
	--,[Oct_18_factor]
	--,[Nov_18_factor]
	--,[Dec_18_factor]

	--,[Jan_19_factor]
	--,[Feb_19_factor]
	--,[Mar_19_factor]
	--,[Apr_19_factor]
	--,[May_19_factor]
	--,[Jun_19_factor]
	--,[Jul_19_factor]
	--,[Aug_19_factor]
	--,[Sep_19_factor]
	--,[Oct_19_factor]
	--,[Nov_19_factor]
	--,[Dec_19_factor]

	--,[Jan_20_factor]
	--,[Feb_20_factor]
	--,[Mar_20_factor]
	--,[Apr_20_factor]
	--,[May_20_factor]
	--,[Jun_20_factor]
	--,[Jul_20_factor]
	--,[Aug_20_factor]
	--,[Sep_20_factor]
	--,[Oct_20_factor]
	--,[Nov_20_factor]
	--,[Dec_20_factor]
		
	--,[Cal_21_factor]
	--,[Cal_22_factor]
	--,[Cal_23_factor]
	--,[Cal_24_factor]
	--,[Cal_25_factor]
				
	--,[Jan_10_Empire_Adj]
	--,[Feb_10_Empire_Adj]
	--,[Mar_10_Empire_Adj]
	--,[Apr_10_Empire_Adj]
	--,[May_10_Empire_Adj]
	--,[Jun_10_Empire_Adj]
	--,[Jul_10_Empire_Adj]
	--,[Aug_10_Empire_Adj]
	--,[Sep_10_Empire_Adj]
	--,[Oct_10_Empire_Adj]
	--,[Nov_10_Empire_Adj]
	--,[Dec_10_Empire_Adj]
	--,[Cal_10_Empire_Adj]
		
	--,[Jan_11_Empire_Adj]
	--,[Feb_11_Empire_Adj]
	--,[Mar_11_Empire_Adj]
	--,[Apr_11_Empire_Adj]
	--,[May_11_Empire_Adj]
	--,[Jun_11_Empire_Adj]
	--,[Jul_11_Empire_Adj]
	--,[Aug_11_Empire_Adj]
	--,[Sep_11_Empire_Adj]
	--,[Oct_11_Empire_Adj]
	--,[Nov_11_Empire_Adj]
	--,[Dec_11_Empire_Adj]
	--,[Cal_11_Empire_Adj]
		
	--,[Jan_12_Empire_Adj]
	--,[Feb_12_Empire_Adj]
	--,[Mar_12_Empire_Adj]
	--,[Apr_12_Empire_Adj]
	--,[May_12_Empire_Adj]
	--,[Jun_12_Empire_Adj]
	--,[Jul_12_Empire_Adj]
	--,[Aug_12_Empire_Adj]
	--,[Sep_12_Empire_Adj]
	--,[Oct_12_Empire_Adj]
	--,[Nov_12_Empire_Adj]
	--,[Dec_12_Empire_Adj]
	--,[Cal_12_Empire_Adj]
		
	--,[Jan_13_Empire_Adj]
	--,[Feb_13_Empire_Adj]
	--,[Mar_13_Empire_Adj]
	--,[Apr_13_Empire_Adj]
	--,[May_13_Empire_Adj]
	--,[Jun_13_Empire_Adj]
	--,[Jul_13_Empire_Adj]
	--,[Aug_13_Empire_Adj]
	--,[Sep_13_Empire_Adj]
	--,[Oct_13_Empire_Adj]
	--,[Nov_13_Empire_Adj]
	--,[Dec_13_Empire_Adj]
	--,[Cal_13_Empire_Adj]
		
	--,[Jan_14_Empire_Adj]
	--,[Feb_14_Empire_Adj]
	--,[Mar_14_Empire_Adj]
	--,[Apr_14_Empire_Adj]
	--,[May_14_Empire_Adj]
	--,[Jun_14_Empire_Adj]
	--,[Jul_14_Empire_Adj]
	--,[Aug_14_Empire_Adj]
	--,[Sep_14_Empire_Adj]
	--,[Oct_14_Empire_Adj]
	--,[Nov_14_Empire_Adj]
	--,[Dec_14_Empire_Adj]
	--,[Cal_14_Empire_Adj]

	--,[Jan_15_Empire_Adj]
	--,[Feb_15_Empire_Adj]
	--,[Mar_15_Empire_Adj]
	--,[Apr_15_Empire_Adj]
	--,[May_15_Empire_Adj]
	--,[Jun_15_Empire_Adj]
	--,[Jul_15_Empire_Adj]
	--,[Aug_15_Empire_Adj]
	--,[Sep_15_Empire_Adj]
	--,[Oct_15_Empire_Adj]
	--,[Nov_15_Empire_Adj]
	--,[Dec_15_Empire_Adj]
	--,[Cal_15_Empire_Adj]
		
	--,[Jan_16_Empire_Adj]
	--,[Feb_16_Empire_Adj]
	--,[Mar_16_Empire_Adj]
	--,[Apr_16_Empire_Adj]
	--,[May_16_Empire_Adj]
	--,[Jun_16_Empire_Adj]
	--,[Jul_16_Empire_Adj]
	--,[Aug_16_Empire_Adj]
	--,[Sep_16_Empire_Adj]
	--,[Oct_16_Empire_Adj]
	--,[Nov_16_Empire_Adj]
	--,[Dec_16_Empire_Adj]
	--,[Cal_16_Empire_Adj]
		
	--,[Jan_17_Empire_Adj]
	--,[Feb_17_Empire_Adj]
	--,[Mar_17_Empire_Adj]
	--,[Apr_17_Empire_Adj]
	--,[May_17_Empire_Adj]
	--,[Jun_17_Empire_Adj]
	--,[Jul_17_Empire_Adj]
	--,[Aug_17_Empire_Adj]
	--,[Sep_17_Empire_Adj]
	--,[Oct_17_Empire_Adj]
	--,[Nov_17_Empire_Adj]
	--,[Dec_17_Empire_Adj]
	--,[Cal_17_Empire_Adj]

	--,[Jan_18_Empire_Adj]
	--,[Feb_18_Empire_Adj]
	--,[Mar_18_Empire_Adj]
	--,[Apr_18_Empire_Adj]
	--,[May_18_Empire_Adj]
	--,[Jun_18_Empire_Adj]
	--,[Jul_18_Empire_Adj]
	--,[Aug_18_Empire_Adj]
	--,[Sep_18_Empire_Adj]
	--,[Oct_18_Empire_Adj]
	--,[Nov_18_Empire_Adj]
	--,[Dec_18_Empire_Adj]
	--,[Cal_18_Empire_Adj]
		
	--,[Jan_19_Empire_Adj]
	--,[Feb_19_Empire_Adj]
	--,[Mar_19_Empire_Adj]
	--,[Apr_19_Empire_Adj]
	--,[May_19_Empire_Adj]
	--,[Jun_19_Empire_Adj]
	--,[Jul_19_Empire_Adj]
	--,[Aug_19_Empire_Adj]
	--,[Sep_19_Empire_Adj]
	--,[Oct_19_Empire_Adj]
	--,[Nov_19_Empire_Adj]
	--,[Dec_19_Empire_Adj]
	--,[Cal_19_Empire_Adj]
		
	--,[Jan_20_Empire_Adj]
	--,[Feb_20_Empire_Adj]
	--,[Mar_20_Empire_Adj]
	--,[Apr_20_Empire_Adj]
	--,[May_20_Empire_Adj]
	--,[Jun_20_Empire_Adj]
	--,[Jul_20_Empire_Adj]
	--,[Aug_20_Empire_Adj]
	--,[Sep_20_Empire_Adj]
	--,[Oct_20_Empire_Adj]
	--,[Nov_20_Empire_Adj]
	--,[Dec_20_Empire_Adj]
	--,[Cal_20_Empire_Adj]

	--,[Cal_21_Empire_Adj]
	--,[Cal_22_Empire_Adj]
	--,[Cal_23_Empire_Adj]
	--,[Cal_24_Empire_Adj]
	--,[Cal_25_Empire_Adj]
		
	--,[Jan_10_Allocated_Empire_Adj]
	--,[Feb_10_Allocated_Empire_Adj]
	--,[Mar_10_Allocated_Empire_Adj]
	--,[Apr_10_Allocated_Empire_Adj]
	--,[May_10_Allocated_Empire_Adj]
	--,[Jun_10_Allocated_Empire_Adj]
	--,[Jul_10_Allocated_Empire_Adj]
	--,[Aug_10_Allocated_Empire_Adj]
	--,[Sep_10_Allocated_Empire_Adj]
	--,[Oct_10_Allocated_Empire_Adj]
	--,[Nov_10_Allocated_Empire_Adj]
	--,[Dec_10_Allocated_Empire_Adj]
	--,[Cal_10_Allocated_Empire_Adj]
		
	--,[Jan_11_Allocated_Empire_Adj]
	--,[Feb_11_Allocated_Empire_Adj]
	--,[Mar_11_Allocated_Empire_Adj]
	--,[Apr_11_Allocated_Empire_Adj]
	--,[May_11_Allocated_Empire_Adj]
	--,[Jun_11_Allocated_Empire_Adj]
	--,[Jul_11_Allocated_Empire_Adj]
	--,[Aug_11_Allocated_Empire_Adj]
	--,[Sep_11_Allocated_Empire_Adj]
	--,[Oct_11_Allocated_Empire_Adj]
	--,[Nov_11_Allocated_Empire_Adj]
	--,[Dec_11_Allocated_Empire_Adj]
	--,[Cal_11_Allocated_Empire_Adj]
		
	--,[Jan_12_Allocated_Empire_Adj]
	--,[Feb_12_Allocated_Empire_Adj]
	--,[Mar_12_Allocated_Empire_Adj]
	--,[Apr_12_Allocated_Empire_Adj]
	--,[May_12_Allocated_Empire_Adj]
	--,[Jun_12_Allocated_Empire_Adj]
	--,[Jul_12_Allocated_Empire_Adj]
	--,[Aug_12_Allocated_Empire_Adj]
	--,[Sep_12_Allocated_Empire_Adj]
	--,[Oct_12_Allocated_Empire_Adj]
	--,[Nov_12_Allocated_Empire_Adj]
	--,[Dec_12_Allocated_Empire_Adj]
	--,[Cal_12_Allocated_Empire_Adj]
		
	--,[Jan_13_Allocated_Empire_Adj]
	--,[Feb_13_Allocated_Empire_Adj]
	--,[Mar_13_Allocated_Empire_Adj]
	--,[Apr_13_Allocated_Empire_Adj]
	--,[May_13_Allocated_Empire_Adj]
	--,[Jun_13_Allocated_Empire_Adj]
	--,[Jul_13_Allocated_Empire_Adj]
	--,[Aug_13_Allocated_Empire_Adj]
	--,[Sep_13_Allocated_Empire_Adj]
	--,[Oct_13_Allocated_Empire_Adj]
	--,[Nov_13_Allocated_Empire_Adj]
	--,[Dec_13_Allocated_Empire_Adj]
	--,[Cal_13_Allocated_Empire_Adj]
		
	--,[Jan_14_Allocated_Empire_Adj]
	--,[Feb_14_Allocated_Empire_Adj]
	--,[Mar_14_Allocated_Empire_Adj]
	--,[Apr_14_Allocated_Empire_Adj]
	--,[May_14_Allocated_Empire_Adj]
	--,[Jun_14_Allocated_Empire_Adj]
	--,[Jul_14_Allocated_Empire_Adj]
	--,[Aug_14_Allocated_Empire_Adj]
	--,[Sep_14_Allocated_Empire_Adj]
	--,[Oct_14_Allocated_Empire_Adj]
	--,[Nov_14_Allocated_Empire_Adj]
	--,[Dec_14_Allocated_Empire_Adj]
	--,[Cal_14_Allocated_Empire_Adj]

	--,[Jan_15_Allocated_Empire_Adj]
	--,[Feb_15_Allocated_Empire_Adj]
	--,[Mar_15_Allocated_Empire_Adj]
	--,[Apr_15_Allocated_Empire_Adj]
	--,[May_15_Allocated_Empire_Adj]
	--,[Jun_15_Allocated_Empire_Adj]
	--,[Jul_15_Allocated_Empire_Adj]
	--,[Aug_15_Allocated_Empire_Adj]
	--,[Sep_15_Allocated_Empire_Adj]
	--,[Oct_15_Allocated_Empire_Adj]
	--,[Nov_15_Allocated_Empire_Adj]
	--,[Dec_15_Allocated_Empire_Adj]
	--,[Cal_15_Allocated_Empire_Adj]
		
	--,[Jan_16_Allocated_Empire_Adj]
	--,[Feb_16_Allocated_Empire_Adj]
	--,[Mar_16_Allocated_Empire_Adj]
	--,[Apr_16_Allocated_Empire_Adj]
	--,[May_16_Allocated_Empire_Adj]
	--,[Jun_16_Allocated_Empire_Adj]
	--,[Jul_16_Allocated_Empire_Adj]
	--,[Aug_16_Allocated_Empire_Adj]
	--,[Sep_16_Allocated_Empire_Adj]
	--,[Oct_16_Allocated_Empire_Adj]
	--,[Nov_16_Allocated_Empire_Adj]
	--,[Dec_16_Allocated_Empire_Adj]
	--,[Cal_16_Allocated_Empire_Adj]
		
	--,[Jan_17_Allocated_Empire_Adj]
	--,[Feb_17_Allocated_Empire_Adj]
	--,[Mar_17_Allocated_Empire_Adj]
	--,[Apr_17_Allocated_Empire_Adj]
	--,[May_17_Allocated_Empire_Adj]
	--,[Jun_17_Allocated_Empire_Adj]
	--,[Jul_17_Allocated_Empire_Adj]
	--,[Aug_17_Allocated_Empire_Adj]
	--,[Sep_17_Allocated_Empire_Adj]
	--,[Oct_17_Allocated_Empire_Adj]
	--,[Nov_17_Allocated_Empire_Adj]
	--,[Dec_17_Allocated_Empire_Adj]
	--,[Cal_17_Allocated_Empire_Adj]

	--,[Jan_18_Allocated_Empire_Adj]
	--,[Feb_18_Allocated_Empire_Adj]
	--,[Mar_18_Allocated_Empire_Adj]
	--,[Apr_18_Allocated_Empire_Adj]
	--,[May_18_Allocated_Empire_Adj]
	--,[Jun_18_Allocated_Empire_Adj]
	--,[Jul_18_Allocated_Empire_Adj]
	--,[Aug_18_Allocated_Empire_Adj]
	--,[Sep_18_Allocated_Empire_Adj]
	--,[Oct_18_Allocated_Empire_Adj]
	--,[Nov_18_Allocated_Empire_Adj]
	--,[Dec_18_Allocated_Empire_Adj]
	--,[Cal_18_Allocated_Empire_Adj]

	--,[Jan_19_Allocated_Empire_Adj]
	--,[Feb_19_Allocated_Empire_Adj]
	--,[Mar_19_Allocated_Empire_Adj]
	--,[Apr_19_Allocated_Empire_Adj]
	--,[May_19_Allocated_Empire_Adj]
	--,[Jun_19_Allocated_Empire_Adj]
	--,[Jul_19_Allocated_Empire_Adj]
	--,[Aug_19_Allocated_Empire_Adj]
	--,[Sep_19_Allocated_Empire_Adj]
	--,[Oct_19_Allocated_Empire_Adj]
	--,[Nov_19_Allocated_Empire_Adj]
	--,[Dec_19_Allocated_Empire_Adj]
	--,[Cal_19_Allocated_Empire_Adj]

	--,[Jan_20_Allocated_Empire_Adj]
	--,[Feb_20_Allocated_Empire_Adj]
	--,[Mar_20_Allocated_Empire_Adj]
	--,[Apr_20_Allocated_Empire_Adj]
	--,[May_20_Allocated_Empire_Adj]
	--,[Jun_20_Allocated_Empire_Adj]
	--,[Jul_20_Allocated_Empire_Adj]
	--,[Aug_20_Allocated_Empire_Adj]
	--,[Sep_20_Allocated_Empire_Adj]
	--,[Oct_20_Allocated_Empire_Adj]
	--,[Nov_20_Allocated_Empire_Adj]
	--,[Dec_20_Allocated_Empire_Adj]
	--,[Cal_20_Allocated_Empire_Adj]

	--,[Cal_21_Allocated_Empire_Adj]
	--,[Cal_22_Allocated_Empire_Adj]
	--,[Cal_23_Allocated_Empire_Adj]
	--,[Cal_24_Allocated_Empire_Adj]
	--,[Cal_25_Allocated_Empire_Adj]
				
	--,[Jan_10_TOTALdemand]
	--,[Feb_10_TOTALdemand]
	--,[Mar_10_TOTALdemand]
	--,[Apr_10_TOTALdemand]
	--,[May_10_TOTALdemand]
	--,[Jun_10_TOTALdemand]
	--,[Jul_10_TOTALdemand]
	--,[Aug_10_TOTALdemand]
	--,[Sep_10_TOTALdemand]
	--,[Oct_10_TOTALdemand]
	--,[Nov_10_TOTALdemand]
	--,[Dec_10_TOTALdemand]
	--,[Cal_10_TOTALdemand]
		
	--,[Jan_11_TOTALdemand]
	--,[Feb_11_TOTALdemand]
	--,[Mar_11_TOTALdemand]
	--,[Apr_11_TOTALdemand]
	--,[May_11_TOTALdemand]
	--,[Jun_11_TOTALdemand]
	--,[Jul_11_TOTALdemand]
	--,[Aug_11_TOTALdemand]
	--,[Sep_11_TOTALdemand]
	--,[Oct_11_TOTALdemand]
	--,[Nov_11_TOTALdemand]
	--,[Dec_11_TOTALdemand]
	--,[Cal_11_TOTALdemand]
		
	--,[Jan_12_TOTALdemand]
	--,[Feb_12_TOTALdemand]
	--,[Mar_12_TOTALdemand]
	--,[Apr_12_TOTALdemand]
	--,[May_12_TOTALdemand]
	--,[Jun_12_TOTALdemand]
	--,[Jul_12_TOTALdemand]
	--,[Aug_12_TOTALdemand]
	--,[Sep_12_TOTALdemand]
	--,[Oct_12_TOTALdemand]
	--,[Nov_12_TOTALdemand]
	--,[Dec_12_TOTALdemand]
	--,[Cal_12_TOTALdemand]
		
	--,[Jan_13_TOTALdemand]
	--,[Feb_13_TOTALdemand]
	--,[Mar_13_TOTALdemand]
	--,[Apr_13_TOTALdemand]
	--,[May_13_TOTALdemand]
	--,[Jun_13_TOTALdemand]
	--,[Jul_13_TOTALdemand]
	--,[Aug_13_TOTALdemand]
	--,[Sep_13_TOTALdemand]
	--,[Oct_13_TOTALdemand]
	--,[Nov_13_TOTALdemand]
	--,[Dec_13_TOTALdemand]
	--,[Cal_13_TOTALdemand]
		
	--,[Jan_14_TOTALdemand]
	--,[Feb_14_TOTALdemand]
	--,[Mar_14_TOTALdemand]
	--,[Apr_14_TOTALdemand]
	--,[May_14_TOTALdemand]
	--,[Jun_14_TOTALdemand]
	--,[Jul_14_TOTALdemand]
	--,[Aug_14_TOTALdemand]
	--,[Sep_14_TOTALdemand]
	--,[Oct_14_TOTALdemand]
	--,[Nov_14_TOTALdemand]
	--,[Dec_14_TOTALdemand]
	--,[Cal_14_TOTALdemand]

	--,[Jan_15_TOTALdemand]
	--,[Feb_15_TOTALdemand]
	--,[Mar_15_TOTALdemand]
	--,[Apr_15_TOTALdemand]
	--,[May_15_TOTALdemand]
	--,[Jun_15_TOTALdemand]
	--,[Jul_15_TOTALdemand]
	--,[Aug_15_TOTALdemand]
	--,[Sep_15_TOTALdemand]
	--,[Oct_15_TOTALdemand]
	--,[Nov_15_TOTALdemand]
	--,[Dec_15_TOTALdemand]
	--,[Cal_15_TOTALdemand]

	,[Jan_16_TOTALdemand]
	,[Feb_16_TOTALdemand]
	,[Mar_16_TOTALdemand]
	,[Apr_16_TOTALdemand]
	,[May_16_TOTALdemand]
	,[Jun_16_TOTALdemand]
	,[Jul_16_TOTALdemand]
	,[Aug_16_TOTALdemand]
	,[Sep_16_TOTALdemand]
	,[Oct_16_TOTALdemand]
	,[Nov_16_TOTALdemand]
	,[Dec_16_TOTALdemand]
	,[Cal_16_TOTALdemand]
				
	,[Jan_17_TOTALdemand]
	,[Feb_17_TOTALdemand]
	,[Mar_17_TOTALdemand]
	,[Apr_17_TOTALdemand]
	,[May_17_TOTALdemand]
	,[Jun_17_TOTALdemand]
	,[Jul_17_TOTALdemand]
	,[Aug_17_TOTALdemand]
	,[Sep_17_TOTALdemand]
	,[Oct_17_TOTALdemand]
	,[Nov_17_TOTALdemand]
	,[Dec_17_TOTALdemand]
	,[Cal_17_TOTALdemand]

	,[Jan_18_TOTALdemand]
	,[Feb_18_TOTALdemand]
	,[Mar_18_TOTALdemand]
	,[Apr_18_TOTALdemand]
	,[May_18_TOTALdemand]
	,[Jun_18_TOTALdemand]
	,[Jul_18_TOTALdemand]
	,[Aug_18_TOTALdemand]
	,[Sep_18_TOTALdemand]
	,[Oct_18_TOTALdemand]
	,[Nov_18_TOTALdemand]
	,[Dec_18_TOTALdemand]
	,[Cal_18_TOTALdemand]

	,[Jan_19_TOTALdemand]
	,[Feb_19_TOTALdemand]
	,[Mar_19_TOTALdemand]
	,[Apr_19_TOTALdemand]
	,[May_19_TOTALdemand]
	,[Jun_19_TOTALdemand]
	,[Jul_19_TOTALdemand]
	,[Aug_19_TOTALdemand]
	,[Sep_19_TOTALdemand]
	,[Oct_19_TOTALdemand]
	,[Nov_19_TOTALdemand]
	,[Dec_19_TOTALdemand]
	,[Cal_19_TOTALdemand]

	,[Jan_20_TOTALdemand]
	,[Feb_20_TOTALdemand]
	,[Mar_20_TOTALdemand]
	,[Apr_20_TOTALdemand]
	,[May_20_TOTALdemand]
	,[Jun_20_TOTALdemand]
	,[Jul_20_TOTALdemand]
	,[Aug_20_TOTALdemand]
	,[Sep_20_TOTALdemand]
	,[Oct_20_TOTALdemand]
	,[Nov_20_TOTALdemand]
	,[Dec_20_TOTALdemand]
	,[Cal_20_TOTALdemand]

	,[Jan_21_TOTALdemand]
	,[Feb_21_TOTALdemand]
	,[Mar_21_TOTALdemand]
	,[Apr_21_TOTALdemand]
	,[May_21_TOTALdemand]
	,[Jun_21_TOTALdemand]
	,[Jul_21_TOTALdemand]
	,[Aug_21_TOTALdemand]
	,[Sep_21_TOTALdemand]
	,[Oct_21_TOTALdemand]
	,[Nov_21_TOTALdemand]
	,[Dec_21_TOTALdemand]
	,[Cal_21_TOTALdemand]

	,[Cal_22_TOTALdemand]
	,[Cal_23_TOTALdemand]		
	,[CAL_24_TOTALdemand]
	,[CAL_25_TOTALdemand]
	,[CAL_26_TOTALdemand]
		
	--,[sp_Dec_10]
	--,[sp_Dec_11]
	--,[sp_Dec_12]
	--,[sp_Dec_13]
	--,[sp_Dec_14]
	--,[sp_Dec_15]
	,[sp_Dec_16]
	,[sp_Dec_17]
	,[sp_Dec_18]
	,[sp_Dec_19]
	,[sp_Dec_20]
	,[sp_Dec_21]
	,[sp_Dec_22]
	,[sp_Dec_23]
	,[sp_Dec_24]
	,[sp_Dec_25]
	,[sp_Dec_26]

	--,[mc_Dec_10]
	--,[mc_Dec_11]
	--,[mc_Dec_12]
	--,[mc_Dec_13]
	--,[mc_Dec_14]
	--,[mc_Dec_15]
	--,(case isnull(sp_dec_15,0) when 0 then 0 else mc_dec_15/sp_dec_15 end) as mcp_dec_15
		
	,[mc_Dec_16]
	,(case isnull(sp_dec_16,0) when 0 then 0 else mc_dec_16/sp_dec_16 end) as mcp_dec_16
	
	,[mc_Dec_17]
	,(case isnull(sp_dec_17,0) when 0 then 0 else mc_dec_17/sp_dec_17 end) as mcp_dec_17
	
	,[mc_Dec_18]
	,(case isnull(sp_dec_18,0) when 0 then 0 else mc_dec_18/sp_dec_18 end) as mcp_dec_18
	
	,[mc_Dec_19]
	,(case isnull(sp_dec_19,0) when 0 then 0 else mc_dec_19/sp_dec_19 end) as mcp_dec_19

	,[mc_Dec_20]
	,(case isnull(sp_dec_20,0) when 0 then 0 else mc_dec_20/sp_dec_20 end) as mcp_dec_20	

	,[mc_Dec_21]
	,(case isnull(sp_dec_21,0) when 0 then 0 else mc_dec_21/sp_dec_21 end) as mcp_dec_21

	,[mc_Dec_22]
	,(case isnull(sp_dec_22,0) when 0 then 0 else mc_dec_22/sp_dec_22 end) as mcp_dec_22

	,[mc_Dec_23]
	,(case isnull(sp_dec_23,0) when 0 then 0 else mc_dec_23/sp_dec_23 end) as mcp_dec_23

	,[mc_Dec_24]
	,(case isnull(sp_dec_24,0) when 0 then 0 else mc_dec_24/sp_dec_24 end) as mcp_dec_24

	,[mc_Dec_25]
	,(case isnull(sp_dec_25,0) when 0 then 0 else mc_dec_25/sp_dec_25 end) as mcp_dec_25

	,[mc_Dec_26]
	,(case isnull(sp_dec_26,0) when 0 then 0 else mc_dec_26/sp_dec_26 end) as mcp_dec_26

		
	--,[Jan_10_TOTALdemand]*[sp_Jan_10] as 'Jan_10_Sales'
	--,[Feb_10_TOTALdemand]*[sp_Feb_10] as 'Feb_10_Sales'
	--,[Mar_10_TOTALdemand]*[sp_Mar_10] as 'Mar_10_Sales'
	--,[Apr_10_TOTALdemand]*[sp_Apr_10] as 'Apr_10_Sales'
	--,[May_10_TOTALdemand]*[sp_May_10] as 'May_10_Sales'
	--,[Jun_10_TOTALdemand]*[sp_Jun_10] as 'Jun_10_Sales'
	--,[Jul_10_TOTALdemand]*[sp_Jul_10] as 'Jul_10_Sales'
	--,[Aug_10_TOTALdemand]*[sp_Aug_10] as 'Aug_10_Sales'
	--,[Sep_10_TOTALdemand]*[sp_Sep_10] as 'Sep_10_Sales'
	--,[Oct_10_TOTALdemand]*[sp_Oct_10] as 'Oct_10_Sales'
	--,[Nov_10_TOTALdemand]*[sp_Nov_10] as 'Nov_10_Sales'
	--,[Dec_10_TOTALdemand]*[sp_Dec_10] as 'Dec_10_Sales'
	--,([Jan_10_TOTALdemand]*[sp_Jan_10])+([Feb_10_TOTALdemand]*[sp_Feb_10])+([Mar_10_TOTALdemand]*[sp_Mar_10])+([Apr_10_TOTALdemand]*[sp_Apr_10])
	--+([May_10_TOTALdemand]*[sp_May_10])+([Jun_10_TOTALdemand]*[sp_Jun_10])+([Jul_10_TOTALdemand]*[sp_Jul_10])+([Aug_10_TOTALdemand]*[sp_Aug_10])
	--+([Sep_10_TOTALdemand]*[sp_Sep_10])+([Oct_10_TOTALdemand]*[sp_Oct_10])+([Nov_10_TOTALdemand]*[sp_Nov_10])+([Dec_10_TOTALdemand]*[sp_Dec_10]) as 'Cal_10_Sales' 
		
	--,[Jan_11_TOTALdemand]*[sp_Jan_11] as 'Jan_11_Sales'
	--,[Feb_11_TOTALdemand]*[sp_Feb_11] as 'Feb_11_Sales'
	--,[Mar_11_TOTALdemand]*[sp_Mar_11] as 'Mar_11_Sales'
	--,[Apr_11_TOTALdemand]*[sp_Apr_11] as 'Apr_11_Sales'
	--,[May_11_TOTALdemand]*[sp_May_11] as 'May_11_Sales'
	--,[Jun_11_TOTALdemand]*[sp_Jun_11] as 'Jun_11_Sales'
	--,[Jul_11_TOTALdemand]*[sp_Jul_11] as 'Jul_11_Sales'
	--,[Aug_11_TOTALdemand]*[sp_Aug_11] as 'Aug_11_Sales'
	--,[Sep_11_TOTALdemand]*[sp_Sep_11] as 'Sep_11_Sales'
	--,[Oct_11_TOTALdemand]*[sp_Oct_11] as 'Oct_11_Sales'
	--,[Nov_11_TOTALdemand]*[sp_Nov_11] as 'Nov_11_Sales'
	--,[Dec_11_TOTALdemand]*[sp_Dec_11] as 'Dec_11_Sales'
	--,([Jan_11_TOTALdemand]*[sp_Jan_11])+([Feb_11_TOTALdemand]*[sp_Feb_11])+([Mar_11_TOTALdemand]*[sp_Mar_11])+([Apr_11_TOTALdemand]*[sp_Apr_11])
	--+([May_11_TOTALdemand]*[sp_May_11])+([Jun_11_TOTALdemand]*[sp_Jun_11])+([Jul_11_TOTALdemand]*[sp_Jul_11])+([Aug_11_TOTALdemand]*[sp_Aug_11])
	--+([Sep_11_TOTALdemand]*[sp_Sep_11])+([Oct_11_TOTALdemand]*[sp_Oct_11])+([Nov_11_TOTALdemand]*[sp_Nov_11])+([Dec_11_TOTALdemand]*[sp_Dec_11]) as 'Cal_11_Sales' 
		
	--,[Jan_12_TOTALdemand]*[sp_Jan_12] as 'Jan_12_Sales'
	--,[Feb_12_TOTALdemand]*[sp_Feb_12] as 'Feb_12_Sales'
	--,[Mar_12_TOTALdemand]*[sp_Mar_12] as 'Mar_12_Sales'
	--,[Apr_12_TOTALdemand]*[sp_Apr_12] as 'Apr_12_Sales'
	--,[May_12_TOTALdemand]*[sp_May_12] as 'May_12_Sales'
	--,[Jun_12_TOTALdemand]*[sp_Jun_12] as 'Jun_12_Sales'
	--,[Jul_12_TOTALdemand]*[sp_Jul_12] as 'Jul_12_Sales'
	--,[Aug_12_TOTALdemand]*[sp_Aug_12] as 'Aug_12_Sales'
	--,[Sep_12_TOTALdemand]*[sp_Sep_12] as 'Sep_12_Sales'
	--,[Oct_12_TOTALdemand]*[sp_Oct_12] as 'Oct_12_Sales'
	--,[Nov_12_TOTALdemand]*[sp_Nov_12] as 'Nov_12_Sales'
	--,[Dec_12_TOTALdemand]*[sp_Dec_12] as 'Dec_12_Sales'
	--,([Jan_12_TOTALdemand]*[sp_Jan_12])+([Feb_12_TOTALdemand]*[sp_Feb_12])+([Mar_12_TOTALdemand]*[sp_Mar_12])+([Apr_12_TOTALdemand]*[sp_Apr_12])
	--+([May_12_TOTALdemand]*[sp_May_12])+([Jun_12_TOTALdemand]*[sp_Jun_12])+([Jul_12_TOTALdemand]*[sp_Jul_12])+([Aug_12_TOTALdemand]*[sp_Aug_12])
	--+([Sep_12_TOTALdemand]*[sp_Sep_12])+([Oct_12_TOTALdemand]*[sp_Oct_12])+([Nov_12_TOTALdemand]*[sp_Nov_12])+([Dec_12_TOTALdemand]*[sp_Dec_12]) as 'Cal_12_Sales' 
		
	--,[Jan_13_TOTALdemand]*[sp_Jan_13] as 'Jan_13_Sales'
	--,[Feb_13_TOTALdemand]*[sp_Feb_13] as 'Feb_13_Sales'
	--,[Mar_13_TOTALdemand]*[sp_Mar_13] as 'Mar_13_Sales'
	--,[Apr_13_TOTALdemand]*[sp_Apr_13] as 'Apr_13_Sales'
	--,[May_13_TOTALdemand]*[sp_May_13] as 'May_13_Sales'
	--,[Jun_13_TOTALdemand]*[sp_Jun_13] as 'Jun_13_Sales'
	--,[Jul_13_TOTALdemand]*[sp_Jul_13] as 'Jul_13_Sales'
	--,[Aug_13_TOTALdemand]*[sp_Aug_13] as 'Aug_13_Sales'
	--,[Sep_13_TOTALdemand]*[sp_Sep_13] as 'Sep_13_Sales'
	--,[Oct_13_TOTALdemand]*[sp_Oct_13] as 'Oct_13_Sales'
	--,[Nov_13_TOTALdemand]*[sp_Nov_13] as 'Nov_13_Sales'
	--,[Dec_13_TOTALdemand]*[sp_Dec_13] as 'Dec_13_Sales'
	--,([Jan_13_TOTALdemand]*[sp_Jan_13])+([Feb_13_TOTALdemand]*[sp_Feb_13])+([Mar_13_TOTALdemand]*[sp_Mar_13])+([Apr_13_TOTALdemand]*[sp_Apr_13])
	--+([May_13_TOTALdemand]*[sp_May_13])+([Jun_13_TOTALdemand]*[sp_Jun_13])+([Jul_13_TOTALdemand]*[sp_Jul_13])+([Aug_13_TOTALdemand]*[sp_Aug_13])
	--+([Sep_13_TOTALdemand]*[sp_Sep_13])+([Oct_13_TOTALdemand]*[sp_Oct_13])+([Nov_13_TOTALdemand]*[sp_Nov_13])+([Dec_13_TOTALdemand]*[sp_Dec_13]) as 'Cal_13_Sales' 
		
	--,[Jan_14_TOTALdemand]*[sp_Jan_14] as 'Jan_14_Sales'
	--,[Feb_14_TOTALdemand]*[sp_Feb_14] as 'Feb_14_Sales'
	--,[Mar_14_TOTALdemand]*[sp_Mar_14] as 'Mar_14_Sales'
	--,[Apr_14_TOTALdemand]*[sp_Apr_14] as 'Apr_14_Sales'
	--,[May_14_TOTALdemand]*[sp_May_14] as 'May_14_Sales'
	--,[Jun_14_TOTALdemand]*[sp_Jun_14] as 'Jun_14_Sales'
	--,[Jul_14_TOTALdemand]*[sp_Jul_14] as 'Jul_14_Sales'
	--,[Aug_14_TOTALdemand]*[sp_Aug_14] as 'Aug_14_Sales'
	--,[Sep_14_TOTALdemand]*[sp_Sep_14] as 'Sep_14_Sales'
	--,[Oct_14_TOTALdemand]*[sp_Oct_14] as 'Oct_14_Sales'
	--,[Nov_14_TOTALdemand]*[sp_Nov_14] as 'Nov_14_Sales'
	--,[Dec_14_TOTALdemand]*[sp_Dec_14] as 'Dec_14_Sales'
	--,([Jan_14_TOTALdemand]*[sp_Jan_14])+([Feb_14_TOTALdemand]*[sp_Feb_14])+([Mar_14_TOTALdemand]*[sp_Mar_14])+([Apr_14_TOTALdemand]*[sp_Apr_14])
	--+([May_14_TOTALdemand]*[sp_May_14])+([Jun_14_TOTALdemand]*[sp_Jun_14])+([Jul_14_TOTALdemand]*[sp_Jul_14])+([Aug_14_TOTALdemand]*[sp_Aug_14])
	--+([Sep_14_TOTALdemand]*[sp_Sep_14])+([Oct_14_TOTALdemand]*[sp_Oct_14])+([Nov_14_TOTALdemand]*[sp_Nov_14])+([Dec_14_TOTALdemand]*[sp_Dec_14]) as 'Cal_14_Sales' 

	--,[Jan_15_TOTALdemand]*[sp_Jan_15] as 'Jan_15_Sales'
	--,[Feb_15_TOTALdemand]*[sp_Feb_15] as 'Feb_15_Sales'
	--,[Mar_15_TOTALdemand]*[sp_Mar_15] as 'Mar_15_Sales'
	--,[Apr_15_TOTALdemand]*[sp_Apr_15] as 'Apr_15_Sales'
	--,[May_15_TOTALdemand]*[sp_May_15] as 'May_15_Sales'
	--,[Jun_15_TOTALdemand]*[sp_Jun_15] as 'Jun_15_Sales'
	--,[Jul_15_TOTALdemand]*[sp_Jul_15] as 'Jul_15_Sales'
	--,[Aug_15_TOTALdemand]*[sp_Aug_15] as 'Aug_15_Sales'
	--,[Sep_15_TOTALdemand]*[sp_Sep_15] as 'Sep_15_Sales'
	--,[Oct_15_TOTALdemand]*[sp_Oct_15] as 'Oct_15_Sales'
	--,[Nov_15_TOTALdemand]*[sp_Nov_15] as 'Nov_15_Sales'
	--,[Dec_15_TOTALdemand]*[sp_Dec_15] as 'Dec_15_Sales'
	--,([Jan_15_TOTALdemand]*[sp_Jan_15])+([Feb_15_TOTALdemand]*[sp_Feb_15])+([Mar_15_TOTALdemand]*[sp_Mar_15])+([Apr_15_TOTALdemand]*[sp_Apr_15])
	--+([May_15_TOTALdemand]*[sp_May_15])+([Jun_15_TOTALdemand]*[sp_Jun_15])+([Jul_15_TOTALdemand]*[sp_Jul_15])+([Aug_15_TOTALdemand]*[sp_Aug_15])
	--+([Sep_15_TOTALdemand]*[sp_Sep_15])+([Oct_15_TOTALdemand]*[sp_Oct_15])+([Nov_15_TOTALdemand]*[sp_Nov_15])+([Dec_15_TOTALdemand]*[sp_Dec_15]) as 'Cal_15_Sales' 
		
	,[Jan_16_TOTALdemand]*[sp_Jan_16] as 'Jan_16_Sales'
	,[Feb_16_TOTALdemand]*[sp_Feb_16] as 'Feb_16_Sales'
	,[Mar_16_TOTALdemand]*[sp_Mar_16] as 'Mar_16_Sales'
	,[Apr_16_TOTALdemand]*[sp_Apr_16] as 'Apr_16_Sales'
	,[May_16_TOTALdemand]*[sp_May_16] as 'May_16_Sales'
	,[Jun_16_TOTALdemand]*[sp_Jun_16] as 'Jun_16_Sales'
	,[Jul_16_TOTALdemand]*[sp_Jul_16] as 'Jul_16_Sales'
	,[Aug_16_TOTALdemand]*[sp_Aug_16] as 'Aug_16_Sales'
	,[Sep_16_TOTALdemand]*[sp_Sep_16] as 'Sep_16_Sales'
	,[Oct_16_TOTALdemand]*[sp_Oct_16] as 'Oct_16_Sales'
	,[Nov_16_TOTALdemand]*[sp_Nov_16] as 'Nov_16_Sales'
	,[Dec_16_TOTALdemand]*[sp_Dec_16] as 'Dec_16_Sales'
	,([Jan_16_TOTALdemand]*[sp_Jan_16])+([Feb_16_TOTALdemand]*[sp_Feb_16])+([Mar_16_TOTALdemand]*[sp_Mar_16])+([Apr_16_TOTALdemand]*[sp_Apr_16])
	+([May_16_TOTALdemand]*[sp_May_16])+([Jun_16_TOTALdemand]*[sp_Jun_16])+([Jul_16_TOTALdemand]*[sp_Jul_16])+([Aug_16_TOTALdemand]*[sp_Aug_16])
	+([Sep_16_TOTALdemand]*[sp_Sep_16])+([Oct_16_TOTALdemand]*[sp_Oct_16])+([Nov_16_TOTALdemand]*[sp_Nov_16])+([Dec_16_TOTALdemand]*[sp_Dec_16]) as 'Cal_16_Sales' 
		
	,[Jan_17_TOTALdemand]*[sp_Jan_17] as 'Jan_17_Sales'
	,[Feb_17_TOTALdemand]*[sp_Feb_17] as 'Feb_17_Sales'
	,[Mar_17_TOTALdemand]*[sp_Mar_17] as 'Mar_17_Sales'
	,[Apr_17_TOTALdemand]*[sp_Apr_17] as 'Apr_17_Sales'
	,[May_17_TOTALdemand]*[sp_May_17] as 'May_17_Sales'
	,[Jun_17_TOTALdemand]*[sp_Jun_17] as 'Jun_17_Sales'
	,[Jul_17_TOTALdemand]*[sp_Jul_17] as 'Jul_17_Sales'
	,[Aug_17_TOTALdemand]*[sp_Aug_17] as 'Aug_17_Sales'
	,[Sep_17_TOTALdemand]*[sp_Sep_17] as 'Sep_17_Sales'
	,[Oct_17_TOTALdemand]*[sp_Oct_17] as 'Oct_17_Sales'
	,[Nov_17_TOTALdemand]*[sp_Nov_17] as 'Nov_17_Sales'
	,[Dec_17_TOTALdemand]*[sp_Dec_17] as 'Dec_17_Sales'
	,([Jan_17_TOTALdemand]*[sp_Jan_17])+([Feb_17_TOTALdemand]*[sp_Feb_17])+([Mar_17_TOTALdemand]*[sp_Mar_17])+([Apr_17_TOTALdemand]*[sp_Apr_17])
	+([May_17_TOTALdemand]*[sp_May_17])+([Jun_17_TOTALdemand]*[sp_Jun_17])+([Jul_17_TOTALdemand]*[sp_Jul_17])+([Aug_17_TOTALdemand]*[sp_Aug_17])
	+([Sep_17_TOTALdemand]*[sp_Sep_17])+([Oct_17_TOTALdemand]*[sp_Oct_17])+([Nov_17_TOTALdemand]*[sp_Nov_17])+([Dec_17_TOTALdemand]*[sp_Dec_17]) as 'Cal_17_Sales' 
		
	,[Jan_18_TOTALdemand]*[sp_Jan_18] as 'Jan_18_Sales'
	,[Feb_18_TOTALdemand]*[sp_Feb_18] as 'Feb_18_Sales'
	,[Mar_18_TOTALdemand]*[sp_Mar_18] as 'Mar_18_Sales'
	,[Apr_18_TOTALdemand]*[sp_Apr_18] as 'Apr_18_Sales'
	,[May_18_TOTALdemand]*[sp_May_18] as 'May_18_Sales'
	,[Jun_18_TOTALdemand]*[sp_Jun_18] as 'Jun_18_Sales'
	,[Jul_18_TOTALdemand]*[sp_Jul_18] as 'Jul_18_Sales'
	,[Aug_18_TOTALdemand]*[sp_Aug_18] as 'Aug_18_Sales'
	,[Sep_18_TOTALdemand]*[sp_Sep_18] as 'Sep_18_Sales'
	,[Oct_18_TOTALdemand]*[sp_Oct_18] as 'Oct_18_Sales'
	,[Nov_18_TOTALdemand]*[sp_Nov_18] as 'Nov_18_Sales'
	,[Dec_18_TOTALdemand]*[sp_Dec_18] as 'Dec_18_Sales'
	,([Jan_18_TOTALdemand]*[sp_Jan_18])+([Feb_18_TOTALdemand]*[sp_Feb_18])+([Mar_18_TOTALdemand]*[sp_Mar_18])+([Apr_18_TOTALdemand]*[sp_Apr_18])
	+([May_18_TOTALdemand]*[sp_May_18])+([Jun_18_TOTALdemand]*[sp_Jun_18])+([Jul_18_TOTALdemand]*[sp_Jul_18])+([Aug_18_TOTALdemand]*[sp_Aug_18])
	+([Sep_18_TOTALdemand]*[sp_Sep_18])+([Oct_18_TOTALdemand]*[sp_Oct_18])+([Nov_18_TOTALdemand]*[sp_Nov_18])+([Dec_18_TOTALdemand]*[sp_Dec_18]) as 'Cal_18_Sales' 
		
	,[Jan_19_TOTALdemand]*[sp_Jan_19] as 'Jan_19_Sales'
	,[Feb_19_TOTALdemand]*[sp_Feb_19] as 'Feb_19_Sales'
	,[Mar_19_TOTALdemand]*[sp_Mar_19] as 'Mar_19_Sales'
	,[Apr_19_TOTALdemand]*[sp_Apr_19] as 'Apr_19_Sales'
	,[May_19_TOTALdemand]*[sp_May_19] as 'May_19_Sales'
	,[Jun_19_TOTALdemand]*[sp_Jun_19] as 'Jun_19_Sales'
	,[Jul_19_TOTALdemand]*[sp_Jul_19] as 'Jul_19_Sales'
	,[Aug_19_TOTALdemand]*[sp_Aug_19] as 'Aug_19_Sales'
	,[Sep_19_TOTALdemand]*[sp_Sep_19] as 'Sep_19_Sales'
	,[Oct_19_TOTALdemand]*[sp_Oct_19] as 'Oct_19_Sales'
	,[Nov_19_TOTALdemand]*[sp_Nov_19] as 'Nov_19_Sales'
	,[Dec_19_TOTALdemand]*[sp_Dec_19] as 'Dec_19_Sales'
	,([Jan_19_TOTALdemand]*[sp_Jan_19])+([Feb_19_TOTALdemand]*[sp_Feb_19])+([Mar_19_TOTALdemand]*[sp_Mar_19])+([Apr_19_TOTALdemand]*[sp_Apr_19])
	+([May_19_TOTALdemand]*[sp_May_19])+([Jun_19_TOTALdemand]*[sp_Jun_19])+([Jul_19_TOTALdemand]*[sp_Jul_19])+([Aug_19_TOTALdemand]*[sp_Aug_19])
	+([Sep_19_TOTALdemand]*[sp_Sep_19])+([Oct_19_TOTALdemand]*[sp_Oct_19])+([Nov_19_TOTALdemand]*[sp_Nov_19])+([Dec_19_TOTALdemand]*[sp_Dec_19]) as 'Cal_19_Sales' 
		
	,[Jan_20_TOTALdemand]*[sp_Jan_20] as 'Jan_20_Sales'
	,[Feb_20_TOTALdemand]*[sp_Feb_20] as 'Feb_20_Sales'
	,[Mar_20_TOTALdemand]*[sp_Mar_20] as 'Mar_20_Sales'
	,[Apr_20_TOTALdemand]*[sp_Apr_20] as 'Apr_20_Sales'
	,[May_20_TOTALdemand]*[sp_May_20] as 'May_20_Sales'
	,[Jun_20_TOTALdemand]*[sp_Jun_20] as 'Jun_20_Sales'
	,[Jul_20_TOTALdemand]*[sp_Jul_20] as 'Jul_20_Sales'
	,[Aug_20_TOTALdemand]*[sp_Aug_20] as 'Aug_20_Sales'
	,[Sep_20_TOTALdemand]*[sp_Sep_20] as 'Sep_20_Sales'
	,[Oct_20_TOTALdemand]*[sp_Oct_20] as 'Oct_20_Sales'
	,[Nov_20_TOTALdemand]*[sp_Nov_20] as 'Nov_20_Sales'
	,[Dec_20_TOTALdemand]*[sp_Dec_20] as 'Dec_20_Sales'
	,([Jan_20_TOTALdemand]*[sp_Jan_20])+([Feb_20_TOTALdemand]*[sp_Feb_20])+([Mar_20_TOTALdemand]*[sp_Mar_20])+([Apr_20_TOTALdemand]*[sp_Apr_20])
	+([May_20_TOTALdemand]*[sp_May_20])+([Jun_20_TOTALdemand]*[sp_Jun_20])+([Jul_20_TOTALdemand]*[sp_Jul_20])+([Aug_20_TOTALdemand]*[sp_Aug_20])
	+([Sep_20_TOTALdemand]*[sp_Sep_20])+([Oct_20_TOTALdemand]*[sp_Oct_20])+([Nov_20_TOTALdemand]*[sp_Nov_20])+([Dec_20_TOTALdemand]*[sp_Dec_20]) as 'Cal_20_Sales' 
			
	,[Jan_21_TOTALdemand]*[sp_Jan_21] as 'Jan_21_Sales'
	,[Feb_21_TOTALdemand]*[sp_Feb_21] as 'Feb_21_Sales'
	,[Mar_21_TOTALdemand]*[sp_Mar_21] as 'Mar_21_Sales'
	,[Apr_21_TOTALdemand]*[sp_Apr_21] as 'Apr_21_Sales'
	,[May_21_TOTALdemand]*[sp_May_21] as 'May_21_Sales'
	,[Jun_21_TOTALdemand]*[sp_Jun_21] as 'Jun_21_Sales'
	,[Jul_21_TOTALdemand]*[sp_Jul_21] as 'Jul_21_Sales'
	,[Aug_21_TOTALdemand]*[sp_Aug_21] as 'Aug_21_Sales'
	,[Sep_21_TOTALdemand]*[sp_Sep_21] as 'Sep_21_Sales'
	,[Oct_21_TOTALdemand]*[sp_Oct_21] as 'Oct_21_Sales'
	,[Nov_21_TOTALdemand]*[sp_Nov_21] as 'Nov_21_Sales'
	,[Dec_21_TOTALdemand]*[sp_Dec_21] as 'Dec_21_Sales'
	,([Jan_21_TOTALdemand]*[sp_Jan_21])+([Feb_21_TOTALdemand]*[sp_Feb_21])+([Mar_21_TOTALdemand]*[sp_Mar_21])+([Apr_21_TOTALdemand]*[sp_Apr_21])
	+([May_21_TOTALdemand]*[sp_May_21])+([Jun_21_TOTALdemand]*[sp_Jun_21])+([Jul_21_TOTALdemand]*[sp_Jul_21])+([Aug_21_TOTALdemand]*[sp_Aug_21])
	+([Sep_21_TOTALdemand]*[sp_Sep_21])+([Oct_21_TOTALdemand]*[sp_Oct_21])+([Nov_21_TOTALdemand]*[sp_Nov_21])+([Dec_21_TOTALdemand]*[sp_Dec_21]) as 'Cal_21_Sales' 
	
	,[Cal_22_TOTALdemand]*[sp_Dec_22] as 'Cal_22_Sales'
	,[Cal_23_TOTALdemand]*[sp_Dec_23] as 'Cal_23_Sales'
	,[Cal_24_TOTALdemand]*[sp_Dec_24] as 'Cal_24_Sales'
	,[Cal_25_TOTALdemand]*[sp_Dec_25] as 'Cal_25_Sales'
	,[Cal_26_TOTALdemand]*[sp_Dec_26] as 'Cal_26_Sales'
				
	--,([Jan_15_TOTALdemand]*[sp_Jan_15])+([Feb_15_TOTALdemand]*[sp_Feb_15])+([Mar_15_TOTALdemand]*[sp_Mar_15])+([Apr_15_TOTALdemand]*[sp_Apr_15])
	--+([May_15_TOTALdemand]*[sp_May_15])+([Jun_15_TOTALdemand]*[sp_Jun_15])+([Jul_15_TOTALdemand]*[sp_Jul_15])+([Aug_15_TOTALdemand]*[sp_Aug_15])
	--+([Sep_15_TOTALdemand]*[sp_Sep_15])+([Oct_15_TOTALdemand]*[sp_Oct_15])+([Nov_15_TOTALdemand]*[sp_Nov_15])+([Dec_15_TOTALdemand]*[sp_Dec_15]) 
	,([Jan_16_TOTALdemand]*[sp_Jan_16])+([Feb_16_TOTALdemand]*[sp_Feb_16])+([Mar_16_TOTALdemand]*[sp_Mar_16])+([Apr_16_TOTALdemand]*[sp_Apr_16])
	+([May_16_TOTALdemand]*[sp_May_16])+([Jun_16_TOTALdemand]*[sp_Jun_16])+([Jul_16_TOTALdemand]*[sp_Jul_16])+([Aug_16_TOTALdemand]*[sp_Aug_16])
	+([Sep_16_TOTALdemand]*[sp_Sep_16])+([Oct_16_TOTALdemand]*[sp_Oct_16])+([Nov_16_TOTALdemand]*[sp_Nov_16])+([Dec_16_TOTALdemand]*[sp_Dec_16]) 
	+([Jan_17_TOTALdemand]*[sp_Jan_17])+([Feb_17_TOTALdemand]*[sp_Feb_17])+([Mar_17_TOTALdemand]*[sp_Mar_17])+([Apr_17_TOTALdemand]*[sp_Apr_17])
	+([May_17_TOTALdemand]*[sp_May_17])+([Jun_17_TOTALdemand]*[sp_Jun_17])+([Jul_17_TOTALdemand]*[sp_Jul_17])+([Aug_17_TOTALdemand]*[sp_Aug_17])
	+([Sep_17_TOTALdemand]*[sp_Sep_17])+([Oct_17_TOTALdemand]*[sp_Oct_17])+([Nov_17_TOTALdemand]*[sp_Nov_17])+([Dec_17_TOTALdemand]*[sp_Dec_17]) 
	+([Jan_18_TOTALdemand]*[sp_Jan_18])+([Feb_18_TOTALdemand]*[sp_Feb_18])+([Mar_18_TOTALdemand]*[sp_Mar_18])+([Apr_18_TOTALdemand]*[sp_Apr_18])
	+([May_18_TOTALdemand]*[sp_May_18])+([Jun_18_TOTALdemand]*[sp_Jun_18])+([Jul_18_TOTALdemand]*[sp_Jul_18])+([Aug_18_TOTALdemand]*[sp_Aug_18])
	+([Sep_18_TOTALdemand]*[sp_Sep_18])+([Oct_18_TOTALdemand]*[sp_Oct_18])+([Nov_18_TOTALdemand]*[sp_Nov_18])+([Dec_18_TOTALdemand]*[sp_Dec_18]) 
	+([Jan_19_TOTALdemand]*[sp_Jan_19])+([Feb_19_TOTALdemand]*[sp_Feb_19])+([Mar_19_TOTALdemand]*[sp_Mar_19])+([Apr_19_TOTALdemand]*[sp_Apr_19])
	+([May_19_TOTALdemand]*[sp_May_19])+([Jun_19_TOTALdemand]*[sp_Jun_19])+([Jul_19_TOTALdemand]*[sp_Jul_19])+([Aug_19_TOTALdemand]*[sp_Aug_19])
	+([Sep_19_TOTALdemand]*[sp_Sep_19])+([Oct_19_TOTALdemand]*[sp_Oct_19])+([Nov_19_TOTALdemand]*[sp_Nov_19])+([Dec_19_TOTALdemand]*[sp_Dec_19])
	+([Jan_20_TOTALdemand]*[sp_Jan_20])+([Feb_20_TOTALdemand]*[sp_Feb_20])+([Mar_20_TOTALdemand]*[sp_Mar_20])+([Apr_20_TOTALdemand]*[sp_Apr_20])
	+([May_20_TOTALdemand]*[sp_May_20])+([Jun_20_TOTALdemand]*[sp_Jun_20])+([Jul_20_TOTALdemand]*[sp_Jul_20])+([Aug_20_TOTALdemand]*[sp_Aug_20])
	+([Sep_20_TOTALdemand]*[sp_Sep_20])+([Oct_20_TOTALdemand]*[sp_Oct_20])+([Nov_20_TOTALdemand]*[sp_Nov_20])+([Dec_20_TOTALdemand]*[sp_Dec_20])
	+([Jan_21_TOTALdemand]*[sp_Jan_21])+([Feb_21_TOTALdemand]*[sp_Feb_21])+([Mar_21_TOTALdemand]*[sp_Mar_21])+([Apr_21_TOTALdemand]*[sp_Apr_21])
	+([May_21_TOTALdemand]*[sp_May_21])+([Jun_21_TOTALdemand]*[sp_Jun_21])+([Jul_21_TOTALdemand]*[sp_Jul_21])+([Aug_21_TOTALdemand]*[sp_Aug_21])
	+([Sep_21_TOTALdemand]*[sp_Sep_21])+([Oct_21_TOTALdemand]*[sp_Oct_21])+([Nov_21_TOTALdemand]*[sp_Nov_21])+([Dec_21_TOTALdemand]*[sp_Dec_21])
	+([Cal_22_TOTALdemand]*[sp_Dec_22])
	+([Cal_23_TOTALdemand]*[sp_Dec_23])
	+([Cal_24_TOTALdemand]*[sp_Dec_24])
	+([Cal_25_TOTALdemand]*[sp_Dec_25])
	+([Cal_26_TOTALdemand]*[sp_Dec_26]) as '2016-2026 Sales'
		
	--,[Jan_14_TOTALdemand]*[mc_Jan_14] as 'Jan_14_MC'
	--,[Feb_14_TOTALdemand]*[mc_Feb_14] as 'Feb_14_MC'
	--,[Mar_14_TOTALdemand]*[mc_Mar_14] as 'Mar_14_MC'
	--,[Apr_14_TOTALdemand]*[mc_Apr_14] as 'Apr_14_MC'
	--,[May_14_TOTALdemand]*[mc_May_14] as 'May_14_MC'
	--,[Jun_14_TOTALdemand]*[mc_Jun_14] as 'Jun_14_MC'
	--,[Jul_14_TOTALdemand]*[mc_Jul_14] as 'Jul_14_MC'
	--,[Aug_14_TOTALdemand]*[mc_Aug_14] as 'Aug_14_MC'
	--,[Sep_14_TOTALdemand]*[mc_Sep_14] as 'Sep_14_MC'
	--,[Oct_14_TOTALdemand]*[mc_Oct_14] as 'Oct_14_MC'
	--,[Nov_14_TOTALdemand]*[mc_Nov_14] as 'Nov_14_MC'
	--,[Dec_14_TOTALdemand]*[mc_Dec_14] as 'Dec_14_MC'
	--,([Jan_14_TOTALdemand]*[mc_Jan_14])+([Feb_14_TOTALdemand]*[mc_Feb_14])+([Mar_14_TOTALdemand]*[mc_Mar_14])+([Apr_14_TOTALdemand]*[mc_Apr_14])
	--+([May_14_TOTALdemand]*[mc_May_14])+([Jun_14_TOTALdemand]*[mc_Jun_14])+([Jul_14_TOTALdemand]*[mc_Jul_14])+([Aug_14_TOTALdemand]*[mc_Aug_14])
	--+([Sep_14_TOTALdemand]*[mc_Sep_14])+([Oct_14_TOTALdemand]*[mc_Oct_14])+([Nov_14_TOTALdemand]*[mc_Nov_14])+([Dec_14_TOTALdemand]*[mc_Dec_14]) as 'Cal_14_MC' 

	--,[Jan_15_TOTALdemand]*[mc_Jan_15] as 'Jan_15_MC'
	--,[Feb_15_TOTALdemand]*[mc_Feb_15] as 'Feb_15_MC'
	--,[Mar_15_TOTALdemand]*[mc_Mar_15] as 'Mar_15_MC'
	--,[Apr_15_TOTALdemand]*[mc_Apr_15] as 'Apr_15_MC'
	--,[May_15_TOTALdemand]*[mc_May_15] as 'May_15_MC'
	--,[Jun_15_TOTALdemand]*[mc_Jun_15] as 'Jun_15_MC'
	--,[Jul_15_TOTALdemand]*[mc_Jul_15] as 'Jul_15_MC'
	--,[Aug_15_TOTALdemand]*[mc_Aug_15] as 'Aug_15_MC'
	--,[Sep_15_TOTALdemand]*[mc_Sep_15] as 'Sep_15_MC'
	--,[Oct_15_TOTALdemand]*[mc_Oct_15] as 'Oct_15_MC'
	--,[Nov_15_TOTALdemand]*[mc_Nov_15] as 'Nov_15_MC'
	--,[Dec_15_TOTALdemand]*[mc_Dec_15] as 'Dec_15_MC'
	--,([Jan_15_TOTALdemand]*[mc_Jan_15])+([Feb_15_TOTALdemand]*[mc_Feb_15])+([Mar_15_TOTALdemand]*[mc_Mar_15])+([Apr_15_TOTALdemand]*[mc_Apr_15])
	--+([May_15_TOTALdemand]*[mc_May_15])+([Jun_15_TOTALdemand]*[mc_Jun_15])+([Jul_15_TOTALdemand]*[mc_Jul_15])+([Aug_15_TOTALdemand]*[mc_Aug_15])
	--+([Sep_15_TOTALdemand]*[mc_Sep_15])+([Oct_15_TOTALdemand]*[mc_Oct_15])+([Nov_15_TOTALdemand]*[mc_Nov_15])+([Dec_15_TOTALdemand]*[mc_Dec_15]) as 'Cal_15_MC' 
		
	,[Jan_16_TOTALdemand]*[mc_Jan_16] as 'Jan_16_MC'
	,[Feb_16_TOTALdemand]*[mc_Feb_16] as 'Feb_16_MC'
	,[Mar_16_TOTALdemand]*[mc_Mar_16] as 'Mar_16_MC'
	,[Apr_16_TOTALdemand]*[mc_Apr_16] as 'Apr_16_MC'
	,[May_16_TOTALdemand]*[mc_May_16] as 'May_16_MC'
	,[Jun_16_TOTALdemand]*[mc_Jun_16] as 'Jun_16_MC'
	,[Jul_16_TOTALdemand]*[mc_Jul_16] as 'Jul_16_MC'
	,[Aug_16_TOTALdemand]*[mc_Aug_16] as 'Aug_16_MC'
	,[Sep_16_TOTALdemand]*[mc_Sep_16] as 'Sep_16_MC'
	,[Oct_16_TOTALdemand]*[mc_Oct_16] as 'Oct_16_MC'
	,[Nov_16_TOTALdemand]*[mc_Nov_16] as 'Nov_16_MC'
	,[Dec_16_TOTALdemand]*[mc_Dec_16] as 'Dec_16_MC'
	,([Jan_16_TOTALdemand]*[mc_Jan_16])+([Feb_16_TOTALdemand]*[mc_Feb_16])+([Mar_16_TOTALdemand]*[mc_Mar_16])+([Apr_16_TOTALdemand]*[mc_Apr_16])
	+([May_16_TOTALdemand]*[mc_May_16])+([Jun_16_TOTALdemand]*[mc_Jun_16])+([Jul_16_TOTALdemand]*[mc_Jul_16])+([Aug_16_TOTALdemand]*[mc_Aug_16])
	+([Sep_16_TOTALdemand]*[mc_Sep_16])+([Oct_16_TOTALdemand]*[mc_Oct_16])+([Nov_16_TOTALdemand]*[mc_Nov_16])+([Dec_16_TOTALdemand]*[mc_Dec_16]) as 'Cal_16_MC' 
		
	,[Jan_17_TOTALdemand]*[mc_Jan_17] as 'Jan_17_MC'
	,[Feb_17_TOTALdemand]*[mc_Feb_17] as 'Feb_17_MC'
	,[Mar_17_TOTALdemand]*[mc_Mar_17] as 'Mar_17_MC'
	,[Apr_17_TOTALdemand]*[mc_Apr_17] as 'Apr_17_MC'
	,[May_17_TOTALdemand]*[mc_May_17] as 'May_17_MC'
	,[Jun_17_TOTALdemand]*[mc_Jun_17] as 'Jun_17_MC'
	,[Jul_17_TOTALdemand]*[mc_Jul_17] as 'Jul_17_MC'
	,[Aug_17_TOTALdemand]*[mc_Aug_17] as 'Aug_17_MC'
	,[Sep_17_TOTALdemand]*[mc_Sep_17] as 'Sep_17_MC'
	,[Oct_17_TOTALdemand]*[mc_Oct_17] as 'Oct_17_MC'
	,[Nov_17_TOTALdemand]*[mc_Nov_17] as 'Nov_17_MC'
	,[Dec_17_TOTALdemand]*[mc_Dec_17] as 'Dec_17_MC'
	,([Jan_17_TOTALdemand]*[mc_Jan_17])+([Feb_17_TOTALdemand]*[mc_Feb_17])+([Mar_17_TOTALdemand]*[mc_Mar_17])+([Apr_17_TOTALdemand]*[mc_Apr_17])
	+([May_17_TOTALdemand]*[mc_May_17])+([Jun_17_TOTALdemand]*[mc_Jun_17])+([Jul_17_TOTALdemand]*[mc_Jul_17])+([Aug_17_TOTALdemand]*[mc_Aug_17])
	+([Sep_17_TOTALdemand]*[mc_Sep_17])+([Oct_17_TOTALdemand]*[mc_Oct_17])+([Nov_17_TOTALdemand]*[mc_Nov_17])+([Dec_17_TOTALdemand]*[mc_Dec_17]) as 'Cal_17_MC' 

	,[Jan_18_TOTALdemand]*[mc_Jan_18] as 'Jan_18_MC'
	,[Feb_18_TOTALdemand]*[mc_Feb_18] as 'Feb_18_MC'
	,[Mar_18_TOTALdemand]*[mc_Mar_18] as 'Mar_18_MC'
	,[Apr_18_TOTALdemand]*[mc_Apr_18] as 'Apr_18_MC'
	,[May_18_TOTALdemand]*[mc_May_18] as 'May_18_MC'
	,[Jun_18_TOTALdemand]*[mc_Jun_18] as 'Jun_18_MC'
	,[Jul_18_TOTALdemand]*[mc_Jul_18] as 'Jul_18_MC'
	,[Aug_18_TOTALdemand]*[mc_Aug_18] as 'Aug_18_MC'
	,[Sep_18_TOTALdemand]*[mc_Sep_18] as 'Sep_18_MC'
	,[Oct_18_TOTALdemand]*[mc_Oct_18] as 'Oct_18_MC'
	,[Nov_18_TOTALdemand]*[mc_Nov_18] as 'Nov_18_MC'
	,[Dec_18_TOTALdemand]*[mc_Dec_18] as 'Dec_18_MC'
	,([Jan_18_TOTALdemand]*[mc_Jan_18])+([Feb_18_TOTALdemand]*[mc_Feb_18])+([Mar_18_TOTALdemand]*[mc_Mar_18])+([Apr_18_TOTALdemand]*[mc_Apr_18])
	+([May_18_TOTALdemand]*[mc_May_18])+([Jun_18_TOTALdemand]*[mc_Jun_18])+([Jul_18_TOTALdemand]*[mc_Jul_18])+([Aug_18_TOTALdemand]*[mc_Aug_18])
	+([Sep_18_TOTALdemand]*[mc_Sep_18])+([Oct_18_TOTALdemand]*[mc_Oct_18])+([Nov_18_TOTALdemand]*[mc_Nov_18])+([Dec_18_TOTALdemand]*[mc_Dec_18]) as 'Cal_18_MC' 

	,[Jan_19_TOTALdemand]*[mc_Jan_19] as 'Jan_19_MC'
	,[Feb_19_TOTALdemand]*[mc_Feb_19] as 'Feb_19_MC'
	,[Mar_19_TOTALdemand]*[mc_Mar_19] as 'Mar_19_MC'
	,[Apr_19_TOTALdemand]*[mc_Apr_19] as 'Apr_19_MC'
	,[May_19_TOTALdemand]*[mc_May_19] as 'May_19_MC'
	,[Jun_19_TOTALdemand]*[mc_Jun_19] as 'Jun_19_MC'
	,[Jul_19_TOTALdemand]*[mc_Jul_19] as 'Jul_19_MC'
	,[Aug_19_TOTALdemand]*[mc_Aug_19] as 'Aug_19_MC'
	,[Sep_19_TOTALdemand]*[mc_Sep_19] as 'Sep_19_MC'
	,[Oct_19_TOTALdemand]*[mc_Oct_19] as 'Oct_19_MC'
	,[Nov_19_TOTALdemand]*[mc_Nov_19] as 'Nov_19_MC'
	,[Dec_19_TOTALdemand]*[mc_Dec_19] as 'Dec_19_MC'
	,([Jan_19_TOTALdemand]*[mc_Jan_19])+([Feb_19_TOTALdemand]*[mc_Feb_19])+([Mar_19_TOTALdemand]*[mc_Mar_19])+([Apr_19_TOTALdemand]*[mc_Apr_19])
	+([May_19_TOTALdemand]*[mc_May_19])+([Jun_19_TOTALdemand]*[mc_Jun_19])+([Jul_19_TOTALdemand]*[mc_Jul_19])+([Aug_19_TOTALdemand]*[mc_Aug_19])
	+([Sep_19_TOTALdemand]*[mc_Sep_19])+([Oct_19_TOTALdemand]*[mc_Oct_19])+([Nov_19_TOTALdemand]*[mc_Nov_19])+([Dec_19_TOTALdemand]*[mc_Dec_19]) as 'Cal_19_MC' 

	,[Jan_20_TOTALdemand]*[mc_Jan_20] as 'Jan_20_MC'
	,[Feb_20_TOTALdemand]*[mc_Feb_20] as 'Feb_20_MC'
	,[Mar_20_TOTALdemand]*[mc_Mar_20] as 'Mar_20_MC'
	,[Apr_20_TOTALdemand]*[mc_Apr_20] as 'Apr_20_MC'
	,[May_20_TOTALdemand]*[mc_May_20] as 'May_20_MC'
	,[Jun_20_TOTALdemand]*[mc_Jun_20] as 'Jun_20_MC'
	,[Jul_20_TOTALdemand]*[mc_Jul_20] as 'Jul_20_MC'
	,[Aug_20_TOTALdemand]*[mc_Aug_20] as 'Aug_20_MC'
	,[Sep_20_TOTALdemand]*[mc_Sep_20] as 'Sep_20_MC'
	,[Oct_20_TOTALdemand]*[mc_Oct_20] as 'Oct_20_MC'
	,[Nov_20_TOTALdemand]*[mc_Nov_20] as 'Nov_20_MC'
	,[Dec_20_TOTALdemand]*[mc_Dec_20] as 'Dec_20_MC'
	,([Jan_20_TOTALdemand]*[mc_Jan_20])+([Feb_20_TOTALdemand]*[mc_Feb_20])+([Mar_20_TOTALdemand]*[mc_Mar_20])+([Apr_20_TOTALdemand]*[mc_Apr_20])
	+([May_20_TOTALdemand]*[mc_May_20])+([Jun_20_TOTALdemand]*[mc_Jun_20])+([Jul_20_TOTALdemand]*[mc_Jul_20])+([Aug_20_TOTALdemand]*[mc_Aug_20])
	+([Sep_20_TOTALdemand]*[mc_Sep_20])+([Oct_20_TOTALdemand]*[mc_Oct_20])+([Nov_20_TOTALdemand]*[mc_Nov_20])+([Dec_20_TOTALdemand]*[mc_Dec_20]) as 'Cal_20_MC' 

	,[Jan_21_TOTALdemand]*[mc_Jan_21] as 'Jan_21_MC'
	,[Feb_21_TOTALdemand]*[mc_Feb_21] as 'Feb_21_MC'
	,[Mar_21_TOTALdemand]*[mc_Mar_21] as 'Mar_21_MC'
	,[Apr_21_TOTALdemand]*[mc_Apr_21] as 'Apr_21_MC'
	,[May_21_TOTALdemand]*[mc_May_21] as 'May_21_MC'
	,[Jun_21_TOTALdemand]*[mc_Jun_21] as 'Jun_21_MC'
	,[Jul_21_TOTALdemand]*[mc_Jul_21] as 'Jul_21_MC'
	,[Aug_21_TOTALdemand]*[mc_Aug_21] as 'Aug_21_MC'
	,[Sep_21_TOTALdemand]*[mc_Sep_21] as 'Sep_21_MC'
	,[Oct_21_TOTALdemand]*[mc_Oct_21] as 'Oct_21_MC'
	,[Nov_21_TOTALdemand]*[mc_Nov_21] as 'Nov_21_MC'
	,[Dec_21_TOTALdemand]*[mc_Dec_21] as 'Dec_21_MC'
	,([Jan_21_TOTALdemand]*[mc_Jan_21])+([Feb_21_TOTALdemand]*[mc_Feb_21])+([Mar_21_TOTALdemand]*[mc_Mar_21])+([Apr_21_TOTALdemand]*[mc_Apr_21])
	+([May_21_TOTALdemand]*[mc_May_21])+([Jun_21_TOTALdemand]*[mc_Jun_21])+([Jul_21_TOTALdemand]*[mc_Jul_21])+([Aug_21_TOTALdemand]*[mc_Aug_21])
	+([Sep_21_TOTALdemand]*[mc_Sep_21])+([Oct_21_TOTALdemand]*[mc_Oct_21])+([Nov_21_TOTALdemand]*[mc_Nov_21])+([Dec_21_TOTALdemand]*[mc_Dec_21]) as 'Cal_21_MC' 

	,[Cal_22_TOTALdemand]*[mc_Dec_22] as 'Cal_22_MC'
	,[Cal_23_TOTALdemand]*[mc_Dec_23] as 'Cal_23_MC'
	,[Cal_24_TOTALdemand]*[mc_Dec_24] as 'Cal_24_MC'
	,[Cal_25_TOTALdemand]*[mc_Dec_25] as 'Cal_25_MC'
	,[Cal_26_TOTALdemand]*[mc_Dec_26] as 'Cal_26_MC'
			
	--,Coalesce((XX.CurrentRevPart),'NoActivePartDefined') as ActiveRevLevel
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_Dec_15) as ActiveRevPartMaterialAccum
		
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand] as Jan_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand] as Feb_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand] as Mar_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand] as Apr_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand] as May_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand] as Jun_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand] as Jul_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand] as Aug_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand] as Sep_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand] as Oct_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand] as Nov_10_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand] as Dec_10_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand]) as Cal_10_TOTALMaterialCUM
	
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand] as Jan_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand] as Feb_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand] as Mar_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand] as Apr_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand] as May_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand] as Jun_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand] as Jul_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand] as Aug_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand] as Sep_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand] as Oct_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand] as Nov_11_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand] as Dec_11_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand]) as Cal_11_TOTALMaterialCUM
	
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand] as Jan_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand] as Feb_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand] as Mar_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand] as Apr_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand] as May_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand] as Jun_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand] as Jul_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand] as Aug_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand] as Sep_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand] as Oct_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand] as Nov_12_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand] as Dec_12_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand]) as Cal_12_TOTALMaterialCUM

	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand] as Jan_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand] as Feb_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand] as Mar_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand] as Apr_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand] as May_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand] as Jun_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand] as Jul_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand] as Aug_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand] as Sep_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand] as Oct_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand] as Nov_13_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand] as Dec_13_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand]) as Cal_13_TOTALMaterialCUM
		
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_14)*[Jan_14_TOTALdemand] as Jan_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_14)*[Feb_14_TOTALdemand] as Feb_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_14)*[Mar_14_TOTALdemand] as Mar_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_14)*[Apr_14_TOTALdemand] as Apr_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_14)*[May_14_TOTALdemand] as May_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_14)*[Jun_14_TOTALdemand] as Jun_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_14)*[Jul_14_TOTALdemand] as Jul_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_14)*[Aug_14_TOTALdemand] as Aug_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_14)*[Sep_14_TOTALdemand] as Sep_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_14)*[Oct_14_TOTALdemand] as Oct_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_14)*[Nov_14_TOTALdemand] as Nov_14_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_14)*[Dec_14_TOTALdemand] as Dec_14_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_14)*[Jan_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_14)*[Feb_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_14)*[Mar_14_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_14)*[Apr_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_14)*[May_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_14)*[Jun_14_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_14)*[Jul_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_14)*[Aug_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_14)*[Sep_14_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_14)*[Oct_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_14)*[Nov_14_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_14)*[Dec_14_TOTALdemand]) as Cal_14_TOTALMaterialCUM
		
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_15)*[Jan_15_TOTALdemand] as Jan_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_15)*[Feb_15_TOTALdemand] as Feb_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_15)*[Mar_15_TOTALdemand] as Mar_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_15)*[Apr_15_TOTALdemand] as Apr_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_15)*[May_15_TOTALdemand] as May_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_15)*[Jun_15_TOTALdemand] as Jun_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_15)*[Jul_15_TOTALdemand] as Jul_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_15)*[Aug_15_TOTALdemand] as Aug_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_15)*[Sep_15_TOTALdemand] as Sep_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_15)*[Oct_15_TOTALdemand] as Oct_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_15)*[Nov_15_TOTALdemand] as Nov_15_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_15)*[Dec_15_TOTALdemand] as Dec_15_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_15)*[Jan_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_15)*[Feb_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_15)*[Mar_15_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_15)*[Apr_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_15)*[May_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_15)*[Jun_15_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_15)*[Jul_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_15)*[Aug_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_15)*[Sep_15_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_15)*[Oct_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_15)*[Nov_15_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_15)*[Dec_15_TOTALdemand]) as Cal_15_TOTALMaterialCUM
		
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_16)*[Jan_16_TOTALdemand] as Jan_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_16)*[Feb_16_TOTALdemand] as Feb_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_16)*[Mar_16_TOTALdemand] as Mar_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_16)*[Apr_16_TOTALdemand] as Apr_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_16)*[May_16_TOTALdemand] as May_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_16)*[Jun_16_TOTALdemand] as Jun_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_16)*[Jul_16_TOTALdemand] as Jul_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_16)*[Aug_16_TOTALdemand] as Aug_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_16)*[Sep_16_TOTALdemand] as Sep_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_16)*[Oct_16_TOTALdemand] as Oct_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_16)*[Nov_16_TOTALdemand] as Nov_16_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_16)*[Dec_16_TOTALdemand] as Dec_16_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_16)*[Jan_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_16)*[Feb_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_16)*[Mar_16_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_16)*[Apr_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_16)*[May_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_16)*[Jun_16_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_16)*[Jul_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_16)*[Aug_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_16)*[Sep_16_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_16)*[Oct_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_16)*[Nov_16_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_16)*[Dec_16_TOTALdemand]) as Cal_16_TOTALMaterialCUM
					
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_17)*[Jan_17_TOTALdemand] as Jan_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_17)*[Feb_17_TOTALdemand] as Feb_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_17)*[Mar_17_TOTALdemand] as Mar_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_17)*[Apr_17_TOTALdemand] as Apr_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_17)*[May_17_TOTALdemand] as May_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_17)*[Jun_17_TOTALdemand] as Jun_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_17)*[Jul_17_TOTALdemand] as Jul_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_17)*[Aug_17_TOTALdemand] as Aug_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_17)*[Sep_17_TOTALdemand] as Sep_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_17)*[Oct_17_TOTALdemand] as Oct_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_17)*[Nov_17_TOTALdemand] as Nov_17_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_17)*[Dec_17_TOTALdemand] as Dec_17_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_17)*[Jan_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_17)*[Feb_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_17)*[Mar_17_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_17)*[Apr_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_17)*[May_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_17)*[Jun_17_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_17)*[Jul_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_17)*[Aug_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_17)*[Sep_17_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_17)*[Oct_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_17)*[Nov_17_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_17)*[Dec_17_TOTALdemand]) as Cal_17_TOTALMaterialCUM
		
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_18)*[Jan_18_TOTALdemand] as Jan_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_18)*[Feb_18_TOTALdemand] as Feb_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_18)*[Mar_18_TOTALdemand] as Mar_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_18)*[Apr_18_TOTALdemand] as Apr_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_18)*[May_18_TOTALdemand] as May_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_18)*[Jun_18_TOTALdemand] as Jun_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_18)*[Jul_18_TOTALdemand] as Jul_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_18)*[Aug_18_TOTALdemand] as Aug_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_18)*[Sep_18_TOTALdemand] as Sep_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_18)*[Oct_18_TOTALdemand] as Oct_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_18)*[Nov_18_TOTALdemand] as Nov_18_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_18)*[Dec_18_TOTALdemand] as Dec_18_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_18)*[Jan_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_18)*[Feb_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_18)*[Mar_18_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_18)*[Apr_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_18)*[May_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_18)*[Jun_18_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_18)*[Jul_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_18)*[Aug_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_18)*[Sep_18_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_18)*[Oct_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_18)*[Nov_18_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_18)*[Dec_18_TOTALdemand]) as Cal_18_TOTALMaterialCUM
				
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_19)*[Jan_19_TOTALdemand] as Jan_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_19)*[Feb_19_TOTALdemand] as Feb_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_19)*[Mar_19_TOTALdemand] as Mar_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_19)*[Apr_19_TOTALdemand] as Apr_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_19)*[May_19_TOTALdemand] as May_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_19)*[Jun_19_TOTALdemand] as Jun_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_19)*[Jul_19_TOTALdemand] as Jul_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_19)*[Aug_19_TOTALdemand] as Aug_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_19)*[Sep_19_TOTALdemand] as Sep_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_19)*[Oct_19_TOTALdemand] as Oct_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_19)*[Nov_19_TOTALdemand] as Nov_19_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_19)*[Dec_19_TOTALdemand] as Dec_19_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_19)*[Jan_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_19)*[Feb_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_19)*[Mar_19_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_19)*[Apr_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_19)*[May_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_19)*[Jun_19_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_19)*[Jul_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_19)*[Aug_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_19)*[Sep_19_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_19)*[Oct_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_19)*[Nov_19_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_19)*[Dec_19_TOTALdemand]) as Cal_19_TOTALMaterialCUM
		
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_20)*[Jan_20_TOTALdemand] as Jan_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_20)*[Feb_20_TOTALdemand] as Feb_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_20)*[Mar_20_TOTALdemand] as Mar_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_20)*[Apr_20_TOTALdemand] as Apr_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_20)*[May_20_TOTALdemand] as May_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_20)*[Jun_20_TOTALdemand] as Jun_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_20)*[Jul_20_TOTALdemand] as Jul_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_20)*[Aug_20_TOTALdemand] as Aug_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_20)*[Sep_20_TOTALdemand] as Sep_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_20)*[Oct_20_TOTALdemand] as Oct_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_20)*[Nov_20_TOTALdemand] as Nov_20_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_20)*[Dec_20_TOTALdemand] as Dec_20_TOTALMaterialCUM
	--,(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jan_20)*[Jan_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_feb_20)*[Feb_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_mar_20)*[Mar_20_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_apr_20)*[Apr_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_may_20)*[May_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jun_20)*[Jun_20_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_jul_20)*[Jul_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_aug_20)*[Aug_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_sep_20)*[Sep_20_TOTALdemand])
	--+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_oct_20)*[Oct_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_nov_20)*[Nov_20_TOTALdemand])+(Coalesce(XX.CurrentRevMaterialAccum,MC.mc_dec_20)*[Dec_20_TOTALdemand]) as Cal_20_TOTALMaterialCUM

	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Cal_21_TOTALdemand] as Cal_21_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Cal_22_TOTALdemand] as Cal_22_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Cal_23_TOTALdemand] as Cal_23_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Cal_24_TOTALdemand] as Cal_24_TOTALMaterialCUM
	--,Coalesce(XX.CurrentRevMaterialAccum,0)*[Cal_25_TOTALdemand] as Cal_25_TOTALMaterialCUM
				
	from

		/* LEVEL 2 */
		/* STATEMENT 2*/
		(select isnull(aa.base_part,bb.base_part) as base_part,
				isnull(aa.version, bb.version) as version,
				isnull(aa.mnemonic, bb.mnemonic) as mnemonic,
				isnull(aa.platform, bb.platform) as platform,
				isnull(aa.program, bb.program) as program,
				isnull(aa.manufacturer, bb.manufacturer) as manufacturer,
				isnull(aa.badge, bb.badge) as badge,
				isnull(aa.vehicle, bb.vehicle) as vehicle,
				isnull(aa.assembly_plant, bb.assembly_plant) as assembly_plant,
				isnull(aa.product_type, bb.product_type) as product_type,
				isnull(aa.global_segment, bb.global_segment) as global_segment,
				isnull(aa.regional_segment, bb.regional_segment) as regional_segment,
				isnull(aa.CSM_sop, bb.CSM_sop) as csm_sop,
				isnull(aa.CSM_eop, bb.CSM_eop) as csm_eop,

				isnull(aa.qty_per, bb.qty_per) as qty_per,
				isnull(aa.take_rate, bb.take_rate) as take_rate,
				isnull(aa.family_allocation, bb.family_allocation) as family_allocation,
				
				--isnull(aa.Jan_10_CSMdemand,0) as Jan_10_CSMdemand,
				--isnull(aa.Feb_10_CSMdemand,0) as Feb_10_CSMdemand,
				--isnull(aa.Mar_10_CSMdemand,0) as Mar_10_CSMdemand,
				--isnull(aa.Apr_10_CSMdemand,0) as Apr_10_CSMdemand,
				--isnull(aa.May_10_CSMdemand,0) as May_10_CSMdemand,
				--isnull(aa.Jun_10_CSMdemand,0) as Jun_10_CSMdemand,
				--isnull(aa.Jul_10_CSMdemand,0) as Jul_10_CSMdemand,
				--isnull(aa.Aug_10_CSMdemand,0) as Aug_10_CSMdemand,
				--isnull(aa.Sep_10_CSMdemand,0) as Sep_10_CSMdemand,
				--isnull(aa.Oct_10_CSMdemand,0) as Oct_10_CSMdemand,
				--isnull(aa.Nov_10_CSMdemand,0) as Nov_10_CSMdemand,
				--isnull(aa.Dec_10_CSMdemand,0) as Dec_10_CSMdemand,
				--isnull(aa.Cal_10_CSMdemand,0) as Cal_10_CSMdemand,
				
				--isnull(aa.Jan_11_CSMdemand,0) as Jan_11_CSMdemand,
				--isnull(aa.Feb_11_CSMdemand,0) as Feb_11_CSMdemand,
				--isnull(aa.Mar_11_CSMdemand,0) as Mar_11_CSMdemand,
				--isnull(aa.Apr_11_CSMdemand,0) as Apr_11_CSMdemand,
				--isnull(aa.May_11_CSMdemand,0) as May_11_CSMdemand,
				--isnull(aa.Jun_11_CSMdemand,0) as Jun_11_CSMdemand,
				--isnull(aa.Jul_11_CSMdemand,0) as Jul_11_CSMdemand,
				--isnull(aa.Aug_11_CSMdemand,0) as Aug_11_CSMdemand,
				--isnull(aa.Sep_11_CSMdemand,0) as Sep_11_CSMdemand,
				--isnull(aa.Oct_11_CSMdemand,0) as Oct_11_CSMdemand,
				--isnull(aa.Nov_11_CSMdemand,0) as Nov_11_CSMdemand,
				--isnull(aa.Dec_11_CSMdemand,0) as Dec_11_CSMdemand,
				--isnull(aa.Cal_11_CSMdemand,0) as Cal_11_CSMdemand,
				
				--isnull(aa.Jan_12_CSMdemand,0) as Jan_12_CSMdemand,
				--isnull(aa.Feb_12_CSMdemand,0) as Feb_12_CSMdemand,
				--isnull(aa.Mar_12_CSMdemand,0) as Mar_12_CSMdemand,
				--isnull(aa.Apr_12_CSMdemand,0) as Apr_12_CSMdemand,
				--isnull(aa.May_12_CSMdemand,0) as May_12_CSMdemand,
				--isnull(aa.Jun_12_CSMdemand,0) as Jun_12_CSMdemand,
				--isnull(aa.Jul_12_CSMdemand,0) as Jul_12_CSMdemand,
				--isnull(aa.Aug_12_CSMdemand,0) as Aug_12_CSMdemand,
				--isnull(aa.Sep_12_CSMdemand,0) as Sep_12_CSMdemand,
				--isnull(aa.Oct_12_CSMdemand,0) as Oct_12_CSMdemand,
				--isnull(aa.Nov_12_CSMdemand,0) as Nov_12_CSMdemand,
				--isnull(aa.Dec_12_CSMdemand,0) as Dec_12_CSMdemand,
				--isnull(aa.Cal_12_CSMdemand,0) as Cal_12_CSMdemand,		
		
				--isnull(aa.Jan_13_CSMdemand,0) as Jan_13_CSMdemand,
				--isnull(aa.Feb_13_CSMdemand,0) as Feb_13_CSMdemand,
				--isnull(aa.Mar_13_CSMdemand,0) as Mar_13_CSMdemand,
				--isnull(aa.Apr_13_CSMdemand,0) as Apr_13_CSMdemand,
				--isnull(aa.May_13_CSMdemand,0) as May_13_CSMdemand,
				--isnull(aa.Jun_13_CSMdemand,0) as Jun_13_CSMdemand,
				--isnull(aa.Jul_13_CSMdemand,0) as Jul_13_CSMdemand,
				--isnull(aa.Aug_13_CSMdemand,0) as Aug_13_CSMdemand,
				--isnull(aa.Sep_13_CSMdemand,0) as Sep_13_CSMdemand,
				--isnull(aa.Oct_13_CSMdemand,0) as Oct_13_CSMdemand,
				--isnull(aa.Nov_13_CSMdemand,0) as Nov_13_CSMdemand,
				--isnull(aa.Dec_13_CSMdemand,0) as Dec_13_CSMdemand,
				--isnull(aa.Cal_13_CSMdemand,0) as Cal_13_CSMdemand,
		
				--isnull(aa.Jan_14_CSMdemand,0) as Jan_14_CSMdemand,
				--isnull(aa.Feb_14_CSMdemand,0) as Feb_14_CSMdemand,
				--isnull(aa.Mar_14_CSMdemand,0) as Mar_14_CSMdemand,
				--isnull(aa.Apr_14_CSMdemand,0) as Apr_14_CSMdemand,
				--isnull(aa.May_14_CSMdemand,0) as May_14_CSMdemand,
				--isnull(aa.Jun_14_CSMdemand,0) as Jun_14_CSMdemand,
				--isnull(aa.Jul_14_CSMdemand,0) as Jul_14_CSMdemand,
				--isnull(aa.Aug_14_CSMdemand,0) as Aug_14_CSMdemand,
				--isnull(aa.Sep_14_CSMdemand,0) as Sep_14_CSMdemand,
				--isnull(aa.Oct_14_CSMdemand,0) as Oct_14_CSMdemand,
				--isnull(aa.Nov_14_CSMdemand,0) as Nov_14_CSMdemand,
				--isnull(aa.Dec_14_CSMdemand,0) as Dec_14_CSMdemand,
				--isnull(aa.Cal_14_CSMdemand,0) as Cal_14_CSMdemand,

				--isnull(aa.Jan_15_CSMdemand,0) as Jan_15_CSMdemand,
				--isnull(aa.Feb_15_CSMdemand,0) as Feb_15_CSMdemand,
				--isnull(aa.Mar_15_CSMdemand,0) as Mar_15_CSMdemand,
				--isnull(aa.Apr_15_CSMdemand,0) as Apr_15_CSMdemand,
				--isnull(aa.May_15_CSMdemand,0) as May_15_CSMdemand,
				--isnull(aa.Jun_15_CSMdemand,0) as Jun_15_CSMdemand,
				--isnull(aa.Jul_15_CSMdemand,0) as Jul_15_CSMdemand,
				--isnull(aa.Aug_15_CSMdemand,0) as Aug_15_CSMdemand,
				--isnull(aa.Sep_15_CSMdemand,0) as Sep_15_CSMdemand,
				--isnull(aa.Oct_15_CSMdemand,0) as Oct_15_CSMdemand,
				--isnull(aa.Nov_15_CSMdemand,0) as Nov_15_CSMdemand,
				--isnull(aa.Dec_15_CSMdemand,0) as Dec_15_CSMdemand,
				--isnull(aa.Cal_15_CSMdemand,0) as Cal_15_CSMdemand,
				
				isnull(aa.Jan_16_CSMdemand,0) as Jan_16_CSMdemand,
				isnull(aa.Feb_16_CSMdemand,0) as Feb_16_CSMdemand,
				isnull(aa.Mar_16_CSMdemand,0) as Mar_16_CSMdemand,
				isnull(aa.Apr_16_CSMdemand,0) as Apr_16_CSMdemand,
				isnull(aa.May_16_CSMdemand,0) as May_16_CSMdemand,
				isnull(aa.Jun_16_CSMdemand,0) as Jun_16_CSMdemand,
				isnull(aa.Jul_16_CSMdemand,0) as Jul_16_CSMdemand,
				isnull(aa.Aug_16_CSMdemand,0) as Aug_16_CSMdemand,
				isnull(aa.Sep_16_CSMdemand,0) as Sep_16_CSMdemand,
				isnull(aa.Oct_16_CSMdemand,0) as Oct_16_CSMdemand,
				isnull(aa.Nov_16_CSMdemand,0) as Nov_16_CSMdemand,
				isnull(aa.Dec_16_CSMdemand,0) as Dec_16_CSMdemand,
				isnull(aa.Cal_16_CSMdemand,0) as Cal_16_CSMdemand,
				
				isnull(aa.Jan_17_CSMdemand,0) as Jan_17_CSMdemand,
				isnull(aa.Feb_17_CSMdemand,0) as Feb_17_CSMdemand,
				isnull(aa.Mar_17_CSMdemand,0) as Mar_17_CSMdemand,
				isnull(aa.Apr_17_CSMdemand,0) as Apr_17_CSMdemand,
				isnull(aa.May_17_CSMdemand,0) as May_17_CSMdemand,
				isnull(aa.Jun_17_CSMdemand,0) as Jun_17_CSMdemand,
				isnull(aa.Jul_17_CSMdemand,0) as Jul_17_CSMdemand,
				isnull(aa.Aug_17_CSMdemand,0) as Aug_17_CSMdemand,
				isnull(aa.Sep_17_CSMdemand,0) as Sep_17_CSMdemand,
				isnull(aa.Oct_17_CSMdemand,0) as Oct_17_CSMdemand,
				isnull(aa.Nov_17_CSMdemand,0) as Nov_17_CSMdemand,
				isnull(aa.Dec_17_CSMdemand,0) as Dec_17_CSMdemand,
				isnull(aa.Cal_17_CSMdemand,0) as Cal_17_CSMdemand,
				
				isnull(aa.Jan_18_CSMdemand,0) as Jan_18_CSMdemand,
				isnull(aa.Feb_18_CSMdemand,0) as Feb_18_CSMdemand,
				isnull(aa.Mar_18_CSMdemand,0) as Mar_18_CSMdemand,
				isnull(aa.Apr_18_CSMdemand,0) as Apr_18_CSMdemand,
				isnull(aa.May_18_CSMdemand,0) as May_18_CSMdemand,
				isnull(aa.Jun_18_CSMdemand,0) as Jun_18_CSMdemand,
				isnull(aa.Jul_18_CSMdemand,0) as Jul_18_CSMdemand,
				isnull(aa.Aug_18_CSMdemand,0) as Aug_18_CSMdemand,
				isnull(aa.Sep_18_CSMdemand,0) as Sep_18_CSMdemand,
				isnull(aa.Oct_18_CSMdemand,0) as Oct_18_CSMdemand,
				isnull(aa.Nov_18_CSMdemand,0) as Nov_18_CSMdemand,
				isnull(aa.Dec_18_CSMdemand,0) as Dec_18_CSMdemand,
				isnull(aa.Cal_18_CSMdemand,0) as Cal_18_CSMdemand,
				
				isnull(aa.Jan_19_CSMdemand,0) as Jan_19_CSMdemand,
				isnull(aa.Feb_19_CSMdemand,0) as Feb_19_CSMdemand,
				isnull(aa.Mar_19_CSMdemand,0) as Mar_19_CSMdemand,
				isnull(aa.Apr_19_CSMdemand,0) as Apr_19_CSMdemand,
				isnull(aa.May_19_CSMdemand,0) as May_19_CSMdemand,
				isnull(aa.Jun_19_CSMdemand,0) as Jun_19_CSMdemand,
				isnull(aa.Jul_19_CSMdemand,0) as Jul_19_CSMdemand,
				isnull(aa.Aug_19_CSMdemand,0) as Aug_19_CSMdemand,
				isnull(aa.Sep_19_CSMdemand,0) as Sep_19_CSMdemand,
				isnull(aa.Oct_19_CSMdemand,0) as Oct_19_CSMdemand,
				isnull(aa.Nov_19_CSMdemand,0) as Nov_19_CSMdemand,
				isnull(aa.Dec_19_CSMdemand,0) as Dec_19_CSMdemand,
				isnull(aa.Cal_19_CSMdemand,0) as Cal_19_CSMdemand,

				isnull(aa.Jan_20_CSMdemand,0) as Jan_20_CSMdemand,
				isnull(aa.Feb_20_CSMdemand,0) as Feb_20_CSMdemand,
				isnull(aa.Mar_20_CSMdemand,0) as Mar_20_CSMdemand,
				isnull(aa.Apr_20_CSMdemand,0) as Apr_20_CSMdemand,
				isnull(aa.May_20_CSMdemand,0) as May_20_CSMdemand,
				isnull(aa.Jun_20_CSMdemand,0) as Jun_20_CSMdemand,
				isnull(aa.Jul_20_CSMdemand,0) as Jul_20_CSMdemand,
				isnull(aa.Aug_20_CSMdemand,0) as Aug_20_CSMdemand,
				isnull(aa.Sep_20_CSMdemand,0) as Sep_20_CSMdemand,
				isnull(aa.Oct_20_CSMdemand,0) as Oct_20_CSMdemand,
				isnull(aa.Nov_20_CSMdemand,0) as Nov_20_CSMdemand,
				isnull(aa.Dec_20_CSMdemand,0) as Dec_20_CSMdemand,
				isnull(aa.Cal_20_CSMdemand,0) as Cal_20_CSMdemand,
				
				isnull(aa.Jan_21_CSMdemand,0) as Jan_21_CSMdemand,
				isnull(aa.Feb_21_CSMdemand,0) as Feb_21_CSMdemand,
				isnull(aa.Mar_21_CSMdemand,0) as Mar_21_CSMdemand,
				isnull(aa.Apr_21_CSMdemand,0) as Apr_21_CSMdemand,
				isnull(aa.May_21_CSMdemand,0) as May_21_CSMdemand,
				isnull(aa.Jun_21_CSMdemand,0) as Jun_21_CSMdemand,
				isnull(aa.Jul_21_CSMdemand,0) as Jul_21_CSMdemand,
				isnull(aa.Aug_21_CSMdemand,0) as Aug_21_CSMdemand,
				isnull(aa.Sep_21_CSMdemand,0) as Sep_21_CSMdemand,
				isnull(aa.Oct_21_CSMdemand,0) as Oct_21_CSMdemand,
				isnull(aa.Nov_21_CSMdemand,0) as Nov_21_CSMdemand,
				isnull(aa.Dec_21_CSMdemand,0) as Dec_21_CSMdemand,
				isnull(aa.Cal_21_CSMdemand,0) as Cal_21_CSMdemand,
		
				isnull(aa.Cal_22_CSMdemand,0) as Cal_22_CSMdemand,
				isnull(aa.Cal_23_CSMdemand,0) as Cal_23_CSMdemand,
				isnull(aa.Cal_24_CSMdemand,0) as Cal_24_CSMdemand,
				isnull(aa.Cal_25_CSMdemand,0) as Cal_25_CSMdemand,
				isnull(aa.Cal_26_CSMdemand,0) as Cal_26_CSMdemand,

				--isnull(aa.Jan_10_factor,1) as Jan_10_factor,
				--isnull(aa.Feb_10_factor,1) as Feb_10_factor,
				--isnull(aa.Mar_10_factor,1) as Mar_10_factor,
				--isnull(aa.Apr_10_factor,1) as Apr_10_factor,
				--isnull(aa.May_10_factor,1) as May_10_factor,
				--isnull(aa.Jun_10_factor,1) as Jun_10_factor,
				--isnull(aa.Jul_10_factor,1) as Jul_10_factor,
				--isnull(aa.Aug_10_factor,1) as Aug_10_factor,
				--isnull(aa.Sep_10_factor,1) as Sep_10_factor,
				--isnull(aa.Oct_10_factor,1) as Oct_10_factor,
				--isnull(aa.Nov_10_factor,1) as Nov_10_factor,
				--isnull(aa.Dec_10_factor,1) as Dec_10_factor,
				
				--isnull(aa.Jan_11_factor,1) as Jan_11_factor,
				--isnull(aa.Feb_11_factor,1) as Feb_11_factor,
				--isnull(aa.Mar_11_factor,1) as Mar_11_factor,
				--isnull(aa.Apr_11_factor,1) as Apr_11_factor,
				--isnull(aa.May_11_factor,1) as May_11_factor,
				--isnull(aa.Jun_11_factor,1) as Jun_11_factor,
				--isnull(aa.Jul_11_factor,1) as Jul_11_factor,
				--isnull(aa.Aug_11_factor,1) as Aug_11_factor,
				--isnull(aa.Sep_11_factor,1) as Sep_11_factor,
				--isnull(aa.Oct_11_factor,1) as Oct_11_factor,
				--isnull(aa.Nov_11_factor,1) as Nov_11_factor,
				--isnull(aa.Dec_11_factor,1) as Dec_11_factor,
		
				--isnull(aa.Jan_12_factor,1) as Jan_12_factor,
				--isnull(aa.Feb_12_factor,1) as Feb_12_factor,
				--isnull(aa.Mar_12_factor,1) as Mar_12_factor,
				--isnull(aa.Apr_12_factor,1) as Apr_12_factor,
				--isnull(aa.May_12_factor,1) as May_12_factor,
				--isnull(aa.Jun_12_factor,1) as Jun_12_factor,
				--isnull(aa.Jul_12_factor,1) as Jul_12_factor,
				--isnull(aa.Aug_12_factor,1) as Aug_12_factor,
				--isnull(aa.Sep_12_factor,1) as Sep_12_factor,
				--isnull(aa.Oct_12_factor,1) as Oct_12_factor,
				--isnull(aa.Nov_12_factor,1) as Nov_12_factor,
				--isnull(aa.Dec_12_factor,1) as Dec_12_factor,		
				
				--isnull(aa.Jan_13_factor,1) as Jan_13_factor,
				--isnull(aa.Feb_13_factor,1) as Feb_13_factor,
				--isnull(aa.Mar_13_factor,1) as Mar_13_factor,
				--isnull(aa.Apr_13_factor,1) as Apr_13_factor,
				--isnull(aa.May_13_factor,1) as May_13_factor,
				--isnull(aa.Jun_13_factor,1) as Jun_13_factor,
				--isnull(aa.Jul_13_factor,1) as Jul_13_factor,
				--isnull(aa.Aug_13_factor,1) as Aug_13_factor,
				--isnull(aa.Sep_13_factor,1) as Sep_13_factor,
				--isnull(aa.Oct_13_factor,1) as Oct_13_factor,
				--isnull(aa.Nov_13_factor,1) as Nov_13_factor,
				--isnull(aa.Dec_13_factor,1) as Dec_13_factor,			
				
				--isnull(aa.Jan_14_factor,1) as Jan_14_factor,
				--isnull(aa.Feb_14_factor,1) as Feb_14_factor,
				--isnull(aa.Mar_14_factor,1) as Mar_14_factor,
				--isnull(aa.Apr_14_factor,1) as Apr_14_factor,
				--isnull(aa.May_14_factor,1) as May_14_factor,
				--isnull(aa.Jun_14_factor,1) as Jun_14_factor,
				--isnull(aa.Jul_14_factor,1) as Jul_14_factor,
				--isnull(aa.Aug_14_factor,1) as Aug_14_factor,
				--isnull(aa.Sep_14_factor,1) as Sep_14_factor,
				--isnull(aa.Oct_14_factor,1) as Oct_14_factor,
				--isnull(aa.Nov_14_factor,1) as Nov_14_factor,
				--isnull(aa.Dec_14_factor,1) as Dec_14_factor,
				
				--isnull(aa.Jan_15_factor,1) as Jan_15_factor,
				--isnull(aa.Feb_15_factor,1) as Feb_15_factor,
				--isnull(aa.Mar_15_factor,1) as Mar_15_factor,
				--isnull(aa.Apr_15_factor,1) as Apr_15_factor,
				--isnull(aa.May_15_factor,1) as May_15_factor,
				--isnull(aa.Jun_15_factor,1) as Jun_15_factor,
				--isnull(aa.Jul_15_factor,1) as Jul_15_factor,
				--isnull(aa.Aug_15_factor,1) as Aug_15_factor,
				--isnull(aa.Sep_15_factor,1) as Sep_15_factor,
				--isnull(aa.Oct_15_factor,1) as Oct_15_factor,
				--isnull(aa.Nov_15_factor,1) as Nov_15_factor,
				--isnull(aa.Dec_15_factor,1) as Dec_15_factor,			
			
				isnull(aa.Jan_16_factor,1) as Jan_16_factor,
				isnull(aa.Feb_16_factor,1) as Feb_16_factor,
				isnull(aa.Mar_16_factor,1) as Mar_16_factor,
				isnull(aa.Apr_16_factor,1) as Apr_16_factor,
				isnull(aa.May_16_factor,1) as May_16_factor,
				isnull(aa.Jun_16_factor,1) as Jun_16_factor,
				isnull(aa.Jul_16_factor,1) as Jul_16_factor,
				isnull(aa.Aug_16_factor,1) as Aug_16_factor,
				isnull(aa.Sep_16_factor,1) as Sep_16_factor,
				isnull(aa.Oct_16_factor,1) as Oct_16_factor,
				isnull(aa.Nov_16_factor,1) as Nov_16_factor,
				isnull(aa.Dec_16_factor,1) as Dec_16_factor,
				
				isnull(aa.Jan_17_factor,1) as Jan_17_factor,
				isnull(aa.Feb_17_factor,1) as Feb_17_factor,
				isnull(aa.Mar_17_factor,1) as Mar_17_factor,
				isnull(aa.Apr_17_factor,1) as Apr_17_factor,
				isnull(aa.May_17_factor,1) as May_17_factor,
				isnull(aa.Jun_17_factor,1) as Jun_17_factor,
				isnull(aa.Jul_17_factor,1) as Jul_17_factor,
				isnull(aa.Aug_17_factor,1) as Aug_17_factor,
				isnull(aa.Sep_17_factor,1) as Sep_17_factor,
				isnull(aa.Oct_17_factor,1) as Oct_17_factor,
				isnull(aa.Nov_17_factor,1) as Nov_17_factor,
				isnull(aa.Dec_17_factor,1) as Dec_17_factor,
				
				isnull(aa.Jan_18_factor,1) as Jan_18_factor,
				isnull(aa.Feb_18_factor,1) as Feb_18_factor,
				isnull(aa.Mar_18_factor,1) as Mar_18_factor,
				isnull(aa.Apr_18_factor,1) as Apr_18_factor,
				isnull(aa.May_18_factor,1) as May_18_factor,
				isnull(aa.Jun_18_factor,1) as Jun_18_factor,
				isnull(aa.Jul_18_factor,1) as Jul_18_factor,
				isnull(aa.Aug_18_factor,1) as Aug_18_factor,
				isnull(aa.Sep_18_factor,1) as Sep_18_factor,
				isnull(aa.Oct_18_factor,1) as Oct_18_factor,
				isnull(aa.Nov_18_factor,1) as Nov_18_factor,
				isnull(aa.Dec_18_factor,1) as Dec_18_factor,
		
				isnull(aa.Jan_19_factor,1) as Jan_19_factor,
				isnull(aa.Feb_19_factor,1) as Feb_19_factor,
				isnull(aa.Mar_19_factor,1) as Mar_19_factor,
				isnull(aa.Apr_19_factor,1) as Apr_19_factor,
				isnull(aa.May_19_factor,1) as May_19_factor,
				isnull(aa.Jun_19_factor,1) as Jun_19_factor,
				isnull(aa.Jul_19_factor,1) as Jul_19_factor,
				isnull(aa.Aug_19_factor,1) as Aug_19_factor,
				isnull(aa.Sep_19_factor,1) as Sep_19_factor,
				isnull(aa.Oct_19_factor,1) as Oct_19_factor,
				isnull(aa.Nov_19_factor,1) as Nov_19_factor,
				isnull(aa.Dec_19_factor,1) as Dec_19_factor,
					
				isnull(aa.Jan_20_factor,1) as Jan_20_factor,
				isnull(aa.Feb_20_factor,1) as Feb_20_factor,
				isnull(aa.Mar_20_factor,1) as Mar_20_factor,
				isnull(aa.Apr_20_factor,1) as Apr_20_factor,
				isnull(aa.May_20_factor,1) as May_20_factor,
				isnull(aa.Jun_20_factor,1) as Jun_20_factor,
				isnull(aa.Jul_20_factor,1) as Jul_20_factor,
				isnull(aa.Aug_20_factor,1) as Aug_20_factor,
				isnull(aa.Sep_20_factor,1) as Sep_20_factor,
				isnull(aa.Oct_20_factor,1) as Oct_20_factor,
				isnull(aa.Nov_20_factor,1) as Nov_20_factor,
				isnull(aa.Dec_20_factor,1) as Dec_20_factor,
						
				isnull(aa.Jan_21_factor,1) as Jan_21_factor,
				isnull(aa.Feb_21_factor,1) as Feb_21_factor,
				isnull(aa.Mar_21_factor,1) as Mar_21_factor,
				isnull(aa.Apr_21_factor,1) as Apr_21_factor,
				isnull(aa.May_21_factor,1) as May_21_factor,
				isnull(aa.Jun_21_factor,1) as Jun_21_factor,
				isnull(aa.Jul_21_factor,1) as Jul_21_factor,
				isnull(aa.Aug_21_factor,1) as Aug_21_factor,
				isnull(aa.Sep_21_factor,1) as Sep_21_factor,
				isnull(aa.Oct_21_factor,1) as Oct_21_factor,
				isnull(aa.Nov_21_factor,1) as Nov_21_factor,
				isnull(aa.Dec_21_factor,1) as Dec_21_factor,
				
				isnull(aa.Cal_22_factor,1) as Cal_22_factor,
				isnull(aa.CAL_23_factor,1) as Cal_23_factor,	
				isnull(aa.CAL_24_factor,1) as Cal_24_factor,
				isnull(aa.CAL_25_factor,1) as Cal_25_factor,
				isnull(aa.CAL_26_factor,1) as Cal_26_factor,

				--isnull(bb.Jan_10,0) as Jan_10_Empire_Adj,
				--isnull(bb.Feb_10,0) as Feb_10_Empire_Adj,
				--isnull(bb.Mar_10,0) as Mar_10_Empire_Adj,
				--isnull(bb.Apr_10,0) as Apr_10_Empire_Adj,
				--isnull(bb.May_10,0) as May_10_Empire_Adj,
				--isnull(bb.Jun_10,0) as Jun_10_Empire_Adj,		
				--isnull(bb.Jul_10,0) as Jul_10_Empire_Adj,
				--isnull(bb.Aug_10,0) as Aug_10_Empire_Adj,
				--isnull(bb.Sep_10,0) as Sep_10_Empire_Adj,		
				--isnull(bb.Oct_10,0) as Oct_10_Empire_Adj,
				--isnull(bb.Nov_10,0) as Nov_10_Empire_Adj,
				--isnull(bb.Dec_10,0) as Dec_10_Empire_Adj,
				--isnull(bb.Cal_10,0) as Cal_10_Empire_Adj,
				
				--isnull(bb.Jan_11,0) as Jan_11_Empire_Adj,
				--isnull(bb.Feb_11,0) as Feb_11_Empire_Adj,
				--isnull(bb.Mar_11,0) as Mar_11_Empire_Adj,
				--isnull(bb.Apr_11,0) as Apr_11_Empire_Adj,
				--isnull(bb.May_11,0) as May_11_Empire_Adj,
				--isnull(bb.Jun_11,0) as Jun_11_Empire_Adj,		
				--isnull(bb.Jul_11,0) as Jul_11_Empire_Adj,
				--isnull(bb.Aug_11,0) as Aug_11_Empire_Adj,
				--isnull(bb.Sep_11,0) as Sep_11_Empire_Adj,		
				--isnull(bb.Oct_11,0) as Oct_11_Empire_Adj,
				--isnull(bb.Nov_11,0) as Nov_11_Empire_Adj,
				--isnull(bb.Dec_11,0) as Dec_11_Empire_Adj,
				--isnull(bb.Cal_11,0) as Cal_11_Empire_Adj,
				
				--isnull(bb.Jan_12,0) as Jan_12_Empire_Adj,
				--isnull(bb.Feb_12,0) as Feb_12_Empire_Adj,
				--isnull(bb.Mar_12,0) as Mar_12_Empire_Adj,
				--isnull(bb.Apr_12,0) as Apr_12_Empire_Adj,
				--isnull(bb.May_12,0) as May_12_Empire_Adj,
				--isnull(bb.Jun_12,0) as Jun_12_Empire_Adj,		
				--isnull(bb.Jul_12,0) as Jul_12_Empire_Adj,
				--isnull(bb.Aug_12,0) as Aug_12_Empire_Adj,
				--isnull(bb.Sep_12,0) as Sep_12_Empire_Adj,		
				--isnull(bb.Oct_12,0) as Oct_12_Empire_Adj,
				--isnull(bb.Nov_12,0) as Nov_12_Empire_Adj,
				--isnull(bb.Dec_12,0) as Dec_12_Empire_Adj,
				--isnull(bb.Cal_12,0) as Cal_12_Empire_Adj,
	
				--isnull(bb.Jan_13,0) as Jan_13_Empire_Adj,
				--isnull(bb.Feb_13,0) as Feb_13_Empire_Adj,
				--isnull(bb.Mar_13,0) as Mar_13_Empire_Adj,
				--isnull(bb.Apr_13,0) as Apr_13_Empire_Adj,
				--isnull(bb.May_13,0) as May_13_Empire_Adj,
				--isnull(bb.Jun_13,0) as Jun_13_Empire_Adj,		
				--isnull(bb.Jul_13,0) as Jul_13_Empire_Adj,
				--isnull(bb.Aug_13,0) as Aug_13_Empire_Adj,
				--isnull(bb.Sep_13,0) as Sep_13_Empire_Adj,		
				--isnull(bb.Oct_13,0) as Oct_13_Empire_Adj,
				--isnull(bb.Nov_13,0) as Nov_13_Empire_Adj,
				--isnull(bb.Dec_13,0) as Dec_13_Empire_Adj,
				--isnull(bb.Cal_13,0) as Cal_13_Empire_Adj,
	
				--isnull(bb.Jan_14,0) as Jan_14_Empire_Adj,
				--isnull(bb.Feb_14,0) as Feb_14_Empire_Adj,
				--isnull(bb.Mar_14,0) as Mar_14_Empire_Adj,
				--isnull(bb.Apr_14,0) as Apr_14_Empire_Adj,
				--isnull(bb.May_14,0) as May_14_Empire_Adj,
				--isnull(bb.Jun_14,0) as Jun_14_Empire_Adj,		
				--isnull(bb.Jul_14,0) as Jul_14_Empire_Adj,
				--isnull(bb.Aug_14,0) as Aug_14_Empire_Adj,
				--isnull(bb.Sep_14,0) as Sep_14_Empire_Adj,		
				--isnull(bb.Oct_14,0) as Oct_14_Empire_Adj,
				--isnull(bb.Nov_14,0) as Nov_14_Empire_Adj,
				--isnull(bb.Dec_14,0) as Dec_14_Empire_Adj,
				--isnull(bb.Cal_14,0) as Cal_14_Empire_Adj,
				
				--isnull(bb.Jan_15,0) as Jan_15_Empire_Adj,
				--isnull(bb.Feb_15,0) as Feb_15_Empire_Adj,
				--isnull(bb.Mar_15,0) as Mar_15_Empire_Adj,
				--isnull(bb.Apr_15,0) as Apr_15_Empire_Adj,
				--isnull(bb.May_15,0) as May_15_Empire_Adj,
				--isnull(bb.Jun_15,0) as Jun_15_Empire_Adj,		
				--isnull(bb.Jul_15,0) as Jul_15_Empire_Adj,
				--isnull(bb.Aug_15,0) as Aug_15_Empire_Adj,
				--isnull(bb.Sep_15,0) as Sep_15_Empire_Adj,		
				--isnull(bb.Oct_15,0) as Oct_15_Empire_Adj,
				--isnull(bb.Nov_15,0) as Nov_15_Empire_Adj,
				--isnull(bb.Dec_15,0) as Dec_15_Empire_Adj,
				--isnull(bb.Cal_15,0) as Cal_15_Empire_Adj,
				
				isnull(bb.Jan_16,0) as Jan_16_Empire_Adj,
				isnull(bb.Feb_16,0) as Feb_16_Empire_Adj,
				isnull(bb.Mar_16,0) as Mar_16_Empire_Adj,
				isnull(bb.Apr_16,0) as Apr_16_Empire_Adj,
				isnull(bb.May_16,0) as May_16_Empire_Adj,
				isnull(bb.Jun_16,0) as Jun_16_Empire_Adj,		
				isnull(bb.Jul_16,0) as Jul_16_Empire_Adj,
				isnull(bb.Aug_16,0) as Aug_16_Empire_Adj,
				isnull(bb.Sep_16,0) as Sep_16_Empire_Adj,		
				isnull(bb.Oct_16,0) as Oct_16_Empire_Adj,
				isnull(bb.Nov_16,0) as Nov_16_Empire_Adj,
				isnull(bb.Dec_16,0) as Dec_16_Empire_Adj,
				isnull(bb.Cal_16,0) as Cal_16_Empire_Adj,
								
				isnull(bb.Jan_17,0) as Jan_17_Empire_Adj,
				isnull(bb.Feb_17,0) as Feb_17_Empire_Adj,
				isnull(bb.Mar_17,0) as Mar_17_Empire_Adj,
				isnull(bb.Apr_17,0) as Apr_17_Empire_Adj,
				isnull(bb.May_17,0) as May_17_Empire_Adj,
				isnull(bb.Jun_17,0) as Jun_17_Empire_Adj,		
				isnull(bb.Jul_17,0) as Jul_17_Empire_Adj,
				isnull(bb.Aug_17,0) as Aug_17_Empire_Adj,
				isnull(bb.Sep_17,0) as Sep_17_Empire_Adj,		
				isnull(bb.Oct_17,0) as Oct_17_Empire_Adj,
				isnull(bb.Nov_17,0) as Nov_17_Empire_Adj,
				isnull(bb.Dec_17,0) as Dec_17_Empire_Adj,
				isnull(bb.Cal_17,0) as Cal_17_Empire_Adj,
				
				isnull(bb.Jan_18,0) as Jan_18_Empire_Adj,
				isnull(bb.Feb_18,0) as Feb_18_Empire_Adj,
				isnull(bb.Mar_18,0) as Mar_18_Empire_Adj,
				isnull(bb.Apr_18,0) as Apr_18_Empire_Adj,
				isnull(bb.May_18,0) as May_18_Empire_Adj,
				isnull(bb.Jun_18,0) as Jun_18_Empire_Adj,		
				isnull(bb.Jul_18,0) as Jul_18_Empire_Adj,
				isnull(bb.Aug_18,0) as Aug_18_Empire_Adj,
				isnull(bb.Sep_18,0) as Sep_18_Empire_Adj,		
				isnull(bb.Oct_18,0) as Oct_18_Empire_Adj,
				isnull(bb.Nov_18,0) as Nov_18_Empire_Adj,
				isnull(bb.Dec_18,0) as Dec_18_Empire_Adj,
				isnull(bb.Cal_18,0) as Cal_18_Empire_Adj,

				isnull(bb.Jan_19,0) as Jan_19_Empire_Adj,
				isnull(bb.Feb_19,0) as Feb_19_Empire_Adj,
				isnull(bb.Mar_19,0) as Mar_19_Empire_Adj,
				isnull(bb.Apr_19,0) as Apr_19_Empire_Adj,
				isnull(bb.May_19,0) as May_19_Empire_Adj,
				isnull(bb.Jun_19,0) as Jun_19_Empire_Adj,		
				isnull(bb.Jul_19,0) as Jul_19_Empire_Adj,
				isnull(bb.Aug_19,0) as Aug_19_Empire_Adj,
				isnull(bb.Sep_19,0) as Sep_19_Empire_Adj,		
				isnull(bb.Oct_19,0) as Oct_19_Empire_Adj,
				isnull(bb.Nov_19,0) as Nov_19_Empire_Adj,
				isnull(bb.Dec_19,0) as Dec_19_Empire_Adj,
				isnull(bb.Cal_19,0) as Cal_19_Empire_Adj,
		
				isnull(bb.Jan_20,0) as Jan_20_Empire_Adj,
				isnull(bb.Feb_20,0) as Feb_20_Empire_Adj,
				isnull(bb.Mar_20,0) as Mar_20_Empire_Adj,
				isnull(bb.Apr_20,0) as Apr_20_Empire_Adj,
				isnull(bb.May_20,0) as May_20_Empire_Adj,
				isnull(bb.Jun_20,0) as Jun_20_Empire_Adj,		
				isnull(bb.Jul_20,0) as Jul_20_Empire_Adj,
				isnull(bb.Aug_20,0) as Aug_20_Empire_Adj,
				isnull(bb.Sep_20,0) as Sep_20_Empire_Adj,		
				isnull(bb.Oct_20,0) as Oct_20_Empire_Adj,
				isnull(bb.Nov_20,0) as Nov_20_Empire_Adj,
				isnull(bb.Dec_20,0) as Dec_20_Empire_Adj,
				isnull(bb.Cal_20,0) as Cal_20_Empire_Adj,
		
				isnull(bb.Jan_21,0) as Jan_21_Empire_Adj,
				isnull(bb.Feb_21,0) as Feb_21_Empire_Adj,
				isnull(bb.Mar_21,0) as Mar_21_Empire_Adj,
				isnull(bb.Apr_21,0) as Apr_21_Empire_Adj,
				isnull(bb.May_21,0) as May_21_Empire_Adj,
				isnull(bb.Jun_21,0) as Jun_21_Empire_Adj,		
				isnull(bb.Jul_21,0) as Jul_21_Empire_Adj,
				isnull(bb.Aug_21,0) as Aug_21_Empire_Adj,
				isnull(bb.Sep_21,0) as Sep_21_Empire_Adj,		
				isnull(bb.Oct_21,0) as Oct_21_Empire_Adj,
				isnull(bb.Nov_21,0) as Nov_21_Empire_Adj,
				isnull(bb.Dec_21,0) as Dec_21_Empire_Adj,
				isnull(bb.Cal_21,0) as Cal_21_Empire_Adj,
								
				isnull(bb.Cal_22,0) as Cal_22_Empire_Adj,
				isnull(bb.Cal_23,0) as Cal_23_Empire_Adj,	
				isnull(bb.Cal_24,0) as Cal_24_Empire_Adj,		
				isnull(bb.Cal_25,0) as Cal_25_Empire_Adj,
				isnull(bb.Cal_26,0) as Cal_26_Empire_Adj,

				--isnull(aa.Jan_10_factor,1)*bb.Jan_10 as Jan_10_Allocated_Empire_Adj,
				--isnull(aa.Feb_10_factor,1)*bb.Feb_10 as Feb_10_Allocated_Empire_Adj,
				--isnull(aa.Mar_10_factor,1)*bb.Mar_10 as Mar_10_Allocated_Empire_Adj,
				--isnull(aa.Apr_10_factor,1)*bb.Apr_10 as Apr_10_Allocated_Empire_Adj,
				--isnull(aa.May_10_factor,1)*bb.May_10 as May_10_Allocated_Empire_Adj,
				--isnull(aa.Jun_10_factor,1)*bb.Jun_10 as Jun_10_Allocated_Empire_Adj,
				--isnull(aa.Jul_10_factor,1)*bb.Jul_10 as Jul_10_Allocated_Empire_Adj,
				--isnull(aa.Aug_10_factor,1)*bb.Aug_10 as Aug_10_Allocated_Empire_Adj,
				--isnull(aa.Sep_10_factor,1)*bb.Sep_10 as Sep_10_Allocated_Empire_Adj,
				--isnull(aa.Oct_10_factor,1)*bb.Oct_10 as Oct_10_Allocated_Empire_Adj,
				--isnull(aa.Nov_10_factor,1)*bb.Nov_10 as Nov_10_Allocated_Empire_Adj,
				--isnull(aa.Dec_10_factor,1)*bb.Dec_10 as Dec_10_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_10_factor,1)*bb.Jan_10) + (isnull(aa.Feb_10_factor,1)*bb.Feb_10) + (isnull(aa.Mar_10_factor,1)*bb.Mar_10) 
				--+ (isnull(aa.Apr_10_factor,1)*bb.Apr_10) + (isnull(aa.May_10_factor,1)*bb.May_10) + (isnull(aa.Jun_10_factor,1)*bb.Jun_10)
				--+ (isnull(aa.Jul_10_factor,1)*bb.Jul_10) + (isnull(aa.Aug_10_factor,1)*bb.Aug_10) + (isnull(aa.Sep_10_factor,1)*bb.Sep_10) 
				--+ (isnull(aa.Oct_10_factor,1)*bb.Oct_10) + (isnull(aa.Nov_10_factor,1)*bb.Nov_10) + (isnull(aa.Dec_10_factor,1)*bb.Dec_10)) as Cal_10_Allocated_Empire_Adj,
				
				--isnull(aa.Jan_11_factor,1)*bb.Jan_11 as Jan_11_Allocated_Empire_Adj,
				--isnull(aa.Feb_11_factor,1)*bb.Feb_11 as Feb_11_Allocated_Empire_Adj,
				--isnull(aa.Mar_11_factor,1)*bb.Mar_11 as Mar_11_Allocated_Empire_Adj,
				--isnull(aa.Apr_11_factor,1)*bb.Apr_11 as Apr_11_Allocated_Empire_Adj,
				--isnull(aa.May_11_factor,1)*bb.May_11 as May_11_Allocated_Empire_Adj,
				--isnull(aa.Jun_11_factor,1)*bb.Jun_11 as Jun_11_Allocated_Empire_Adj,
				--isnull(aa.Jul_11_factor,1)*bb.Jul_11 as Jul_11_Allocated_Empire_Adj,
				--isnull(aa.Aug_11_factor,1)*bb.Aug_11 as Aug_11_Allocated_Empire_Adj,
				--isnull(aa.Sep_11_factor,1)*bb.Sep_11 as Sep_11_Allocated_Empire_Adj,
				--isnull(aa.Oct_11_factor,1)*bb.Oct_11 as Oct_11_Allocated_Empire_Adj,
				--isnull(aa.Nov_11_factor,1)*bb.Nov_11 as Nov_11_Allocated_Empire_Adj,
				--isnull(aa.Dec_11_factor,1)*bb.Dec_11 as Dec_11_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_11_factor,1)*bb.Jan_11) + (isnull(aa.Feb_11_factor,1)*bb.Feb_11) + (isnull(aa.Mar_11_factor,1)*bb.Mar_11) 
				--+ (isnull(aa.Apr_11_factor,1)*bb.Apr_11) + (isnull(aa.May_11_factor,1)*bb.May_11) + (isnull(aa.Jun_11_factor,1)*bb.Jun_11) 
				--+ (isnull(aa.Jul_11_factor,1)*bb.Jul_11) + (isnull(aa.Aug_11_factor,1)*bb.Aug_11) + (isnull(aa.Sep_11_factor,1)*bb.Sep_11) 
				--+ (isnull(aa.Oct_11_factor,1)*bb.Oct_11) + (isnull(aa.Nov_11_factor,1)*bb.Nov_11) + (isnull(aa.Dec_11_factor,1)*bb.Dec_11)) as Cal_11_Allocated_Empire_Adj,
				
				--isnull(aa.Jan_12_factor,1)*bb.Jan_12 as Jan_12_Allocated_Empire_Adj,
				--isnull(aa.Feb_12_factor,1)*bb.Feb_12 as Feb_12_Allocated_Empire_Adj,
				--isnull(aa.Mar_12_factor,1)*bb.Mar_12 as Mar_12_Allocated_Empire_Adj,
				--isnull(aa.Apr_12_factor,1)*bb.Apr_12 as Apr_12_Allocated_Empire_Adj,
				--isnull(aa.May_12_factor,1)*bb.May_12 as May_12_Allocated_Empire_Adj,
				--isnull(aa.Jun_12_factor,1)*bb.Jun_12 as Jun_12_Allocated_Empire_Adj,
				--isnull(aa.Jul_12_factor,1)*bb.Jul_12 as Jul_12_Allocated_Empire_Adj,
				--isnull(aa.Aug_12_factor,1)*bb.Aug_12 as Aug_12_Allocated_Empire_Adj,
				--isnull(aa.Sep_12_factor,1)*bb.Sep_12 as Sep_12_Allocated_Empire_Adj,
				--isnull(aa.Oct_12_factor,1)*bb.Oct_12 as Oct_12_Allocated_Empire_Adj,
				--isnull(aa.Nov_12_factor,1)*bb.Nov_12 as Nov_12_Allocated_Empire_Adj,
				--isnull(aa.Dec_12_factor,1)*bb.Dec_12 as Dec_12_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_12_factor,1)*bb.Jan_12) + (isnull(aa.Feb_12_factor,1)*bb.Feb_12) + (isnull(aa.Mar_12_factor,1)*bb.Mar_12)
				--+ (isnull(aa.Apr_12_factor,1)*bb.Apr_12) + (isnull(aa.May_12_factor,1)*bb.May_12) + (isnull(aa.Jun_12_factor,1)*bb.Jun_12) 
				--+ (isnull(aa.Jul_12_factor,1)*bb.Jul_12) + (isnull(aa.Aug_12_factor,1)*bb.Aug_12) + (isnull(aa.Sep_12_factor,1)*bb.Sep_12) 
				--+ (isnull(aa.Oct_12_factor,1)*bb.Oct_12) + (isnull(aa.Nov_12_factor,1)*bb.Nov_12) + (isnull(aa.Dec_12_factor,1)*bb.Dec_12)) as Cal_12_Allocated_Empire_Adj,
				
				--isnull(aa.Jan_13_factor,1)*bb.Jan_13 as Jan_13_Allocated_Empire_Adj,
				--isnull(aa.Feb_13_factor,1)*bb.Feb_13 as Feb_13_Allocated_Empire_Adj,
				--isnull(aa.Mar_13_factor,1)*bb.Mar_13 as Mar_13_Allocated_Empire_Adj,
				--isnull(aa.Apr_13_factor,1)*bb.Apr_13 as Apr_13_Allocated_Empire_Adj,
				--isnull(aa.May_13_factor,1)*bb.May_13 as May_13_Allocated_Empire_Adj,
				--isnull(aa.Jun_13_factor,1)*bb.Jun_13 as Jun_13_Allocated_Empire_Adj,
				--isnull(aa.Jul_13_factor,1)*bb.Jul_13 as Jul_13_Allocated_Empire_Adj,
				--isnull(aa.Aug_13_factor,1)*bb.Aug_13 as Aug_13_Allocated_Empire_Adj,
				--isnull(aa.Sep_13_factor,1)*bb.Sep_13 as Sep_13_Allocated_Empire_Adj,
				--isnull(aa.Oct_13_factor,1)*bb.Oct_13 as Oct_13_Allocated_Empire_Adj,
				--isnull(aa.Nov_13_factor,1)*bb.Nov_13 as Nov_13_Allocated_Empire_Adj,
				--isnull(aa.Dec_13_factor,1)*bb.Dec_13 as Dec_13_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_13_factor,1)*bb.Jan_13) + (isnull(aa.Feb_13_factor,1)*bb.Feb_13) + (isnull(aa.Mar_13_factor,1)*bb.Mar_13) 
				--+ (isnull(aa.Apr_13_factor,1)*bb.Apr_13) + (isnull(aa.May_13_factor,1)*bb.May_13) + (isnull(aa.Jun_13_factor,1)*bb.Jun_13) 
				--+ (isnull(aa.Jul_13_factor,1)*bb.Jul_13) + (isnull(aa.Aug_13_factor,1)*bb.Aug_13) + (isnull(aa.Sep_13_factor,1)*bb.Sep_13) 
				--+ (isnull(aa.Oct_13_factor,1)*bb.Oct_13) + (isnull(aa.Nov_13_factor,1)*bb.Nov_13) + (isnull(aa.Dec_13_factor,1)*bb.Dec_13)) as Cal_13_Allocated_Empire_Adj,
				
				--isnull(aa.Jan_14_factor,1)*bb.Jan_14 as Jan_14_Allocated_Empire_Adj,
				--isnull(aa.Feb_14_factor,1)*bb.Feb_14 as Feb_14_Allocated_Empire_Adj,
				--isnull(aa.Mar_14_factor,1)*bb.Mar_14 as Mar_14_Allocated_Empire_Adj,
				--isnull(aa.Apr_14_factor,1)*bb.Apr_14 as Apr_14_Allocated_Empire_Adj,
				--isnull(aa.May_14_factor,1)*bb.May_14 as May_14_Allocated_Empire_Adj,
				--isnull(aa.Jun_14_factor,1)*bb.Jun_14 as Jun_14_Allocated_Empire_Adj,
				--isnull(aa.Jul_14_factor,1)*bb.Jul_14 as Jul_14_Allocated_Empire_Adj,
				--isnull(aa.Aug_14_factor,1)*bb.Aug_14 as Aug_14_Allocated_Empire_Adj,
				--isnull(aa.Sep_14_factor,1)*bb.Sep_14 as Sep_14_Allocated_Empire_Adj,
				--isnull(aa.Oct_14_factor,1)*bb.Oct_14 as Oct_14_Allocated_Empire_Adj,
				--isnull(aa.Nov_14_factor,1)*bb.Nov_14 as Nov_14_Allocated_Empire_Adj,
				--isnull(aa.Dec_14_factor,1)*bb.Dec_14 as Dec_14_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_14_factor,1)*bb.Jan_14) + (isnull(aa.Feb_14_factor,1)*bb.Feb_14) + (isnull(aa.Mar_14_factor,1)*bb.Mar_14) 
				--+ (isnull(aa.Apr_14_factor,1)*bb.Apr_14) + (isnull(aa.May_14_factor,1)*bb.May_14) + (isnull(aa.Jun_14_factor,1)*bb.Jun_14) 
				--+ (isnull(aa.Jul_14_factor,1)*bb.Jul_14) + (isnull(aa.Aug_14_factor,1)*bb.Aug_14) + (isnull(aa.Sep_14_factor,1)*bb.Sep_14) 
				--+ (isnull(aa.Oct_14_factor,1)*bb.Oct_14) + (isnull(aa.Nov_14_factor,1)*bb.Nov_14) + (isnull(aa.Dec_14_factor,1)*bb.Dec_14)) as Cal_14_Allocated_Empire_Adj,
				
				--isnull(aa.Jan_15_factor,1)*bb.Jan_15 as Jan_15_Allocated_Empire_Adj,
				--isnull(aa.Feb_15_factor,1)*bb.Feb_15 as Feb_15_Allocated_Empire_Adj,
				--isnull(aa.Mar_15_factor,1)*bb.Mar_15 as Mar_15_Allocated_Empire_Adj,
				--isnull(aa.Apr_15_factor,1)*bb.Apr_15 as Apr_15_Allocated_Empire_Adj,
				--isnull(aa.May_15_factor,1)*bb.May_15 as May_15_Allocated_Empire_Adj,
				--isnull(aa.Jun_15_factor,1)*bb.Jun_15 as Jun_15_Allocated_Empire_Adj,
				--isnull(aa.Jul_15_factor,1)*bb.Jul_15 as Jul_15_Allocated_Empire_Adj,
				--isnull(aa.Aug_15_factor,1)*bb.Aug_15 as Aug_15_Allocated_Empire_Adj,
				--isnull(aa.Sep_15_factor,1)*bb.Sep_15 as Sep_15_Allocated_Empire_Adj,
				--isnull(aa.Oct_15_factor,1)*bb.Oct_15 as Oct_15_Allocated_Empire_Adj,
				--isnull(aa.Nov_15_factor,1)*bb.Nov_15 as Nov_15_Allocated_Empire_Adj,
				--isnull(aa.Dec_15_factor,1)*bb.Dec_15 as Dec_15_Allocated_Empire_Adj,
				--( (isnull(aa.Jan_15_factor,1)*bb.Jan_15) + (isnull(aa.Feb_15_factor,1)*bb.Feb_15) + (isnull(aa.Mar_15_factor,1)*bb.Mar_15) 
				--+ (isnull(aa.Apr_15_factor,1)*bb.Apr_15) + (isnull(aa.May_15_factor,1)*bb.May_15) + (isnull(aa.Jun_15_factor,1)*bb.Jun_15) 
				--+ (isnull(aa.Jul_15_factor,1)*bb.Jul_15) + (isnull(aa.Aug_15_factor,1)*bb.Aug_15) + (isnull(aa.Sep_15_factor,1)*bb.Sep_15) 
				--+ (isnull(aa.Oct_15_factor,1)*bb.Oct_15) + (isnull(aa.Nov_15_factor,1)*bb.Nov_15) + (isnull(aa.Dec_15_factor,1)*bb.Dec_15)) as Cal_15_Allocated_Empire_Adj,
				
				isnull(aa.Jan_16_factor,1)*bb.Jan_16 as Jan_16_Allocated_Empire_Adj,
				isnull(aa.Feb_16_factor,1)*bb.Feb_16 as Feb_16_Allocated_Empire_Adj,
				isnull(aa.Mar_16_factor,1)*bb.Mar_16 as Mar_16_Allocated_Empire_Adj,
				isnull(aa.Apr_16_factor,1)*bb.Apr_16 as Apr_16_Allocated_Empire_Adj,
				isnull(aa.May_16_factor,1)*bb.May_16 as May_16_Allocated_Empire_Adj,
				isnull(aa.Jun_16_factor,1)*bb.Jun_16 as Jun_16_Allocated_Empire_Adj,
				isnull(aa.Jul_16_factor,1)*bb.Jul_16 as Jul_16_Allocated_Empire_Adj,
				isnull(aa.Aug_16_factor,1)*bb.Aug_16 as Aug_16_Allocated_Empire_Adj,
				isnull(aa.Sep_16_factor,1)*bb.Sep_16 as Sep_16_Allocated_Empire_Adj,
				isnull(aa.Oct_16_factor,1)*bb.Oct_16 as Oct_16_Allocated_Empire_Adj,
				isnull(aa.Nov_16_factor,1)*bb.Nov_16 as Nov_16_Allocated_Empire_Adj,
				isnull(aa.Dec_16_factor,1)*bb.Dec_16 as Dec_16_Allocated_Empire_Adj,
				( (isnull(aa.Jan_16_factor,1)*bb.Jan_16) + (isnull(aa.Feb_16_factor,1)*bb.Feb_16) + (isnull(aa.Mar_16_factor,1)*bb.Mar_16) 
				+ (isnull(aa.Apr_16_factor,1)*bb.Apr_16) + (isnull(aa.May_16_factor,1)*bb.May_16) + (isnull(aa.Jun_16_factor,1)*bb.Jun_16) 
				+ (isnull(aa.Jul_16_factor,1)*bb.Jul_16) + (isnull(aa.Aug_16_factor,1)*bb.Aug_16) + (isnull(aa.Sep_16_factor,1)*bb.Sep_16) 
				+ (isnull(aa.Oct_16_factor,1)*bb.Oct_16) + (isnull(aa.Nov_16_factor,1)*bb.Nov_16) + (isnull(aa.Dec_16_factor,1)*bb.Dec_16)) as Cal_16_Allocated_Empire_Adj,

				isnull(aa.Jan_17_factor,1)*bb.Jan_17 as Jan_17_Allocated_Empire_Adj,
				isnull(aa.Feb_17_factor,1)*bb.Feb_17 as Feb_17_Allocated_Empire_Adj,
				isnull(aa.Mar_17_factor,1)*bb.Mar_17 as Mar_17_Allocated_Empire_Adj,
				isnull(aa.Apr_17_factor,1)*bb.Apr_17 as Apr_17_Allocated_Empire_Adj,
				isnull(aa.May_17_factor,1)*bb.May_17 as May_17_Allocated_Empire_Adj,
				isnull(aa.Jun_17_factor,1)*bb.Jun_17 as Jun_17_Allocated_Empire_Adj,
				isnull(aa.Jul_17_factor,1)*bb.Jul_17 as Jul_17_Allocated_Empire_Adj,
				isnull(aa.Aug_17_factor,1)*bb.Aug_17 as Aug_17_Allocated_Empire_Adj,
				isnull(aa.Sep_17_factor,1)*bb.Sep_17 as Sep_17_Allocated_Empire_Adj,
				isnull(aa.Oct_17_factor,1)*bb.Oct_17 as Oct_17_Allocated_Empire_Adj,
				isnull(aa.Nov_17_factor,1)*bb.Nov_17 as Nov_17_Allocated_Empire_Adj,
				isnull(aa.Dec_17_factor,1)*bb.Dec_17 as Dec_17_Allocated_Empire_Adj,
				( (isnull(aa.Jan_17_factor,1)*bb.Jan_17) + (isnull(aa.Feb_17_factor,1)*bb.Feb_17) + (isnull(aa.Mar_17_factor,1)*bb.Mar_17) 
				+ (isnull(aa.Apr_17_factor,1)*bb.Apr_17) + (isnull(aa.May_17_factor,1)*bb.May_17) + (isnull(aa.Jun_17_factor,1)*bb.Jun_17) 
				+ (isnull(aa.Jul_17_factor,1)*bb.Jul_17) + (isnull(aa.Aug_17_factor,1)*bb.Aug_17) + (isnull(aa.Sep_17_factor,1)*bb.Sep_17) 
				+ (isnull(aa.Oct_17_factor,1)*bb.Oct_17) + (isnull(aa.Nov_17_factor,1)*bb.Nov_17) + (isnull(aa.Dec_17_factor,1)*bb.Dec_17)) as Cal_17_Allocated_Empire_Adj,

				isnull(aa.Jan_18_factor,1)*bb.Jan_18 as Jan_18_Allocated_Empire_Adj,
				isnull(aa.Feb_18_factor,1)*bb.Feb_18 as Feb_18_Allocated_Empire_Adj,
				isnull(aa.Mar_18_factor,1)*bb.Mar_18 as Mar_18_Allocated_Empire_Adj,
				isnull(aa.Apr_18_factor,1)*bb.Apr_18 as Apr_18_Allocated_Empire_Adj,
				isnull(aa.May_18_factor,1)*bb.May_18 as May_18_Allocated_Empire_Adj,
				isnull(aa.Jun_18_factor,1)*bb.Jun_18 as Jun_18_Allocated_Empire_Adj,
				isnull(aa.Jul_18_factor,1)*bb.Jul_18 as Jul_18_Allocated_Empire_Adj,
				isnull(aa.Aug_18_factor,1)*bb.Aug_18 as Aug_18_Allocated_Empire_Adj,
				isnull(aa.Sep_18_factor,1)*bb.Sep_18 as Sep_18_Allocated_Empire_Adj,
				isnull(aa.Oct_18_factor,1)*bb.Oct_18 as Oct_18_Allocated_Empire_Adj,
				isnull(aa.Nov_18_factor,1)*bb.Nov_18 as Nov_18_Allocated_Empire_Adj,
				isnull(aa.Dec_18_factor,1)*bb.Dec_18 as Dec_18_Allocated_Empire_Adj,
				( (isnull(aa.Jan_18_factor,1)*bb.Jan_18) + (isnull(aa.Feb_18_factor,1)*bb.Feb_18) + (isnull(aa.Mar_18_factor,1)*bb.Mar_18) 
				+ (isnull(aa.Apr_18_factor,1)*bb.Apr_18) + (isnull(aa.May_18_factor,1)*bb.May_18) + (isnull(aa.Jun_18_factor,1)*bb.Jun_18) 
				+ (isnull(aa.Jul_18_factor,1)*bb.Jul_18) + (isnull(aa.Aug_18_factor,1)*bb.Aug_18) + (isnull(aa.Sep_18_factor,1)*bb.Sep_18) 
				+ (isnull(aa.Oct_18_factor,1)*bb.Oct_18) + (isnull(aa.Nov_18_factor,1)*bb.Nov_18) + (isnull(aa.Dec_18_factor,1)*bb.Dec_18)) as Cal_18_Allocated_Empire_Adj,

				isnull(aa.Jan_19_factor,1)*bb.Jan_19 as Jan_19_Allocated_Empire_Adj,
				isnull(aa.Feb_19_factor,1)*bb.Feb_19 as Feb_19_Allocated_Empire_Adj,
				isnull(aa.Mar_19_factor,1)*bb.Mar_19 as Mar_19_Allocated_Empire_Adj,
				isnull(aa.Apr_19_factor,1)*bb.Apr_19 as Apr_19_Allocated_Empire_Adj,
				isnull(aa.May_19_factor,1)*bb.May_19 as May_19_Allocated_Empire_Adj,
				isnull(aa.Jun_19_factor,1)*bb.Jun_19 as Jun_19_Allocated_Empire_Adj,
				isnull(aa.Jul_19_factor,1)*bb.Jul_19 as Jul_19_Allocated_Empire_Adj,
				isnull(aa.Aug_19_factor,1)*bb.Aug_19 as Aug_19_Allocated_Empire_Adj,
				isnull(aa.Sep_19_factor,1)*bb.Sep_19 as Sep_19_Allocated_Empire_Adj,
				isnull(aa.Oct_19_factor,1)*bb.Oct_19 as Oct_19_Allocated_Empire_Adj,
				isnull(aa.Nov_19_factor,1)*bb.Nov_19 as Nov_19_Allocated_Empire_Adj,
				isnull(aa.Dec_19_factor,1)*bb.Dec_19 as Dec_19_Allocated_Empire_Adj,
				( (isnull(aa.Jan_19_factor,1)*bb.Jan_19) + (isnull(aa.Feb_19_factor,1)*bb.Feb_19) + (isnull(aa.Mar_19_factor,1)*bb.Mar_19) 
				+ (isnull(aa.Apr_19_factor,1)*bb.Apr_19) + (isnull(aa.May_19_factor,1)*bb.May_19) + (isnull(aa.Jun_19_factor,1)*bb.Jun_19) 
				+ (isnull(aa.Jul_19_factor,1)*bb.Jul_19) + (isnull(aa.Aug_19_factor,1)*bb.Aug_19) + (isnull(aa.Sep_19_factor,1)*bb.Sep_19) 
				+ (isnull(aa.Oct_19_factor,1)*bb.Oct_19) + (isnull(aa.Nov_19_factor,1)*bb.Nov_19) + (isnull(aa.Dec_19_factor,1)*bb.Dec_19)) as Cal_19_Allocated_Empire_Adj,

				isnull(aa.Jan_20_factor,1)*bb.Jan_20 as Jan_20_Allocated_Empire_Adj,
				isnull(aa.Feb_20_factor,1)*bb.Feb_20 as Feb_20_Allocated_Empire_Adj,
				isnull(aa.Mar_20_factor,1)*bb.Mar_20 as Mar_20_Allocated_Empire_Adj,
				isnull(aa.Apr_20_factor,1)*bb.Apr_20 as Apr_20_Allocated_Empire_Adj,
				isnull(aa.May_20_factor,1)*bb.May_20 as May_20_Allocated_Empire_Adj,
				isnull(aa.Jun_20_factor,1)*bb.Jun_20 as Jun_20_Allocated_Empire_Adj,
				isnull(aa.Jul_20_factor,1)*bb.Jul_20 as Jul_20_Allocated_Empire_Adj,
				isnull(aa.Aug_20_factor,1)*bb.Aug_20 as Aug_20_Allocated_Empire_Adj,
				isnull(aa.Sep_20_factor,1)*bb.Sep_20 as Sep_20_Allocated_Empire_Adj,
				isnull(aa.Oct_20_factor,1)*bb.Oct_20 as Oct_20_Allocated_Empire_Adj,
				isnull(aa.Nov_20_factor,1)*bb.Nov_20 as Nov_20_Allocated_Empire_Adj,
				isnull(aa.Dec_20_factor,1)*bb.Dec_20 as Dec_20_Allocated_Empire_Adj,
				( (isnull(aa.Jan_20_factor,1)*bb.Jan_20) + (isnull(aa.Feb_20_factor,1)*bb.Feb_20) + (isnull(aa.Mar_20_factor,1)*bb.Mar_20) 
				+ (isnull(aa.Apr_20_factor,1)*bb.Apr_20) + (isnull(aa.May_20_factor,1)*bb.May_20) + (isnull(aa.Jun_20_factor,1)*bb.Jun_20) 
				+ (isnull(aa.Jul_20_factor,1)*bb.Jul_20) + (isnull(aa.Aug_20_factor,1)*bb.Aug_20) + (isnull(aa.Sep_20_factor,1)*bb.Sep_20) 
				+ (isnull(aa.Oct_20_factor,1)*bb.Oct_20) + (isnull(aa.Nov_20_factor,1)*bb.Nov_20) + (isnull(aa.Dec_20_factor,1)*bb.Dec_20)) as Cal_20_Allocated_Empire_Adj,

				isnull(aa.Jan_21_factor,1)*bb.Jan_21 as Jan_21_Allocated_Empire_Adj,
				isnull(aa.Feb_21_factor,1)*bb.Feb_21 as Feb_21_Allocated_Empire_Adj,
				isnull(aa.Mar_21_factor,1)*bb.Mar_21 as Mar_21_Allocated_Empire_Adj,
				isnull(aa.Apr_21_factor,1)*bb.Apr_21 as Apr_21_Allocated_Empire_Adj,
				isnull(aa.May_21_factor,1)*bb.May_21 as May_21_Allocated_Empire_Adj,
				isnull(aa.Jun_21_factor,1)*bb.Jun_21 as Jun_21_Allocated_Empire_Adj,
				isnull(aa.Jul_21_factor,1)*bb.Jul_21 as Jul_21_Allocated_Empire_Adj,
				isnull(aa.Aug_21_factor,1)*bb.Aug_21 as Aug_21_Allocated_Empire_Adj,
				isnull(aa.Sep_21_factor,1)*bb.Sep_21 as Sep_21_Allocated_Empire_Adj,
				isnull(aa.Oct_21_factor,1)*bb.Oct_21 as Oct_21_Allocated_Empire_Adj,
				isnull(aa.Nov_21_factor,1)*bb.Nov_21 as Nov_21_Allocated_Empire_Adj,
				isnull(aa.Dec_21_factor,1)*bb.Dec_21 as Dec_21_Allocated_Empire_Adj,
				( (isnull(aa.Jan_21_factor,1)*bb.Jan_21) + (isnull(aa.Feb_21_factor,1)*bb.Feb_21) + (isnull(aa.Mar_21_factor,1)*bb.Mar_21) 
				+ (isnull(aa.Apr_21_factor,1)*bb.Apr_21) + (isnull(aa.May_21_factor,1)*bb.May_21) + (isnull(aa.Jun_21_factor,1)*bb.Jun_21) 
				+ (isnull(aa.Jul_21_factor,1)*bb.Jul_21) + (isnull(aa.Aug_21_factor,1)*bb.Aug_21) + (isnull(aa.Sep_21_factor,1)*bb.Sep_21) 
				+ (isnull(aa.Oct_21_factor,1)*bb.Oct_21) + (isnull(aa.Nov_21_factor,1)*bb.Nov_21) + (isnull(aa.Dec_21_factor,1)*bb.Dec_21)) as Cal_21_Allocated_Empire_Adj,

				isnull(aa.Cal_22_factor,1)*bb.Cal_22 as Cal_22_Allocated_Empire_Adj,
				isnull(aa.CAL_23_factor,1)*bb.CAL_23 as CAL_23_Allocated_Empire_Adj,
				isnull(aa.CAL_24_factor,1)*bb.CAL_24 as CAL_24_Allocated_Empire_Adj,
				isnull(aa.CAL_25_factor,1)*bb.CAL_25 as CAL_25_Allocated_Empire_Adj,
				isnull(aa.CAL_26_factor,1)*bb.CAL_26 as CAL_26_Allocated_Empire_Adj,

				--isnull(aa.Jan_10_CSMdemand,0) + (isnull(aa.Jan_10_factor,1)*isnull(bb.Jan_10,0)) as Jan_10_TOTALdemand,
				--isnull(aa.Feb_10_CSMdemand,0) + (isnull(aa.Feb_10_factor,1)*isnull(bb.Feb_10,0)) as Feb_10_TOTALdemand,
				--isnull(aa.Mar_10_CSMdemand,0) + (isnull(aa.Mar_10_factor,1)*isnull(bb.Mar_10,0)) as Mar_10_TOTALdemand,
				--isnull(aa.Apr_10_CSMdemand,0) + (isnull(aa.Apr_10_factor,1)*isnull(bb.Apr_10,0)) as Apr_10_TOTALdemand,
				--isnull(aa.May_10_CSMdemand,0) + (isnull(aa.May_10_factor,1)*isnull(bb.May_10,0)) as May_10_TOTALdemand,
				--isnull(aa.Jun_10_CSMdemand,0) + (isnull(aa.Jun_10_factor,1)*isnull(bb.Jun_10,0)) as Jun_10_TOTALdemand,
				--isnull(aa.Jul_10_CSMdemand,0) + (isnull(aa.Jul_10_factor,1)*isnull(bb.Jul_10,0)) as Jul_10_TOTALdemand,
				--isnull(aa.Aug_10_CSMdemand,0) + (isnull(aa.Aug_10_factor,1)*isnull(bb.Aug_10,0)) as Aug_10_TOTALdemand,
				--isnull(aa.Sep_10_CSMdemand,0) + (isnull(aa.Sep_10_factor,1)*isnull(bb.Sep_10,0)) as Sep_10_TOTALdemand,
				--isnull(aa.Oct_10_CSMdemand,0) + (isnull(aa.Oct_10_factor,1)*isnull(bb.Oct_10,0)) as Oct_10_TOTALdemand,
				--isnull(aa.Nov_10_CSMdemand,0) + (isnull(aa.Nov_10_factor,1)*isnull(bb.Nov_10,0)) as Nov_10_TOTALdemand,
				--isnull(aa.Dec_10_CSMdemand,0) + (isnull(aa.Dec_10_factor,1)*isnull(bb.Dec_10,0)) as Dec_10_TOTALdemand,		
				--isnull(aa.Cal_10_CSMdemand,0) + ((isnull(aa.Jan_10_factor,1)*isnull(bb.Jan_10,0)) + (isnull(aa.Feb_10_factor,1)*isnull(bb.Feb_10,0)) + (isnull(aa.Mar_10_factor,1)*isnull(bb.Mar_10,0)) 
				--                              +  (isnull(aa.Apr_10_factor,1)*isnull(bb.Apr_10,0)) + (isnull(aa.May_10_factor,1)*isnull(bb.May_10,0)) + (isnull(aa.Jun_10_factor,1)*isnull(bb.Jun_10,0)) 
				--                              +  (isnull(aa.Jul_10_factor,1)*isnull(bb.Jul_10,0)) + (isnull(aa.Aug_10_factor,1)*isnull(bb.Aug_10,0)) + (isnull(aa.Sep_10_factor,1)*isnull(bb.Sep_10,0)) 
				--                              +  (isnull(aa.Oct_10_factor,1)*isnull(bb.Oct_10,0)) + (isnull(aa.Nov_10_factor,1)*isnull(bb.Nov_10,0)) + (isnull(aa.Dec_10_factor,1)*isnull(bb.Dec_10,0))) as Cal_10_TOTALdemand,
				
				--isnull(aa.Jan_11_CSMdemand,0) + (isnull(aa.Jan_11_factor,1)*isnull(bb.Jan_11,0)) as Jan_11_TOTALdemand,	
				--isnull(aa.Feb_11_CSMdemand,0) + (isnull(aa.Feb_11_factor,1)*isnull(bb.Feb_11,0)) as Feb_11_TOTALdemand,
				--isnull(aa.Mar_11_CSMdemand,0) + (isnull(aa.Mar_11_factor,1)*isnull(bb.Mar_11,0)) as Mar_11_TOTALdemand,
				--isnull(aa.Apr_11_CSMdemand,0) + (isnull(aa.Apr_11_factor,1)*isnull(bb.Apr_11,0)) as Apr_11_TOTALdemand,	
				--isnull(aa.May_11_CSMdemand,0) + (isnull(aa.May_11_factor,1)*isnull(bb.May_11,0)) as May_11_TOTALdemand,
				--isnull(aa.Jun_11_CSMdemand,0) + (isnull(aa.Jun_11_factor,1)*isnull(bb.Jun_11,0)) as Jun_11_TOTALdemand,
				--isnull(aa.Jul_11_CSMdemand,0) + (isnull(aa.Jul_11_factor,1)*isnull(bb.Jul_11,0)) as Jul_11_TOTALdemand,
				--isnull(aa.Aug_11_CSMdemand,0) + (isnull(aa.Aug_11_factor,1)*isnull(bb.Aug_11,0)) as Aug_11_TOTALdemand,
				--isnull(aa.Sep_11_CSMdemand,0) + (isnull(aa.Sep_11_factor,1)*isnull(bb.Sep_11,0)) as Sep_11_TOTALdemand,
				--isnull(aa.Oct_11_CSMdemand,0) + (isnull(aa.Oct_11_factor,1)*isnull(bb.Oct_11,0)) as Oct_11_TOTALdemand,
				--isnull(aa.Nov_11_CSMdemand,0) + (isnull(aa.Nov_11_factor,1)*isnull(bb.Nov_11,0)) as Nov_11_TOTALdemand,
				--isnull(aa.Dec_11_CSMdemand,0) + (isnull(aa.Dec_11_factor,1)*isnull(bb.Dec_11,0)) as Dec_11_TOTALdemand,		
				--isnull(aa.Cal_11_CSMdemand,0) + ((isnull(aa.Jan_11_factor,1)*isnull(bb.Jan_11,0)) + (isnull(aa.Feb_11_factor,1)*isnull(bb.Feb_11,0)) + (isnull(aa.Mar_11_factor,1)*isnull(bb.Mar_11,0)) 
				--                              +  (isnull(aa.Apr_11_factor,1)*isnull(bb.Apr_11,0)) + (isnull(aa.May_11_factor,1)*isnull(bb.May_11,0)) + (isnull(aa.Jun_11_factor,1)*isnull(bb.Jun_11,0)) 
				--                              +  (isnull(aa.Jul_11_factor,1)*isnull(bb.Jul_11,0)) + (isnull(aa.Aug_11_factor,1)*isnull(bb.Aug_11,0)) + (isnull(aa.Sep_11_factor,1)*isnull(bb.Sep_11,0)) 
				--                              +  (isnull(aa.Oct_11_factor,1)*isnull(bb.Oct_11,0)) + (isnull(aa.Nov_11_factor,1)*isnull(bb.Nov_11,0)) + (isnull(aa.Dec_11_factor,1)*isnull(bb.Dec_11,0))) as Cal_11_TOTALdemand,
				
				--isnull(aa.Jan_12_CSMdemand,0) + (isnull(aa.Jan_12_factor,1)*isnull(bb.Jan_12,0)) as Jan_12_TOTALdemand,
				--isnull(aa.Feb_12_CSMdemand,0) + (isnull(aa.Feb_12_factor,1)*isnull(bb.Feb_12,0)) as Feb_12_TOTALdemand,
				--isnull(aa.Mar_12_CSMdemand,0) + (isnull(aa.Mar_12_factor,1)*isnull(bb.Mar_12,0)) as Mar_12_TOTALdemand,
				--isnull(aa.Apr_12_CSMdemand,0) + (isnull(aa.Apr_12_factor,1)*isnull(bb.Apr_12,0)) as Apr_12_TOTALdemand,
				--isnull(aa.May_12_CSMdemand,0) + (isnull(aa.May_12_factor,1)*isnull(bb.May_12,0)) as May_12_TOTALdemand,
				--isnull(aa.Jun_12_CSMdemand,0) + (isnull(aa.Jun_12_factor,1)*isnull(bb.Jun_12,0)) as Jun_12_TOTALdemand,
				--isnull(aa.Jul_12_CSMdemand,0) + (isnull(aa.Jul_12_factor,1)*isnull(bb.Jul_12,0)) as Jul_12_TOTALdemand,
				--isnull(aa.Aug_12_CSMdemand,0) + (isnull(aa.Aug_12_factor,1)*isnull(bb.Aug_12,0)) as Aug_12_TOTALdemand,
				--isnull(aa.Sep_12_CSMdemand,0) + (isnull(aa.Sep_12_factor,1)*isnull(bb.Sep_12,0)) as Sep_12_TOTALdemand,
				--isnull(aa.Oct_12_CSMdemand,0) + (isnull(aa.Oct_12_factor,1)*isnull(bb.Oct_12,0)) as Oct_12_TOTALdemand,
				--isnull(aa.Nov_12_CSMdemand,0) + (isnull(aa.Nov_12_factor,1)*isnull(bb.Nov_12,0)) as Nov_12_TOTALdemand,
				--isnull(aa.Dec_12_CSMdemand,0) + (isnull(aa.Dec_12_factor,1)*isnull(bb.Dec_12,0)) as Dec_12_TOTALdemand,		
				--isnull(aa.Cal_12_CSMdemand,0) + ((isnull(aa.Jan_12_factor,1)*isnull(bb.Jan_12,0)) + (isnull(aa.Feb_12_factor,1)*isnull(bb.Feb_12,0)) + (isnull(aa.Mar_12_factor,1)*isnull(bb.Mar_12,0)) 
				--                              +  (isnull(aa.Apr_12_factor,1)*isnull(bb.Apr_12,0)) + (isnull(aa.May_12_factor,1)*isnull(bb.May_12,0)) + (isnull(aa.Jun_12_factor,1)*isnull(bb.Jun_12,0)) 
				--                              +  (isnull(aa.Jul_12_factor,1)*isnull(bb.Jul_12,0)) + (isnull(aa.Aug_12_factor,1)*isnull(bb.Aug_12,0)) + (isnull(aa.Sep_12_factor,1)*isnull(bb.Sep_12,0)) 
				--                              +  (isnull(aa.Oct_12_factor,1)*isnull(bb.Oct_12,0)) + (isnull(aa.Nov_12_factor,1)*isnull(bb.Nov_12,0)) +  (isnull(aa.Dec_12_factor,1)*isnull(bb.Dec_12,0))) as Cal_12_TOTALdemand,
				
	
				--isnull(aa.Jan_13_CSMdemand,0) + (isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) as Jan_13_TOTALdemand,
				--isnull(aa.Feb_13_CSMdemand,0) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) as Feb_13_TOTALdemand,
				--isnull(aa.Mar_13_CSMdemand,0) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) as Mar_13_TOTALdemand,
				--isnull(aa.Apr_13_CSMdemand,0) + (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) as Apr_13_TOTALdemand,
				--isnull(aa.May_13_CSMdemand,0) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) as May_13_TOTALdemand,
				--isnull(aa.Jun_13_CSMdemand,0) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) as Jun_13_TOTALdemand,
				--isnull(aa.Jul_13_CSMdemand,0) + (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) as Jul_13_TOTALdemand,
				--isnull(aa.Aug_13_CSMdemand,0) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) as Aug_13_TOTALdemand,
				--isnull(aa.Sep_13_CSMdemand,0) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) as Sep_13_TOTALdemand,
				--isnull(aa.Oct_13_CSMdemand,0) + (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) as Oct_13_TOTALdemand,
				--isnull(aa.Nov_13_CSMdemand,0) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) as Nov_13_TOTALdemand,
				--isnull(aa.Dec_13_CSMdemand,0) + (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0)) as Dec_13_TOTALdemand,		
				--isnull(aa.Cal_13_CSMdemand,0) + ((isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) 
				--                              +  (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) 
				--                              +  (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) 
				--                              +  (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) + (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0))) as Cal_13_TOTALdemand,
				
				--isnull(aa.Jan_14_CSMdemand,0) + (isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) as Jan_14_TOTALdemand,
				--isnull(aa.Feb_14_CSMdemand,0) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) as Feb_14_TOTALdemand,
				--isnull(aa.Mar_14_CSMdemand,0) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) as Mar_14_TOTALdemand,
				--isnull(aa.Apr_14_CSMdemand,0) + (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) as Apr_14_TOTALdemand,
				--isnull(aa.May_14_CSMdemand,0) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) as May_14_TOTALdemand,
				--isnull(aa.Jun_14_CSMdemand,0) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0)) as Jun_14_TOTALdemand,
				--isnull(aa.Jul_14_CSMdemand,0) + (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) as Jul_14_TOTALdemand,
				--isnull(aa.Aug_14_CSMdemand,0) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) as Aug_14_TOTALdemand,
				--isnull(aa.Sep_14_CSMdemand,0) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) as Sep_14_TOTALdemand,
				--isnull(aa.Oct_14_CSMdemand,0) + (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) as Oct_14_TOTALdemand,
				--isnull(aa.Nov_14_CSMdemand,0) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) as Nov_14_TOTALdemand,
				--isnull(aa.Dec_14_CSMdemand,0) + (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0)) as Dec_14_TOTALdemand,		
				--isnull(aa.Cal_14_CSMdemand,0) + ((isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) 
				--                              +  (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0))
				--                              +  (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) 
				--                              +  (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) + (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0))) as Cal_14_TOTALdemand,

				--isnull(aa.Jan_15_CSMdemand,0) + (isnull(aa.Jan_15_factor,1)*isnull(bb.Jan_15,0)) as Jan_15_TOTALdemand,
				--isnull(aa.Feb_15_CSMdemand,0) + (isnull(aa.Feb_15_factor,1)*isnull(bb.Feb_15,0)) as Feb_15_TOTALdemand,
				--isnull(aa.Mar_15_CSMdemand,0) + (isnull(aa.Mar_15_factor,1)*isnull(bb.Mar_15,0)) as Mar_15_TOTALdemand,
				--isnull(aa.Apr_15_CSMdemand,0) + (isnull(aa.Apr_15_factor,1)*isnull(bb.Apr_15,0)) as Apr_15_TOTALdemand,
				--isnull(aa.May_15_CSMdemand,0) + (isnull(aa.May_15_factor,1)*isnull(bb.May_15,0)) as May_15_TOTALdemand,
				--isnull(aa.Jun_15_CSMdemand,0) + (isnull(aa.Jun_15_factor,1)*isnull(bb.Jun_15,0)) as Jun_15_TOTALdemand,
				--isnull(aa.Jul_15_CSMdemand,0) + (isnull(aa.Jul_15_factor,1)*isnull(bb.Jul_15,0)) as Jul_15_TOTALdemand,
				--isnull(aa.Aug_15_CSMdemand,0) + (isnull(aa.Aug_15_factor,1)*isnull(bb.Aug_15,0)) as Aug_15_TOTALdemand,
				--isnull(aa.Sep_15_CSMdemand,0) + (isnull(aa.Sep_15_factor,1)*isnull(bb.Sep_15,0)) as Sep_15_TOTALdemand,
				--isnull(aa.Oct_15_CSMdemand,0) + (isnull(aa.Oct_15_factor,1)*isnull(bb.Oct_15,0)) as Oct_15_TOTALdemand,
				--isnull(aa.Nov_15_CSMdemand,0) + (isnull(aa.Nov_15_factor,1)*isnull(bb.Nov_15,0)) as Nov_15_TOTALdemand,
				--isnull(aa.Dec_15_CSMdemand,0) + (isnull(aa.Dec_15_factor,1)*isnull(bb.Dec_15,0)) as Dec_15_TOTALdemand,		
				--isnull(aa.Cal_15_CSMdemand,0) + ((isnull(aa.Jan_15_factor,1)*isnull(bb.Jan_15,0)) + (isnull(aa.Feb_15_factor,1)*isnull(bb.Feb_15,0)) + (isnull(aa.Mar_15_factor,1)*isnull(bb.Mar_15,0)) 
				--                              +  (isnull(aa.Apr_15_factor,1)*isnull(bb.Apr_15,0)) + (isnull(aa.May_15_factor,1)*isnull(bb.May_15,0)) + (isnull(aa.Jun_15_factor,1)*isnull(bb.Jun_15,0)) 
				--                              +  (isnull(aa.Jul_15_factor,1)*isnull(bb.Jul_15,0)) + (isnull(aa.Aug_15_factor,1)*isnull(bb.Aug_15,0)) + (isnull(aa.Sep_15_factor,1)*isnull(bb.Sep_15,0)) 
				--                              +  (isnull(aa.Oct_15_factor,1)*isnull(bb.Oct_15,0)) + (isnull(aa.Nov_15_factor,1)*isnull(bb.Nov_15,0)) + (isnull(aa.Dec_15_factor,1)*isnull(bb.Dec_15,0))) as Cal_15_TOTALdemand,

				isnull(aa.Jan_16_CSMdemand,0) + (isnull(aa.Jan_16_factor,1)*isnull(bb.Jan_16,0)) as Jan_16_TOTALdemand,
				isnull(aa.Feb_16_CSMdemand,0) + (isnull(aa.Feb_16_factor,1)*isnull(bb.Feb_16,0)) as Feb_16_TOTALdemand,
				isnull(aa.Mar_16_CSMdemand,0) + (isnull(aa.Mar_16_factor,1)*isnull(bb.Mar_16,0)) as Mar_16_TOTALdemand,
				isnull(aa.Apr_16_CSMdemand,0) + (isnull(aa.Apr_16_factor,1)*isnull(bb.Apr_16,0)) as Apr_16_TOTALdemand,
				isnull(aa.May_16_CSMdemand,0) + (isnull(aa.May_16_factor,1)*isnull(bb.May_16,0)) as May_16_TOTALdemand,
				isnull(aa.Jun_16_CSMdemand,0) + (isnull(aa.Jun_16_factor,1)*isnull(bb.Jun_16,0)) as Jun_16_TOTALdemand,
				isnull(aa.Jul_16_CSMdemand,0) + (isnull(aa.Jul_16_factor,1)*isnull(bb.Jul_16,0)) as Jul_16_TOTALdemand,
				isnull(aa.Aug_16_CSMdemand,0) + (isnull(aa.Aug_16_factor,1)*isnull(bb.Aug_16,0)) as Aug_16_TOTALdemand,
				isnull(aa.Sep_16_CSMdemand,0) + (isnull(aa.Sep_16_factor,1)*isnull(bb.Sep_16,0)) as Sep_16_TOTALdemand,
				isnull(aa.Oct_16_CSMdemand,0) + (isnull(aa.Oct_16_factor,1)*isnull(bb.Oct_16,0)) as Oct_16_TOTALdemand,
				isnull(aa.Nov_16_CSMdemand,0) + (isnull(aa.Nov_16_factor,1)*isnull(bb.Nov_16,0)) as Nov_16_TOTALdemand,
				isnull(aa.Dec_16_CSMdemand,0) + (isnull(aa.Dec_16_factor,1)*isnull(bb.Dec_16,0)) as Dec_16_TOTALdemand,		
				isnull(aa.Cal_16_CSMdemand,0) + ((isnull(aa.Jan_16_factor,1)*isnull(bb.Jan_16,0)) + (isnull(aa.Feb_16_factor,1)*isnull(bb.Feb_16,0)) + (isnull(aa.Mar_16_factor,1)*isnull(bb.Mar_16,0)) 
				                                +  (isnull(aa.Apr_16_factor,1)*isnull(bb.Apr_16,0)) + (isnull(aa.May_16_factor,1)*isnull(bb.May_16,0)) + (isnull(aa.Jun_16_factor,1)*isnull(bb.Jun_16,0))
												+  (isnull(aa.Jul_16_factor,1)*isnull(bb.Jul_16,0)) + (isnull(aa.Aug_16_factor,1)*isnull(bb.Aug_16,0)) + (isnull(aa.Sep_16_factor,1)*isnull(bb.Sep_16,0)) 
												+  (isnull(aa.Oct_16_factor,1)*isnull(bb.Oct_16,0)) + (isnull(aa.Nov_16_factor,1)*isnull(bb.Nov_16,0)) + (isnull(aa.Dec_16_factor,1)*isnull(bb.Dec_16,0))) as Cal_16_TOTALdemand,
				
				isnull(aa.Jan_17_CSMdemand,0) + (isnull(aa.Jan_17_factor,1)*isnull(bb.Jan_17,0)) as Jan_17_TOTALdemand,
				isnull(aa.Feb_17_CSMdemand,0) + (isnull(aa.Feb_17_factor,1)*isnull(bb.Feb_17,0)) as Feb_17_TOTALdemand,
				isnull(aa.Mar_17_CSMdemand,0) + (isnull(aa.Mar_17_factor,1)*isnull(bb.Mar_17,0)) as Mar_17_TOTALdemand,
				isnull(aa.Apr_17_CSMdemand,0) + (isnull(aa.Apr_17_factor,1)*isnull(bb.Apr_17,0)) as Apr_17_TOTALdemand,
				isnull(aa.May_17_CSMdemand,0) + (isnull(aa.May_17_factor,1)*isnull(bb.May_17,0)) as May_17_TOTALdemand,
				isnull(aa.Jun_17_CSMdemand,0) + (isnull(aa.Jun_17_factor,1)*isnull(bb.Jun_17,0)) as Jun_17_TOTALdemand,
				isnull(aa.Jul_17_CSMdemand,0) + (isnull(aa.Jul_17_factor,1)*isnull(bb.Jul_17,0)) as Jul_17_TOTALdemand,
				isnull(aa.Aug_17_CSMdemand,0) + (isnull(aa.Aug_17_factor,1)*isnull(bb.Aug_17,0)) as Aug_17_TOTALdemand,
				isnull(aa.Sep_17_CSMdemand,0) + (isnull(aa.Sep_17_factor,1)*isnull(bb.Sep_17,0)) as Sep_17_TOTALdemand,
				isnull(aa.Oct_17_CSMdemand,0) + (isnull(aa.Oct_17_factor,1)*isnull(bb.Oct_17,0)) as Oct_17_TOTALdemand,
				isnull(aa.Nov_17_CSMdemand,0) + (isnull(aa.Nov_17_factor,1)*isnull(bb.Nov_17,0)) as Nov_17_TOTALdemand,
				isnull(aa.Dec_17_CSMdemand,0) + (isnull(aa.Dec_17_factor,1)*isnull(bb.Dec_17,0)) as Dec_17_TOTALdemand,		
				isnull(aa.Cal_17_CSMdemand,0) + ((isnull(aa.Jan_17_factor,1)*isnull(bb.Jan_17,0)) + (isnull(aa.Feb_17_factor,1)*isnull(bb.Feb_17,0)) + (isnull(aa.Mar_17_factor,1)*isnull(bb.Mar_17,0)) 
				                                +  (isnull(aa.Apr_17_factor,1)*isnull(bb.Apr_17,0)) + (isnull(aa.May_17_factor,1)*isnull(bb.May_17,0)) + (isnull(aa.Jun_17_factor,1)*isnull(bb.Jun_17,0)) 
												+  (isnull(aa.Jul_17_factor,1)*isnull(bb.Jul_17,0)) + (isnull(aa.Aug_17_factor,1)*isnull(bb.Aug_17,0)) + (isnull(aa.Sep_17_factor,1)*isnull(bb.Sep_17,0)) 
												+  (isnull(aa.Oct_17_factor,1)*isnull(bb.Oct_17,0)) + (isnull(aa.Nov_17_factor,1)*isnull(bb.Nov_17,0)) + (isnull(aa.Dec_17_factor,1)*isnull(bb.Dec_17,0))) as Cal_17_TOTALdemand,
					
				isnull(aa.Jan_18_CSMdemand,0) + (isnull(aa.Jan_18_factor,1)*isnull(bb.Jan_18,0)) as Jan_18_TOTALdemand,
				isnull(aa.Feb_18_CSMdemand,0) + (isnull(aa.Feb_18_factor,1)*isnull(bb.Feb_18,0)) as Feb_18_TOTALdemand,
				isnull(aa.Mar_18_CSMdemand,0) + (isnull(aa.Mar_18_factor,1)*isnull(bb.Mar_18,0)) as Mar_18_TOTALdemand,
				isnull(aa.Apr_18_CSMdemand,0) + (isnull(aa.Apr_18_factor,1)*isnull(bb.Apr_18,0)) as Apr_18_TOTALdemand,
				isnull(aa.May_18_CSMdemand,0) + (isnull(aa.May_18_factor,1)*isnull(bb.May_18,0)) as May_18_TOTALdemand,
				isnull(aa.Jun_18_CSMdemand,0) + (isnull(aa.Jun_18_factor,1)*isnull(bb.Jun_18,0)) as Jun_18_TOTALdemand,
				isnull(aa.Jul_18_CSMdemand,0) + (isnull(aa.Jul_18_factor,1)*isnull(bb.Jul_18,0)) as Jul_18_TOTALdemand,
				isnull(aa.Aug_18_CSMdemand,0) + (isnull(aa.Aug_18_factor,1)*isnull(bb.Aug_18,0)) as Aug_18_TOTALdemand,
				isnull(aa.Sep_18_CSMdemand,0) + (isnull(aa.Sep_18_factor,1)*isnull(bb.Sep_18,0)) as Sep_18_TOTALdemand,
				isnull(aa.Oct_18_CSMdemand,0) + (isnull(aa.Oct_18_factor,1)*isnull(bb.Oct_18,0)) as Oct_18_TOTALdemand,
				isnull(aa.Nov_18_CSMdemand,0) + (isnull(aa.Nov_18_factor,1)*isnull(bb.Nov_18,0)) as Nov_18_TOTALdemand,
				isnull(aa.Dec_18_CSMdemand,0) + (isnull(aa.Dec_18_factor,1)*isnull(bb.Dec_18,0)) as Dec_18_TOTALdemand,		
				isnull(aa.Cal_18_CSMdemand,0) + ((isnull(aa.Jan_18_factor,1)*isnull(bb.Jan_18,0)) + (isnull(aa.Feb_18_factor,1)*isnull(bb.Feb_18,0)) + (isnull(aa.Mar_18_factor,1)*isnull(bb.Mar_18,0)) 
				                                +  (isnull(aa.Apr_18_factor,1)*isnull(bb.Apr_18,0)) + (isnull(aa.May_18_factor,1)*isnull(bb.May_18,0)) + (isnull(aa.Jun_18_factor,1)*isnull(bb.Jun_18,0)) 
												+  (isnull(aa.Jul_18_factor,1)*isnull(bb.Jul_18,0)) + (isnull(aa.Aug_18_factor,1)*isnull(bb.Aug_18,0)) + (isnull(aa.Sep_18_factor,1)*isnull(bb.Sep_18,0)) 
												+  (isnull(aa.Oct_18_factor,1)*isnull(bb.Oct_18,0)) + (isnull(aa.Nov_18_factor,1)*isnull(bb.Nov_18,0)) + (isnull(aa.Dec_18_factor,1)*isnull(bb.Dec_18,0))) as Cal_18_TOTALdemand,						
				
				isnull(aa.Jan_19_CSMdemand,0) + (isnull(aa.Jan_19_factor,1)*isnull(bb.Jan_19,0)) as Jan_19_TOTALdemand,
				isnull(aa.Feb_19_CSMdemand,0) + (isnull(aa.Feb_19_factor,1)*isnull(bb.Feb_19,0)) as Feb_19_TOTALdemand,
				isnull(aa.Mar_19_CSMdemand,0) + (isnull(aa.Mar_19_factor,1)*isnull(bb.Mar_19,0)) as Mar_19_TOTALdemand,
				isnull(aa.Apr_19_CSMdemand,0) + (isnull(aa.Apr_19_factor,1)*isnull(bb.Apr_19,0)) as Apr_19_TOTALdemand,
				isnull(aa.May_19_CSMdemand,0) + (isnull(aa.May_19_factor,1)*isnull(bb.May_19,0)) as May_19_TOTALdemand,
				isnull(aa.Jun_19_CSMdemand,0) + (isnull(aa.Jun_19_factor,1)*isnull(bb.Jun_19,0)) as Jun_19_TOTALdemand,
				isnull(aa.Jul_19_CSMdemand,0) + (isnull(aa.Jul_19_factor,1)*isnull(bb.Jul_19,0)) as Jul_19_TOTALdemand,
				isnull(aa.Aug_19_CSMdemand,0) + (isnull(aa.Aug_19_factor,1)*isnull(bb.Aug_19,0)) as Aug_19_TOTALdemand,
				isnull(aa.Sep_19_CSMdemand,0) + (isnull(aa.Sep_19_factor,1)*isnull(bb.Sep_19,0)) as Sep_19_TOTALdemand,
				isnull(aa.Oct_19_CSMdemand,0) + (isnull(aa.Oct_19_factor,1)*isnull(bb.Oct_19,0)) as Oct_19_TOTALdemand,
				isnull(aa.Nov_19_CSMdemand,0) + (isnull(aa.Nov_19_factor,1)*isnull(bb.Nov_19,0)) as Nov_19_TOTALdemand,
				isnull(aa.Dec_19_CSMdemand,0) + (isnull(aa.Dec_19_factor,1)*isnull(bb.Dec_19,0)) as Dec_19_TOTALdemand,		
				isnull(aa.Cal_19_CSMdemand,0) + ((isnull(aa.Jan_19_factor,1)*isnull(bb.Jan_19,0)) + (isnull(aa.Feb_19_factor,1)*isnull(bb.Feb_19,0)) + (isnull(aa.Mar_19_factor,1)*isnull(bb.Mar_19,0)) 
				                              +  (isnull(aa.Apr_19_factor,1)*isnull(bb.Apr_19,0)) + (isnull(aa.May_19_factor,1)*isnull(bb.May_19,0)) + (isnull(aa.Jun_19_factor,1)*isnull(bb.Jun_19,0)) 
										      +  (isnull(aa.Jul_19_factor,1)*isnull(bb.Jul_19,0)) + (isnull(aa.Aug_19_factor,1)*isnull(bb.Aug_19,0)) + (isnull(aa.Sep_19_factor,1)*isnull(bb.Sep_19,0)) 
											  +  (isnull(aa.Oct_19_factor,1)*isnull(bb.Oct_19,0)) + (isnull(aa.Nov_19_factor,1)*isnull(bb.Nov_19,0)) + (isnull(aa.Dec_19_factor,1)*isnull(bb.Dec_19,0))) as Cal_19_TOTALdemand,						
	
					
				isnull(aa.Jan_20_CSMdemand,0) + (isnull(aa.Jan_20_factor,1)*isnull(bb.Jan_20,0)) as Jan_20_TOTALdemand,
				isnull(aa.Feb_20_CSMdemand,0) + (isnull(aa.Feb_20_factor,1)*isnull(bb.Feb_20,0)) as Feb_20_TOTALdemand,
				isnull(aa.Mar_20_CSMdemand,0) + (isnull(aa.Mar_20_factor,1)*isnull(bb.Mar_20,0)) as Mar_20_TOTALdemand,
				isnull(aa.Apr_20_CSMdemand,0) + (isnull(aa.Apr_20_factor,1)*isnull(bb.Apr_20,0)) as Apr_20_TOTALdemand,
				isnull(aa.May_20_CSMdemand,0) + (isnull(aa.May_20_factor,1)*isnull(bb.May_20,0)) as May_20_TOTALdemand,
				isnull(aa.Jun_20_CSMdemand,0) + (isnull(aa.Jun_20_factor,1)*isnull(bb.Jun_20,0)) as Jun_20_TOTALdemand,
				isnull(aa.Jul_20_CSMdemand,0) + (isnull(aa.Jul_20_factor,1)*isnull(bb.Jul_20,0)) as Jul_20_TOTALdemand,
				isnull(aa.Aug_20_CSMdemand,0) + (isnull(aa.Aug_20_factor,1)*isnull(bb.Aug_20,0)) as Aug_20_TOTALdemand,
				isnull(aa.Sep_20_CSMdemand,0) + (isnull(aa.Sep_20_factor,1)*isnull(bb.Sep_20,0)) as Sep_20_TOTALdemand,
				isnull(aa.Oct_20_CSMdemand,0) + (isnull(aa.Oct_20_factor,1)*isnull(bb.Oct_20,0)) as Oct_20_TOTALdemand,
				isnull(aa.Nov_20_CSMdemand,0) + (isnull(aa.Nov_20_factor,1)*isnull(bb.Nov_20,0)) as Nov_20_TOTALdemand,
				isnull(aa.Dec_20_CSMdemand,0) + (isnull(aa.Dec_20_factor,1)*isnull(bb.Dec_20,0)) as Dec_20_TOTALdemand,		
				isnull(aa.Cal_20_CSMdemand,0) + ((isnull(aa.Jan_20_factor,1)*isnull(bb.Jan_20,0)) + (isnull(aa.Feb_20_factor,1)*isnull(bb.Feb_20,0)) + (isnull(aa.Mar_20_factor,1)*isnull(bb.Mar_20,0)) 
				                              +  (isnull(aa.Apr_20_factor,1)*isnull(bb.Apr_20,0)) + (isnull(aa.May_20_factor,1)*isnull(bb.May_20,0)) + (isnull(aa.Jun_20_factor,1)*isnull(bb.Jun_20,0)) 
											  +  (isnull(aa.Jul_20_factor,1)*isnull(bb.Jul_20,0)) + (isnull(aa.Aug_20_factor,1)*isnull(bb.Aug_20,0)) + (isnull(aa.Sep_20_factor,1)*isnull(bb.Sep_20,0)) 
											  +  (isnull(aa.Oct_20_factor,1)*isnull(bb.Oct_20,0)) + (isnull(aa.Nov_20_factor,1)*isnull(bb.Nov_20,0)) + (isnull(aa.Dec_20_factor,1)*isnull(bb.Dec_20,0))) as Cal_20_TOTALdemand,						
	
					
				isnull(aa.Jan_21_CSMdemand,0) + (isnull(aa.Jan_21_factor,1)*isnull(bb.Jan_21,0)) as Jan_21_TOTALdemand,
				isnull(aa.Feb_21_CSMdemand,0) + (isnull(aa.Feb_21_factor,1)*isnull(bb.Feb_21,0)) as Feb_21_TOTALdemand,
				isnull(aa.Mar_21_CSMdemand,0) + (isnull(aa.Mar_21_factor,1)*isnull(bb.Mar_21,0)) as Mar_21_TOTALdemand,
				isnull(aa.Apr_21_CSMdemand,0) + (isnull(aa.Apr_21_factor,1)*isnull(bb.Apr_21,0)) as Apr_21_TOTALdemand,
				isnull(aa.May_21_CSMdemand,0) + (isnull(aa.May_21_factor,1)*isnull(bb.May_21,0)) as May_21_TOTALdemand,
				isnull(aa.Jun_21_CSMdemand,0) + (isnull(aa.Jun_21_factor,1)*isnull(bb.Jun_21,0)) as Jun_21_TOTALdemand,
				isnull(aa.Jul_21_CSMdemand,0) + (isnull(aa.Jul_21_factor,1)*isnull(bb.Jul_21,0)) as Jul_21_TOTALdemand,
				isnull(aa.Aug_21_CSMdemand,0) + (isnull(aa.Aug_21_factor,1)*isnull(bb.Aug_21,0)) as Aug_21_TOTALdemand,
				isnull(aa.Sep_21_CSMdemand,0) + (isnull(aa.Sep_21_factor,1)*isnull(bb.Sep_21,0)) as Sep_21_TOTALdemand,
				isnull(aa.Oct_21_CSMdemand,0) + (isnull(aa.Oct_21_factor,1)*isnull(bb.Oct_21,0)) as Oct_21_TOTALdemand,
				isnull(aa.Nov_21_CSMdemand,0) + (isnull(aa.Nov_21_factor,1)*isnull(bb.Nov_21,0)) as Nov_21_TOTALdemand,
				isnull(aa.Dec_21_CSMdemand,0) + (isnull(aa.Dec_21_factor,1)*isnull(bb.Dec_21,0)) as Dec_21_TOTALdemand,		
				isnull(aa.Cal_21_CSMdemand,0) + ((isnull(aa.Jan_21_factor,1)*isnull(bb.Jan_21,0)) + (isnull(aa.Feb_21_factor,1)*isnull(bb.Feb_21,0)) + (isnull(aa.Mar_21_factor,1)*isnull(bb.Mar_21,0)) 
				                              +  (isnull(aa.Apr_21_factor,1)*isnull(bb.Apr_21,0)) + (isnull(aa.May_21_factor,1)*isnull(bb.May_21,0)) + (isnull(aa.Jun_21_factor,1)*isnull(bb.Jun_21,0)) 
											  +  (isnull(aa.Jul_21_factor,1)*isnull(bb.Jul_21,0)) + (isnull(aa.Aug_21_factor,1)*isnull(bb.Aug_21,0)) + (isnull(aa.Sep_21_factor,1)*isnull(bb.Sep_21,0)) 
											  +  (isnull(aa.Oct_21_factor,1)*isnull(bb.Oct_21,0)) + (isnull(aa.Nov_21_factor,1)*isnull(bb.Nov_21,0)) + (isnull(aa.Dec_21_factor,1)*isnull(bb.Dec_21,0))) as Cal_21_TOTALdemand,						
	
	
				isnull(aa.Cal_22_CSMdemand,0) + (isnull(aa.Cal_22_factor,1)*isnull(bb.Cal_22,0)) as Cal_22_TOTALdemand,	
				isnull(aa.Cal_23_CSMdemand,0) + (isnull(aa.Cal_23_factor,1)*isnull(bb.Cal_23,0)) as Cal_23_TOTALdemand,
				isnull(aa.Cal_24_CSMdemand,0) + (isnull(aa.Cal_24_factor,1)*isnull(bb.Cal_24,0)) as Cal_24_TOTALdemand,
				isnull(aa.Cal_25_CSMdemand,0) + (isnull(aa.Cal_25_factor,1)*isnull(bb.Cal_25,0)) as Cal_25_TOTALdemand,
				isnull(aa.Cal_26_CSMdemand,0) + (isnull(aa.Cal_26_factor,1)*isnull(bb.Cal_26,0)) as Cal_26_TOTALdemand		
	-- THE ABOVE STATEMENT WILL ASSUME A 1 WHEN THE FACTOR IS NULL, THE FACTOR WILL BE NULL WHEN THERE IS NO DEMAND IN THE YEAR; THE RESULT WILL BE MULTIPLIED bY THE NUMBER OF ROWS RETURNED FOR THE PART -- 

	
		from

				/* LEVEL 3 */
				/* STATEMENT 3aa BEGINS */
				(select a.base_part,
						a.mnemonic,						
						a.version,
						a.badge,
						a.manufacturer,
						a.platform,
						a.program,
						a.vehicle,
						a.assembly_plant,
						a.product_type,
						a.global_segment,
						a.regional_segment,
						a.market, 
						a.CSM_sop, 
						a.CSM_eop,
						a.qty_per, 
						a.take_rate, 
						a.family_allocation,
						
						--a.jan_10 as Jan_10_CSMdemand,
						--a.feb_10 as Feb_10_CSMdemand,
						--a.mar_10 as Mar_10_CSMdemand,
						--a.apr_10 as Apr_10_CSMdemand,
						--a.may_10 as May_10_CSMdemand,
						--a.jun_10 as Jun_10_CSMdemand,
						--a.jul_10 as Jul_10_CSMdemand,
						--a.aug_10 as Aug_10_CSMdemand,
						--a.sep_10 as Sep_10_CSMdemand,
						--a.oct_10 as Oct_10_CSMdemand,
						--a.nov_10 as Nov_10_CSMdemand,
						--a.dec_10 as Dec_10_CSMdemand, 
						--a.cal_10 as Cal_10_CSMdemand, 
						
						--a.jan_11 as Jan_11_CSMdemand,
						--a.feb_11 as Feb_11_CSMdemand,
						--a.mar_11 as Mar_11_CSMdemand,
						--a.apr_11 as Apr_11_CSMdemand,
						--a.may_11 as May_11_CSMdemand,
						--a.jun_11 as Jun_11_CSMdemand,
						--a.jul_11 as Jul_11_CSMdemand,
						--a.aug_11 as Aug_11_CSMdemand,
						--a.sep_11 as Sep_11_CSMdemand,
						--a.oct_11 as Oct_11_CSMdemand,
						--a.nov_11 as Nov_11_CSMdemand,
						--a.dec_11 as Dec_11_CSMdemand, 
						--a.cal_11 as Cal_11_CSMdemand, 
						
						--a.jan_12 as Jan_12_CSMdemand,
						--a.feb_12 as Feb_12_CSMdemand,
						--a.mar_12 as Mar_12_CSMdemand,
						--a.apr_12 as Apr_12_CSMdemand,
						--a.may_12 as May_12_CSMdemand,
						--a.jun_12 as Jun_12_CSMdemand,
						--a.jul_12 as Jul_12_CSMdemand,
						--a.aug_12 as Aug_12_CSMdemand,
						--a.sep_12 as Sep_12_CSMdemand,
						--a.oct_12 as Oct_12_CSMdemand,
						--a.nov_12 as Nov_12_CSMdemand,
						--a.dec_12 as Dec_12_CSMdemand, 
						--a.cal_12 as Cal_12_CSMdemand,
		
						--a.jan_13 as Jan_13_CSMdemand,
						--a.feb_13 as Feb_13_CSMdemand,
						--a.mar_13 as Mar_13_CSMdemand,
						--a.apr_13 as Apr_13_CSMdemand,
						--a.may_13 as May_13_CSMdemand,
						--a.jun_13 as Jun_13_CSMdemand,
						--a.jul_13 as Jul_13_CSMdemand,
						--a.aug_13 as Aug_13_CSMdemand,
						--a.sep_13 as Sep_13_CSMdemand,
						--a.oct_13 as Oct_13_CSMdemand,
						--a.nov_13 as Nov_13_CSMdemand,
						--a.dec_13 as Dec_13_CSMdemand, 
						--a.cal_13 as Cal_13_CSMdemand,
						
						--a.jan_14 as Jan_14_CSMdemand,
						--a.feb_14 as Feb_14_CSMdemand,
						--a.mar_14 as Mar_14_CSMdemand,
						--a.apr_14 as Apr_14_CSMdemand,
						--a.may_14 as May_14_CSMdemand,
						--a.jun_14 as Jun_14_CSMdemand,
						--a.jul_14 as Jul_14_CSMdemand,
						--a.aug_14 as Aug_14_CSMdemand,
						--a.sep_14 as Sep_14_CSMdemand,
						--a.oct_14 as Oct_14_CSMdemand,
						--a.nov_14 as Nov_14_CSMdemand,
						--a.dec_14 as Dec_14_CSMdemand, 
						--a.cal_14 as Cal_14_CSMdemand,	
						
						--a.jan_15 as Jan_15_CSMdemand,
						--a.feb_15 as Feb_15_CSMdemand,
						--a.mar_15 as Mar_15_CSMdemand,
						--a.apr_15 as Apr_15_CSMdemand,
						--a.may_15 as May_15_CSMdemand,
						--a.jun_15 as Jun_15_CSMdemand,
						--a.jul_15 as Jul_15_CSMdemand,
						--a.aug_15 as Aug_15_CSMdemand,
						--a.sep_15 as Sep_15_CSMdemand,
						--a.oct_15 as Oct_15_CSMdemand,
						--a.nov_15 as Nov_15_CSMdemand,
						--a.dec_15 as Dec_15_CSMdemand, 
						--a.cal_15 as Cal_15_CSMdemand,		
						
						a.jan_16 as Jan_16_CSMdemand,
						a.feb_16 as Feb_16_CSMdemand,
						a.mar_16 as Mar_16_CSMdemand,
						a.apr_16 as Apr_16_CSMdemand,
						a.may_16 as May_16_CSMdemand,
						a.jun_16 as Jun_16_CSMdemand,
						a.jul_16 as Jul_16_CSMdemand,
						a.aug_16 as Aug_16_CSMdemand,
						a.sep_16 as Sep_16_CSMdemand,
						a.oct_16 as Oct_16_CSMdemand,
						a.nov_16 as Nov_16_CSMdemand,
						a.dec_16 as Dec_16_CSMdemand, 
						a.cal_16 as Cal_16_CSMdemand,		
												
						a.jan_17 as Jan_17_CSMdemand,
						a.feb_17 as Feb_17_CSMdemand,
						a.mar_17 as Mar_17_CSMdemand,
						a.apr_17 as Apr_17_CSMdemand,
						a.may_17 as May_17_CSMdemand,
						a.jun_17 as Jun_17_CSMdemand,
						a.jul_17 as Jul_17_CSMdemand,
						a.aug_17 as Aug_17_CSMdemand,
						a.sep_17 as Sep_17_CSMdemand,
						a.oct_17 as Oct_17_CSMdemand,
						a.nov_17 as Nov_17_CSMdemand,
						a.dec_17 as Dec_17_CSMdemand, 
						a.cal_17 as Cal_17_CSMdemand,	

						a.jan_18 as Jan_18_CSMdemand,
						a.feb_18 as Feb_18_CSMdemand,
						a.mar_18 as Mar_18_CSMdemand,
						a.apr_18 as Apr_18_CSMdemand,
						a.may_18 as May_18_CSMdemand,
						a.jun_18 as Jun_18_CSMdemand,
						a.jul_18 as Jul_18_CSMdemand,
						a.aug_18 as Aug_18_CSMdemand,
						a.sep_18 as Sep_18_CSMdemand,
						a.oct_18 as Oct_18_CSMdemand,
						a.nov_18 as Nov_18_CSMdemand,
						a.dec_18 as Dec_18_CSMdemand, 
						a.cal_18 as Cal_18_CSMdemand,	

						a.jan_19 as Jan_19_CSMdemand,
						a.feb_19 as Feb_19_CSMdemand,
						a.mar_19 as Mar_19_CSMdemand,
						a.apr_19 as Apr_19_CSMdemand,
						a.may_19 as May_19_CSMdemand,
						a.jun_19 as Jun_19_CSMdemand,
						a.jul_19 as Jul_19_CSMdemand,
						a.aug_19 as Aug_19_CSMdemand,
						a.sep_19 as Sep_19_CSMdemand,
						a.oct_19 as Oct_19_CSMdemand,
						a.nov_19 as Nov_19_CSMdemand,
						a.dec_19 as Dec_19_CSMdemand, 
						a.cal_19 as Cal_19_CSMdemand,	

						a.jan_20 as Jan_20_CSMdemand,
						a.feb_20 as Feb_20_CSMdemand,
						a.mar_20 as Mar_20_CSMdemand,
						a.apr_20 as Apr_20_CSMdemand,
						a.may_20 as May_20_CSMdemand,
						a.jun_20 as Jun_20_CSMdemand,
						a.jul_20 as Jul_20_CSMdemand,
						a.aug_20 as Aug_20_CSMdemand,
						a.sep_20 as Sep_20_CSMdemand,
						a.oct_20 as Oct_20_CSMdemand,
						a.nov_20 as Nov_20_CSMdemand,
						a.dec_20 as Dec_20_CSMdemand, 
						a.cal_20 as Cal_20_CSMdemand,	

						a.jan_21 as Jan_21_CSMdemand,
						a.feb_21 as Feb_21_CSMdemand,
						a.mar_21 as Mar_21_CSMdemand,
						a.apr_21 as Apr_21_CSMdemand,
						a.may_21 as May_21_CSMdemand,
						a.jun_21 as Jun_21_CSMdemand,
						a.jul_21 as Jul_21_CSMdemand,
						a.aug_21 as Aug_21_CSMdemand,
						a.sep_21 as Sep_21_CSMdemand,
						a.oct_21 as Oct_21_CSMdemand,
						a.nov_21 as Nov_21_CSMdemand,
						a.dec_21 as Dec_21_CSMdemand, 
						a.cal_21 as Cal_21_CSMdemand,	
												
						a.cal_22 as Cal_22_CSMdemand,
						a.cal_23 as Cal_23_CSMdemand,
						a.cal_24 as Cal_24_CSMdemand,
						a.cal_25 as Cal_25_CSMdemand,
						a.cal_26 as Cal_26_CSMdemand,

						--(case when isnull(b.jan_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.jan_10/NULLIF(b.jan_10,0) end) as jan_10_factor, 
						--(case when isnull(b.feb_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.feb_10/NULLIF(b.feb_10,0) end) as feb_10_factor,
						--(case when isnull(b.mar_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.mar_10/NULLIF(b.mar_10,0) end) as mar_10_factor,
						--(case when isnull(b.apr_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.apr_10/NULLIF(b.apr_10,0) end) as apr_10_factor,
						--(case when isnull(b.may_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.may_10/NULLIF(b.may_10,0) end) as may_10_factor,
						--(case when isnull(b.jun_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.jun_10/NULLIF(b.jun_10,0) end) as jun_10_factor,
						--(case when isnull(b.jul_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.jul_10/NULLIF(b.jul_10,0) end) as jul_10_factor, 
						--(case when isnull(b.aug_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.aug_10/NULLIF(b.aug_10,0) end) as aug_10_factor,
						--(case when isnull(b.sep_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.sep_10/NULLIF(b.sep_10,0) end) as sep_10_factor,
						--(case when isnull(b.oct_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.oct_10/NULLIF(b.oct_10,0) end) as oct_10_factor,
						--(case when isnull(b.nov_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.nov_10/NULLIF(b.nov_10,0) end) as nov_10_factor,
						--(case when isnull(b.dec_10,0)=0 then a.cal_10/NULLIF(b.cal_10,0) else a.dec_10/NULLIF(b.dec_10,0) end) as dec_10_factor,
						
						--(case when isnull(b.jan_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.jan_11/NULLIF(b.jan_11,0) end) as jan_11_factor, 
						--(case when isnull(b.feb_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.feb_11/NULLIF(b.feb_11,0) end) as feb_11_factor,
						--(case when isnull(b.mar_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.mar_11/NULLIF(b.mar_11,0) end) as mar_11_factor,
						--(case when isnull(b.apr_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.apr_11/NULLIF(b.apr_11,0) end) as apr_11_factor,
						--(case when isnull(b.may_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.may_11/NULLIF(b.may_11,0) end) as may_11_factor,
						--(case when isnull(b.jun_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.jun_11/NULLIF(b.jun_11,0) end) as jun_11_factor,
						--(case when isnull(b.jul_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.jul_11/NULLIF(b.jul_11,0) end) as jul_11_factor, 
						--(case when isnull(b.aug_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.aug_11/NULLIF(b.aug_11,0) end) as aug_11_factor,
						--(case when isnull(b.sep_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.sep_11/NULLIF(b.sep_11,0) end) as sep_11_factor,
						--(case when isnull(b.oct_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.oct_11/NULLIF(b.oct_11,0) end) as oct_11_factor,
						--(case when isnull(b.nov_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.nov_11/NULLIF(b.nov_11,0) end) as nov_11_factor,
						--(case when isnull(b.dec_11,0)=0 then a.cal_11/NULLIF(b.cal_11,0) else a.dec_11/NULLIF(b.dec_11,0) end) as dec_11_factor,
						
						--(case when isnull(b.jan_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.jan_12/NULLIF(b.jan_12,0) end) as jan_12_factor, 
						--(case when isnull(b.feb_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.feb_12/NULLIF(b.feb_12,0) end) as feb_12_factor,
						--(case when isnull(b.mar_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.mar_12/NULLIF(b.mar_12,0) end) as mar_12_factor,
						--(case when isnull(b.apr_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.apr_12/NULLIF(b.apr_12,0) end) as apr_12_factor,
						--(case when isnull(b.may_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.may_12/NULLIF(b.may_12,0) end) as may_12_factor,
						--(case when isnull(b.jun_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.jun_12/NULLIF(b.jun_12,0) end) as jun_12_factor,
						--(case when isnull(b.jul_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.jul_12/NULLIF(b.jul_12,0) end) as jul_12_factor, 
						--(case when isnull(b.aug_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.aug_12/NULLIF(b.aug_12,0) end) as aug_12_factor,
						--(case when isnull(b.sep_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.sep_12/NULLIF(b.sep_12,0) end) as sep_12_factor,
						--(case when isnull(b.oct_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.oct_12/NULLIF(b.oct_12,0) end) as oct_12_factor,
						--(case when isnull(b.nov_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.nov_12/NULLIF(b.nov_12,0) end) as nov_12_factor,
						--(case when isnull(b.dec_12,0)=0 then a.cal_12/NULLIF(b.cal_12,0) else a.dec_12/NULLIF(b.dec_12,0) end) as dec_12_factor,
		
						--(case when isnull(b.jan_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.jan_13/NULLIF(b.jan_13,0) end) as jan_13_factor, 
						--(case when isnull(b.feb_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.feb_13/NULLIF(b.feb_13,0) end) as feb_13_factor,
						--(case when isnull(b.mar_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.mar_13/NULLIF(b.mar_13,0) end) as mar_13_factor,
						--(case when isnull(b.apr_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.apr_13/NULLIF(b.apr_13,0) end) as apr_13_factor,
						--(case when isnull(b.may_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.may_13/NULLIF(b.may_13,0) end) as may_13_factor,
						--(case when isnull(b.jun_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.jun_13/NULLIF(b.jun_13,0) end) as jun_13_factor,
						--(case when isnull(b.jul_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.jul_13/NULLIF(b.jul_13,0) end) as jul_13_factor, 
						--(case when isnull(b.aug_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.aug_13/NULLIF(b.aug_13,0) end) as aug_13_factor,
						--(case when isnull(b.sep_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.sep_13/NULLIF(b.sep_13,0) end) as sep_13_factor,
						--(case when isnull(b.oct_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.oct_13/NULLIF(b.oct_13,0) end) as oct_13_factor,
						--(case when isnull(b.nov_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.nov_13/NULLIF(b.nov_13,0) end) as nov_13_factor,
						--(case when isnull(b.dec_13,0)=0 then a.cal_13/NULLIF(b.cal_13,0) else a.dec_13/NULLIF(b.dec_13,0) end) as dec_13_factor,
								
						--(case when isnull(b.jan_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.jan_14/NULLIF(b.jan_14,0) end) as jan_14_factor, 
						--(case when isnull(b.feb_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.feb_14/NULLIF(b.feb_14,0) end) as feb_14_factor,
						--(case when isnull(b.mar_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.mar_14/NULLIF(b.mar_14,0) end) as mar_14_factor,
						--(case when isnull(b.apr_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.apr_14/NULLIF(b.apr_14,0) end) as apr_14_factor,
						--(case when isnull(b.may_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.may_14/NULLIF(b.may_14,0) end) as may_14_factor,
						--(case when isnull(b.jun_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.jun_14/NULLIF(b.jun_14,0) end) as jun_14_factor,
						--(case when isnull(b.jul_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.jul_14/NULLIF(b.jul_14,0) end) as jul_14_factor, 
						--(case when isnull(b.aug_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.aug_14/NULLIF(b.aug_14,0) end) as aug_14_factor,
						--(case when isnull(b.sep_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.sep_14/NULLIF(b.sep_14,0) end) as sep_14_factor,
						--(case when isnull(b.oct_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.oct_14/NULLIF(b.oct_14,0) end) as oct_14_factor,
						--(case when isnull(b.nov_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.nov_14/NULLIF(b.nov_14,0) end) as nov_14_factor,
						--(case when isnull(b.dec_14,0)=0 then a.cal_14/NULLIF(b.cal_14,0) else a.dec_14/NULLIF(b.dec_14,0) end) as dec_14_factor,

						--(case when isnull(b.jan_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.jan_15/NULLIF(b.jan_15,0) end) as jan_15_factor, 
						--(case when isnull(b.feb_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.feb_15/NULLIF(b.feb_15,0) end) as feb_15_factor,
						--(case when isnull(b.mar_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.mar_15/NULLIF(b.mar_15,0) end) as mar_15_factor,
						--(case when isnull(b.apr_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.apr_15/NULLIF(b.apr_15,0) end) as apr_15_factor,
						--(case when isnull(b.may_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.may_15/NULLIF(b.may_15,0) end) as may_15_factor,
						--(case when isnull(b.jun_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.jun_15/NULLIF(b.jun_15,0) end) as jun_15_factor,
						--(case when isnull(b.jul_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.jul_15/NULLIF(b.jul_15,0) end) as jul_15_factor, 
						--(case when isnull(b.aug_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.aug_15/NULLIF(b.aug_15,0) end) as aug_15_factor,
						--(case when isnull(b.sep_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.sep_15/NULLIF(b.sep_15,0) end) as sep_15_factor,
						--(case when isnull(b.oct_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.oct_15/NULLIF(b.oct_15,0) end) as oct_15_factor,
						--(case when isnull(b.nov_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.nov_15/NULLIF(b.nov_15,0) end) as nov_15_factor,
						--(case when isnull(b.dec_15,0)=0 then a.cal_15/NULLIF(b.cal_15,0) else a.dec_15/NULLIF(b.dec_15,0) end) as dec_15_factor,
						
						--(case when isnull(b.jan_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.jan_16/nullif(b.jan_16,0) end) as jan_16_factor, 
						--(case when isnull(b.feb_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.feb_16/nullif(b.feb_16,0) end) as feb_16_factor,
						--(case when isnull(b.mar_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.mar_16/nullif(b.mar_16,0) end) as mar_16_factor,
						--(case when isnull(b.apr_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.apr_16/nullif(b.apr_16,0) end) as apr_16_factor,
						--(case when isnull(b.may_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.may_16/nullif(b.may_16,0) end) as may_16_factor,
						--(case when isnull(b.jun_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.jun_16/nullif(b.jun_16,0) end) as jun_16_factor,
						--(case when isnull(b.jul_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.jul_16/nullif(b.jul_16,0) end) as jul_16_factor, 
						--(case when isnull(b.aug_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.aug_16/nullif(b.aug_16,0) end) as aug_16_factor,
						--(case when isnull(b.sep_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.sep_16/nullif(b.sep_16,0) end) as sep_16_factor,
						--(case when isnull(b.oct_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.oct_16/nullif(b.oct_16,0) end) as oct_16_factor,
						--(case when isnull(b.nov_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.nov_16/nullif(b.nov_16,0) end) as nov_16_factor,
						--(case when isnull(b.dec_16,0)=0 then a.cal_16/nullif(b.cal_16,0) else a.dec_16/nullif(b.dec_16,0) end) as dec_16_factor,
						
						--(case when isnull(b.jan_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.jan_17/nullif(b.jan_17,0) end) as jan_17_factor, 
						--(case when isnull(b.feb_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.feb_17/nullif(b.feb_17,0) end) as feb_17_factor,
						--(case when isnull(b.mar_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.mar_17/nullif(b.mar_17,0) end) as mar_17_factor,
						--(case when isnull(b.apr_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.apr_17/nullif(b.apr_17,0) end) as apr_17_factor,
						--(case when isnull(b.may_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.may_17/nullif(b.may_17,0) end) as may_17_factor,
						--(case when isnull(b.jun_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.jun_17/nullif(b.jun_17,0) end) as jun_17_factor,
						--(case when isnull(b.jul_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.jul_17/nullif(b.jul_17,0) end) as jul_17_factor, 
						--(case when isnull(b.aug_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.aug_17/nullif(b.aug_17,0) end) as aug_17_factor,
						--(case when isnull(b.sep_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.sep_17/nullif(b.sep_17,0) end) as sep_17_factor,
						--(case when isnull(b.oct_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.oct_17/nullif(b.oct_17,0) end) as oct_17_factor,
						--(case when isnull(b.nov_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.nov_17/nullif(b.nov_17,0) end) as nov_17_factor,
						--(case when isnull(b.dec_17,0)=0 then a.cal_17/nullif(b.cal_17,0) else a.dec_17/nullif(b.dec_17,0) end) as dec_17_factor,
						
						--(case when isnull(b.jan_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.jan_18/nullif(b.jan_18,0) end) as jan_18_factor, 
						--(case when isnull(b.feb_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.feb_18/nullif(b.feb_18,0) end) as feb_18_factor,
						--(case when isnull(b.mar_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.mar_18/nullif(b.mar_18,0) end) as mar_18_factor,
						--(case when isnull(b.apr_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.apr_18/nullif(b.apr_18,0) end) as apr_18_factor,
						--(case when isnull(b.may_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.may_18/nullif(b.may_18,0) end) as may_18_factor,
						--(case when isnull(b.jun_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.jun_18/nullif(b.jun_18,0) end) as jun_18_factor,
						--(case when isnull(b.jul_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.jul_18/nullif(b.jul_18,0) end) as jul_18_factor, 
						--(case when isnull(b.aug_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.aug_18/nullif(b.aug_18,0) end) as aug_18_factor,
						--(case when isnull(b.sep_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.sep_18/nullif(b.sep_18,0) end) as sep_18_factor,
						--(case when isnull(b.oct_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.oct_18/nullif(b.oct_18,0) end) as oct_18_factor,
						--(case when isnull(b.nov_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.nov_18/nullif(b.nov_18,0) end) as nov_18_factor,
						--(case when isnull(b.dec_18,0)=0 then a.cal_18/nullif(b.cal_18,0) else a.dec_18/nullif(b.dec_18,0) end) as dec_18_factor,
						
						--(case when isnull(b.jan_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.jan_19/nullif(b.jan_19,0) end) as jan_19_factor, 
						--(case when isnull(b.feb_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.feb_19/nullif(b.feb_19,0) end) as feb_19_factor,
						--(case when isnull(b.mar_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.mar_19/nullif(b.mar_19,0) end) as mar_19_factor,
						--(case when isnull(b.apr_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.apr_19/nullif(b.apr_19,0) end) as apr_19_factor,
						--(case when isnull(b.may_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.may_19/nullif(b.may_19,0) end) as may_19_factor,
						--(case when isnull(b.jun_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.jun_19/nullif(b.jun_19,0) end) as jun_19_factor,
						--(case when isnull(b.jul_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.jul_19/nullif(b.jul_19,0) end) as jul_19_factor, 
						--(case when isnull(b.aug_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.aug_19/nullif(b.aug_19,0) end) as aug_19_factor,
						--(case when isnull(b.sep_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.sep_19/nullif(b.sep_19,0) end) as sep_19_factor,
						--(case when isnull(b.oct_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.oct_19/nullif(b.oct_19,0) end) as oct_19_factor,
						--(case when isnull(b.nov_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.nov_19/nullif(b.nov_19,0) end) as nov_19_factor,
						--(case when isnull(b.dec_19,0)=0 then a.cal_19/nullif(b.cal_19,0) else a.dec_19/nullif(b.dec_19,0) end) as dec_19_factor,

						--(case when isnull(b.jan_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.jan_20/nullif(b.jan_20,0) end) as jan_20_factor, 
						--(case when isnull(b.feb_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.feb_20/nullif(b.feb_20,0) end) as feb_20_factor,
						--(case when isnull(b.mar_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.mar_20/nullif(b.mar_20,0) end) as mar_20_factor,
						--(case when isnull(b.apr_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.apr_20/nullif(b.apr_20,0) end) as apr_20_factor,
						--(case when isnull(b.may_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.may_20/nullif(b.may_20,0) end) as may_20_factor,
						--(case when isnull(b.jun_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.jun_20/nullif(b.jun_20,0) end) as jun_20_factor,
						--(case when isnull(b.jul_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.jul_20/nullif(b.jul_20,0) end) as jul_20_factor, 
						--(case when isnull(b.aug_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.aug_20/nullif(b.aug_20,0) end) as aug_20_factor,
						--(case when isnull(b.sep_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.sep_20/nullif(b.sep_20,0) end) as sep_20_factor,
						--(case when isnull(b.oct_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.oct_20/nullif(b.oct_20,0) end) as oct_20_factor,
						--(case when isnull(b.nov_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.nov_20/nullif(b.nov_20,0) end) as nov_20_factor,
						--(case when isnull(b.dec_20,0)=0 then a.cal_20/nullif(b.cal_20,0) else a.dec_20/nullif(b.dec_20,0) end) as dec_20_factor
									
						--(case when isnull(b.cal_21,0)=0 then 1 else a.cal_21/nullif(b.cal_21,0) end) as cal_21_factor,
						--(case when isnull(b.cal_22,0)=0 then 1 else a.cal_22/nullif(b.cal_22,0) end) as cal_22_factor,
						--(case when isnull(b.cal_23,0)=0 then 1 else a.cal_23/nullif(b.cal_23,0) end) as cal_23_factor,
						--(case when isnull(b.cal_24,0)=0 then 1 else a.cal_24/nullif(b.cal_24,0) end) as cal_24_factor,
						--(case when isnull(b.cal_25,0)=0 then 1 else a.cal_25/nullif(b.cal_25,0) end) as cal_25_factor
						coalesce(a.jan_16/nullif(b.jan_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as jan_16_factor
					,	coalesce(a.feb_16/nullif(b.feb_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as feb_16_factor
					,	coalesce(a.mar_16/nullif(b.mar_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as mar_16_factor
					,	coalesce(a.apr_16/nullif(b.apr_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as apr_16_factor
					,	coalesce(a.may_16/nullif(b.may_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as may_16_factor
					,	coalesce(a.jun_16/nullif(b.jun_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as jun_16_factor
					,	coalesce(a.jul_16/nullif(b.jul_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as jul_16_factor
					,	coalesce(a.aug_16/nullif(b.aug_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as aug_16_factor
					,	coalesce(a.sep_16/nullif(b.sep_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as sep_16_factor
					,	coalesce(a.oct_16/nullif(b.oct_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as oct_16_factor
					,	coalesce(a.nov_16/nullif(b.nov_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as nov_16_factor
					,	coalesce(a.dec_16/nullif(b.dec_16,0),                                                                                                                                                                                                                                         a.cal_16/nullif(b.cal_16,0), 1) as dec_16_factor

					,	coalesce(a.jan_17/nullif(b.jan_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jan_17_factor
					,	coalesce(a.feb_17/nullif(b.feb_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as feb_17_factor
					,	coalesce(a.mar_17/nullif(b.mar_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as mar_17_factor
					,	coalesce(a.apr_17/nullif(b.apr_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as apr_17_factor
					,	coalesce(a.may_17/nullif(b.may_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as may_17_factor
					,	coalesce(a.jun_17/nullif(b.jun_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jun_17_factor
					,	coalesce(a.jul_17/nullif(b.jul_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jul_17_factor
					,	coalesce(a.aug_17/nullif(b.aug_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as aug_17_factor
					,	coalesce(a.sep_17/nullif(b.sep_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as sep_17_factor
					,	coalesce(a.oct_17/nullif(b.oct_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as oct_17_factor
					,	coalesce(a.nov_17/nullif(b.nov_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as nov_17_factor
					,	coalesce(a.dec_17/nullif(b.dec_17,0),                                                                                                                                                                                                            a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as dec_17_factor
																																																				                             									
					,	coalesce(a.jan_18/nullif(b.jan_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jan_18_factor
					,	coalesce(a.feb_18/nullif(b.feb_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as feb_18_factor
					,	coalesce(a.mar_18/nullif(b.mar_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as mar_18_factor
					,	coalesce(a.apr_18/nullif(b.apr_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as apr_18_factor
					,	coalesce(a.may_18/nullif(b.may_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as may_18_factor
					,	coalesce(a.jun_18/nullif(b.jun_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jun_18_factor
					,	coalesce(a.jul_18/nullif(b.jul_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jul_18_factor
					,	coalesce(a.aug_18/nullif(b.aug_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as aug_18_factor
					,	coalesce(a.sep_18/nullif(b.sep_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as sep_18_factor
					,	coalesce(a.oct_18/nullif(b.oct_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as oct_18_factor
					,	coalesce(a.nov_18/nullif(b.nov_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as nov_18_factor
					,	coalesce(a.dec_18/nullif(b.dec_18,0),                                                                                                                                                                               a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as dec_18_factor

					,	coalesce(a.jan_19/nullif(b.jan_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jan_19_factor
					,	coalesce(a.feb_19/nullif(b.feb_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as feb_19_factor
					,	coalesce(a.mar_19/nullif(b.mar_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as mar_19_factor
					,	coalesce(a.apr_19/nullif(b.apr_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as apr_19_factor
					,	coalesce(a.may_19/nullif(b.may_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as may_19_factor
					,	coalesce(a.jun_19/nullif(b.jun_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jun_19_factor
					,	coalesce(a.jul_19/nullif(b.jul_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jul_19_factor
					,	coalesce(a.aug_19/nullif(b.aug_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as aug_19_factor
					,	coalesce(a.sep_19/nullif(b.sep_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as sep_19_factor
					,	coalesce(a.oct_19/nullif(b.oct_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as oct_19_factor
					,	coalesce(a.nov_19/nullif(b.nov_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as nov_19_factor
					,	coalesce(a.dec_19/nullif(b.dec_19,0),                                                                                                                                                  a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as dec_19_factor
																																																																				
					,	coalesce(a.jan_20/nullif(b.jan_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jan_20_factor
					,	coalesce(a.feb_20/nullif(b.feb_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as feb_20_factor
					,	coalesce(a.mar_20/nullif(b.mar_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as mar_20_factor
					,	coalesce(a.apr_20/nullif(b.apr_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as apr_20_factor
					,	coalesce(a.may_20/nullif(b.may_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as may_20_factor
					,	coalesce(a.jun_20/nullif(b.jun_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jun_20_factor
					,	coalesce(a.jul_20/nullif(b.jul_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jul_20_factor
					,	coalesce(a.aug_20/nullif(b.aug_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as aug_20_factor
					,	coalesce(a.sep_20/nullif(b.sep_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as sep_20_factor
					,	coalesce(a.oct_20/nullif(b.oct_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as oct_20_factor
					,	coalesce(a.nov_20/nullif(b.nov_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as nov_20_factor
					,	coalesce(a.dec_20/nullif(b.dec_20,0),                                                                                                                     a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as dec_20_factor
																																																																				
					,	coalesce(a.jan_20/nullif(b.jan_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jan_21_factor
					,	coalesce(a.feb_20/nullif(b.feb_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as feb_21_factor
					,	coalesce(a.mar_20/nullif(b.mar_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as mar_21_factor
					,	coalesce(a.apr_20/nullif(b.apr_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as apr_21_factor
					,	coalesce(a.may_20/nullif(b.may_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as may_21_factor
					,	coalesce(a.jun_20/nullif(b.jun_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jun_21_factor
					,	coalesce(a.jul_20/nullif(b.jul_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as jul_21_factor
					,	coalesce(a.aug_20/nullif(b.aug_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as aug_21_factor
					,	coalesce(a.sep_20/nullif(b.sep_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as sep_21_factor
					,	coalesce(a.oct_20/nullif(b.oct_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as oct_21_factor
					,	coalesce(a.nov_20/nullif(b.nov_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as nov_21_factor
					,	coalesce(a.dec_20/nullif(b.dec_20,0),                                                                                        a.cal_21/nullif(b.cal_21,0),  a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as dec_21_factor
																																																																									
                    ,	coalesce(                                                                                                                    a.cal_22/nullif(b.cal_22,0), a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as cal_22_factor
					,	coalesce(                                                                                       a.cal_23/nullif(b.cal_23,0), a.cal_22/nullif(b.cal_22,0), a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as cal_23_factor
					,	coalesce(                                                          a.cal_24/nullif(b.cal_24,0), a.cal_23/nullif(b.cal_23,0), a.cal_22/nullif(b.cal_22,0), a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as cal_24_factor
					,	coalesce(                             a.cal_25/nullif(b.cal_25,0), a.cal_24/nullif(b.cal_24,0), a.cal_23/nullif(b.cal_23,0), a.cal_22/nullif(b.cal_22,0), a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as cal_25_factor
					,	coalesce(a.cal_26/nullif(b.cal_26,0), a.cal_25/nullif(b.cal_25,0), a.cal_24/nullif(b.cal_24,0), a.cal_23/nullif(b.cal_23,0), a.cal_22/nullif(b.cal_22,0), a.cal_21/nullif(b.cal_21,0), a.cal_20/nullif(b.cal_20,0), a.cal_19/nullif(b.cal_19,0), a.cal_18/nullif(b.cal_18,0), a.cal_17/nullif(b.cal_17,0), a.cal_16/nullif(b.cal_16,0), 1) as cal_26_factor
						-- THE ABOVE STATEMENT WILL NOT RETURN RESULTS WHEN THE ENTIRE YEAR IS 0 --

				from
					
						/* LEVEL 4 */
						/* STATEMENT 4a BEGINS*/
						(select b.version,
								a.base_part,
								a.mnemonic, 								
								b.badge,
								b.manufacturer, 
								b.platform, 
								b.program, 
								b.badge+' '+b.nameplate as vehicle, 
								b.assembly_plant,
								b.product_type,
								b.global_segment,
								b.regional_segment,
								b.market, 
								b.sop as 'CSM_SOP', 
								b.eop as 'CSM_EOP',
								a.qty_per, 
								a.take_rate, 
								a.family_allocation, 
								
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_10*c.jan_10,0) as jan_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_10*c.feb_10,0) as feb_10,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_10*c.mar_10,0) as mar_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_10*c.apr_10,0) as apr_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_10*c.may_10,0) as may_10,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_10*c.jun_10,0) as jun_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_10*c.jul_10,0) as jul_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_10*c.aug_10,0) as aug_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_10*c.sep_10,0) as sep_10,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_10*c.oct_10,0) as oct_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_10*c.nov_10,0) as nov_10, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_10*c.dec_10,0) as dec_10,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_10*c.jan_10,0)+ISNULL(b.feb_10*c.feb_10,0)+ISNULL(b.mar_10*c.mar_10,0)
								--                                            +ISNULL(b.apr_10*c.apr_10,0)+ISNULL(b.may_10*c.may_10,0)+ISNULL(b.jun_10*c.jun_10,0)
								--                                            +ISNULL(b.jul_10*c.jul_10,0)+ISNULL(b.aug_10*c.aug_10,0)+ISNULL(b.sep_10*c.sep_10,0)
								--                                            +ISNULL(b.oct_10*c.oct_10,0)+ISNULL(b.nov_10*c.nov_10,0)+ISNULL(b.dec_10*c.dec_10,0)) as cal_10,
								
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_11*c.jan_11,0) as jan_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_11*c.feb_11,0) as feb_11,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_11*c.mar_11,0) as mar_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_11*c.apr_11,0) as apr_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_11*c.may_11,0) as may_11,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_11*c.jun_11,0) as jun_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_11*c.jul_11,0) as jul_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_11*c.aug_11,0) as aug_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_11*c.sep_11,0) as sep_11,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_11*c.oct_11,0) as oct_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_11*c.nov_11,0) as nov_11, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_11*c.dec_11,0) as dec_11,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_11*c.jan_11,0)+ISNULL(b.feb_11*c.feb_11,0)+ISNULL(b.mar_11*c.mar_11,0)
								--                                            +ISNULL(b.apr_11*c.apr_11,0)+ISNULL(b.may_11*c.may_11,0)+ISNULL(b.jun_11*c.jun_11,0)
								--                                            +ISNULL(b.jul_11*c.jul_11,0)+ISNULL(b.aug_11*c.aug_11,0)+ISNULL(b.sep_11*c.sep_11,0)
								--                                            +ISNULL(b.oct_11*c.oct_11,0)+ISNULL(b.nov_11*c.nov_11,0)+ISNULL(b.dec_11*c.dec_11,0)) as cal_11,
								
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_12*c.jan_12,0) as jan_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_12*c.feb_12,0) as feb_12,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_12*c.mar_12,0) as mar_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_12*c.apr_12,0) as apr_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_12*c.may_12,0) as may_12,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_12*c.jun_12,0) as jun_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_12*c.jul_12,0) as jul_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_12*c.aug_12,0) as aug_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_12*c.sep_12,0) as sep_12,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_12*c.oct_12,0) as oct_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_12*c.nov_12,0) as nov_12, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_12*c.dec_12,0) as dec_12,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12*c.jan_12,0)+ISNULL(b.feb_12*c.feb_12,0)+ISNULL(b.mar_12*c.mar_12,0)
								--                                            +ISNULL(b.apr_12*c.apr_12,0)+ISNULL(b.may_12*c.may_12,0)+ISNULL(b.jun_12*c.jun_12,0)
								--                                            +ISNULL(b.jul_12*c.jul_12,0)+ISNULL(b.aug_12*c.aug_12,0)+ISNULL(b.sep_12*c.sep_12,0)
								--                                            +ISNULL(b.oct_12*c.oct_12,0)+ISNULL(b.nov_12*c.nov_12,0)+ISNULL(b.dec_12*c.dec_12,0)) as cal_12,
								
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13*c.jan_13,0) as jan_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13*c.feb_13,0) as feb_13,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13*c.mar_13,0) as mar_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13*c.apr_13,0) as apr_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13*c.may_13,0) as may_13,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13*c.jun_13,0) as jun_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13*c.jul_13,0) as jul_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13*c.aug_13,0) as aug_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13*c.sep_13,0) as sep_13,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13*c.oct_13,0) as oct_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13*c.nov_13,0) as nov_13, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13*c.dec_13,0) as dec_13,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13*c.jan_13,0)+ISNULL(b.feb_13*c.feb_13,0)+ISNULL(b.mar_13*c.mar_13,0)
								--                                            +ISNULL(b.apr_13*c.apr_13,0)+ISNULL(b.may_13*c.may_13,0)+ISNULL(b.jun_13*c.jun_13,0)
								--                                            +ISNULL(b.jul_13*c.jul_13,0)+ISNULL(b.aug_13*c.aug_13,0)+ISNULL(b.sep_13*c.sep_13,0)
								--                                            +ISNULL(b.oct_13*c.oct_13,0)+ISNULL(b.nov_13*c.nov_13,0)+ISNULL(b.dec_13*c.dec_13,0)) as cal_13,
								
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14*c.jan_14,0) as jan_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14*c.feb_14,0) as feb_14,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14*c.mar_14,0) as mar_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14*c.apr_14,0) as apr_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14*c.may_14,0) as may_14,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14*c.jun_14,0) as jun_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14*c.jul_14,0) as jul_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14*c.aug_14,0) as aug_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14*c.sep_14,0) as sep_14,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14*c.oct_14,0) as oct_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14*c.nov_14,0) as nov_14, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14*c.dec_14,0) as dec_14,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14*c.jan_14,0)+ISNULL(b.feb_14*c.feb_14,0)+ISNULL(b.mar_14*c.mar_14,0)
								--                                            +ISNULL(b.apr_14*c.apr_14,0)+ISNULL(b.may_14*c.may_14,0)+ISNULL(b.jun_14*c.jun_14,0)
								--                                            +ISNULL(b.jul_14*c.jul_14,0)+ISNULL(b.aug_14*c.aug_14,0)+ISNULL(b.sep_14*c.sep_14,0)
								--                                            +ISNULL(b.oct_14*c.oct_14,0)+ISNULL(b.nov_14*c.nov_14,0)+ISNULL(b.dec_14*c.dec_14,0)) as cal_14,

								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_15*c.jan_15,0) as jan_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_15*c.feb_15,0) as feb_15,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_15*c.mar_15,0) as mar_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_15*c.apr_15,0) as apr_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_15*c.may_15,0) as may_15,
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_15*c.jun_15,0) as jun_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_15*c.jul_15,0) as jul_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_15*c.aug_15,0) as aug_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_15*c.sep_15,0) as sep_15,  
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_15*c.oct_15,0) as oct_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_15*c.nov_15,0) as nov_15, 
								--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_15*c.dec_15,0) as dec_15,  
								--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_15*c.jan_15,0)+ISNULL(b.feb_15*c.feb_15,0)+ISNULL(b.mar_15*c.mar_15,0)
								--                                            +ISNULL(b.apr_15*c.apr_15,0)+ISNULL(b.may_15*c.may_15,0)+ISNULL(b.jun_15*c.jun_15,0)
								--                                            +ISNULL(b.jul_15*c.jul_15,0)+ISNULL(b.aug_15*c.aug_15,0)+ISNULL(b.sep_15*c.sep_15,0)
								--                                            +ISNULL(b.oct_15*c.oct_15,0)+ISNULL(b.nov_15*c.nov_15,0)+ISNULL(b.dec_15*c.dec_15,0)) as cal_15,

								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_16*c.jan_16,0) as jan_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_16*c.feb_16,0) as feb_16,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_16*c.mar_16,0) as mar_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_16*c.apr_16,0) as apr_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_16*c.may_16,0) as may_16,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_16*c.jun_16,0) as jun_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_16*c.jul_16,0) as jul_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_16*c.aug_16,0) as aug_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_16*c.sep_16,0) as sep_16,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_16*c.oct_16,0) as oct_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_16*c.nov_16,0) as nov_16, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_16*c.dec_16,0) as dec_16,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_16*c.jan_16,0)+isnull(b.feb_16*c.feb_16,0)+isnull(b.mar_16*c.mar_16,0)
								                                            +isnull(b.apr_16*c.apr_16,0)+isnull(b.may_16*c.may_16,0)+isnull(b.jun_16*c.jun_16,0)
																			+isnull(b.jul_16*c.jul_16,0)+isnull(b.aug_16*c.aug_16,0)+isnull(b.sep_16*c.sep_16,0)
																			+isnull(b.oct_16*c.oct_16,0)+isnull(b.nov_16*c.nov_16,0)+isnull(b.dec_16*c.dec_16,0)) as cal_16,
								
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_17*c.jan_17,0) as jan_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_17*c.feb_17,0) as feb_17,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_17*c.mar_17,0) as mar_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_17*c.apr_17,0) as apr_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_17*c.may_17,0) as may_17,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_17*c.jun_17,0) as jun_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_17*c.jul_17,0) as jul_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_17*c.aug_17,0) as aug_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_17*c.sep_17,0) as sep_17,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_17*c.oct_17,0) as oct_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_17*c.nov_17,0) as nov_17, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_17*c.dec_17,0) as dec_17,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_17*c.jan_17,0)+isnull(b.feb_17*c.feb_17,0)+isnull(b.mar_17*c.mar_17,0)
								                                            +isnull(b.apr_17*c.apr_17,0)+isnull(b.may_17*c.may_17,0)+isnull(b.jun_17*c.jun_17,0)
																			+isnull(b.jul_17*c.jul_17,0)+isnull(b.aug_17*c.aug_17,0)+isnull(b.sep_17*c.sep_17,0)
																			+isnull(b.oct_17*c.oct_17,0)+isnull(b.nov_17*c.nov_17,0)+isnull(b.dec_17*c.dec_17,0)) as cal_17,
								
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_18*c.jan_18,0) as jan_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_18*c.feb_18,0) as feb_18,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_18*c.mar_18,0) as mar_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_18*c.apr_18,0) as apr_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_18*c.may_18,0) as may_18,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_18*c.jun_18,0) as jun_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_18*c.jul_18,0) as jul_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_18*c.aug_18,0) as aug_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_18*c.sep_18,0) as sep_18,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_18*c.oct_18,0) as oct_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_18*c.nov_18,0) as nov_18, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_18*c.dec_18,0) as dec_18,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_18*c.jan_18,0)+isnull(b.feb_18*c.feb_18,0)+isnull(b.mar_18*c.mar_18,0)
								                                            +isnull(b.apr_18*c.apr_18,0)+isnull(b.may_18*c.may_18,0)+isnull(b.jun_18*c.jun_18,0)
																			+isnull(b.jul_18*c.jul_18,0)+isnull(b.aug_18*c.aug_18,0)+isnull(b.sep_18*c.sep_18,0)
																			+isnull(b.oct_18*c.oct_18,0)+isnull(b.nov_18*c.nov_18,0)+isnull(b.dec_18*c.dec_18,0)) as cal_18,
																
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_19*c.jan_19,0) as jan_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_19*c.feb_19,0) as feb_19,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_19*c.mar_19,0) as mar_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_19*c.apr_19,0) as apr_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_19*c.may_19,0) as may_19,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_19*c.jun_19,0) as jun_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_19*c.jul_19,0) as jul_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_19*c.aug_19,0) as aug_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_19*c.sep_19,0) as sep_19,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_19*c.oct_19,0) as oct_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_19*c.nov_19,0) as nov_19, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_19*c.dec_19,0) as dec_19,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_19*c.jan_19,0)+isnull(b.feb_19*c.feb_19,0)+isnull(b.mar_19*c.mar_19,0)
								                                            +isnull(b.apr_19*c.apr_19,0)+isnull(b.may_19*c.may_19,0)+isnull(b.jun_19*c.jun_19,0)
																			+isnull(b.jul_19*c.jul_19,0)+isnull(b.aug_19*c.aug_19,0)+isnull(b.sep_19*c.sep_19,0)
																			+isnull(b.oct_19*c.oct_19,0)+isnull(b.nov_19*c.nov_19,0)+isnull(b.dec_19*c.dec_19,0)) as cal_19,

								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_20*c.jan_20,0) as jan_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_20*c.feb_20,0) as feb_20,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_20*c.mar_20,0) as mar_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_20*c.apr_20,0) as apr_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_20*c.may_20,0) as may_20,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_20*c.jun_20,0) as jun_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_20*c.jul_20,0) as jul_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_20*c.aug_20,0) as aug_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_20*c.sep_20,0) as sep_20,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_20*c.oct_20,0) as oct_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_20*c.nov_20,0) as nov_20, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_20*c.dec_20,0) as dec_20,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_20*c.jan_20,0)+isnull(b.feb_20*c.feb_20,0)+isnull(b.mar_20*c.mar_20,0)
								                                            +isnull(b.apr_20*c.apr_20,0)+isnull(b.may_20*c.may_20,0)+isnull(b.jun_20*c.jun_20,0)
																			+isnull(b.jul_20*c.jul_20,0)+isnull(b.aug_20*c.aug_20,0)+isnull(b.sep_20*c.sep_20,0)
																			+isnull(b.oct_20*c.oct_20,0)+isnull(b.nov_20*c.nov_20,0)+isnull(b.dec_20*c.dec_20,0)) as cal_20,
				
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_21*c.jan_21,0) as jan_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_21*c.feb_21,0) as feb_21,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_21*c.mar_21,0) as mar_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_21*c.apr_21,0) as apr_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_21*c.may_21,0) as may_21,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_21*c.jun_21,0) as jun_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_21*c.jul_21,0) as jul_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_21*c.aug_21,0) as aug_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_21*c.sep_21,0) as sep_21,  
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_21*c.oct_21,0) as oct_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_21*c.nov_21,0) as nov_21, 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_21*c.dec_21,0) as dec_21,  
								(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_21*c.jan_21,0)+isnull(b.feb_21*c.feb_21,0)+isnull(b.mar_21*c.mar_21,0)
								                                            +isnull(b.apr_21*c.apr_21,0)+isnull(b.may_21*c.may_21,0)+isnull(b.jun_21*c.jun_21,0)
																			+isnull(b.jul_21*c.jul_21,0)+isnull(b.aug_21*c.aug_21,0)+isnull(b.sep_21*c.sep_21,0)
																			+isnull(b.oct_21*c.oct_21,0)+isnull(b.nov_21*c.nov_21,0)+isnull(b.dec_21*c.dec_21,0)) as cal_21,
				
 
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.CAL_22*c.cal_22,0) as cal_22,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.CAL_23*c.cal_23,0) as cal_23,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.CAL_24*c.cal_24,0) as cal_24,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.CAL_25*c.cal_25,0) as cal_25,
								isnull(a.qty_per*a.take_rate*a.family_allocation*b.CAL_26*c.cal_26,0) as cal_26
						from	
					
								/* LEVEL 5 */
								(select * 
								 from	eeiuser.acctg_csm_base_part_mnemonic
								 where	release_id = --'2018-09'
											(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
								) a 
								left outer join 
									(	select	* 
										from	eeiuser.acctg_csm_NACSM 
										where	version = 'CSM' 
											and release_id = --'2018-09'
												(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )  
								) b
								on a.mnemonic = b.mnemonic 
						 		left outer join
								(select	a.base_part,
										a.mnemonic, 										
										b.badge,
										b.manufacturer, 
										b.platform, 
										b.program, 
										b.badge+' '+b.nameplate as vehicle, 
										b.assembly_plant,
										b.product_type,
										b.global_segment,
										b.regional_segment,
										b.market, 
										b.sop as 'CSM_SOP', 
										b.eop as 'CSM_EOP',
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
										
										--ISNULL(b.jan_10,0) as jan_10, 
										--ISNULL(b.feb_10,0) as feb_10,
										--ISNULL(b.mar_10,0) as mar_10, 
										--ISNULL(b.apr_10,0) as apr_10, 
										--ISNULL(b.may_10,0) as may_10,
										--ISNULL(b.jun_10,0) as jun_10, 
										--ISNULL(b.jul_10,0) as jul_10, 
										--ISNULL(b.aug_10,0) as aug_10, 
										--ISNULL(b.sep_10,0) as sep_10,  
										--ISNULL(b.oct_10,0) as oct_10, 
										--ISNULL(b.nov_10,0) as nov_10, 
										--ISNULL(b.dec_10,0) as dec_10,  
										--(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)
										--+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as cal_10,
										
										--ISNULL(b.jan_11,0) as jan_11, 
										--ISNULL(b.feb_11,0) as feb_11,
										--ISNULL(b.mar_11,0) as mar_11, 
										--ISNULL(b.apr_11,0) as apr_11, 
										--ISNULL(b.may_11,0) as may_11,
										--ISNULL(b.jun_11,0) as jun_11, 
										--ISNULL(b.jul_11,0) as jul_11, 
										--ISNULL(b.aug_11,0) as aug_11, 
										--ISNULL(b.sep_11,0) as sep_11,  
										--ISNULL(b.oct_11,0) as oct_11, 
										--ISNULL(b.nov_11,0) as nov_11, 
										--ISNULL(b.dec_11,0) as dec_11,  
										--(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)
										--+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as cal_11,
										
										--ISNULL(b.jan_12,0) as jan_12, 
										--ISNULL(b.feb_12,0) as feb_12,
										--ISNULL(b.mar_12,0) as mar_12, 
										--ISNULL(b.apr_12,0) as apr_12, 
										--ISNULL(b.may_12,0) as may_12,
										--ISNULL(b.jun_12,0) as jun_12, 
										--ISNULL(b.jul_12,0) as jul_12, 
										--ISNULL(b.aug_12,0) as aug_12, 
										--ISNULL(b.sep_12,0) as sep_12,  
										--ISNULL(b.oct_12,0) as oct_12, 
										--ISNULL(b.nov_12,0) as nov_12, 
										--ISNULL(b.dec_12,0) as dec_12,  
										--(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)
										--+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as cal_12,
										
										--ISNULL(b.jan_13,0) as jan_13, 
										--ISNULL(b.feb_13,0) as feb_13,
										--ISNULL(b.mar_13,0) as mar_13, 
										--ISNULL(b.apr_13,0) as apr_13, 
										--ISNULL(b.may_13,0) as may_13,
										--ISNULL(b.jun_13,0) as jun_13, 
										--ISNULL(b.jul_13,0) as jul_13, 
										--ISNULL(b.aug_13,0) as aug_13, 
										--ISNULL(b.sep_13,0) as sep_13,  
										--ISNULL(b.oct_13,0) as oct_13, 
										--ISNULL(b.nov_13,0) as nov_13, 
										--ISNULL(b.dec_13,0) as dec_13,  
										--(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)
										--+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as cal_13,
					
										--ISNULL(b.jan_14,0) as jan_14, 
										--ISNULL(b.feb_14,0) as feb_14,
										--ISNULL(b.mar_14,0) as mar_14, 
										--ISNULL(b.apr_14,0) as apr_14, 
										--ISNULL(b.may_14,0) as may_14,
										--ISNULL(b.jun_14,0) as jun_14, 
										--ISNULL(b.jul_14,0) as jul_14, 
										--ISNULL(b.aug_14,0) as aug_14, 
										--ISNULL(b.sep_14,0) as sep_14,  
										--ISNULL(b.oct_14,0) as oct_14, 
										--ISNULL(b.nov_14,0) as nov_14, 
										--ISNULL(b.dec_14,0) as dec_14,  
										--(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)
										--+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as cal_14,

										--ISNULL(b.jan_15,0) as jan_15, 
										--ISNULL(b.feb_15,0) as feb_15,
										--ISNULL(b.mar_15,0) as mar_15, 
										--ISNULL(b.apr_15,0) as apr_15, 
										--ISNULL(b.may_15,0) as may_15,
										--ISNULL(b.jun_15,0) as jun_15, 
										--ISNULL(b.jul_15,0) as jul_15, 
										--ISNULL(b.aug_15,0) as aug_15, 
										--ISNULL(b.sep_15,0) as sep_15,  
										--ISNULL(b.oct_15,0) as oct_15, 
										--ISNULL(b.nov_15,0) as nov_15, 
										--ISNULL(b.dec_15,0) as dec_15,  
										--(ISNULL(b.jan_15,0)+ISNULL(b.feb_15,0)+ISNULL(b.mar_15,0)+ISNULL(b.apr_15,0)+ISNULL(b.may_15,0)+ISNULL(b.jun_15,0)
										--+ISNULL(b.jul_15,0)+ISNULL(b.aug_15,0)+ISNULL(b.sep_15,0)+ISNULL(b.oct_15,0)+ISNULL(b.nov_15,0)+ISNULL(b.dec_15,0)) as cal_15,

										isnull(b.jan_16,0) as jan_16, 
										isnull(b.feb_16,0) as feb_16,
										isnull(b.mar_16,0) as mar_16, 
										isnull(b.apr_16,0) as apr_16, 
										isnull(b.may_16,0) as may_16,
										isnull(b.jun_16,0) as jun_16, 
										isnull(b.jul_16,0) as jul_16, 
										isnull(b.aug_16,0) as aug_16, 
										isnull(b.sep_16,0) as sep_16,  
										isnull(b.oct_16,0) as oct_16, 
										isnull(b.nov_16,0) as nov_16, 
										isnull(b.dec_16,0) as dec_16,  
										(isnull(b.jan_16,0)+isnull(b.feb_16,0)+isnull(b.mar_16,0)+isnull(b.apr_16,0)+isnull(b.may_16,0)+isnull(b.jun_16,0)
										+isnull(b.jul_16,0)+isnull(b.aug_16,0)+isnull(b.sep_16,0)+isnull(b.oct_16,0)+isnull(b.nov_16,0)+isnull(b.dec_16,0)) as cal_16,
					
										isnull(b.jan_17,0) as jan_17, 
										isnull(b.feb_17,0) as feb_17,
										isnull(b.mar_17,0) as mar_17, 
										isnull(b.apr_17,0) as apr_17, 
										isnull(b.may_17,0) as may_17,
										isnull(b.jun_17,0) as jun_17, 
										isnull(b.jul_17,0) as jul_17, 
										isnull(b.aug_17,0) as aug_17, 
										isnull(b.sep_17,0) as sep_17,  
										isnull(b.oct_17,0) as oct_17, 
										isnull(b.nov_17,0) as nov_17, 
										isnull(b.dec_17,0) as dec_17,  
										(isnull(b.jan_17,0)+isnull(b.feb_17,0)+isnull(b.mar_17,0)+isnull(b.apr_17,0)+isnull(b.may_17,0)+isnull(b.jun_17,0)
										+isnull(b.jul_17,0)+isnull(b.aug_17,0)+isnull(b.sep_17,0)+isnull(b.oct_17,0)+isnull(b.nov_17,0)+isnull(b.dec_17,0)) as cal_17,
					
										isnull(b.jan_18,0) as jan_18, 
										isnull(b.feb_18,0) as feb_18,
										isnull(b.mar_18,0) as mar_18, 
										isnull(b.apr_18,0) as apr_18, 
										isnull(b.may_18,0) as may_18,
										isnull(b.jun_18,0) as jun_18, 
										isnull(b.jul_18,0) as jul_18, 
										isnull(b.aug_18,0) as aug_18, 
										isnull(b.sep_18,0) as sep_18,  
										isnull(b.oct_18,0) as oct_18, 
										isnull(b.nov_18,0) as nov_18, 
										isnull(b.dec_18,0) as dec_18,  
										(isnull(b.jan_18,0)+isnull(b.feb_18,0)+isnull(b.mar_18,0)+isnull(b.apr_18,0)+isnull(b.may_18,0)+isnull(b.jun_18,0)
										+isnull(b.jul_18,0)+isnull(b.aug_18,0)+isnull(b.sep_18,0)+isnull(b.oct_18,0)+isnull(b.nov_18,0)+isnull(b.dec_18,0)) as cal_18,
					
										isnull(b.jan_19,0) as jan_19, 
										isnull(b.feb_19,0) as feb_19,
										isnull(b.mar_19,0) as mar_19, 
										isnull(b.apr_19,0) as apr_19, 
										isnull(b.may_19,0) as may_19,
										isnull(b.jun_19,0) as jun_19, 
										isnull(b.jul_19,0) as jul_19, 
										isnull(b.aug_19,0) as aug_19, 
										isnull(b.sep_19,0) as sep_19,  
										isnull(b.oct_19,0) as oct_19, 
										isnull(b.nov_19,0) as nov_19, 
										isnull(b.dec_19,0) as dec_19,  
										(isnull(b.jan_19,0)+isnull(b.feb_19,0)+isnull(b.mar_19,0)+isnull(b.apr_19,0)+isnull(b.may_19,0)+isnull(b.jun_19,0)
										+isnull(b.jul_19,0)+isnull(b.aug_19,0)+isnull(b.sep_19,0)+isnull(b.oct_19,0)+isnull(b.nov_19,0)+isnull(b.dec_19,0)) as cal_19,
					
										isnull(b.jan_20,0) as jan_20, 
										isnull(b.feb_20,0) as feb_20,
										isnull(b.mar_20,0) as mar_20, 
										isnull(b.apr_20,0) as apr_20, 
										isnull(b.may_20,0) as may_20,
										isnull(b.jun_20,0) as jun_20, 
										isnull(b.jul_20,0) as jul_20, 
										isnull(b.aug_20,0) as aug_20, 
										isnull(b.sep_20,0) as sep_20,  
										isnull(b.oct_20,0) as oct_20, 
										isnull(b.nov_20,0) as nov_20, 
										isnull(b.dec_20,0) as dec_20,  
										(isnull(b.jan_20,0)+isnull(b.feb_20,0)+isnull(b.mar_20,0)+isnull(b.apr_20,0)+isnull(b.may_20,0)+isnull(b.jun_20,0)
										+isnull(b.jul_20,0)+isnull(b.aug_20,0)+isnull(b.sep_20,0)+isnull(b.oct_20,0)+isnull(b.nov_20,0)+isnull(b.dec_20,0)) as cal_20,
										
										isnull(b.jan_21,0) as jan_21, 
										isnull(b.feb_21,0) as feb_21,
										isnull(b.mar_21,0) as mar_21, 
										isnull(b.apr_21,0) as apr_21, 
										isnull(b.may_21,0) as may_21,
										isnull(b.jun_21,0) as jun_21, 
										isnull(b.jul_21,0) as jul_21, 
										isnull(b.aug_21,0) as aug_21, 
										isnull(b.sep_21,0) as sep_21,  
										isnull(b.oct_21,0) as oct_21, 
										isnull(b.nov_21,0) as nov_21, 
										isnull(b.dec_21,0) as dec_21,  
										(isnull(b.jan_21,0)+isnull(b.feb_21,0)+isnull(b.mar_21,0)+isnull(b.apr_21,0)+isnull(b.may_21,0)+isnull(b.jun_21,0)
										+isnull(b.jul_21,0)+isnull(b.aug_21,0)+isnull(b.sep_21,0)+isnull(b.oct_21,0)+isnull(b.nov_21,0)+isnull(b.dec_21,0)) as cal_21,

										isnull(b.CAL_22,0) as cal_22,
										isnull(b.CAL_23,0) as cal_23, 
										isnull(b.CAL_24,0) as cal_24,
										isnull(b.CAL_25,0) as cal_25,
										isnull(b.CAL_26,0) as cal_26
								from 
								
										/* LEVEL 6 */
										(select * 
										 from	eeiuser.acctg_csm_base_part_mnemonic
										 where	release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										) a
										left outer join
										(	select * 
											from	eeiuser.acctg_csm_NACSM 
											where	version = 'Empire Factor' 
												and release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )  
										) b
										on a.mnemonic = b.mnemonic
										where b.mnemonic is not null 
								) c
								on a.base_part = c.base_part
								
							 	where b.mnemonic is not null 
									and (isnull(b.cal_16,0)+isnull(b.cal_17,0)+isnull(b.cal_18,0)+isnull(b.cal_19,0)+isnull(b.cal_20,0)+isnull(b.cal_21,0)+isnull(b.cal_22,0)+isnull(b.cal_23,0)+isnull(b.cal_24,0)+isnull(b.cal_25,0)+isnull(b.cal_26,0)) <>  0 
												
						)a

						full outer join

						(select a.base_part,
						--		sum(a.jan_10*b.jan_10) as jan_10, 
						--		sum(a.feb_10*b.feb_10) as feb_10, 
						--		sum(a.mar_10*b.mar_10) as mar_10, 
						--		sum(a.apr_10*b.apr_10) as apr_10, 
						--		sum(a.may_10*b.may_10) as may_10, 
						--		sum(a.jun_10*b.jun_10) as jun_10, 
						--		sum(a.jul_10*b.jul_10) as jul_10, 
						--		sum(a.aug_10*b.aug_10) as aug_10,
						--		sum(a.sep_10*b.sep_10) as sep_10, 
						--		sum(a.oct_10*b.oct_10) as oct_10, 
						--		sum(a.nov_10*b.nov_10) as nov_10, 
						--		sum(a.dec_10*b.dec_10) as dec_10,
						--		(sum(a.jan_10*b.jan_10)+sum(a.feb_10*b.feb_10)+sum(a.mar_10*b.mar_10)+sum(a.apr_10*b.apr_10)+sum(a.may_10*b.may_10)+sum(a.jun_10*b.jun_10)
						--      +sum(a.jul_10*b.jul_10)+sum(a.aug_10*b.aug_10)+sum(a.sep_10*b.sep_10)+sum(a.oct_10*b.oct_10)+sum(a.nov_10*b.nov_10)+sum(a.dec_10*b.dec_10)) as cal_10,
								
								--sum(a.jan_11*b.jan_11) as jan_11, 
								--sum(a.feb_11*b.feb_11) as feb_11, 
								--sum(a.mar_11*b.mar_11) as mar_11, 
								--sum(a.apr_11*b.apr_11) as apr_11, 
								--sum(a.may_11*b.may_11) as may_11, 
								--sum(a.jun_11*b.jun_11) as jun_11, 
								--sum(a.jul_11*b.jul_11) as jul_11, 
								--sum(a.aug_11*b.aug_11) as aug_11,
								--sum(a.sep_11*b.sep_11) as sep_11, 
								--sum(a.oct_11*b.oct_11) as oct_11, 
								--sum(a.nov_11*b.nov_11) as nov_11, 
								--sum(a.dec_11*b.dec_11) as dec_11,
								--(sum(a.jan_11*b.jan_11)+sum(a.feb_11*b.feb_11)+sum(a.mar_11*b.mar_11)+sum(a.apr_11*b.apr_11)+sum(a.may_11*b.may_11)+sum(a.jun_11*b.jun_11)
								--+sum(a.jul_11*b.jul_11)+sum(a.aug_11*b.aug_11)+sum(a.sep_11*b.sep_11)+sum(a.oct_11*b.oct_11)+sum(a.nov_11*b.nov_11)+sum(a.dec_11*b.dec_11)) as cal_11,
								
								--sum(a.jan_12*b.jan_12) as jan_12, 
								--sum(a.feb_12*b.feb_12) as feb_12, 
								--sum(a.mar_12*b.mar_12) as mar_12, 
								--sum(a.apr_12*b.apr_12) as apr_12, 
								--sum(a.may_12*b.may_12) as may_12, 
								--sum(a.jun_12*b.jun_12) as jun_12, 
								--sum(a.jul_12*b.jul_12) as jul_12, 
								--sum(a.aug_12*b.aug_12) as aug_12,
								--sum(a.sep_12*b.sep_12) as sep_12, 
								--sum(a.oct_12*b.oct_12) as oct_12, 
								--sum(a.nov_12*b.nov_12) as nov_12, 
								--sum(a.dec_12*b.dec_12) as dec_12,
								--(sum(a.jan_12*b.jan_12)+sum(a.feb_12*b.feb_12)+sum(a.mar_12*b.mar_12)+sum(a.apr_12*b.apr_12)+sum(a.may_12*b.may_12)+sum(a.jun_12*b.jun_12)
								--+sum(a.jul_12*b.jul_12)+sum(a.aug_12*b.aug_12)+sum(a.sep_12*b.sep_12)+sum(a.oct_12*b.oct_12)+sum(a.nov_12*b.nov_12)+sum(a.dec_12*b.dec_12)) as cal_12,
								
								--sum(a.jan_13*b.jan_13) as jan_13, 
								--sum(a.feb_13*b.feb_13) as feb_13, 
								--sum(a.mar_13*b.mar_13) as mar_13, 
								--sum(a.apr_13*b.apr_13) as apr_13, 
								--sum(a.may_13*b.may_13) as may_13, 
								--sum(a.jun_13*b.jun_13) as jun_13, 
								--sum(a.jul_13*b.jul_13) as jul_13, 
								--sum(a.aug_13*b.aug_13) as aug_13,
								--sum(a.sep_13*b.sep_13) as sep_13, 
								--sum(a.oct_13*b.oct_13) as oct_13, 
								--sum(a.nov_13*b.nov_13) as nov_13, 
								--sum(a.dec_13*b.dec_13) as dec_13,
								--(sum(a.jan_13*b.jan_13)+sum(a.feb_13*b.feb_13)+sum(a.mar_13*b.mar_13)+sum(a.apr_13*b.apr_13)+sum(a.may_13*b.may_13)+sum(a.jun_13*b.jun_13)
								--+sum(a.jul_13*b.jul_13)+sum(a.aug_13*b.aug_13)+sum(a.sep_13*b.sep_13)+sum(a.oct_13*b.oct_13)+sum(a.nov_13*b.nov_13)+sum(a.dec_13*b.dec_13)) as cal_13,
								
								--sum(a.jan_14*b.jan_14) as jan_14, 
								--sum(a.feb_14*b.feb_14) as feb_14, 
								--sum(a.mar_14*b.mar_14) as mar_14, 
								--sum(a.apr_14*b.apr_14) as apr_14, 
								--sum(a.may_14*b.may_14) as may_14, 
								--sum(a.jun_14*b.jun_14) as jun_14, 
								--sum(a.jul_14*b.jul_14) as jul_14, 
								--sum(a.aug_14*b.aug_14) as aug_14,
								--sum(a.sep_14*b.sep_14) as sep_14, 
								--sum(a.oct_14*b.oct_14) as oct_14, 
								--sum(a.nov_14*b.nov_14) as nov_14, 
								--sum(a.dec_14*b.dec_14) as dec_14,
								--(sum(a.jan_14*b.jan_14)+sum(a.feb_14*b.feb_14)+sum(a.mar_14*b.mar_14)+sum(a.apr_14*b.apr_14)+sum(a.may_14*b.may_14)+sum(a.jun_14*b.jun_14)
								--+sum(a.jul_14*b.jul_14)+sum(a.aug_14*b.aug_14)+sum(a.sep_14*b.sep_14)+sum(a.oct_14*b.oct_14)+sum(a.nov_14*b.nov_14)+sum(a.dec_14*b.dec_14)) as cal_14,
								
								
								--sum(a.jan_15*b.jan_15) as jan_15, 
								--sum(a.feb_15*b.feb_15) as feb_15, 
								--sum(a.mar_15*b.mar_15) as mar_15, 
								--sum(a.apr_15*b.apr_15) as apr_15, 
								--sum(a.may_15*b.may_15) as may_15, 
								--sum(a.jun_15*b.jun_15) as jun_15, 
								--sum(a.jul_15*b.jul_15) as jul_15, 
								--sum(a.aug_15*b.aug_15) as aug_15,
								--sum(a.sep_15*b.sep_15) as sep_15, 
								--sum(a.oct_15*b.oct_15) as oct_15, 
								--sum(a.nov_15*b.nov_15) as nov_15, 
								--sum(a.dec_15*b.dec_15) as dec_15,
								--(sum(a.jan_15*b.jan_15)+sum(a.feb_15*b.feb_15)+sum(a.mar_15*b.mar_15)+sum(a.apr_15*b.apr_15)+sum(a.may_15*b.may_15)+sum(a.jun_15*b.jun_15)
								--+sum(a.jul_15*b.jul_15)+sum(a.aug_15*b.aug_15)+sum(a.sep_15*b.sep_15)+sum(a.oct_15*b.oct_15)+sum(a.nov_15*b.nov_15)+sum(a.dec_15*b.dec_15)) as cal_15,
														
								sum(a.jan_16*b.jan_16) as jan_16, 
								sum(a.feb_16*b.feb_16) as feb_16, 
								sum(a.mar_16*b.mar_16) as mar_16, 
								sum(a.apr_16*b.apr_16) as apr_16, 
								sum(a.may_16*b.may_16) as may_16, 
								sum(a.jun_16*b.jun_16) as jun_16, 
								sum(a.jul_16*b.jul_16) as jul_16, 
								sum(a.aug_16*b.aug_16) as aug_16,
								sum(a.sep_16*b.sep_16) as sep_16, 
								sum(a.oct_16*b.oct_16) as oct_16, 
								sum(a.nov_16*b.nov_16) as nov_16, 
								sum(a.dec_16*b.dec_16) as dec_16,
								(sum(a.jan_16*b.jan_16)+sum(a.feb_16*b.feb_16)+sum(a.mar_16*b.mar_16)+sum(a.apr_16*b.apr_16)+sum(a.may_16*b.may_16)+sum(a.jun_16*b.jun_16)
								+sum(a.jul_16*b.jul_16)+sum(a.aug_16*b.aug_16)+sum(a.sep_16*b.sep_16)+sum(a.oct_16*b.oct_16)+sum(a.nov_16*b.nov_16)+sum(a.dec_16*b.dec_16)) as cal_16,
							
								sum(a.jan_17*b.jan_17) as jan_17, 
								sum(a.feb_17*b.feb_17) as feb_17, 
								sum(a.mar_17*b.mar_17) as mar_17, 
								sum(a.apr_17*b.apr_17) as apr_17, 
								sum(a.may_17*b.may_17) as may_17, 
								sum(a.jun_17*b.jun_17) as jun_17, 
								sum(a.jul_17*b.jul_17) as jul_17, 
								sum(a.aug_17*b.aug_17) as aug_17,
								sum(a.sep_17*b.sep_17) as sep_17, 
								sum(a.oct_17*b.oct_17) as oct_17, 
								sum(a.nov_17*b.nov_17) as nov_17, 
								sum(a.dec_17*b.dec_17) as dec_17,
								(sum(a.jan_17*b.jan_17)+sum(a.feb_17*b.feb_17)+sum(a.mar_17*b.mar_17)+sum(a.apr_17*b.apr_17)+sum(a.may_17*b.may_17)+sum(a.jun_17*b.jun_17)
								+sum(a.jul_17*b.jul_17)+sum(a.aug_17*b.aug_17)+sum(a.sep_17*b.sep_17)+sum(a.oct_17*b.oct_17)+sum(a.nov_17*b.nov_17)+sum(a.dec_17*b.dec_17)) as cal_17,
							
								sum(a.jan_18*b.jan_18) as jan_18, 
								sum(a.feb_18*b.feb_18) as feb_18, 
								sum(a.mar_18*b.mar_18) as mar_18, 
								sum(a.apr_18*b.apr_18) as apr_18, 
								sum(a.may_18*b.may_18) as may_18, 
								sum(a.jun_18*b.jun_18) as jun_18, 
								sum(a.jul_18*b.jul_18) as jul_18, 
								sum(a.aug_18*b.aug_18) as aug_18,
								sum(a.sep_18*b.sep_18) as sep_18, 
								sum(a.oct_18*b.oct_18) as oct_18, 
								sum(a.nov_18*b.nov_18) as nov_18, 
								sum(a.dec_18*b.dec_18) as dec_18,
								(sum(a.jan_18*b.jan_18)+sum(a.feb_18*b.feb_18)+sum(a.mar_18*b.mar_18)+sum(a.apr_18*b.apr_18)+sum(a.may_18*b.may_18)+sum(a.jun_18*b.jun_18)
								+sum(a.jul_18*b.jul_18)+sum(a.aug_18*b.aug_18)+sum(a.sep_18*b.sep_18)+sum(a.oct_18*b.oct_18)+sum(a.nov_18*b.nov_18)+sum(a.dec_18*b.dec_18)) as cal_18,
								
								sum(a.jan_19*b.jan_19) as jan_19, 
								sum(a.feb_19*b.feb_19) as feb_19, 
								sum(a.mar_19*b.mar_19) as mar_19, 
								sum(a.apr_19*b.apr_19) as apr_19, 
								sum(a.may_19*b.may_19) as may_19, 
								sum(a.jun_19*b.jun_19) as jun_19, 
								sum(a.jul_19*b.jul_19) as jul_19, 
								sum(a.aug_19*b.aug_19) as aug_19,
								sum(a.sep_19*b.sep_19) as sep_19, 
								sum(a.oct_19*b.oct_19) as oct_19, 
								sum(a.nov_19*b.nov_19) as nov_19, 
								sum(a.dec_19*b.dec_19) as dec_19,
								(sum(a.jan_19*b.jan_19)+sum(a.feb_19*b.feb_19)+sum(a.mar_19*b.mar_19)+sum(a.apr_19*b.apr_19)+sum(a.may_19*b.may_19)+sum(a.jun_19*b.jun_19)
								+sum(a.jul_19*b.jul_19)+sum(a.aug_19*b.aug_19)+sum(a.sep_19*b.sep_19)+sum(a.oct_19*b.oct_19)+sum(a.nov_19*b.nov_19)+sum(a.dec_19*b.dec_19)) as cal_19,
								
								sum(a.jan_20*b.jan_20) as jan_20, 
								sum(a.feb_20*b.feb_20) as feb_20, 
								sum(a.mar_20*b.mar_20) as mar_20, 
								sum(a.apr_20*b.apr_20) as apr_20, 
								sum(a.may_20*b.may_20) as may_20, 
								sum(a.jun_20*b.jun_20) as jun_20, 
								sum(a.jul_20*b.jul_20) as jul_20, 
								sum(a.aug_20*b.aug_20) as aug_20,
								sum(a.sep_20*b.sep_20) as sep_20, 
								sum(a.oct_20*b.oct_20) as oct_20, 
								sum(a.nov_20*b.nov_20) as nov_20, 
								sum(a.dec_20*b.dec_20) as dec_20,
								(sum(a.jan_20*b.jan_20)+sum(a.feb_20*b.feb_20)+sum(a.mar_20*b.mar_20)+sum(a.apr_20*b.apr_20)+sum(a.may_20*b.may_20)+sum(a.jun_20*b.jun_20)
								+sum(a.jul_20*b.jul_20)+sum(a.aug_20*b.aug_20)+sum(a.sep_20*b.sep_20)+sum(a.oct_20*b.oct_20)+sum(a.nov_20*b.nov_20)+sum(a.dec_20*b.dec_20)) as cal_20,
								
								sum(a.jan_21*b.jan_21) as jan_21, 
								sum(a.feb_21*b.feb_21) as feb_21, 
								sum(a.mar_21*b.mar_21) as mar_21, 
								sum(a.apr_21*b.apr_21) as apr_21, 
								sum(a.may_21*b.may_21) as may_21, 
								sum(a.jun_21*b.jun_21) as jun_21, 
								sum(a.jul_21*b.jul_21) as jul_21, 
								sum(a.aug_21*b.aug_21) as aug_21,
								sum(a.sep_21*b.sep_21) as sep_21, 
								sum(a.oct_21*b.oct_21) as oct_21, 
								sum(a.nov_21*b.nov_21) as nov_21, 
								sum(a.dec_21*b.dec_21) as dec_21,
								(sum(a.jan_21*b.jan_21)+sum(a.feb_21*b.feb_21)+sum(a.mar_21*b.mar_21)+sum(a.apr_21*b.apr_21)+sum(a.may_21*b.may_21)+sum(a.jun_21*b.jun_21)
								+sum(a.jul_21*b.jul_21)+sum(a.aug_21*b.aug_21)+sum(a.sep_21*b.sep_21)+sum(a.oct_21*b.oct_21)+sum(a.nov_21*b.nov_21)+sum(a.dec_21*b.dec_21)) as cal_21,

								sum(a.cal_22*b.cal_22) as cal_22,
								sum(a.cal_23*b.cal_23) as cal_23,
								sum(a.cal_24*b.cal_24) as cal_24,
								sum(a.cal_25*b.cal_25) as cal_25,
								sum(a.cal_26*b.cal_26) as cal_26
						
						from 
												
								(select	a.base_part,
										a.mnemonic,										
										b.badge,
										b.manufacturer, 
										b.platform, 
										b.program, 
										b.badge+' '+b.nameplate as vehicle, 
										b.assembly_plant,
										b.product_type,
										b.global_segment,
										b.regional_segment,
										b.market, 
										b.sop as 'CSM_SOP', 
										b.eop as 'CSM_EOP', 
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
										
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_10,0) as jan_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_10,0) as feb_10,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_10,0) as mar_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_10,0) as apr_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_10,0) as may_10,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_10,0) as jun_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_10,0) as jul_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_10,0) as aug_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_10,0) as sep_10,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_10,0) as oct_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_10,0) as nov_10, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_10,0) as dec_10,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)
										--                                            +ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as cal_10,
										
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_11,0) as jan_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_11,0) as feb_11,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_11,0) as mar_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_11,0) as apr_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_11,0) as may_11,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_11,0) as jun_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_11,0) as jul_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_11,0) as aug_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_11,0) as sep_11,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_11,0) as oct_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_11,0) as nov_11, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_11,0) as dec_11,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)
										--                                            +ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as cal_11,
										
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_12,0) as jan_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_12,0) as feb_12,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_12,0) as mar_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_12,0) as apr_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_12,0) as may_12,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_12,0) as jun_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_12,0) as jul_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_12,0) as aug_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_12,0) as sep_12,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_12,0) as oct_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_12,0) as nov_12, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_12,0) as dec_12,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)
										--                                            +ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as cal_12,
										
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13,0) as jan_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13,0) as feb_13,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13,0) as mar_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13,0) as apr_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13,0) as may_13,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13,0) as jun_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13,0) as jul_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13,0) as aug_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13,0) as sep_13,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13,0) as oct_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13,0) as nov_13, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13,0) as dec_13,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)
										--                                            +ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as cal_13,
										
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14,0) as jan_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14,0) as feb_14,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14,0) as mar_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14,0) as apr_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14,0) as may_14,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14,0) as jun_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14,0) as jul_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14,0) as aug_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14,0) as sep_14,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14,0) as oct_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14,0) as nov_14, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14,0) as dec_14,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)
										--                                            +ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as cal_14,							
										
																		
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_15,0) as jan_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_15,0) as feb_15,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_15,0) as mar_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_15,0) as apr_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_15,0) as may_15,
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_15,0) as jun_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_15,0) as jul_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_15,0) as aug_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_15,0) as sep_15,  
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_15,0) as oct_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_15,0) as nov_15, 
										--ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_15,0) as dec_15,  
										--(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_15,0)+ISNULL(b.feb_15,0)+ISNULL(b.mar_15,0)+ISNULL(b.apr_15,0)+ISNULL(b.may_15,0)+ISNULL(b.jun_15,0)
										--                                            +ISNULL(b.jul_15,0)+ISNULL(b.aug_15,0)+ISNULL(b.sep_15,0)+ISNULL(b.oct_15,0)+ISNULL(b.nov_15,0)+ISNULL(b.dec_15,0)) as cal_15,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_16,0) as jan_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_16,0) as feb_16,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_16,0) as mar_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_16,0) as apr_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_16,0) as may_16,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_16,0) as jun_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_16,0) as jul_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_16,0) as aug_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_16,0) as sep_16,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_16,0) as oct_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_16,0) as nov_16, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_16,0) as dec_16,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_16,0)+isnull(b.feb_16,0)+isnull(b.mar_16,0)+isnull(b.apr_16,0)+isnull(b.may_16,0)+isnull(b.jun_16,0)
										                                            +isnull(b.jul_16,0)+isnull(b.aug_16,0)+isnull(b.sep_16,0)+isnull(b.oct_16,0)+isnull(b.nov_16,0)+isnull(b.dec_16,0)) as cal_16,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_17,0) as jan_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_17,0) as feb_17,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_17,0) as mar_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_17,0) as apr_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_17,0) as may_17,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_17,0) as jun_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_17,0) as jul_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_17,0) as aug_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_17,0) as sep_17,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_17,0) as oct_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_17,0) as nov_17, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_17,0) as dec_17,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_17,0)+isnull(b.feb_17,0)+isnull(b.mar_17,0)+isnull(b.apr_17,0)+isnull(b.may_17,0)+isnull(b.jun_17,0)
										                                            +isnull(b.jul_17,0)+isnull(b.aug_17,0)+isnull(b.sep_17,0)+isnull(b.oct_17,0)+isnull(b.nov_17,0)+isnull(b.dec_17,0)) as cal_17,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_18,0) as jan_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_18,0) as feb_18,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_18,0) as mar_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_18,0) as apr_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_18,0) as may_18,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_18,0) as jun_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_18,0) as jul_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_18,0) as aug_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_18,0) as sep_18,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_18,0) as oct_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_18,0) as nov_18, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_18,0) as dec_18,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_18,0)+isnull(b.feb_18,0)+isnull(b.mar_18,0)+isnull(b.apr_18,0)+isnull(b.may_18,0)+isnull(b.jun_18,0)
										                                            +isnull(b.jul_18,0)+isnull(b.aug_18,0)+isnull(b.sep_18,0)+isnull(b.oct_18,0)+isnull(b.nov_18,0)+isnull(b.dec_18,0)) as cal_18,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_19,0) as jan_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_19,0) as feb_19,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_19,0) as mar_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_19,0) as apr_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_19,0) as may_19,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_19,0) as jun_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_19,0) as jul_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_19,0) as aug_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_19,0) as sep_19,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_19,0) as oct_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_19,0) as nov_19, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_19,0) as dec_19,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_19,0)+isnull(b.feb_19,0)+isnull(b.mar_19,0)+isnull(b.apr_19,0)+isnull(b.may_19,0)+isnull(b.jun_19,0)
										                                            +isnull(b.jul_19,0)+isnull(b.aug_19,0)+isnull(b.sep_19,0)+isnull(b.oct_19,0)+isnull(b.nov_19,0)+isnull(b.dec_19,0)) as cal_19,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_20,0) as jan_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_20,0) as feb_20,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_20,0) as mar_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_20,0) as apr_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_20,0) as may_20,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_20,0) as jun_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_20,0) as jul_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_20,0) as aug_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_20,0) as sep_20,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_20,0) as oct_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_20,0) as nov_20, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_20,0) as dec_20,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_20,0)+isnull(b.feb_20,0)+isnull(b.mar_20,0)+isnull(b.apr_20,0)+isnull(b.may_20,0)+isnull(b.jun_20,0)
										                                            +isnull(b.jul_20,0)+isnull(b.aug_20,0)+isnull(b.sep_20,0)+isnull(b.oct_20,0)+isnull(b.nov_20,0)+isnull(b.dec_20,0)) as cal_20,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jan_21,0) as jan_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.feb_21,0) as feb_21,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.mar_21,0) as mar_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.apr_21,0) as apr_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.may_21,0) as may_21,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jun_21,0) as jun_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.jul_21,0) as jul_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.aug_21,0) as aug_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.sep_21,0) as sep_21,  
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.oct_21,0) as oct_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.nov_21,0) as nov_21, 
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.dec_21,0) as dec_21,  
										(a.qty_per*a.take_rate*a.family_allocation)*(isnull(b.jan_21,0)+isnull(b.feb_21,0)+isnull(b.mar_21,0)+isnull(b.apr_21,0)+isnull(b.may_21,0)+isnull(b.jun_21,0)
										                                            +isnull(b.jul_21,0)+isnull(b.aug_21,0)+isnull(b.sep_21,0)+isnull(b.oct_21,0)+isnull(b.nov_21,0)+isnull(b.dec_21,0)) as cal_21,	

										isnull(a.qty_per*a.take_rate*a.family_allocation*b.cal_22,0) as cal_22,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.cal_23,0) as cal_23,  								
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.cal_24,0) as cal_24,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.cal_25,0) as cal_25,
										isnull(a.qty_per*a.take_rate*a.family_allocation*b.cal_26,0) as cal_26

										from	
							
										(select * 
										 from	eeiuser.acctg_csm_base_part_mnemonic
										 where	release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										) a 
								
										left outer join 
								
										(	select * 
											from	eeiuser.acctg_csm_NACSM 
											where	version = 'CSM' 
												and release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )  
										) b
										on a.mnemonic = b.mnemonic 
										and a.release_id = b.release_id
								 
								 		where b.mnemonic is not null 
										and (isnull(b.cal_16,0)+isnull(b.cal_17,0)+isnull(b.CAL_18,0)+isnull(b.CAL_19,0)+isnull(b.cal_20,0)+isnull(b.CAL_21,0)+isnull(b.CAL_22,0)+isnull(b.CAL_23,0)+isnull(b.CAL_24,0)+isnull(b.CAL_25,0)) <>  0 
								) a
						
								left join
								-- EMPIRE FACTOR ROWS FOR EACH MONTH --
								(select	a.base_part,
										a.mnemonic, 										
										b.badge,
										b.manufacturer, 
										b.platform, 
										b.program, 
										b.badge+' '+b.nameplate as vehicle, 
										b.assembly_plant,
										b.product_type,
										b.global_segment,
										b.regional_segment,
										b.market, 
										b.sop as 'CSM_SOP', 
										b.eop as 'CSM_EOP',
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
		
										--ISNULL(b.jan_10,0) as jan_10, 
										--ISNULL(b.feb_10,0) as feb_10,
										--ISNULL(b.mar_10,0) as mar_10, 
										--ISNULL(b.apr_10,0) as apr_10, 
										--ISNULL(b.may_10,0) as may_10,
										--ISNULL(b.jun_10,0) as jun_10, 
										--ISNULL(b.jul_10,0) as jul_10, 
										--ISNULL(b.aug_10,0) as aug_10, 
										--ISNULL(b.sep_10,0) as sep_10,  
										--ISNULL(b.oct_10,0) as oct_10, 
										--ISNULL(b.nov_10,0) as nov_10, 
										--ISNULL(b.dec_10,0) as dec_10,  
										--(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)
										--+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as cal_10,
		
										--ISNULL(b.jan_11,0) as jan_11, 
										--ISNULL(b.feb_11,0) as feb_11,
										--ISNULL(b.mar_11,0) as mar_11, 
										--ISNULL(b.apr_11,0) as apr_11, 
										--ISNULL(b.may_11,0) as may_11,
										--ISNULL(b.jun_11,0) as jun_11, 
										--ISNULL(b.jul_11,0) as jul_11, 
										--ISNULL(b.aug_11,0) as aug_11, 
										--ISNULL(b.sep_11,0) as sep_11,  
										--ISNULL(b.oct_11,0) as oct_11, 
										--ISNULL(b.nov_11,0) as nov_11, 
										--ISNULL(b.dec_11,0) as dec_11,  
										--(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)
										--+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as cal_11,
		
										--ISNULL(b.jan_12,0) as jan_12, 
										--ISNULL(b.feb_12,0) as feb_12,
										--ISNULL(b.mar_12,0) as mar_12, 
										--ISNULL(b.apr_12,0) as apr_12, 
										--ISNULL(b.may_12,0) as may_12,
										--ISNULL(b.jun_12,0) as jun_12, 
										--ISNULL(b.jul_12,0) as jul_12, 
										--ISNULL(b.aug_12,0) as aug_12, 
										--ISNULL(b.sep_12,0) as sep_12,  
										--ISNULL(b.oct_12,0) as oct_12, 
										--ISNULL(b.nov_12,0) as nov_12, 
										--ISNULL(b.dec_12,0) as dec_12,  
										--(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)
										--+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as cal_12,
		
										--ISNULL(b.jan_13,0) as jan_13, 
										--ISNULL(b.feb_13,0) as feb_13,
										--ISNULL(b.mar_13,0) as mar_13, 
										--ISNULL(b.apr_13,0) as apr_13, 
										--ISNULL(b.may_13,0) as may_13,
										--ISNULL(b.jun_13,0) as jun_13, 
										--ISNULL(b.jul_13,0) as jul_13, 
										--ISNULL(b.aug_13,0) as aug_13, 
										--ISNULL(b.sep_13,0) as sep_13,  
										--ISNULL(b.oct_13,0) as oct_13, 
										--ISNULL(b.nov_13,0) as nov_13, 
										--ISNULL(b.dec_13,0) as dec_13,  
										--(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)
										--+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as cal_13,
												
										--ISNULL(b.jan_14,0) as jan_14, 
										--ISNULL(b.feb_14,0) as feb_14,
										--ISNULL(b.mar_14,0) as mar_14, 
										--ISNULL(b.apr_14,0) as apr_14, 
										--ISNULL(b.may_14,0) as may_14,
										--ISNULL(b.jun_14,0) as jun_14, 
										--ISNULL(b.jul_14,0) as jul_14, 
										--ISNULL(b.aug_14,0) as aug_14, 
										--ISNULL(b.sep_14,0) as sep_14,  
										--ISNULL(b.oct_14,0) as oct_14, 
										--ISNULL(b.nov_14,0) as nov_14, 
										--ISNULL(b.dec_14,0) as dec_14,  
										--(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)
										--+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as cal_14,

										--ISNULL(b.jan_15,0) as jan_15, 
										--ISNULL(b.feb_15,0) as feb_15,
										--ISNULL(b.mar_15,0) as mar_15, 
										--ISNULL(b.apr_15,0) as apr_15, 
										--ISNULL(b.may_15,0) as may_15,
										--ISNULL(b.jun_15,0) as jun_15, 
										--ISNULL(b.jul_15,0) as jul_15, 
										--ISNULL(b.aug_15,0) as aug_15, 
										--ISNULL(b.sep_15,0) as sep_15,  
										--ISNULL(b.oct_15,0) as oct_15, 
										--ISNULL(b.nov_15,0) as nov_15, 
										--ISNULL(b.dec_15,0) as dec_15,  
										--(ISNULL(b.jan_15,0)+ISNULL(b.feb_15,0)+ISNULL(b.mar_15,0)+ISNULL(b.apr_15,0)+ISNULL(b.may_15,0)+ISNULL(b.jun_15,0)
										--+ISNULL(b.jul_15,0)+ISNULL(b.aug_15,0)+ISNULL(b.sep_15,0)+ISNULL(b.oct_15,0)+ISNULL(b.nov_15,0)+ISNULL(b.dec_15,0)) as cal_15,
										
										isnull(b.jan_16,0) as jan_16, 
										isnull(b.feb_16,0) as feb_16,
										isnull(b.mar_16,0) as mar_16, 
										isnull(b.apr_16,0) as apr_16, 
										isnull(b.may_16,0) as may_16,
										isnull(b.jun_16,0) as jun_16, 
										isnull(b.jul_16,0) as jul_16, 
										isnull(b.aug_16,0) as aug_16, 
										isnull(b.sep_16,0) as sep_16,  
										isnull(b.oct_16,0) as oct_16, 
										isnull(b.nov_16,0) as nov_16, 
										isnull(b.dec_16,0) as dec_16,  
										(isnull(b.jan_16,0)+isnull(b.feb_16,0)+isnull(b.mar_16,0)+isnull(b.apr_16,0)+isnull(b.may_16,0)+isnull(b.jun_16,0)
										+isnull(b.jul_16,0)+isnull(b.aug_16,0)+isnull(b.sep_16,0)+isnull(b.oct_16,0)+isnull(b.nov_16,0)+isnull(b.dec_16,0)) as cal_16,
						
										isnull(b.jan_17,0) as jan_17, 
										isnull(b.feb_17,0) as feb_17,
										isnull(b.mar_17,0) as mar_17, 
										isnull(b.apr_17,0) as apr_17, 
										isnull(b.may_17,0) as may_17,
										isnull(b.jun_17,0) as jun_17, 
										isnull(b.jul_17,0) as jul_17, 
										isnull(b.aug_17,0) as aug_17, 
										isnull(b.sep_17,0) as sep_17,  
										isnull(b.oct_17,0) as oct_17, 
										isnull(b.nov_17,0) as nov_17, 
										isnull(b.dec_17,0) as dec_17,  
										(isnull(b.jan_17,0)+isnull(b.feb_17,0)+isnull(b.mar_17,0)+isnull(b.apr_17,0)+isnull(b.may_17,0)+isnull(b.jun_17,0)
										+isnull(b.jul_17,0)+isnull(b.aug_17,0)+isnull(b.sep_17,0)+isnull(b.oct_17,0)+isnull(b.nov_17,0)+isnull(b.dec_17,0)) as cal_17,
										
										isnull(b.jan_18,0) as jan_18, 
										isnull(b.feb_18,0) as feb_18,
										isnull(b.mar_18,0) as mar_18, 
										isnull(b.apr_18,0) as apr_18, 
										isnull(b.may_18,0) as may_18,
										isnull(b.jun_18,0) as jun_18, 
										isnull(b.jul_18,0) as jul_18, 
										isnull(b.aug_18,0) as aug_18, 
										isnull(b.sep_18,0) as sep_18,  
										isnull(b.oct_18,0) as oct_18, 
										isnull(b.nov_18,0) as nov_18, 
										isnull(b.dec_18,0) as dec_18,  
										(isnull(b.jan_18,0)+isnull(b.feb_18,0)+isnull(b.mar_18,0)+isnull(b.apr_18,0)+isnull(b.may_18,0)+isnull(b.jun_18,0)
										+isnull(b.jul_18,0)+isnull(b.aug_18,0)+isnull(b.sep_18,0)+isnull(b.oct_18,0)+isnull(b.nov_18,0)+isnull(b.dec_18,0)) as cal_18,
						  
										isnull(b.jan_19,0) as jan_19, 
										isnull(b.feb_19,0) as feb_19,
										isnull(b.mar_19,0) as mar_19, 
										isnull(b.apr_19,0) as apr_19, 
										isnull(b.may_19,0) as may_19,
										isnull(b.jun_19,0) as jun_19, 
										isnull(b.jul_19,0) as jul_19, 
										isnull(b.aug_19,0) as aug_19, 
										isnull(b.sep_19,0) as sep_19,  
										isnull(b.oct_19,0) as oct_19, 
										isnull(b.nov_19,0) as nov_19, 
										isnull(b.dec_19,0) as dec_19,  
										(isnull(b.jan_19,0)+isnull(b.feb_19,0)+isnull(b.mar_19,0)+isnull(b.apr_19,0)+isnull(b.may_19,0)+isnull(b.jun_19,0)
										+isnull(b.jul_19,0)+isnull(b.aug_19,0)+isnull(b.sep_19,0)+isnull(b.oct_19,0)+isnull(b.nov_19,0)+isnull(b.dec_19,0)) as cal_19,
						
										isnull(b.jan_20,0) as jan_20, 
										isnull(b.feb_20,0) as feb_20,
										isnull(b.mar_20,0) as mar_20, 
										isnull(b.apr_20,0) as apr_20, 
										isnull(b.may_20,0) as may_20,
										isnull(b.jun_20,0) as jun_20, 
										isnull(b.jul_20,0) as jul_20, 
										isnull(b.aug_20,0) as aug_20, 
										isnull(b.sep_20,0) as sep_20,  
										isnull(b.oct_20,0) as oct_20, 
										isnull(b.nov_20,0) as nov_20, 
										isnull(b.dec_20,0) as dec_20,  
										(isnull(b.jan_20,0)+isnull(b.feb_20,0)+isnull(b.mar_20,0)+isnull(b.apr_20,0)+isnull(b.may_20,0)+isnull(b.jun_20,0)
										+isnull(b.jul_20,0)+isnull(b.aug_20,0)+isnull(b.sep_20,0)+isnull(b.oct_20,0)+isnull(b.nov_20,0)+isnull(b.dec_20,0)) as cal_20,
						
										isnull(b.jan_21,0) as jan_21, 
										isnull(b.feb_21,0) as feb_21,
										isnull(b.mar_21,0) as mar_21, 
										isnull(b.apr_21,0) as apr_21, 
										isnull(b.may_21,0) as may_21,
										isnull(b.jun_21,0) as jun_21, 
										isnull(b.jul_21,0) as jul_21, 
										isnull(b.aug_21,0) as aug_21, 
										isnull(b.sep_21,0) as sep_21,  
										isnull(b.oct_21,0) as oct_21, 
										isnull(b.nov_21,0) as nov_21, 
										isnull(b.dec_21,0) as dec_21,  
										(isnull(b.jan_21,0)+isnull(b.feb_21,0)+isnull(b.mar_21,0)+isnull(b.apr_21,0)+isnull(b.may_21,0)+isnull(b.jun_21,0)
										+isnull(b.jul_21,0)+isnull(b.aug_21,0)+isnull(b.sep_21,0)+isnull(b.oct_21,0)+isnull(b.nov_21,0)+isnull(b.dec_21,0)) as cal_21,
												
										isnull(b.cal_22,0) as cal_22,
										isnull(b.cal_23,0) as cal_23,
										isnull(b.cal_24,0) as cal_24,
										isnull(b.cal_25,0) as cal_25,
										isnull(b.cal_26,0) as cal_26
								from 
							
										(select * 
										 from	eeiuser.acctg_csm_base_part_mnemonic
										 where  release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										) a							
										left outer join									
										(	select * 
											from	eeiuser.acctg_csm_NACSM 
											where	version = 'Empire Factor' 
												and release_id = --'2018-09'
													(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
										) b								
										on a.mnemonic = b.mnemonic
										and a.release_id = b.release_id
										where b.mnemonic is not null 
								) b -- RETURNS A SET OF ROWS WITH THE EMPIRE FACTOR
								on a.base_part = b.base_part
								group by a.base_part 
						) b
							
						on a.base_part = b.base_part 
				) aa
				/* STATEMENT 3aa ENDS */

				full outer join

				/* STATEMENT 3bb BEGINS */
				(select b.version,
						a.base_part,
						a.mnemonic,						
						b.badge,
						b.manufacturer, 
						b.platform, 
						b.program, 
						b.badge+' '+b.nameplate as vehicle, 
						b.assembly_plant,
						b.product_type,
						b.global_segment,
						b.regional_segment,
						b.market,
						b.sop as 'CSM_SOP',
						b.eop as 'CSM_EOP',
						a.qty_per, 
						a.take_rate, 
						a.family_allocation, 
						
						--ISNULL(b.jan_10,0) as jan_10, 
						--ISNULL(b.feb_10,0) as feb_10, 
						--ISNULL(b.mar_10,0) as mar_10, 
						--ISNULL(b.apr_10,0) as apr_10, 
						--ISNULL(b.may_10,0) as may_10, 
						--ISNULL(b.jun_10,0) as jun_10, 
						--ISNULL(b.jul_10,0) as jul_10, 
						--ISNULL(b.aug_10,0) as aug_10, 
						--ISNULL(b.sep_10,0) as sep_10, 
						--ISNULL(b.oct_10,0) as oct_10, 
						--ISNULL(b.nov_10,0) as nov_10, 
						--ISNULL(b.dec_10,0) as dec_10, 
						--(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)
						--+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as cal_10,
		
						--ISNULL(b.jan_11,0) as jan_11, 
						--ISNULL(b.feb_11,0) as feb_11, 
						--ISNULL(b.mar_11,0) as mar_11, 
						--ISNULL(b.apr_11,0) as apr_11, 
						--ISNULL(b.may_11,0) as may_11, 
						--ISNULL(b.jun_11,0) as jun_11, 
						--ISNULL(b.jul_11,0) as jul_11, 
						--ISNULL(b.aug_11,0) as aug_11, 
						--ISNULL(b.sep_11,0) as sep_11, 
						--ISNULL(b.oct_11,0) as oct_11, 
						--ISNULL(b.nov_11,0) as nov_11, 
						--ISNULL(b.dec_11,0) as dec_11, 
						--(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)
						--+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0))  as cal_11,
		
						--ISNULL(b.jan_12,0) as jan_12, 
						--ISNULL(b.feb_12,0) as feb_12, 
						--ISNULL(b.mar_12,0) as mar_12, 
						--ISNULL(b.apr_12,0) as apr_12, 
						--ISNULL(b.may_12,0) as may_12, 
						--ISNULL(b.jun_12,0) as jun_12, 
						--ISNULL(b.jul_12,0) as jul_12, 
						--ISNULL(b.aug_12,0) as aug_12, 
						--ISNULL(b.sep_12,0) as sep_12, 
						--ISNULL(b.oct_12,0) as oct_12, 
						--ISNULL(b.nov_12,0) as nov_12, 
						--ISNULL(b.dec_12,0) as dec_12, 
						--(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)
						--+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0))  as cal_12,
		
						--ISNULL(b.jan_13,0) as jan_13, 
						--ISNULL(b.feb_13,0) as feb_13, 
						--ISNULL(b.mar_13,0) as mar_13, 
						--ISNULL(b.apr_13,0) as apr_13, 
						--ISNULL(b.may_13,0) as may_13, 
						--ISNULL(b.jun_13,0) as jun_13, 
						--ISNULL(b.jul_13,0) as jul_13, 
						--ISNULL(b.aug_13,0) as aug_13, 
						--ISNULL(b.sep_13,0) as sep_13, 
						--ISNULL(b.oct_13,0) as oct_13, 
						--ISNULL(b.nov_13,0) as nov_13, 
						--ISNULL(b.dec_13,0) as dec_13, 
						--(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)
						--+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0))  as cal_13,
		
						--ISNULL(b.jan_14,0) as jan_14, 
						--ISNULL(b.feb_14,0) as feb_14, 
						--ISNULL(b.mar_14,0) as mar_14, 
						--ISNULL(b.apr_14,0) as apr_14, 
						--ISNULL(b.may_14,0) as may_14, 
						--ISNULL(b.jun_14,0) as jun_14, 
						--ISNULL(b.jul_14,0) as jul_14, 
						--ISNULL(b.aug_14,0) as aug_14, 
						--ISNULL(b.sep_14,0) as sep_14, 
						--ISNULL(b.oct_14,0) as oct_14, 
						--ISNULL(b.nov_14,0) as nov_14, 
						--ISNULL(b.dec_14,0) as dec_14, 
						--(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)
						--+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0))  as cal_14,
						
						--ISNULL(b.jan_15,0) as jan_15, 
						--ISNULL(b.feb_15,0) as feb_15, 
						--ISNULL(b.mar_15,0) as mar_15, 
						--ISNULL(b.apr_15,0) as apr_15, 
						--ISNULL(b.may_15,0) as may_15, 
						--ISNULL(b.jun_15,0) as jun_15, 
						--ISNULL(b.jul_15,0) as jul_15, 
						--ISNULL(b.aug_15,0) as aug_15, 
						--ISNULL(b.sep_15,0) as sep_15, 
						--ISNULL(b.oct_15,0) as oct_15, 
						--ISNULL(b.nov_15,0) as nov_15, 
						--ISNULL(b.dec_15,0) as dec_15, 
						--(ISNULL(b.jan_15,0)+ISNULL(b.feb_15,0)+ISNULL(b.mar_15,0)+ISNULL(b.apr_15,0)+ISNULL(b.may_15,0)+ISNULL(b.jun_15,0)
						--+ISNULL(b.jul_15,0)+ISNULL(b.aug_15,0)+ISNULL(b.sep_15,0)+ISNULL(b.oct_15,0)+ISNULL(b.nov_15,0)+ISNULL(b.dec_15,0))  as cal_15,

						isnull(b.jan_16,0) as jan_16, 
						isnull(b.feb_16,0) as feb_16, 
						isnull(b.mar_16,0) as mar_16, 
						isnull(b.apr_16,0) as apr_16, 
						isnull(b.may_16,0) as may_16, 
						isnull(b.jun_16,0) as jun_16, 
						isnull(b.jul_16,0) as jul_16, 
						isnull(b.aug_16,0) as aug_16, 
						isnull(b.sep_16,0) as sep_16, 
						isnull(b.oct_16,0) as oct_16, 
						isnull(b.nov_16,0) as nov_16, 
						isnull(b.dec_16,0) as dec_16, 
						(isnull(b.jan_16,0)+isnull(b.feb_16,0)+isnull(b.mar_16,0)+isnull(b.apr_16,0)+isnull(b.may_16,0)+isnull(b.jun_16,0)
						+isnull(b.jul_16,0)+isnull(b.aug_16,0)+isnull(b.sep_16,0)+isnull(b.oct_16,0)+isnull(b.nov_16,0)+isnull(b.dec_16,0))  as cal_16,
						
						isnull(b.jan_17,0) as jan_17, 
						isnull(b.feb_17,0) as feb_17, 
						isnull(b.mar_17,0) as mar_17, 
						isnull(b.apr_17,0) as apr_17, 
						isnull(b.may_17,0) as may_17, 
						isnull(b.jun_17,0) as jun_17, 
						isnull(b.jul_17,0) as jul_17, 
						isnull(b.aug_17,0) as aug_17, 
						isnull(b.sep_17,0) as sep_17, 
						isnull(b.oct_17,0) as oct_17, 
						isnull(b.nov_17,0) as nov_17, 
						isnull(b.dec_17,0) as dec_17, 
						(isnull(b.jan_17,0)+isnull(b.feb_17,0)+isnull(b.mar_17,0)+isnull(b.apr_17,0)+isnull(b.may_17,0)+isnull(b.jun_17,0)
						+isnull(b.jul_17,0)+isnull(b.aug_17,0)+isnull(b.sep_17,0)+isnull(b.oct_17,0)+isnull(b.nov_17,0)+isnull(b.dec_17,0))  as cal_17,
						
						isnull(b.jan_18,0) as jan_18, 
						isnull(b.feb_18,0) as feb_18, 
						isnull(b.mar_18,0) as mar_18, 
						isnull(b.apr_18,0) as apr_18, 
						isnull(b.may_18,0) as may_18, 
						isnull(b.jun_18,0) as jun_18, 
						isnull(b.jul_18,0) as jul_18, 
						isnull(b.aug_18,0) as aug_18, 
						isnull(b.sep_18,0) as sep_18, 
						isnull(b.oct_18,0) as oct_18, 
						isnull(b.nov_18,0) as nov_18, 
						isnull(b.dec_18,0) as dec_18, 
						(isnull(b.jan_18,0)+isnull(b.feb_18,0)+isnull(b.mar_18,0)+isnull(b.apr_18,0)+isnull(b.may_18,0)+isnull(b.jun_18,0)
						+isnull(b.jul_18,0)+isnull(b.aug_18,0)+isnull(b.sep_18,0)+isnull(b.oct_18,0)+isnull(b.nov_18,0)+isnull(b.dec_18,0))  as cal_18,
						
						isnull(b.jan_19,0) as jan_19, 
						isnull(b.feb_19,0) as feb_19, 
						isnull(b.mar_19,0) as mar_19, 
						isnull(b.apr_19,0) as apr_19, 
						isnull(b.may_19,0) as may_19, 
						isnull(b.jun_19,0) as jun_19, 
						isnull(b.jul_19,0) as jul_19, 
						isnull(b.aug_19,0) as aug_19, 
						isnull(b.sep_19,0) as sep_19, 
						isnull(b.oct_19,0) as oct_19, 
						isnull(b.nov_19,0) as nov_19, 
						isnull(b.dec_19,0) as dec_19, 
						(isnull(b.jan_19,0)+isnull(b.feb_19,0)+isnull(b.mar_19,0)+isnull(b.apr_19,0)+isnull(b.may_19,0)+isnull(b.jun_19,0)
						+isnull(b.jul_19,0)+isnull(b.aug_19,0)+isnull(b.sep_19,0)+isnull(b.oct_19,0)+isnull(b.nov_19,0)+isnull(b.dec_19,0))  as cal_19,
						
						isnull(b.jan_20,0) as jan_20, 
						isnull(b.feb_20,0) as feb_20, 
						isnull(b.mar_20,0) as mar_20, 
						isnull(b.apr_20,0) as apr_20, 
						isnull(b.may_20,0) as may_20, 
						isnull(b.jun_20,0) as jun_20, 
						isnull(b.jul_20,0) as jul_20, 
						isnull(b.aug_20,0) as aug_20, 
						isnull(b.sep_20,0) as sep_20, 
						isnull(b.oct_20,0) as oct_20, 
						isnull(b.nov_20,0) as nov_20, 
						isnull(b.dec_20,0) as dec_20, 
						(isnull(b.jan_20,0)+isnull(b.feb_20,0)+isnull(b.mar_20,0)+isnull(b.apr_20,0)+isnull(b.may_20,0)+isnull(b.jun_20,0)
						+isnull(b.jul_20,0)+isnull(b.aug_20,0)+isnull(b.sep_20,0)+isnull(b.oct_20,0)+isnull(b.nov_20,0)+isnull(b.dec_20,0))  as cal_20,
						
						isnull(b.jan_21,0) as jan_21, 
						isnull(b.feb_21,0) as feb_21, 
						isnull(b.mar_21,0) as mar_21, 
						isnull(b.apr_21,0) as apr_21, 
						isnull(b.may_21,0) as may_21, 
						isnull(b.jun_21,0) as jun_21, 
						isnull(b.jul_21,0) as jul_21, 
						isnull(b.aug_21,0) as aug_21, 
						isnull(b.sep_21,0) as sep_21, 
						isnull(b.oct_21,0) as oct_21, 
						isnull(b.nov_21,0) as nov_21, 
						isnull(b.dec_21,0) as dec_21, 
						(isnull(b.jan_21,0)+isnull(b.feb_21,0)+isnull(b.mar_21,0)+isnull(b.apr_21,0)+isnull(b.may_21,0)+isnull(b.jun_21,0)
						+isnull(b.jul_21,0)+isnull(b.aug_21,0)+isnull(b.sep_21,0)+isnull(b.oct_21,0)+isnull(b.nov_21,0)+isnull(b.dec_21,0))  as cal_21,

						isnull(b.cal_22,0) as cal_22,
						isnull(b.cal_23,0) as cal_23,
						isnull(b.cal_24,0) as cal_24,
						isnull(b.cal_25,0) as cal_25,
						isnull(b.cal_26,0) as cal_26
				from    
						(select * 
						 from	eeiuser.acctg_csm_base_part_mnemonic
						 where	release_id = --'2018-09'
									(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
						) a 
						left outer join 
						(	select	* 
							from	eeiuser.acctg_csm_NACSM  
							where	release_id = --'2018-09'
									(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
						) b
						on a.mnemonic = b.mnemonic 
						and a.release_id = b.release_id
						where	version = 'Empire Adjustment'
								and b.mnemonic is not null
								and (isnull(b.cal_16,0)+isnull(b.CAL_17,0)+isnull(b.CAL_18,0)+isnull(b.CAL_19,0)+isnull(b.CAL_20,0)+isnull(b.CAL_21,0)+isnull(b.CAL_22,0)+isnull(b.CAL_23,0)+isnull(b.CAL_24,0)+isnull(b.CAL_25,0)+isnull(b.CAL_26,0)) <>  0
				) bb
				/* STATEMENT 3bb ENDS */
				
				on aa.base_part = bb.base_part 
		) cc
				/*STATEMENT 2cc ENDS */

		left join 
		
				/*STATEMENT 2yy BEGINS */
				eeiuser.acctg_csm_vw_select_selling_price yy 
				/*STATEMENT 2yy ENDS */
		
			on cc.base_part = yy.base_part
		
		left join   (	select	MCBasePart,
								CurrentRevPart,
								coalesce(CurrentRevMaterialAccum ,0) as CurrentRevMaterialAccum,
								BOMFlag,
								PartDataBase
						from	vwft_ActivePartMaterialAccum
						where	PartDataBase = 'EEH'
								and isnull(BOMFlag,0) = 0 
								and MCBASEPart not in (select MCBasePart from vwft_ActivePartMaterialAccum where BOMFlag = 1) 
						union
						select	MCBasePart,
								CurrentRevPart,
								coalesce(CurrentRevFrozenMaterialCost ,0) as CurrentRevMaterialAccum,
								BOMFlag,
								PartDataBase
						from	vwft_ActivePartMaterialAccum
						where	PartDataBase = 'EEI'
								and isnull(BOMFlag,0) = 1 
					)	XX
									
			on cc.base_part = XX.MCBasePart

		left join	(	select	* 
						from	eeiuser.acctg_csm_base_part_attributes 
						where	release_id = --'2018-09'
								(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM'))
					) ZZ

			on cc.base_part = ZZ.base_part
			
		left join [EEIUser].[acctg_csm_vw_select_material_cost] MC
			on cc.base_part = MC.base_part 

		left join [EEIUser].acctg_csm_post918programs PP
		    on cc.base_part = PP.base_part
		
where cc.base_part in	(	select	base_part 
							from	eeiuser.acctg_csm_base_part_attributes 
							where	include_in_forecast = 1
									and release_id = --'2018-09'
										(select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
							)




GO
