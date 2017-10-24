SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view  [EEIUser].[OBS_acctg_csm_vw_select_csmdemandwitheeiadjustments_dw]
as 

/* LEVEL 1 */
select	(case when left(cc.base_part,3) = 'GUI' then 'VPP' else left(cc.base_part,3) end) as customer
		,cc.[base_part]
		,[version]
		,[mnemonic]
		,[platform]
		,[program]
		,[manufacturer]
		,[badge]
		,[vehicle]
		,[assembly_plant]
		,[empire_market_segment]
		,[empire_application]
		,[product_type]
		,[global_segment]
		,[regional_segment]
		,(case when (datediff(d,ISNULL([EMPIRE_eop],[CSM_eop]),getdate()) > 90) then 'Service' else (case when (datediff(d,ISNULL([EMPIRE_eop],[CSM_eop]),getdate()) between -180 and 90) then 'Closeout' else (case when (datediff(d,ISNULL([EMPIRE_sop],[CSM_sop]),getdate()) between -180 and 90) then 'Launch' else (case when (datediff(d,ISNULL([EMPIRE_sop],[CSM_sop]),getdate()) < -180) then 'Pre-Launch' else 'Production' end)end)end)end) as status
		,[CSM_sop]
		,[CSM_eop]
		,[csm_sop] as 'CSM_sop_display'
		,[csm_eop] as 'CSM_eop_display'
		,[EMPIRE_sop]
		,[EMPIRE_eop]
		,ISNULL([EMPIRE_sop],[CSM_sop]) as [sop]
		,ISNULL([EMPIRE_eop],[CSM_eop]) as [eop]
		,ISNULL([EMPIRE_sop],[CSM_sop]) as [sop_display]
		,ISNULL([EMPIRE_eop],[CSM_eop]) as [eop_display]
		,DATEDIFF(mm,ISNULL([empire_sop],[csm_sop]),isnull([empire_eop],[csm_eop])) as [empire_duration_mo]
		,[qty_per]
		,[take_rate]
		,[family_allocation]
		,[Jan_10_CSMdemand]
		,[Feb_10_CSMdemand]
		,[Mar_10_CSMdemand]
		,[Apr_10_CSMdemand]
		,[May_10_CSMdemand]
		,[Jun_10_CSMdemand]
		,[Jul_10_CSMdemand]
		,[Aug_10_CSMdemand]
		,[Sep_10_CSMdemand]
		,[Oct_10_CSMdemand]
		,[Nov_10_CSMdemand]
		,[Dec_10_CSMdemand]
		,[Total_10_CSMdemand]
		,[Jan_11_CSMdemand]
		,[Feb_11_CSMdemand]
		,[Mar_11_CSMdemand]
		,[Apr_11_CSMdemand]
		,[May_11_CSMdemand]
		,[Jun_11_CSMdemand]
		,[Jul_11_CSMdemand]
		,[Aug_11_CSMdemand]
		,[Sep_11_CSMdemand]
		,[Oct_11_CSMdemand]
		,[Nov_11_CSMdemand]
		,[Dec_11_CSMdemand]
		,[Total_11_CSMdemand]
		,[Jan_12_CSMdemand]
		,[Feb_12_CSMdemand]
		,[Mar_12_CSMdemand]
		,[Apr_12_CSMdemand]
		,[May_12_CSMdemand]
		,[Jun_12_CSMdemand]
		,[Jul_12_CSMdemand]
		,[Aug_12_CSMdemand]
		,[Sep_12_CSMdemand]
		,[Oct_12_CSMdemand]
		,[Nov_12_CSMdemand]
		,[Dec_12_CSMdemand]
		,[Total_12_CSMdemand]
		,[Cal13_CSMdemand]
		,[Cal14_CSMdemand]
		,[Cal15_CSMdemand]
		,[Cal16_CSMdemand]
		,[Jan_10_factor]
		,[Feb_10_factor]
		,[Mar_10_factor]
		,[Apr_10_factor]
		,[May_10_factor]
		,[Jun_10_factor]
		,[Jul_10_factor]
		,[Aug_10_factor]
		,[Sep_10_factor]
		,[Oct_10_factor]
		,[Nov_10_factor]
		,[Dec_10_factor]
		,[Jan_11_factor]
		,[Feb_11_factor]
		,[Mar_11_factor]
		,[Apr_11_factor]
		,[May_11_factor]
		,[Jun_11_factor]
		,[Jul_11_factor]
		,[Aug_11_factor]
		,[Sep_11_factor]
		,[Oct_11_factor]
		,[Nov_11_factor]
		,[Dec_11_factor]
		,[Jan_12_factor]
		,[Feb_12_factor]
		,[Mar_12_factor]
		,[Apr_12_factor]
		,[May_12_factor]
		,[Jun_12_factor]
		,[Jul_12_factor]
		,[Aug_12_factor]
		,[Sep_12_factor]
		,[Oct_12_factor]
		,[Nov_12_factor]
		,[Dec_12_factor]
		,[Cal13_factor]
		,[Cal14_factor]
		,[Cal15_factor]
		,[Cal16_factor]
		,[Jan_10_Empire_Adj]
		,[Feb_10_Empire_Adj]
		,[Mar_10_Empire_Adj]
		,[Apr_10_Empire_Adj]
		,[May_10_Empire_Adj]
		,[Jun_10_Empire_Adj]
		,[Jul_10_Empire_Adj]
		,[Aug_10_Empire_Adj]
		,[Sep_10_Empire_Adj]
		,[Oct_10_Empire_Adj]
		,[Nov_10_Empire_Adj]
		,[Dec_10_Empire_Adj]
		,[Total_10_Empire_Adj]
		,[Jan_11_Empire_Adj]
		,[Feb_11_Empire_Adj]
		,[Mar_11_Empire_Adj]
		,[Apr_11_Empire_Adj]
		,[May_11_Empire_Adj]
		,[Jun_11_Empire_Adj]
		,[Jul_11_Empire_Adj]
		,[Aug_11_Empire_Adj]
		,[Sep_11_Empire_Adj]
		,[Oct_11_Empire_Adj]
		,[Nov_11_Empire_Adj]
		,[Dec_11_Empire_Adj]
		,[Total_11_Empire_Adj]
		,[Jan_12_Empire_Adj]
		,[Feb_12_Empire_Adj]
		,[Mar_12_Empire_Adj]
		,[Apr_12_Empire_Adj]
		,[May_12_Empire_Adj]
		,[Jun_12_Empire_Adj]
		,[Jul_12_Empire_Adj]
		,[Aug_12_Empire_Adj]
		,[Sep_12_Empire_Adj]
		,[Oct_12_Empire_Adj]
		,[Nov_12_Empire_Adj]
		,[Dec_12_Empire_Adj]
		,[Total_12_Empire_Adj]
		,[Cal13_Empire_Adj]
		,[Cal14_Empire_Adj]
		,[Cal15_Empire_Adj]
		,[Cal16_Empire_Adj]
		,[Jan_10_Allocated_Empire_Adj]
		,[Feb_10_Allocated_Empire_Adj]
		,[Mar_10_Allocated_Empire_Adj]
		,[Apr_10_Allocated_Empire_Adj]
		,[May_10_Allocated_Empire_Adj]
		,[Jun_10_Allocated_Empire_Adj]
		,[Jul_10_Allocated_Empire_Adj]
		,[Aug_10_Allocated_Empire_Adj]
		,[Sep_10_Allocated_Empire_Adj]
		,[Oct_10_Allocated_Empire_Adj]
		,[Nov_10_Allocated_Empire_Adj]
		,[Dec_10_Allocated_Empire_Adj]
		,[Total_10_Allocated_Empire_Adj]
		,[Jan_11_Allocated_Empire_Adj]
		,[Feb_11_Allocated_Empire_Adj]
		,[Mar_11_Allocated_Empire_Adj]
		,[Apr_11_Allocated_Empire_Adj]
		,[May_11_Allocated_Empire_Adj]
		,[Jun_11_Allocated_Empire_Adj]
		,[Jul_11_Allocated_Empire_Adj]
		,[Aug_11_Allocated_Empire_Adj]
		,[Sep_11_Allocated_Empire_Adj]
		,[Oct_11_Allocated_Empire_Adj]
		,[Nov_11_Allocated_Empire_Adj]
		,[Dec_11_Allocated_Empire_Adj]
		,[Total_11_Allocated_Empire_Adj]
		,[Jan_12_Allocated_Empire_Adj]
		,[Feb_12_Allocated_Empire_Adj]
		,[Mar_12_Allocated_Empire_Adj]
		,[Apr_12_Allocated_Empire_Adj]
		,[May_12_Allocated_Empire_Adj]
		,[Jun_12_Allocated_Empire_Adj]
		,[Jul_12_Allocated_Empire_Adj]
		,[Aug_12_Allocated_Empire_Adj]
		,[Sep_12_Allocated_Empire_Adj]
		,[Oct_12_Allocated_Empire_Adj]
		,[Nov_12_Allocated_Empire_Adj]
		,[Dec_12_Allocated_Empire_Adj]
		,[Total_12_Allocated_Empire_Adj]
		,[Cal13_Allocated_Empire_Adj]
		,[Cal14_Allocated_Empire_Adj]
		,[Cal15_Allocated_Empire_Adj]
		,[Cal16_Allocated_Empire_Adj]
		,[Jan_10_TOTALdemand]
		,[Feb_10_TOTALdemand]
		,[Mar_10_TOTALdemand]
		,[Apr_10_TOTALdemand]
		,[May_10_TOTALdemand]
		,[Jun_10_TOTALdemand]
		,[Jul_10_TOTALdemand]
		,[Aug_10_TOTALdemand]
		,[Sep_10_TOTALdemand]
		,[Oct_10_TOTALdemand]
		,[Nov_10_TOTALdemand]
		,[Dec_10_TOTALdemand]
		,[Total_2010_TOTALdemand]
		,[Jan_11_TOTALdemand]
		,[Feb_11_TOTALdemand]
		,[Mar_11_TOTALdemand]
		,[Apr_11_TOTALdemand]
		,[May_11_TOTALdemand]
		,[Jun_11_TOTALdemand]
		,[Jul_11_TOTALdemand]
		,[Aug_11_TOTALdemand]
		,[Sep_11_TOTALdemand]
		,[Oct_11_TOTALdemand]
		,[Nov_11_TOTALdemand]
		,[Dec_11_TOTALdemand]
		,[Total_2011_TOTALdemand]
		,[Jan_12_TOTALdemand]
		,[Feb_12_TOTALdemand]
		,[Mar_12_TOTALdemand]
		,[Apr_12_TOTALdemand]
		,[May_12_TOTALdemand]
		,[Jun_12_TOTALdemand]
		,[Jul_12_TOTALdemand]
		,[Aug_12_TOTALdemand]
		,[Sep_12_TOTALdemand]
		,[Oct_12_TOTALdemand]
		,[Nov_12_TOTALdemand]
		,[Dec_12_TOTALdemand]
		,[Total_2012_TOTALdemand]
		,[Cal13_TOTALdemand]
		,[Cal14_TOTALdemand]
		,[Cal15_TOTALdemand]
		,[Cal16_TOTALdemand]
		,[sp_Dec_10]
		,[sp_Dec_11]
		,[sp_Dec_12]
		,[Jan_10_TOTALdemand]*[sp_Dec_10] as 'Jan_10_Sales'
		,[Feb_10_TOTALdemand]*[sp_Dec_10] as 'Feb_10_Sales'
		,[Mar_10_TOTALdemand]*[sp_Dec_10] as 'Mar_10_Sales'
		,[Apr_10_TOTALdemand]*[sp_Dec_10] as 'Apr_10_Sales'
		,[May_10_TOTALdemand]*[sp_Dec_10] as 'May_10_Sales'
		,[Jun_10_TOTALdemand]*[sp_Dec_10] as 'Jun_10_Sales'
		,[Jul_10_TOTALdemand]*[sp_Dec_10] as 'Jul_10_Sales'
		,[Aug_10_TOTALdemand]*[sp_Dec_10] as 'Aug_10_Sales'
		,[Sep_10_TOTALdemand]*[sp_Dec_10] as 'Sep_10_Sales'
		,[Oct_10_TOTALdemand]*[sp_Dec_10] as 'Oct_10_Sales'
		,[Nov_10_TOTALdemand]*[sp_Dec_10] as 'Nov_10_Sales'
		,[Dec_10_TOTALdemand]*[sp_Dec_10] as 'Dec_10_Sales'
		,[Total_2010_TOTALdemand]*[sp_Dec_10] as 'Cal_10_Sales' 
		,[Jan_11_TOTALdemand]*[sp_Dec_11] as 'Jan_11_Sales'
		,[Feb_11_TOTALdemand]*[sp_Dec_11] as 'Feb_11_Sales'
		,[Mar_11_TOTALdemand]*[sp_Dec_11] as 'Mar_11_Sales'
		,[Apr_11_TOTALdemand]*[sp_Dec_11] as 'Apr_11_Sales'
		,[May_11_TOTALdemand]*[sp_Dec_11] as 'May_11_Sales'
		,[Jun_11_TOTALdemand]*[sp_Dec_11] as 'Jun_11_Sales'
		,[Jul_11_TOTALdemand]*[sp_Dec_11] as 'Jul_11_Sales'
		,[Aug_11_TOTALdemand]*[sp_Dec_11] as 'Aug_11_Sales'
		,[Sep_11_TOTALdemand]*[sp_Dec_11] as 'Sep_11_Sales'
		,[Oct_11_TOTALdemand]*[sp_Dec_11] as 'Oct_11_Sales'
		,[Nov_11_TOTALdemand]*[sp_Dec_11] as 'Nov_11_Sales'
		,[Dec_11_TOTALdemand]*[sp_Dec_11] as 'Dec_11_Sales'
		,[Total_2011_TOTALdemand]*[sp_Dec_11] as 'Cal_11_Sales'
		,[Jan_12_TOTALdemand]*[sp_Dec_12] as 'Jan_12_Sales'
		,[Feb_12_TOTALdemand]*[sp_Dec_12] as 'Feb_12_Sales'
		,[Mar_12_TOTALdemand]*[sp_Dec_12] as 'Mar_12_Sales'
		,[Apr_12_TOTALdemand]*[sp_Dec_12] as 'Apr_12_Sales'
		,[May_12_TOTALdemand]*[sp_Dec_12] as 'May_12_Sales'
		,[Jun_12_TOTALdemand]*[sp_Dec_12] as 'Jun_12_Sales'
		,[Jul_12_TOTALdemand]*[sp_Dec_12] as 'Jul_12_Sales'
		,[Aug_12_TOTALdemand]*[sp_Dec_12] as 'Aug_12_Sales'
		,[Sep_12_TOTALdemand]*[sp_Dec_12] as 'Sep_12_Sales'
		,[Oct_12_TOTALdemand]*[sp_Dec_12] as 'Oct_12_Sales'
		,[Nov_12_TOTALdemand]*[sp_Dec_12] as 'Nov_12_Sales'
		,[Dec_12_TOTALdemand]*[sp_Dec_12] as 'Dec_12_Sales'
		,[Total_2012_TOTALdemand] *[sp_Dec_12]  as 'Cal_12_Sales'   
		,[Cal13_TOTALdemand]*[sp_Dec_12] as 'Cal_13_Sales'
		,[Cal14_TOTALdemand]*[sp_Dec_12] as 'Cal_14_Sales'
		,[Cal15_TOTALdemand]*[sp_Dec_12] as 'Cal_15_Sales'
		,[Cal16_TOTALdemand]*[sp_Dec_12] as 'Cal_16_Sales'
		,([Total_2010_TOTALdemand]*[sp_Dec_10])+([Total_2011_TOTALdemand]*[sp_Dec_11])+([Total_2012_TOTALdemand] *[sp_Dec_12])+([Cal13_TOTALdemand]*[sp_Dec_12])+([Cal14_TOTALdemand]*[sp_Dec_12])+([Cal15_TOTALdemand]*[sp_Dec_12])+([Cal16_TOTALdemand]*[sp_Dec_12]) as '2010-2016_Sales'
from

		/* LEVEL 2 */
		/* STATEMENT 2*/
		(SELECT isnull(aa.base_part,bb.base_part) as base_part,
				isnull(aa.version, bb.version) as version,
				isnull(aa.mnemonic, bb.mnemonic) as mnemonic,
				isnull(aa.platform, bb.platform) as platform,
				isnull(aa.program, bb.program) as program,
				isnull(aa.manufacturer, bb.manufacturer) as manufacturer,
				isnull(aa.badge, bb.badge) as badge,
				isnull(aa.vehicle, bb.vehicle) as vehicle,
				isnull(aa.assembly_plant, bb.assembly_plant) as assembly_plant,
				isnull(aa.empire_market_segment, bb.empire_market_segment) as empire_market_segment,
				isnull(aa.empire_application, bb.empire_application) as empire_application,
				isnull(aa.product_type, bb.product_type) as product_type,
				isnull(aa.global_segment, bb.global_segment) as global_segment,
				isnull(aa.regional_segment, bb.regional_segment) as regional_segment,
				isnull(aa.CSM_sop, bb.CSM_sop) as csm_sop,
				isnull(aa.CSM_eop, bb.CSM_eop) as csm_eop,
				isnull(aa.EMPIRE_sop, bb.EMPIRE_sop) as empire_sop,
				isnull(aa.EMPIRE_eop, bb.EMPIRE_eop) as empire_eop,
				isnull(aa.qty_per, bb.qty_per) as qty_per,
				isnull(aa.take_rate, bb.take_rate) as take_rate,
				isnull(aa.family_allocation, bb.family_allocation) as family_allocation,
				isnull(aa.Jan_10_CSMdemand,0) as Jan_10_CSMdemand,
				isnull(aa.Feb_10_CSMdemand,0) as Feb_10_CSMdemand,
				isnull(aa.Mar_10_CSMdemand,0) as Mar_10_CSMdemand,
				isnull(aa.Apr_10_CSMdemand,0) as Apr_10_CSMdemand,
				isnull(aa.May_10_CSMdemand,0) as May_10_CSMdemand,
				isnull(aa.Jun_10_CSMdemand,0) as Jun_10_CSMdemand,
				isnull(aa.Jul_10_CSMdemand,0) as Jul_10_CSMdemand,
				isnull(aa.Aug_10_CSMdemand,0) as Aug_10_CSMdemand,
				isnull(aa.Sep_10_CSMdemand,0) as Sep_10_CSMdemand,
				isnull(aa.Oct_10_CSMdemand,0) as Oct_10_CSMdemand,
				isnull(aa.Nov_10_CSMdemand,0) as Nov_10_CSMdemand,
				isnull(aa.Dec_10_CSMdemand,0) as Dec_10_CSMdemand,
				isnull(aa.Total_10_CSMdemand,0) as Total_10_CSMdemand,
				isnull(aa.Jan_11_CSMdemand,0) as Jan_11_CSMdemand,
				isnull(aa.Feb_11_CSMdemand,0) as Feb_11_CSMdemand,
				isnull(aa.Mar_11_CSMdemand,0) as Mar_11_CSMdemand,
				isnull(aa.Apr_11_CSMdemand,0) as Apr_11_CSMdemand,
				isnull(aa.May_11_CSMdemand,0) as May_11_CSMdemand,
				isnull(aa.Jun_11_CSMdemand,0) as Jun_11_CSMdemand,
				isnull(aa.Jul_11_CSMdemand,0) as Jul_11_CSMdemand,
				isnull(aa.Aug_11_CSMdemand,0) as Aug_11_CSMdemand,
				isnull(aa.Sep_11_CSMdemand,0) as Sep_11_CSMdemand,
				isnull(aa.Oct_11_CSMdemand,0) as Oct_11_CSMdemand,
				isnull(aa.Nov_11_CSMdemand,0) as Nov_11_CSMdemand,
				isnull(aa.Dec_11_CSMdemand,0) as Dec_11_CSMdemand,
				isnull(aa.Total_11_CSMdemand,0) as Total_11_CSMdemand,
				isnull(aa.Jan_12_CSMdemand,0) as Jan_12_CSMdemand,
				isnull(aa.Feb_12_CSMdemand,0) as Feb_12_CSMdemand,
				isnull(aa.Mar_12_CSMdemand,0) as Mar_12_CSMdemand,
				isnull(aa.Apr_12_CSMdemand,0) as Apr_12_CSMdemand,
				isnull(aa.May_12_CSMdemand,0) as May_12_CSMdemand,
				isnull(aa.Jun_12_CSMdemand,0) as Jun_12_CSMdemand,
				isnull(aa.Jul_12_CSMdemand,0) as Jul_12_CSMdemand,
				isnull(aa.Aug_12_CSMdemand,0) as Aug_12_CSMdemand,
				isnull(aa.Sep_12_CSMdemand,0) as Sep_12_CSMdemand,
				isnull(aa.Oct_12_CSMdemand,0) as Oct_12_CSMdemand,
				isnull(aa.Nov_12_CSMdemand,0) as Nov_12_CSMdemand,
				isnull(aa.Dec_12_CSMdemand,0) as Dec_12_CSMdemand,
				isnull(aa.Total_12_CSMdemand,0) as Total_12_CSMdemand,		
				isnull(aa.Cal13_CSMdemand,0) as Cal13_CSMdemand,
				isnull(aa.Cal14_CSMdemand,0) as Cal14_CSMdemand,
				isnull(aa.Cal15_CSMdemand,0) as Cal15_CSMdemand,
				isnull(aa.Cal16_CSMdemand,0) as Cal16_CSMdemand,
				isnull(aa.Jan_10_factor,1) as Jan_10_factor,
				isnull(aa.Feb_10_factor,1) as Feb_10_factor,
				isnull(aa.Mar_10_factor,1) as Mar_10_factor,
				isnull(aa.Apr_10_factor,1) as Apr_10_factor,
				isnull(aa.May_10_factor,1) as May_10_factor,
				isnull(aa.Jun_10_factor,1) as Jun_10_factor,
				isnull(aa.Jul_10_factor,1) as Jul_10_factor,
				isnull(aa.Aug_10_factor,1) as Aug_10_factor,
				isnull(aa.Sep_10_factor,1) as Sep_10_factor,
				isnull(aa.Oct_10_factor,1) as Oct_10_factor,
				isnull(aa.Nov_10_factor,1) as Nov_10_factor,
				isnull(aa.Dec_10_factor,1) as Dec_10_factor,
				isnull(aa.Jan_11_factor,1) as Jan_11_factor,
				isnull(aa.Feb_11_factor,1) as Feb_11_factor,
				isnull(aa.Mar_11_factor,1) as Mar_11_factor,
				isnull(aa.Apr_11_factor,1) as Apr_11_factor,
				isnull(aa.May_11_factor,1) as May_11_factor,
				isnull(aa.Jun_11_factor,1) as Jun_11_factor,
				isnull(aa.Jul_11_factor,1) as Jul_11_factor,
				isnull(aa.Aug_11_factor,1) as Aug_11_factor,
				isnull(aa.Sep_11_factor,1) as Sep_11_factor,
				isnull(aa.Oct_11_factor,1) as Oct_11_factor,
				isnull(aa.Nov_11_factor,1) as Nov_11_factor,
				isnull(aa.Dec_11_factor,1) as Dec_11_factor,
				isnull(aa.Jan_12_factor,1) as Jan_12_factor,
				isnull(aa.Feb_12_factor,1) as Feb_12_factor,
				isnull(aa.Mar_12_factor,1) as Mar_12_factor,
				isnull(aa.Apr_12_factor,1) as Apr_12_factor,
				isnull(aa.May_12_factor,1) as May_12_factor,
				isnull(aa.Jun_12_factor,1) as Jun_12_factor,
				isnull(aa.Jul_12_factor,1) as Jul_12_factor,
				isnull(aa.Aug_12_factor,1) as Aug_12_factor,
				isnull(aa.Sep_12_factor,1) as Sep_12_factor,
				isnull(aa.Oct_12_factor,1) as Oct_12_factor,
				isnull(aa.Nov_12_factor,1) as Nov_12_factor,
				isnull(aa.Dec_12_factor,1) as Dec_12_factor,		
				isnull(aa.Cal13_factor,1) as Cal13_factor,
				isnull(aa.Cal14_factor,1) as Cal14_factor,
				isnull(aa.Cal15_factor,1) as Cal15_factor,
				isnull(aa.Cal16_factor,1) as Cal16_factor,
				isnull(bb.Jan_10,0) as Jan_10_Empire_Adj,
				isnull(bb.Feb_10,0) as Feb_10_Empire_Adj,
				isnull(bb.Mar_10,0) as Mar_10_Empire_Adj,
				isnull(bb.Apr_10,0) as Apr_10_Empire_Adj,
				isnull(bb.May_10,0) as May_10_Empire_Adj,
				isnull(bb.Jun_10,0) as Jun_10_Empire_Adj,		
				isnull(bb.Jul_10,0) as Jul_10_Empire_Adj,
				isnull(bb.Aug_10,0) as Aug_10_Empire_Adj,
				isnull(bb.Sep_10,0) as Sep_10_Empire_Adj,		
				isnull(bb.Oct_10,0) as Oct_10_Empire_Adj,
				isnull(bb.Nov_10,0) as Nov_10_Empire_Adj,
				isnull(bb.Dec_10,0) as Dec_10_Empire_Adj,
				isnull(bb.Total_2010,0) as Total_10_Empire_Adj,
				isnull(bb.Jan_11,0) as Jan_11_Empire_Adj,
				isnull(bb.Feb_11,0) as Feb_11_Empire_Adj,
				isnull(bb.Mar_11,0) as Mar_11_Empire_Adj,
				isnull(bb.Apr_11,0) as Apr_11_Empire_Adj,
				isnull(bb.May_11,0) as May_11_Empire_Adj,
				isnull(bb.Jun_11,0) as Jun_11_Empire_Adj,		
				isnull(bb.Jul_11,0) as Jul_11_Empire_Adj,
				isnull(bb.Aug_11,0) as Aug_11_Empire_Adj,
				isnull(bb.Sep_11,0) as Sep_11_Empire_Adj,		
				isnull(bb.Oct_11,0) as Oct_11_Empire_Adj,
				isnull(bb.Nov_11,0) as Nov_11_Empire_Adj,
				isnull(bb.Dec_11,0) as Dec_11_Empire_Adj,
				isnull(bb.Total_2011,0) as Total_11_Empire_Adj,
				isnull(bb.Jan_12,0) as Jan_12_Empire_Adj,
				isnull(bb.Feb_12,0) as Feb_12_Empire_Adj,
				isnull(bb.Mar_12,0) as Mar_12_Empire_Adj,
				isnull(bb.Apr_12,0) as Apr_12_Empire_Adj,
				isnull(bb.May_12,0) as May_12_Empire_Adj,
				isnull(bb.Jun_12,0) as Jun_12_Empire_Adj,		
				isnull(bb.Jul_12,0) as Jul_12_Empire_Adj,
				isnull(bb.Aug_12,0) as Aug_12_Empire_Adj,
				isnull(bb.Sep_12,0) as Sep_12_Empire_Adj,		
				isnull(bb.Oct_12,0) as Oct_12_Empire_Adj,
				isnull(bb.Nov_12,0) as Nov_12_Empire_Adj,
				isnull(bb.Dec_12,0) as Dec_12_Empire_Adj,
				isnull(bb.Total_2012,0) as Total_12_Empire_Adj,
				isnull(bb.Cal13,0) as Cal13_Empire_Adj,
				isnull(bb.Cal14,0) as Cal14_Empire_Adj,
				isnull(bb.Cal15,0) as Cal15_Empire_Adj,
				isnull(bb.Cal16,0) as Cal16_Empire_Adj,			
				isnull(aa.Jan_10_factor,1)*bb.Jan_10 as Jan_10_Allocated_Empire_Adj,
				isnull(aa.Feb_10_factor,1)*bb.Feb_10 as Feb_10_Allocated_Empire_Adj,
				isnull(aa.Mar_10_factor,1)*bb.Mar_10 as Mar_10_Allocated_Empire_Adj,
				isnull(aa.Apr_10_factor,1)*bb.Apr_10 as Apr_10_Allocated_Empire_Adj,
				isnull(aa.May_10_factor,1)*bb.May_10 as May_10_Allocated_Empire_Adj,
				isnull(aa.Jun_10_factor,1)*bb.Jun_10 as Jun_10_Allocated_Empire_Adj,
				isnull(aa.Jul_10_factor,1)*bb.Jul_10 as Jul_10_Allocated_Empire_Adj,
				isnull(aa.Aug_10_factor,1)*bb.Aug_10 as Aug_10_Allocated_Empire_Adj,
				isnull(aa.Sep_10_factor,1)*bb.Sep_10 as Sep_10_Allocated_Empire_Adj,
				isnull(aa.Oct_10_factor,1)*bb.Oct_10 as Oct_10_Allocated_Empire_Adj,
				isnull(aa.Nov_10_factor,1)*bb.Nov_10 as Nov_10_Allocated_Empire_Adj,
				isnull(aa.Dec_10_factor,1)*bb.Dec_10 as Dec_10_Allocated_Empire_Adj,
				((isnull(aa.Jan_10_factor,1)*bb.Jan_10) + (isnull(aa.Feb_10_factor,1)*bb.Feb_10) + (isnull(aa.Mar_10_factor,1)*bb.Mar_10) + (isnull(aa.Apr_10_factor,1)*bb.Apr_10) + (isnull(aa.May_10_factor,1)*bb.May_10) + (isnull(aa.Jun_10_factor,1)*bb.Jun_10) + (isnull(aa.Jul_10_factor,1)*bb.Jul_10) + (isnull(aa.Aug_10_factor,1)*bb.Aug_10) + (isnull(aa.Sep_10_factor,1)*bb.Sep_10) +  (isnull(aa.Oct_10_factor,1)*bb.Oct_10) + (isnull(aa.Nov_10_factor,1)*bb.Nov_10) +  (isnull(aa.Dec_10_factor,1)*bb.Dec_10)) as Total_10_Allocated_Empire_Adj,
				isnull(aa.Jan_11_factor,1)*bb.Jan_11 as Jan_11_Allocated_Empire_Adj,
				isnull(aa.Feb_11_factor,1)*bb.Feb_11 as Feb_11_Allocated_Empire_Adj,
				isnull(aa.Mar_11_factor,1)*bb.Mar_11 as Mar_11_Allocated_Empire_Adj,
				isnull(aa.Apr_11_factor,1)*bb.Apr_11 as Apr_11_Allocated_Empire_Adj,
				isnull(aa.May_11_factor,1)*bb.May_11 as May_11_Allocated_Empire_Adj,
				isnull(aa.Jun_11_factor,1)*bb.Jun_11 as Jun_11_Allocated_Empire_Adj,
				isnull(aa.Jul_11_factor,1)*bb.Jul_11 as Jul_11_Allocated_Empire_Adj,
				isnull(aa.Aug_11_factor,1)*bb.Aug_11 as Aug_11_Allocated_Empire_Adj,
				isnull(aa.Sep_11_factor,1)*bb.Sep_11 as Sep_11_Allocated_Empire_Adj,
				isnull(aa.Oct_11_factor,1)*bb.Oct_11 as Oct_11_Allocated_Empire_Adj,
				isnull(aa.Nov_11_factor,1)*bb.Nov_11 as Nov_11_Allocated_Empire_Adj,
				isnull(aa.Dec_11_factor,1)*bb.Dec_11 as Dec_11_Allocated_Empire_Adj,
				((isnull(aa.Jan_11_factor,1)*bb.Jan_11) + (isnull(aa.Feb_11_factor,1)*bb.Feb_11) + (isnull(aa.Mar_11_factor,1)*bb.Mar_11) + (isnull(aa.Apr_11_factor,1)*bb.Apr_11) + (isnull(aa.May_11_factor,1)*bb.May_11) + (isnull(aa.Jun_11_factor,1)*bb.Jun_11) + (isnull(aa.Jul_11_factor,1)*bb.Jul_11) + (isnull(aa.Aug_11_factor,1)*bb.Aug_11) + (isnull(aa.Sep_11_factor,1)*bb.Sep_11) +  (isnull(aa.Oct_11_factor,1)*bb.Oct_11) + (isnull(aa.Nov_11_factor,1)*bb.Nov_11) +  (isnull(aa.Dec_11_factor,1)*bb.Dec_11)) as Total_11_Allocated_Empire_Adj,
				isnull(aa.Jan_12_factor,1)*bb.Jan_12 as Jan_12_Allocated_Empire_Adj,
				isnull(aa.Feb_12_factor,1)*bb.Feb_12 as Feb_12_Allocated_Empire_Adj,
				isnull(aa.Mar_12_factor,1)*bb.Mar_12 as Mar_12_Allocated_Empire_Adj,
				isnull(aa.Apr_12_factor,1)*bb.Apr_12 as Apr_12_Allocated_Empire_Adj,
				isnull(aa.May_12_factor,1)*bb.May_12 as May_12_Allocated_Empire_Adj,
				isnull(aa.Jun_12_factor,1)*bb.Jun_12 as Jun_12_Allocated_Empire_Adj,
				isnull(aa.Jul_12_factor,1)*bb.Jul_12 as Jul_12_Allocated_Empire_Adj,
				isnull(aa.Aug_12_factor,1)*bb.Aug_12 as Aug_12_Allocated_Empire_Adj,
				isnull(aa.Sep_12_factor,1)*bb.Sep_12 as Sep_12_Allocated_Empire_Adj,
				isnull(aa.Oct_12_factor,1)*bb.Oct_12 as Oct_12_Allocated_Empire_Adj,
				isnull(aa.Nov_12_factor,1)*bb.Nov_12 as Nov_12_Allocated_Empire_Adj,
				isnull(aa.Dec_12_factor,1)*bb.Dec_12 as Dec_12_Allocated_Empire_Adj,
				((isnull(aa.Jan_12_factor,1)*bb.Jan_12) + (isnull(aa.Feb_12_factor,1)*bb.Feb_12) + (isnull(aa.Mar_12_factor,1)*bb.Mar_12) + (isnull(aa.Apr_12_factor,1)*bb.Apr_12) + (isnull(aa.May_12_factor,1)*bb.May_12) + (isnull(aa.Jun_12_factor,1)*bb.Jun_12) + (isnull(aa.Jul_12_factor,1)*bb.Jul_12) + (isnull(aa.Aug_12_factor,1)*bb.Aug_12) + (isnull(aa.Sep_12_factor,1)*bb.Sep_12) +  (isnull(aa.Oct_12_factor,1)*bb.Oct_12) + (isnull(aa.Nov_12_factor,1)*bb.Nov_12) +  (isnull(aa.Dec_12_factor,1)*bb.Dec_12)) as Total_12_Allocated_Empire_Adj,
				isnull(aa.Cal13_factor,1)*bb.Cal13 as Cal13_Allocated_Empire_Adj,
				isnull(aa.Cal14_factor,1)*bb.Cal14 as Cal14_Allocated_Empire_Adj,
				isnull(aa.Cal15_factor,1)*bb.Cal15 as Cal15_Allocated_Empire_Adj,
				isnull(aa.Cal16_factor,1)*bb.Cal16 as Cal16_Allocated_Empire_Adj,
				isnull(aa.Jan_10_CSMdemand,0) + (isnull(aa.Jan_10_factor,1)*isnull(bb.Jan_10,0)) as Jan_10_TOTALdemand,
				isnull(aa.Feb_10_CSMdemand,0) + (isnull(aa.Feb_10_factor,1)*isnull(bb.Feb_10,0)) as Feb_10_TOTALdemand,
				isnull(aa.Mar_10_CSMdemand,0) + (isnull(aa.Mar_10_factor,1)*isnull(bb.Mar_10,0)) as Mar_10_TOTALdemand,
				isnull(aa.Apr_10_CSMdemand,0) + (isnull(aa.Apr_10_factor,1)*isnull(bb.Apr_10,0)) as Apr_10_TOTALdemand,
				isnull(aa.May_10_CSMdemand,0) + (isnull(aa.May_10_factor,1)*isnull(bb.May_10,0)) as May_10_TOTALdemand,
				isnull(aa.Jun_10_CSMdemand,0) + (isnull(aa.Jun_10_factor,1)*isnull(bb.Jun_10,0)) as Jun_10_TOTALdemand,
				isnull(aa.Jul_10_CSMdemand,0) + (isnull(aa.Jul_10_factor,1)*isnull(bb.Jul_10,0)) as Jul_10_TOTALdemand,
				isnull(aa.Aug_10_CSMdemand,0) + (isnull(aa.Aug_10_factor,1)*isnull(bb.Aug_10,0)) as Aug_10_TOTALdemand,
				isnull(aa.Sep_10_CSMdemand,0) + (isnull(aa.Sep_10_factor,1)*isnull(bb.Sep_10,0)) as Sep_10_TOTALdemand,
				isnull(aa.Oct_10_CSMdemand,0) + (isnull(aa.Oct_10_factor,1)*isnull(bb.Oct_10,0)) as Oct_10_TOTALdemand,
				isnull(aa.Nov_10_CSMdemand,0) + (isnull(aa.Nov_10_factor,1)*isnull(bb.Nov_10,0)) as Nov_10_TOTALdemand,
				isnull(aa.Dec_10_CSMdemand,0) + (isnull(aa.Dec_10_factor,1)*isnull(bb.Dec_10,0)) as Dec_10_TOTALdemand,		
				isnull(aa.Total_10_CSMdemand,0) + ((isnull(aa.Jan_10_factor,1)*isnull(bb.Jan_10,0)) + (isnull(aa.Feb_10_factor,1)*isnull(bb.Feb_10,0)) + (isnull(aa.Mar_10_factor,1)*isnull(bb.Mar_10,0)) + (isnull(aa.Apr_10_factor,1)*isnull(bb.Apr_10,0)) + (isnull(aa.May_10_factor,1)*isnull(bb.May_10,0)) + (isnull(aa.Jun_10_factor,1)*isnull(bb.Jun_10,0)) + (isnull(aa.Jul_10_factor,1)*isnull(bb.Jul_10,0)) + (isnull(aa.Aug_10_factor,1)*isnull(bb.Aug_10,0)) + (isnull(aa.Sep_10_factor,1)*isnull(bb.Sep_10,0)) +  (isnull(aa.Oct_10_factor,1)*isnull(bb.Oct_10,0)) + (isnull(aa.Nov_10_factor,1)*isnull(bb.Nov_10,0)) +  (isnull(aa.Dec_10_factor,1)*isnull(bb.Dec_10,0))) as Total_2010_TOTALdemand,
				isnull(aa.Jan_11_CSMdemand,0) + (isnull(aa.Jan_11_factor,1)*isnull(bb.Jan_11,0)) as Jan_11_TOTALdemand,	
				isnull(aa.Feb_11_CSMdemand,0) + (isnull(aa.Feb_11_factor,1)*isnull(bb.Feb_11,0)) as Feb_11_TOTALdemand,
				isnull(aa.Mar_11_CSMdemand,0) + (isnull(aa.Mar_11_factor,1)*isnull(bb.Mar_11,0)) as Mar_11_TOTALdemand,
				isnull(aa.Apr_11_CSMdemand,0) + (isnull(aa.Apr_11_factor,1)*isnull(bb.Apr_11,0)) as Apr_11_TOTALdemand,	
				isnull(aa.May_11_CSMdemand,0) + (isnull(aa.May_11_factor,1)*isnull(bb.May_11,0)) as May_11_TOTALdemand,
				isnull(aa.Jun_11_CSMdemand,0) + (isnull(aa.Jun_11_factor,1)*isnull(bb.Jun_11,0)) as Jun_11_TOTALdemand,
				isnull(aa.Jul_11_CSMdemand,0) + (isnull(aa.Jul_11_factor,1)*isnull(bb.Jul_11,0)) as Jul_11_TOTALdemand,
				isnull(aa.Aug_11_CSMdemand,0) + (isnull(aa.Aug_11_factor,1)*isnull(bb.Aug_11,0)) as Aug_11_TOTALdemand,
				isnull(aa.Sep_11_CSMdemand,0) + (isnull(aa.Sep_11_factor,1)*isnull(bb.Sep_11,0)) as Sep_11_TOTALdemand,
				isnull(aa.Oct_11_CSMdemand,0) + (isnull(aa.Oct_11_factor,1)*isnull(bb.Oct_11,0)) as Oct_11_TOTALdemand,
				isnull(aa.Nov_11_CSMdemand,0) + (isnull(aa.Nov_11_factor,1)*isnull(bb.Nov_11,0)) as Nov_11_TOTALdemand,
				isnull(aa.Dec_11_CSMdemand,0) + (isnull(aa.Dec_11_factor,1)*isnull(bb.Dec_11,0)) as Dec_11_TOTALdemand,		
				isnull(aa.Total_11_CSMdemand,0) + ((isnull(aa.Jan_11_factor,1)*isnull(bb.Jan_11,0)) + (isnull(aa.Feb_11_factor,1)*isnull(bb.Feb_11,0)) + (isnull(aa.Mar_11_factor,1)*isnull(bb.Mar_11,0)) + (isnull(aa.Apr_11_factor,1)*isnull(bb.Apr_11,0)) + (isnull(aa.May_11_factor,1)*isnull(bb.May_11,0)) + (isnull(aa.Jun_11_factor,1)*isnull(bb.Jun_11,0)) + (isnull(aa.Jul_11_factor,1)*isnull(bb.Jul_11,0)) + (isnull(aa.Aug_11_factor,1)*isnull(bb.Aug_11,0)) + (isnull(aa.Sep_11_factor,1)*isnull(bb.Sep_11,0)) +  (isnull(aa.Oct_11_factor,1)*isnull(bb.Oct_11,0)) + (isnull(aa.Nov_11_factor,1)*isnull(bb.Nov_11,0)) +  (isnull(aa.Dec_11_factor,1)*isnull(bb.Dec_11,0))) as Total_2011_TOTALdemand,
				isnull(aa.Jan_12_CSMdemand,0) + (isnull(aa.Jan_12_factor,1)*isnull(bb.Jan_12,0)) as Jan_12_TOTALdemand,
				isnull(aa.Feb_12_CSMdemand,0) + (isnull(aa.Feb_12_factor,1)*isnull(bb.Feb_12,0)) as Feb_12_TOTALdemand,
				isnull(aa.Mar_12_CSMdemand,0) + (isnull(aa.Mar_12_factor,1)*isnull(bb.Mar_12,0)) as Mar_12_TOTALdemand,
				isnull(aa.Apr_12_CSMdemand,0) + (isnull(aa.Apr_12_factor,1)*isnull(bb.Apr_12,0)) as Apr_12_TOTALdemand,
				isnull(aa.May_12_CSMdemand,0) + (isnull(aa.May_12_factor,1)*isnull(bb.May_12,0)) as May_12_TOTALdemand,
				isnull(aa.Jun_12_CSMdemand,0) + (isnull(aa.Jun_12_factor,1)*isnull(bb.Jun_12,0)) as Jun_12_TOTALdemand,
				isnull(aa.Jul_12_CSMdemand,0) + (isnull(aa.Jul_12_factor,1)*isnull(bb.Jul_12,0)) as Jul_12_TOTALdemand,
				isnull(aa.Aug_12_CSMdemand,0) + (isnull(aa.Aug_12_factor,1)*isnull(bb.Aug_12,0)) as Aug_12_TOTALdemand,
				isnull(aa.Sep_12_CSMdemand,0) + (isnull(aa.Sep_12_factor,1)*isnull(bb.Sep_12,0)) as Sep_12_TOTALdemand,
				isnull(aa.Oct_12_CSMdemand,0) + (isnull(aa.Oct_12_factor,1)*isnull(bb.Oct_12,0)) as Oct_12_TOTALdemand,
				isnull(aa.Nov_12_CSMdemand,0) + (isnull(aa.Nov_12_factor,1)*isnull(bb.Nov_12,0)) as Nov_12_TOTALdemand,
				isnull(aa.Dec_12_CSMdemand,0) + (isnull(aa.Dec_12_factor,1)*isnull(bb.Dec_12,0)) as Dec_12_TOTALdemand,		
				isnull(aa.Total_12_CSMdemand,0) + ((isnull(aa.Jan_12_factor,1)*isnull(bb.Jan_12,0)) + (isnull(aa.Feb_12_factor,1)*isnull(bb.Feb_12,0)) + (isnull(aa.Mar_12_factor,1)*isnull(bb.Mar_12,0)) + (isnull(aa.Apr_12_factor,1)*isnull(bb.Apr_12,0)) + (isnull(aa.May_12_factor,1)*isnull(bb.May_12,0)) + (isnull(aa.Jun_12_factor,1)*isnull(bb.Jun_12,0)) + (isnull(aa.Jul_12_factor,1)*isnull(bb.Jul_12,0)) + (isnull(aa.Aug_12_factor,1)*isnull(bb.Aug_12,0)) + (isnull(aa.Sep_12_factor,1)*isnull(bb.Sep_12,0)) +  (isnull(aa.Oct_12_factor,1)*isnull(bb.Oct_12,0)) + (isnull(aa.Nov_12_factor,1)*isnull(bb.Nov_12,0)) +  (isnull(aa.Dec_12_factor,1)*isnull(bb.Dec_12,0))) as Total_2012_TOTALdemand,
				isnull(aa.Cal13_CSMdemand,0) + (isnull(aa.Cal13_factor,1)*isnull(bb.Cal13,0)) as Cal13_TOTALdemand,	
				isnull(aa.Cal14_CSMdemand,0) + (isnull(aa.Cal14_factor,1)*isnull(bb.Cal14,0)) as Cal14_TOTALdemand,	
				isnull(aa.Cal15_CSMdemand,0) + (isnull(aa.Cal15_factor,1)*isnull(bb.Cal15,0)) as Cal15_TOTALdemand,	
				isnull(aa.Cal16_CSMdemand,0) + (isnull(aa.Cal16_factor,1)*isnull(bb.Cal16,0)) as Cal16_TOTALdemand	
		from

				/* LEVEL 3 */
				/* STATEMENT 3aa BEGINS */
				(SELECT a.base_part,
						a.version,
						a.empire_market_segment,
						a.empire_application,
						a.badge,
						a.manufacturer,
						a.mnemonic,
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
						a.EMPIRE_SOP,
						a.EMPIRE_EOP,  
						a.qty_per, 
						a.take_rate, 
						a.family_allocation,
						a.jan_10 as Jan_10_CSMdemand,
						a.feb_10 as Feb_10_CSMdemand,
						a.mar_10 as Mar_10_CSMdemand,
						a.apr_10 as Apr_10_CSMdemand,
						a.may_10 as May_10_CSMdemand,
						a.jun_10 as Jun_10_CSMdemand,
						a.jul_10 as Jul_10_CSMdemand,
						a.aug_10 as Aug_10_CSMdemand,
						a.sep_10 as Sep_10_CSMdemand,
						a.oct_10 as Oct_10_CSMdemand,
						a.nov_10 as Nov_10_CSMdemand,
						a.dec_10 as Dec_10_CSMdemand, 
						a.total_2010 as Total_10_CSMdemand, 
						a.jan_11 as Jan_11_CSMdemand,
						a.feb_11 as Feb_11_CSMdemand,
						a.mar_11 as Mar_11_CSMdemand,
						a.apr_11 as Apr_11_CSMdemand,
						a.may_11 as May_11_CSMdemand,
						a.jun_11 as Jun_11_CSMdemand,
						a.jul_11 as Jul_11_CSMdemand,
						a.aug_11 as Aug_11_CSMdemand,
						a.sep_11 as Sep_11_CSMdemand,
						a.oct_11 as Oct_11_CSMdemand,
						a.nov_11 as Nov_11_CSMdemand,
						a.dec_11 as Dec_11_CSMdemand, 
						a.total_2011 as Total_11_CSMdemand, 
						a.jan_12 as Jan_12_CSMdemand,
						a.feb_12 as Feb_12_CSMdemand,
						a.mar_12 as Mar_12_CSMdemand,
						a.apr_12 as Apr_12_CSMdemand,
						a.may_12 as May_12_CSMdemand,
						a.jun_12 as Jun_12_CSMdemand,
						a.jul_12 as Jul_12_CSMdemand,
						a.aug_12 as Aug_12_CSMdemand,
						a.sep_12 as Sep_12_CSMdemand,
						a.oct_12 as Oct_12_CSMdemand,
						a.nov_12 as Nov_12_CSMdemand,
						a.dec_12 as Dec_12_CSMdemand, 
						a.total_2012 as Total_12_CSMdemand,
						a.cal13 as Cal13_CSMdemand,
						a.cal14 as Cal14_CSMdemand,
						a.cal15 as CAL15_CSMdemand,
						a.cal16 as Cal16_CSMdemand,
						(case when isnull(b.jan_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.jan_10/NULLIF(b.jan_10,0) end) as jan_10_factor, 
						(case when isnull(b.feb_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.feb_10/NULLIF(b.feb_10,0) end) as feb_10_factor,
						(case when isnull(b.mar_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.mar_10/NULLIF(b.mar_10,0) end) as mar_10_factor,
						(case when isnull(b.apr_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.apr_10/NULLIF(b.apr_10,0) end) as apr_10_factor,
						(case when isnull(b.may_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.may_10/NULLIF(b.may_10,0) end) as may_10_factor,
						(case when isnull(b.jun_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.jun_10/NULLIF(b.jun_10,0) end) as jun_10_factor,
						(case when isnull(b.jul_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.jul_10/NULLIF(b.jul_10,0) end) as jul_10_factor, 
						(case when isnull(b.aug_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.aug_10/NULLIF(b.aug_10,0) end) as aug_10_factor,
						(case when isnull(b.sep_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.sep_10/NULLIF(b.sep_10,0) end) as sep_10_factor,
						(case when isnull(b.oct_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.oct_10/NULLIF(b.oct_10,0) end) as oct_10_factor,
						(case when isnull(b.nov_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0)else a.nov_10/NULLIF(b.nov_10,0) end) as nov_10_factor,
						(case when isnull(b.dec_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.dec_10/NULLIF(b.dec_10,0) end) as dec_10_factor,
						(case when isnull(b.jan_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.jan_11/NULLIF(b.jan_11,0) end) as jan_11_factor, 
						(case when isnull(b.feb_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.feb_11/NULLIF(b.feb_11,0) end) as feb_11_factor,
						(case when isnull(b.mar_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.mar_11/NULLIF(b.mar_11,0) end) as mar_11_factor,
						(case when isnull(b.apr_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.apr_11/NULLIF(b.apr_11,0) end) as apr_11_factor,
						(case when isnull(b.may_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.may_11/NULLIF(b.may_11,0) end) as may_11_factor,
						(case when isnull(b.jun_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.jun_11/NULLIF(b.jun_11,0) end) as jun_11_factor,
						(case when isnull(b.jul_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.jul_11/NULLIF(b.jul_11,0) end) as jul_11_factor, 
						(case when isnull(b.aug_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.aug_11/NULLIF(b.aug_11,0) end) as aug_11_factor,
						(case when isnull(b.sep_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.sep_11/NULLIF(b.sep_11,0) end) as sep_11_factor,
						(case when isnull(b.oct_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.oct_11/NULLIF(b.oct_11,0) end) as oct_11_factor,
						(case when isnull(b.nov_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.nov_11/NULLIF(b.nov_11,0) end) as nov_11_factor,
						(case when isnull(b.dec_11,0)=0 then a.total_2011/NULLIF(b.total_2011,0) else a.dec_11/NULLIF(b.dec_11,0) end) as dec_11_factor,
						(case when isnull(b.jan_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.jan_12/NULLIF(b.jan_12,0) end) as jan_12_factor, 
						(case when isnull(b.feb_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.feb_12/NULLIF(b.feb_12,0) end) as feb_12_factor,
						(case when isnull(b.mar_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.mar_12/NULLIF(b.mar_12,0) end) as mar_12_factor,
						(case when isnull(b.apr_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.apr_12/NULLIF(b.apr_12,0) end) as apr_12_factor,
						(case when isnull(b.may_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.may_12/NULLIF(b.may_12,0) end) as may_12_factor,
						(case when isnull(b.jun_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.jun_12/NULLIF(b.jun_12,0) end) as jun_12_factor,
						(case when isnull(b.jul_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.jul_12/NULLIF(b.jul_12,0) end) as jul_12_factor, 
						(case when isnull(b.aug_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.aug_12/NULLIF(b.aug_12,0) end) as aug_12_factor,
						(case when isnull(b.sep_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.sep_12/NULLIF(b.sep_12,0) end) as sep_12_factor,
						(case when isnull(b.oct_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.oct_12/NULLIF(b.oct_12,0) end) as oct_12_factor,
						(case when isnull(b.nov_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.nov_12/NULLIF(b.nov_12,0) end) as nov_12_factor,
						(case when isnull(b.dec_12,0)=0 then a.total_2012/NULLIF(b.total_2012,0) else a.dec_12/NULLIF(b.dec_12,0) end) as dec_12_factor,
						(case when isnull(b.cal13,0)=0 then 1 else a.cal13/NULLIF(b.cal13,0) end) as cal13_factor,
						(case when isnull(b.cal14,0)=0 then 1 else a.cal14/NULLIF(b.cal14,0) end) as cal14_factor,
						(case when isnull(b.cal15,0)=0 then 1 else a.cal15/NULLIF(b.cal15,0) end) as cal15_factor,
						(case when isnull(b.cal16,0)=0 then 1 else a.cal16/NULLIF(b.cal16,0) end) as cal16_factor
				from
					
						/* LEVEL 4 */
						/* STATEMENT 4a BEGINS*/
						(SELECT b.version,
								a.base_part,
								a.empire_market_segment,
								a.empire_application,
								b.badge,
								b.manufacturer, 
								b.mnemonic, 
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
								a.EMPIRE_SOP,
								a.EMPIRE_EOP,  
								a.qty_per, 
								a.take_rate, 
								a.family_allocation, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_10*c.jan_10,0) as jan_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_10*c.feb_10,0) as feb_10,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_10*c.mar_10,0) as mar_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_10*c.apr_10,0) as apr_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_10*c.may_10,0) as may_10,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_10*c.jun_10,0) as jun_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_10*c.jul_10,0) as jul_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_10*c.aug_10,0) as aug_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_10*c.sep_10,0) as sep_10,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_10*c.oct_10,0) as oct_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_10*c.nov_10,0) as nov_10, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_10*c.dec_10,0) as dec_10,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_10*c.jan_10,0)+ISNULL(b.feb_10*c.feb_10,0)+ISNULL(b.mar_10*c.mar_10,0)+ISNULL(b.apr_10*c.apr_10,0)+ISNULL(b.may_10*c.may_10,0)+ISNULL(b.jun_10*c.jun_10,0)+ISNULL(b.jul_10*c.jul_10,0)+ISNULL(b.aug_10*c.aug_10,0)+ISNULL(b.sep_10*c.sep_10,0)+ISNULL(b.oct_10*c.oct_10,0)+ISNULL(b.nov_10*c.nov_10,0)+ISNULL(b.dec_10*c.dec_10,0)) as total_2010,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_11*c.jan_11,0) as jan_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_11*c.feb_11,0) as feb_11,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_11*c.mar_11,0) as mar_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_11*c.apr_11,0) as apr_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_11*c.may_11,0) as may_11,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_11*c.jun_11,0) as jun_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_11*c.jul_11,0) as jul_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_11*c.aug_11,0) as aug_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_11*c.sep_11,0) as sep_11,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_11*c.oct_11,0) as oct_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_11*c.nov_11,0) as nov_11, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_11*c.dec_11,0) as dec_11,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_11*c.jan_11,0)+ISNULL(b.feb_11*c.feb_11,0)+ISNULL(b.mar_11*c.mar_11,0)+ISNULL(b.apr_11*c.apr_11,0)+ISNULL(b.may_11*c.may_11,0)+ISNULL(b.jun_11*c.jun_11,0)+ISNULL(b.jul_11*c.jul_11,0)+ISNULL(b.aug_11*c.aug_11,0)+ISNULL(b.sep_11*c.sep_11,0)+ISNULL(b.oct_11*c.oct_11,0)+ISNULL(b.nov_11*c.nov_11,0)+ISNULL(b.dec_11*c.dec_11,0)) as total_2011,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_12*c.jan_12,0) as jan_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_12*c.feb_12,0) as feb_12,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_12*c.mar_12,0) as mar_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_12*c.apr_12,0) as apr_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_12*c.may_12,0) as may_12,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_12*c.jun_12,0) as jun_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_12*c.jul_12,0) as jul_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_12*c.aug_12,0) as aug_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_12*c.sep_12,0) as sep_12,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_12*c.oct_12,0) as oct_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_12*c.nov_12,0) as nov_12, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_12*c.dec_12,0) as dec_12,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12*c.jan_12,0)+ISNULL(b.feb_12*c.feb_12,0)+ISNULL(b.mar_12*c.mar_12,0)+ISNULL(b.apr_12*c.apr_12,0)+ISNULL(b.may_12*c.may_12,0)+ISNULL(b.jun_12*c.jun_12,0)+ISNULL(b.jul_12*c.jul_12,0)+ISNULL(b.aug_12*c.aug_12,0)+ISNULL(b.sep_12*c.sep_12,0)+ISNULL(b.oct_12*c.oct_12,0)+ISNULL(b.nov_12*c.nov_12,0)+ISNULL(b.dec_12*c.dec_12,0)) as total_2012,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal13*c.cal13,0) as cal13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal14*c.cal14,0) as cal14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal15*c.cal15,0) as cal15, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal16*c.cal16,0) as cal16   
						from	
					
								/* LEVEL 5 */
								(select * from eeiuser.acctg_csm_base_part_mnemonic
								) a 
								left outer join 
								(select * from eeiuser.acctg_csm_NACSM where release_id = (SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and version = 'CSM'
								) b
								on a.mnemonic = b.mnemonic 
						 		left outer join
								(select	a.base_part,
										a.empire_market_segment,
										a.empire_application,
										b.badge,
										b.manufacturer, 
										b.mnemonic, 
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
										a.EMPIRE_SOP,
										a.EMPIRE_EOP,  
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
										ISNULL(b.jan_10,0) as jan_10, 
										ISNULL(b.feb_10,0) as feb_10,
										ISNULL(b.mar_10,0) as mar_10, 
										ISNULL(b.apr_10,0) as apr_10, 
										ISNULL(b.may_10,0) as may_10,
										ISNULL(b.jun_10,0) as jun_10, 
										ISNULL(b.jul_10,0) as jul_10, 
										ISNULL(b.aug_10,0) as aug_10, 
										ISNULL(b.sep_10,0) as sep_10,  
										ISNULL(b.oct_10,0) as oct_10, 
										ISNULL(b.nov_10,0) as nov_10, 
										ISNULL(b.dec_10,0) as dec_10,  
										(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as total_2010,
										ISNULL(b.jan_11,0) as jan_11, 
										ISNULL(b.feb_11,0) as feb_11,
										ISNULL(b.mar_11,0) as mar_11, 
										ISNULL(b.apr_11,0) as apr_11, 
										ISNULL(b.may_11,0) as may_11,
										ISNULL(b.jun_11,0) as jun_11, 
										ISNULL(b.jul_11,0) as jul_11, 
										ISNULL(b.aug_11,0) as aug_11, 
										ISNULL(b.sep_11,0) as sep_11,  
										ISNULL(b.oct_11,0) as oct_11, 
										ISNULL(b.nov_11,0) as nov_11, 
										ISNULL(b.dec_11,0) as dec_11,  
										(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as total_2011,
										ISNULL(b.jan_12,0) as jan_12, 
										ISNULL(b.feb_12,0) as feb_12,
										ISNULL(b.mar_12,0) as mar_12, 
										ISNULL(b.apr_12,0) as apr_12, 
										ISNULL(b.may_12,0) as may_12,
										ISNULL(b.jun_12,0) as jun_12, 
										ISNULL(b.jul_12,0) as jul_12, 
										ISNULL(b.aug_12,0) as aug_12, 
										ISNULL(b.sep_12,0) as sep_12,  
										ISNULL(b.oct_12,0) as oct_12, 
										ISNULL(b.nov_12,0) as nov_12, 
										ISNULL(b.dec_12,0) as dec_12,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
										ISNULL(b.cal13,0) as cal13, 
										ISNULL(b.cal14,0) as cal14, 
										ISNULL(b.cal15,0) as cal15, 
										ISNULL(b.cal16,0) as cal16    
								from 
								
										/* LEVEL 6 */
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
										left outer join
										(select * from eeiuser.acctg_csm_NACSM where release_id = (Select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and version = 'Empire Factor'
										) b
										on a.mnemonic = b.mnemonic
										
										where b.mnemonic is not null 
								) c
								on a.base_part = c.base_part
								
							 	where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)) <>  0 
												
						)a

						full outer join

						(SELECT a.base_part,
								sum(a.jan_10*b.jan_10) as jan_10, 
								sum(a.feb_10*b.feb_10) as feb_10, 
								sum(a.mar_10*b.mar_10) as mar_10, 
								sum(a.apr_10*b.apr_10) as apr_10, 
								sum(a.may_10*b.may_10) as may_10, 
								sum(a.jun_10*b.jun_10) as jun_10, 
								sum(a.jul_10*b.jul_10) as jul_10, 
								sum(a.aug_10*b.aug_10) as aug_10,
								sum(a.sep_10*b.sep_10) as sep_10, 
								sum(a.oct_10*b.oct_10) as oct_10, 
								sum(a.nov_10*b.nov_10) as nov_10, 
								sum(a.dec_10*b.dec_10) as dec_10,
								(sum(a.jan_10*b.jan_10)+sum(a.feb_10*b.feb_10)+sum(a.mar_10*b.mar_10)+sum(a.apr_10*b.apr_10)+sum(a.may_10*b.may_10)+sum(a.jun_10*b.jun_10)+sum(a.jul_10*b.jul_10)+sum(a.aug_10*b.aug_10)+sum(a.sep_10*b.sep_10)+sum(a.oct_10*b.oct_10)+sum(a.nov_10*b.nov_10)+sum(a.dec_10*b.dec_10)) as total_2010,
								sum(a.jan_11*b.jan_11) as jan_11, 
								sum(a.feb_11*b.feb_11) as feb_11, 
								sum(a.mar_11*b.mar_11) as mar_11, 
								sum(a.apr_11*b.apr_11) as apr_11, 
								sum(a.may_11*b.may_11) as may_11, 
								sum(a.jun_11*b.jun_11) as jun_11, 
								sum(a.jul_11*b.jul_11) as jul_11, 
								sum(a.aug_11*b.aug_11) as aug_11,
								sum(a.sep_11*b.sep_11) as sep_11, 
								sum(a.oct_11*b.oct_11) as oct_11, 
								sum(a.nov_11*b.nov_11) as nov_11, 
								sum(a.dec_11*b.dec_11) as dec_11,
								(sum(a.jan_11*b.jan_11)+sum(a.feb_11*b.feb_11)+sum(a.mar_11*b.mar_11)+sum(a.apr_11*b.apr_11)+sum(a.may_11*b.may_11)+sum(a.jun_11*b.jun_11)+sum(a.jul_11*b.jul_11)+sum(a.aug_11*b.aug_11)+sum(a.sep_11*b.sep_11)+sum(a.oct_11*b.oct_11)+sum(a.nov_11*b.nov_11)+sum(a.dec_11*b.dec_11)) as total_2011,
								sum(a.jan_12*b.jan_12) as jan_12, 
								sum(a.feb_12*b.feb_12) as feb_12, 
								sum(a.mar_12*b.mar_12) as mar_12, 
								sum(a.apr_12*b.apr_12) as apr_12, 
								sum(a.may_12*b.may_12) as may_12, 
								sum(a.jun_12*b.jun_12) as jun_12, 
								sum(a.jul_12*b.jul_12) as jul_12, 
								sum(a.aug_12*b.aug_12) as aug_12,
								sum(a.sep_12*b.sep_12) as sep_12, 
								sum(a.oct_12*b.oct_12) as oct_12, 
								sum(a.nov_12*b.nov_12) as nov_12, 
								sum(a.dec_12*b.dec_12) as dec_12,
								(sum(a.jan_12*b.jan_12)+sum(a.feb_12*b.feb_12)+sum(a.mar_12*b.mar_12)+sum(a.apr_12*b.apr_12)+sum(a.may_12*b.may_12)+sum(a.jun_12*b.jun_12)+sum(a.jul_12*b.jul_12)+sum(a.aug_12*b.aug_12)+sum(a.sep_12*b.sep_12)+sum(a.oct_12*b.oct_12)+sum(a.nov_12*b.nov_12)+sum(a.dec_12*b.dec_12)) as total_2012,
								sum(a.cal13*b.cal13) as cal13, 
								sum(a.cal14*b.cal14) as cal14, 
								sum(a.cal15*b.cal15) as cal15, 
								sum(a.cal16*b.cal16) as cal16
						from 
												
								(select	a.base_part,
										a.empire_market_segment,
										a.empire_application,
										b.badge,
										b.manufacturer, 
										b.mnemonic, 
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
										a.EMPIRE_SOP,
										a.EMPIRE_EOP,  
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_10,0) as jan_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_10,0) as feb_10,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_10,0) as mar_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_10,0) as apr_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_10,0) as may_10,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_10,0) as jun_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_10,0) as jul_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_10,0) as aug_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_10,0) as sep_10,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_10,0) as oct_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_10,0) as nov_10, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_10,0) as dec_10,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as total_2010,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_11,0) as jan_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_11,0) as feb_11,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_11,0) as mar_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_11,0) as apr_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_11,0) as may_11,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_11,0) as jun_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_11,0) as jul_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_11,0) as aug_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_11,0) as sep_11,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_11,0) as oct_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_11,0) as nov_11, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_11,0) as dec_11,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as total_2011,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_12,0) as jan_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_12,0) as feb_12,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_12,0) as mar_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_12,0) as apr_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_12,0) as may_12,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_12,0) as jun_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_12,0) as jul_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_12,0) as aug_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_12,0) as sep_12,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_12,0) as oct_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_12,0) as nov_12, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_12,0) as dec_12,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal13,0) as cal13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal14,0) as cal14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal15,0) as cal15, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal16,0) as cal16   
								from	
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a 
								
										left outer join 
								
										( select * from eeiuser.acctg_csm_NACSM where release_id = (Select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and version = 'CSM'
										) b
										on a.mnemonic = b.mnemonic 
								 
								 		where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)) <>  0 
								) a
						
								left join
							
								(select	a.base_part,
										a.empire_market_segment,
										a.empire_application,
										b.badge,
										b.manufacturer, 
										b.mnemonic, 
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
										a.EMPIRE_SOP,
										a.EMPIRE_EOP,  
										a.qty_per, 
										a.take_rate, 
										a.family_allocation, 
										ISNULL(b.jan_10,0) as jan_10, 
										ISNULL(b.feb_10,0) as feb_10,
										ISNULL(b.mar_10,0) as mar_10, 
										ISNULL(b.apr_10,0) as apr_10, 
										ISNULL(b.may_10,0) as may_10,
										ISNULL(b.jun_10,0) as jun_10, 
										ISNULL(b.jul_10,0) as jul_10, 
										ISNULL(b.aug_10,0) as aug_10, 
										ISNULL(b.sep_10,0) as sep_10,  
										ISNULL(b.oct_10,0) as oct_10, 
										ISNULL(b.nov_10,0) as nov_10, 
										ISNULL(b.dec_10,0) as dec_10,  
										(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as total_2010,
										ISNULL(b.jan_11,0) as jan_11, 
										ISNULL(b.feb_11,0) as feb_11,
										ISNULL(b.mar_11,0) as mar_11, 
										ISNULL(b.apr_11,0) as apr_11, 
										ISNULL(b.may_11,0) as may_11,
										ISNULL(b.jun_11,0) as jun_11, 
										ISNULL(b.jul_11,0) as jul_11, 
										ISNULL(b.aug_11,0) as aug_11, 
										ISNULL(b.sep_11,0) as sep_11,  
										ISNULL(b.oct_11,0) as oct_11, 
										ISNULL(b.nov_11,0) as nov_11, 
										ISNULL(b.dec_11,0) as dec_11,  
										(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) as total_2011,
										ISNULL(b.jan_12,0) as jan_12, 
										ISNULL(b.feb_12,0) as feb_12,
										ISNULL(b.mar_12,0) as mar_12, 
										ISNULL(b.apr_12,0) as apr_12, 
										ISNULL(b.may_12,0) as may_12,
										ISNULL(b.jun_12,0) as jun_12, 
										ISNULL(b.jul_12,0) as jul_12, 
										ISNULL(b.aug_12,0) as aug_12, 
										ISNULL(b.sep_12,0) as sep_12,  
										ISNULL(b.oct_12,0) as oct_12, 
										ISNULL(b.nov_12,0) as nov_12, 
										ISNULL(b.dec_12,0) as dec_12,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
										ISNULL(b.cal13,0) as cal13, 
										ISNULL(b.cal14,0) as cal14, 
										ISNULL(b.cal15,0) as cal15, 
										ISNULL(b.cal16,0) as cal16    
								
								from 
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
								
										left outer join
									
										( select * from eeiuser.acctg_csm_NACSM where release_id = (Select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and version = 'Empire Factor'
										) b
										
										on a.mnemonic = b.mnemonic
									
										where b.mnemonic is not null 
								) b
								on a.base_part = b.base_part
								group by a.base_part 
						) b
							
						on a.base_part = b.base_part 
				) aa
				/* STATEMENT 3aa ENDS */

				full outer join

				/* STATEMENT 3bb BEGINDS */
				(select b.version,
						a.base_part,
						a.empire_market_segment,
						a.empire_application,
						b.badge,
						b.manufacturer, 
						b.mnemonic, 
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
						a.Empire_SOP,
						a.Empire_EOP,
						a.qty_per, 
						a.take_rate, 
						a.family_allocation, 
						ISNULL(b.jan_10,0) as jan_10, 
						ISNULL(b.feb_10,0) as feb_10, 
						ISNULL(b.mar_10,0) as mar_10, 
						ISNULL(b.apr_10,0) as apr_10, 
						ISNULL(b.may_10,0) as may_10, 
						ISNULL(b.jun_10,0) as jun_10, 
						ISNULL(b.jul_10,0) as jul_10, 
						ISNULL(b.aug_10,0) as aug_10, 
						ISNULL(b.sep_10,0) as sep_10, 
						ISNULL(b.oct_10,0) as oct_10, 
						ISNULL(b.nov_10,0) as nov_10, 
						ISNULL(b.dec_10,0) as dec_10, 
						(ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) as total_2010,
						ISNULL(b.jan_11,0) as jan_11, 
						ISNULL(b.feb_11,0) as feb_11, 
						ISNULL(b.mar_11,0) as mar_11, 
						ISNULL(b.apr_11,0) as apr_11, 
						ISNULL(b.may_11,0) as may_11, 
						ISNULL(b.jun_11,0) as jun_11, 
						ISNULL(b.jul_11,0) as jul_11, 
						ISNULL(b.aug_11,0) as aug_11, 
						ISNULL(b.sep_11,0) as sep_11, 
						ISNULL(b.oct_11,0) as oct_11, 
						ISNULL(b.nov_11,0) as nov_11, 
						ISNULL(b.dec_11,0) as dec_11, 
						(ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0))  as total_2011,
						ISNULL(b.jan_12,0) as jan_12, 
						ISNULL(b.feb_12,0) as feb_12, 
						ISNULL(b.mar_12,0) as mar_12, 
						ISNULL(b.apr_12,0) as apr_12, 
						ISNULL(b.may_12,0) as may_12, 
						ISNULL(b.jun_12,0) as jun_12, 
						ISNULL(b.jul_12,0) as jul_12, 
						ISNULL(b.aug_12,0) as aug_12, 
						ISNULL(b.sep_12,0) as sep_12, 
						ISNULL(b.oct_12,0) as oct_12, 
						ISNULL(b.nov_12,0) as nov_12, 
						ISNULL(b.dec_12,0) as dec_12, 
						(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0))  as total_2012,
						ISNULL(b.cal13,0) as cal13,
						ISNULL(b.cal14,0) as cal14,
						ISNULL(b.cal15,0) as cal15,
						ISNULL(b.cal16,0) as cal16
				from    
						(select * from eeiuser.acctg_csm_base_part_mnemonic
						) a 
						left outer join 
						(select * from eeiuser.acctg_csm_NACSM where release_id = (SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
						) b
						on b.mnemonic = a.mnemonic 
						where	b.version = 'Empire'
							and b.mnemonic is not null
							and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)) <>  0
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
		where cc.base_part not in (select base_part from eeiuser.acctg_csm_excluded_base_parts where release_id = (SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and include_in_forecast = 0)





GO
