SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view  [EEIUser].[acctg_csm_vw_sales_forecast_comparison]
as 


select * from 

/* LEVEL 1 */
(select	(SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) as [csm_release1]
		,(case when left(cc.base_part,3) = 'GUI' then 'VPP' else left(cc.base_part,3) end) as customer1
		,cc.[base_part] as [base_part1]
		,[version] as [version1]
		,[mnemonic] as mnemonic1
		,[platform] as platform1
		,[program] as program1
		,[manufacturer] as manufacturer1
		,[badge] as badge1
		,[vehicle] as vehicle1
		,[assembly_plant] as assembly_plant1
		,[empire_market_segment] as empire_market_segment1
		,[empire_application] as empire_application1
		,[product_type] as product_type1
		,[global_segment] as global_segment1
		,[regional_segment] as regional_segment1
		,(case when (datediff(d,ISNULL([EMPIRE_eop],[CSM_eop]),getdate()) > 90) then 'Service' else (case when (datediff(d,ISNULL([EMPIRE_eop],[CSM_eop]),getdate()) between -180 and 90) then 'Closeout' else (case when (datediff(d,ISNULL([EMPIRE_sop],[CSM_sop]),getdate()) between -180 and 90) then 'Launch' else (case when (datediff(d,ISNULL([EMPIRE_sop],[CSM_sop]),getdate()) < -180) then 'Pre-Launch' else 'Production' end)end)end)end) as status1
		,[CSM_sop] as CSM_sop1
		,[CSM_eop] as CSM_sop2
		,[csm_sop] as 'CSM_sop_display1'
		,[csm_eop] as 'CSM_eop_display1'
		,[EMPIRE_sop] as EMPIRE_sop1
		,[EMPIRE_eop] as EMPIRE_eop1
		,ISNULL([EMPIRE_sop],[CSM_sop]) as [sop1]
		,ISNULL([EMPIRE_eop],[CSM_eop]) as [eop1]
		,ISNULL([EMPIRE_sop],[CSM_sop]) as [sop_display1]
		,ISNULL([EMPIRE_eop],[CSM_eop]) as [eop_display1]
		,DATEDIFF(mm,ISNULL([empire_sop],[csm_sop]),isnull([empire_eop],[csm_eop])) as [empire_duration_mo1]
		,[qty_per] as qty_per1
		,[take_rate] as take_rate1
		,[family_allocation] as family_allocation1
		
		,[Jan_10_CSMdemand] as Jan_10_CSMdemand1
		,[Feb_10_CSMdemand] as Feb_10_CSMdemand1
		,[Mar_10_CSMdemand] as Mar_10_CSMdemand1
		,[Apr_10_CSMdemand] as Apr_10_CSMdemand1
		,[May_10_CSMdemand] as May_10_CSMdemand1
		,[Jun_10_CSMdemand] as Jun_10_CSMdemand1
		,[Jul_10_CSMdemand] as Jul_10_CSMdemand1
		,[Aug_10_CSMdemand] as Aug_10_CSMdemand1
		,[Sep_10_CSMdemand] as Sep_10_CSMdemand1
		,[Oct_10_CSMdemand] as Oct_10_CSMdemand1
		,[Nov_10_CSMdemand] as Nov_10_CSMdemand1
		,[Dec_10_CSMdemand] as Dec_10_CSMdemand1
		,[Total_10_CSMdemand] as Total_10_CSMdemand1
		
		,[Jan_11_CSMdemand] as Jan_11_CSMdemand1
		,[Feb_11_CSMdemand] as Feb_11_CSMdemand1
		,[Mar_11_CSMdemand] as Mar_11_CSMdemand1
		,[Apr_11_CSMdemand] as Apr_11_CSMdemand1
		,[May_11_CSMdemand] as May_11_CSMdemand1
		,[Jun_11_CSMdemand] as Jun_11_CSMdemand1
		,[Jul_11_CSMdemand] as Jul_11_CSMdemand1
		,[Aug_11_CSMdemand] as Aug_11_CSMdemand1
		,[Sep_11_CSMdemand] as Sep_11_CSMdemand1
		,[Oct_11_CSMdemand] as Oct_11_CSMdemand1
		,[Nov_11_CSMdemand] as Nov_11_CSMdemand1
		,[Dec_11_CSMdemand] as Dec_11_CSMdemand1
		,[Total_11_CSMdemand] as Total_11_CSMdemand1
		
		,[Jan_12_CSMdemand] as Jan_12_CSMdemand1
		,[Feb_12_CSMdemand] as Feb_12_CSMdemand1
		,[Mar_12_CSMdemand] as Mar_12_CSMdemand1
		,[Apr_12_CSMdemand] as Apr_12_CSMdemand1
		,[May_12_CSMdemand] as May_12_CSMdemand1
		,[Jun_12_CSMdemand] as Jun_12_CSMdemand1
		,[Jul_12_CSMdemand] as Jul_12_CSMdemand1
		,[Aug_12_CSMdemand] as Aug_12_CSMdemand1
		,[Sep_12_CSMdemand] as Sep_12_CSMdemand1
		,[Oct_12_CSMdemand] as Oct_12_CSMdemand1
		,[Nov_12_CSMdemand] as Nov_12_CSMdemand1
		,[Dec_12_CSMdemand] as Dec_12_CSMdemand1
		,[Total_12_CSMdemand] as Total_12_CSMdemand1
		
		,[Jan_13_CSMdemand] as Jan_13_CSMdemand1
		,[Feb_13_CSMdemand] as Feb_13_CSMdemand1
		,[Mar_13_CSMdemand] as Mar_13_CSMdemand1
		,[Apr_13_CSMdemand] as Apr_13_CSMdemand1
		,[May_13_CSMdemand] as May_13_CSMdemand1
		,[Jun_13_CSMdemand] as Jun_13_CSMdemand1
		,[Jul_13_CSMdemand] as Jul_13_CSMdemand1
		,[Aug_13_CSMdemand] as Aug_13_CSMdemand1
		,[Sep_13_CSMdemand] as Sep_13_CSMdemand1
		,[Oct_13_CSMdemand] as Oct_13_CSMdemand1
		,[Nov_13_CSMdemand] as Nov_13_CSMdemand1
		,[Dec_13_CSMdemand] as Dec_13_CSMdemand1
		,[Total_13_CSMdemand] as Total_13_CSMdemand1
		
		,[Jan_14_CSMdemand] as Jan_14_CSMdemand1
		,[Feb_14_CSMdemand] as Feb_14_CSMdemand1
		,[Mar_14_CSMdemand] as Mar_14_CSMdemand1
		,[Apr_14_CSMdemand] as Apr_14_CSMdemand1
		,[May_14_CSMdemand] as May_14_CSMdemand1
		,[Jun_14_CSMdemand] as Jun_14_CSMdemand1
		,[Jul_14_CSMdemand] as Jul_14_CSMdemand1
		,[Aug_14_CSMdemand] as Aug_14_CSMdemand1
		,[Sep_14_CSMdemand] as Sep_14_CSMdemand1
		,[Oct_14_CSMdemand] as Oct_14_CSMdemand1
		,[Nov_14_CSMdemand] as Nov_14_CSMdemand1
		,[Dec_14_CSMdemand] as Dec_14_CSMdemand1
		,[Total_14_CSMdemand] as Total_14_CSMdemand1
		
		,[Cal15_CSMdemand] as Cal15_CSMdemand1
		,[Cal16_CSMdemand] as Cal16_CSMdemand1
		,[Cal17_CSMdemand] as CAL17_CSMdemand1
		,[Cal18_CSMdemand] as CAL18_CSMdemand1
		,[Cal19_CSMdemand] as CAL19_CSMdemand1
		
		,[Jan_10_factor] as Jan_10_factor1
		,[Feb_10_factor] as Feb_10_factor1
		,[Mar_10_factor] as Mar_10_factor1
		,[Apr_10_factor] as Apr_10_factor1
		,[May_10_factor] as May_10_factor1
		,[Jun_10_factor] as Jun_10_factor1
		,[Jul_10_factor] as Jul_10_factor1
		,[Aug_10_factor] as Aug_10_factor1
		,[Sep_10_factor] as Sep_10_factor1
		,[Oct_10_factor] as Oct_10_factor1
		,[Nov_10_factor] as Nov_10_factor1
		,[Dec_10_factor] as Dec_10_factor1
		
		,[Jan_11_factor] as Jan_11_factor1
		,[Feb_11_factor] as Feb_11_factor1
		,[Mar_11_factor] as Mar_11_factor1
		,[Apr_11_factor] as Apr_11_factor1
		,[May_11_factor] as May_11_factor1
		,[Jun_11_factor] as Jun_11_factor1
		,[Jul_11_factor] as Jul_11_factor1
		,[Aug_11_factor] as Aug_11_factor1
		,[Sep_11_factor] as Sep_11_factor1
		,[Oct_11_factor] as Oct_11_factor1
		,[Nov_11_factor] as Nov_11_factor1
		,[Dec_11_factor] as Dec_11_factor1
		
		,[Jan_12_factor] as Jan_12_factor1
		,[Feb_12_factor] as Feb_12_factor1
		,[Mar_12_factor] as Mar_12_factor1
		,[Apr_12_factor] as Apr_12_factor1
		,[May_12_factor] as May_12_factor1
		,[Jun_12_factor] as Jun_12_factor1
		,[Jul_12_factor] as Jul_12_factor1
		,[Aug_12_factor] as Aug_12_factor1
		,[Sep_12_factor] as Sep_12_factor1
		,[Oct_12_factor] as Oct_12_factor1
		,[Nov_12_factor] as Nov_12_factor1
		,[Dec_12_factor] as Dec_12_factor1
		
		,[Jan_13_factor] as Jan_13_factor1
		,[Feb_13_factor] as Feb_13_factor1
		,[Mar_13_factor] as Mar_13_factor1
		,[Apr_13_factor] as Apr_13_factor1
		,[May_13_factor] as May_13_factor1
		,[Jun_13_factor] as Jun_13_factor1
		,[Jul_13_factor] as Jul_13_factor1
		,[Aug_13_factor] as Aug_13_factor1
		,[Sep_13_factor] as Sep_13_factor1
		,[Oct_13_factor] as Oct_13_factor1
		,[Nov_13_factor] as Nov_13_factor1
		,[Dec_13_factor] as Dec_13_factor1
		
		,[Jan_14_factor] as Jan_14_factor1
		,[Feb_14_factor] as Feb_14_factor1
		,[Mar_14_factor] as Mar_14_factor1
		,[Apr_14_factor] as Apr_14_factor1
		,[May_14_factor] as May_14_factor1
		,[Jun_14_factor] as Jun_14_factor1
		,[Jul_14_factor] as Jul_14_factor1
		,[Aug_14_factor] as Aug_14_factor1
		,[Sep_14_factor] as Sep_14_factor1
		,[Oct_14_factor] as Oct_14_factor1
		,[Nov_14_factor] as Nov_14_factor1
		,[Dec_14_factor] as Dec_14_factor1
		
		,[Cal15_factor] as Cal15_factor1
		,[Cal16_factor] as Cal16_factor1
		,[Cal17_factor] as Cal17_factor1
		,[Cal18_factor] as Cal18_factor1
		,[Cal19_factor] as Cal19_factor1
		
		,[Jan_10_Empire_Adj] as Jan_10_Empire_Adj1
		,[Feb_10_Empire_Adj] as Feb_10_Empire_Adj1
		,[Mar_10_Empire_Adj] as Mar_10_Empire_Adj1
		,[Apr_10_Empire_Adj] as Apr_10_Empire_Adj1
		,[May_10_Empire_Adj] as May_10_Empire_Adj1
		,[Jun_10_Empire_Adj] as Jun_10_Empire_Adj1
		,[Jul_10_Empire_Adj] as Jul_10_Empire_Adj1
		,[Aug_10_Empire_Adj] as Aug_10_Empire_Adj1
		,[Sep_10_Empire_Adj] as Sep_10_Empire_Adj1
		,[Oct_10_Empire_Adj] as Oct_10_Empire_Adj1
		,[Nov_10_Empire_Adj] as Nov_10_Empire_Adj1
		,[Dec_10_Empire_Adj] as Dec_10_Empire_Adj1
		,[Total_10_Empire_Adj] as Total_10_Empire_Adj1
		
		,[Jan_11_Empire_Adj] as Jan_11_Empire_Adj1
		,[Feb_11_Empire_Adj] as Feb_11_Empire_Adj1
		,[Mar_11_Empire_Adj] as Mar_11_Empire_Adj1
		,[Apr_11_Empire_Adj] as Apr_11_Empire_Adj1
		,[May_11_Empire_Adj] as May_11_Empire_Adj1
		,[Jun_11_Empire_Adj] as Jun_11_Empire_Adj1
		,[Jul_11_Empire_Adj] as Jul_11_Empire_Adj1
		,[Aug_11_Empire_Adj] as Aug_11_Empire_Adj1
		,[Sep_11_Empire_Adj] as Sep_11_Empire_Adj1
		,[Oct_11_Empire_Adj] as Oct_11_Empire_Adj1
		,[Nov_11_Empire_Adj] as Nov_11_Empire_Adj1
		,[Dec_11_Empire_Adj] as Dec_11_Empire_Adj1
		,[Total_11_Empire_Adj] as Total_11_Empire_Adj1
		
		,[Jan_12_Empire_Adj] as Jan_12_Empire_Adj1
		,[Feb_12_Empire_Adj] as Feb_12_Empire_Adj1
		,[Mar_12_Empire_Adj] as Mar_12_Empire_Adj1
		,[Apr_12_Empire_Adj] as Apr_12_Empire_Adj1
		,[May_12_Empire_Adj] as May_12_Empire_Adj1
		,[Jun_12_Empire_Adj] as Jun_12_Empire_Adj1
		,[Jul_12_Empire_Adj] as Jul_12_Empire_Adj1
		,[Aug_12_Empire_Adj] as Aug_12_Empire_Adj1
		,[Sep_12_Empire_Adj] as Sep_12_Empire_Adj1
		,[Oct_12_Empire_Adj] as Oct_12_Empire_Adj1
		,[Nov_12_Empire_Adj] as Nov_12_Empire_Adj1
		,[Dec_12_Empire_Adj] as Dec_12_Empire_Adj1
		,[Total_12_Empire_Adj] as Total_12_Empire_Adj1
		
		,[Jan_13_Empire_Adj] as Jan_13_Empire_Adj1
		,[Feb_13_Empire_Adj] as Feb_13_Empire_Adj1
		,[Mar_13_Empire_Adj] as Mar_13_Empire_Adj1
		,[Apr_13_Empire_Adj] as Apr_13_Empire_Adj1
		,[May_13_Empire_Adj] as May_13_Empire_Adj1
		,[Jun_13_Empire_Adj] as Jun_13_Empire_Adj1
		,[Jul_13_Empire_Adj] as Jul_13_Empire_Adj1
		,[Aug_13_Empire_Adj] as Aug_13_Empire_Adj1
		,[Sep_13_Empire_Adj] as Sep_13_Empire_Adj1
		,[Oct_13_Empire_Adj] as Oct_13_Empire_Adj1
		,[Nov_13_Empire_Adj] as Nov_13_Empire_Adj1
		,[Dec_13_Empire_Adj] as Dec_13_Empire_Adj1
		,[Total_13_Empire_Adj] as Total_13_Empire_Adj1
		
		,[Jan_14_Empire_Adj] as Jan_14_Empire_Adj1
		,[Feb_14_Empire_Adj] as Feb_14_Empire_Adj1
		,[Mar_14_Empire_Adj] as Mar_14_Empire_Adj1
		,[Apr_14_Empire_Adj] as Apr_14_Empire_Adj1
		,[May_14_Empire_Adj] as May_14_Empire_Adj1
		,[Jun_14_Empire_Adj] as Jun_14_Empire_Adj1
		,[Jul_14_Empire_Adj] as Jul_14_Empire_Adj1
		,[Aug_14_Empire_Adj] as Aug_14_Empire_Adj1
		,[Sep_14_Empire_Adj] as Sep_14_Empire_Adj1
		,[Oct_14_Empire_Adj] as Oct_14_Empire_Adj1
		,[Nov_14_Empire_Adj] as Nov_14_Empire_Adj1
		,[Dec_14_Empire_Adj] as Dec_14_Empire_Adj1
		,[Total_14_Empire_Adj] as Total_14_Empire_Adj1
		
		,[Cal15_Empire_Adj] as Cal15_Empire_Adj1
		,[Cal16_Empire_Adj] as Cal16_Empire_Adj1
		,[Cal17_Empire_Adj] as Cal17_Empire_Adj1
		,[Cal18_Empire_Adj] as Cal18_Empire_Adj1
		,[Cal19_Empire_adj] as Cal19_Empire_Adj1
		
			
		,[sp_Dec_10] as sp_Dec_10_1
		,[sp_Dec_11] as sp_Dec_11_1
		,[sp_Dec_12] as sp_Dec_12_1
		,[sp_Dec_13] as sp_Dec_13_1
		,[sp_Dec_14] as sp_Dec_14_1
		,[sp_Dec_15] as sp_Dec_15_1
		,[sp_Dec_16] as sp_Dec_16_1
		,[sp_Dec_17] as sp_Dec_17_1
		,[sp_Dec_18] as sp_Dec_18_1
		,[sp_Dec_19] as sp_Dec_19_1
		
		,[Jan_10_TOTALdemand]*[sp_Jan_10] as 'Jan_10_Sales1'
		,[Feb_10_TOTALdemand]*[sp_Feb_10] as 'Feb_10_Sales1'
		,[Mar_10_TOTALdemand]*[sp_Mar_10] as 'Mar_10_Sales1'
		,[Apr_10_TOTALdemand]*[sp_Apr_10] as 'Apr_10_Sales1'
		,[May_10_TOTALdemand]*[sp_May_10] as 'May_10_Sales1'
		,[Jun_10_TOTALdemand]*[sp_Jun_10] as 'Jun_10_Sales1'
		,[Jul_10_TOTALdemand]*[sp_Jul_10] as 'Jul_10_Sales1'
		,[Aug_10_TOTALdemand]*[sp_Aug_10] as 'Aug_10_Sales1'
		,[Sep_10_TOTALdemand]*[sp_Sep_10] as 'Sep_10_Sales1'
		,[Oct_10_TOTALdemand]*[sp_Oct_10] as 'Oct_10_Sales1'
		,[Nov_10_TOTALdemand]*[sp_Nov_10] as 'Nov_10_Sales1'
		,[Dec_10_TOTALdemand]*[sp_Dec_10] as 'Dec_10_Sales1'
		,([Jan_10_TOTALdemand]*[sp_Jan_10])+([Feb_10_TOTALdemand]*[sp_Feb_10])+([Mar_10_TOTALdemand]*[sp_Mar_10])+([Apr_10_TOTALdemand]*[sp_Apr_10])
		+([May_10_TOTALdemand]*[sp_May_10])+([Jun_10_TOTALdemand]*[sp_Jun_10])+([Jul_10_TOTALdemand]*[sp_Jul_10])+([Aug_10_TOTALdemand]*[sp_Aug_10])
		+([Sep_10_TOTALdemand]*[sp_Sep_10])+([Oct_10_TOTALdemand]*[sp_Oct_10])+([Nov_10_TOTALdemand]*[sp_Nov_10])+([Dec_10_TOTALdemand]*[sp_Dec_10]) as 'Cal_10_Sales1' 
		
		,[Jan_11_TOTALdemand]*[sp_Jan_11] as 'Jan_11_Sales1'
		,[Feb_11_TOTALdemand]*[sp_Feb_11] as 'Feb_11_Sales1'
		,[Mar_11_TOTALdemand]*[sp_Mar_11] as 'Mar_11_Sales1'
		,[Apr_11_TOTALdemand]*[sp_Apr_11] as 'Apr_11_Sales1'
		,[May_11_TOTALdemand]*[sp_May_11] as 'May_11_Sales1'
		,[Jun_11_TOTALdemand]*[sp_Jun_11] as 'Jun_11_Sales1'
		,[Jul_11_TOTALdemand]*[sp_Jul_11] as 'Jul_11_Sales1'
		,[Aug_11_TOTALdemand]*[sp_Aug_11] as 'Aug_11_Sales1'
		,[Sep_11_TOTALdemand]*[sp_Sep_11] as 'Sep_11_Sales1'
		,[Oct_11_TOTALdemand]*[sp_Oct_11] as 'Oct_11_Sales1'
		,[Nov_11_TOTALdemand]*[sp_Nov_11] as 'Nov_11_Sales1'
		,[Dec_11_TOTALdemand]*[sp_Dec_11] as 'Dec_11_Sales1'
		,([Jan_11_TOTALdemand]*[sp_Jan_11])+([Feb_11_TOTALdemand]*[sp_Feb_11])+([Mar_11_TOTALdemand]*[sp_Mar_11])+([Apr_11_TOTALdemand]*[sp_Apr_11])
		+([May_11_TOTALdemand]*[sp_May_11])+([Jun_11_TOTALdemand]*[sp_Jun_11])+([Jul_11_TOTALdemand]*[sp_Jul_11])+([Aug_11_TOTALdemand]*[sp_Aug_11])
		+([Sep_11_TOTALdemand]*[sp_Sep_11])+([Oct_11_TOTALdemand]*[sp_Oct_11])+([Nov_11_TOTALdemand]*[sp_Nov_11])+([Dec_11_TOTALdemand]*[sp_Dec_11]) as 'Cal_11_Sales1' 
		
		,[Jan_12_TOTALdemand]*[sp_Jan_12] as 'Jan_12_Sales1'
		,[Feb_12_TOTALdemand]*[sp_Feb_12] as 'Feb_12_Sales1'
		,[Mar_12_TOTALdemand]*[sp_Mar_12] as 'Mar_12_Sales1'
		,[Apr_12_TOTALdemand]*[sp_Apr_12] as 'Apr_12_Sales1'
		,[May_12_TOTALdemand]*[sp_May_12] as 'May_12_Sales1'
		,[Jun_12_TOTALdemand]*[sp_Jun_12] as 'Jun_12_Sales1'
		,[Jul_12_TOTALdemand]*[sp_Jul_12] as 'Jul_12_Sales1'
		,[Aug_12_TOTALdemand]*[sp_Aug_12] as 'Aug_12_Sales1'
		,[Sep_12_TOTALdemand]*[sp_Sep_12] as 'Sep_12_Sales1'
		,[Oct_12_TOTALdemand]*[sp_Oct_12] as 'Oct_12_Sales1'
		,[Nov_12_TOTALdemand]*[sp_Nov_12] as 'Nov_12_Sales1'
		,[Dec_12_TOTALdemand]*[sp_Dec_12] as 'Dec_12_Sales1'
		,([Jan_12_TOTALdemand]*[sp_Jan_12])+([Feb_12_TOTALdemand]*[sp_Feb_12])+([Mar_12_TOTALdemand]*[sp_Mar_12])+([Apr_12_TOTALdemand]*[sp_Apr_12])
		+([May_12_TOTALdemand]*[sp_May_12])+([Jun_12_TOTALdemand]*[sp_Jun_12])+([Jul_12_TOTALdemand]*[sp_Jul_12])+([Aug_12_TOTALdemand]*[sp_Aug_12])
		+([Sep_12_TOTALdemand]*[sp_Sep_12])+([Oct_12_TOTALdemand]*[sp_Oct_12])+([Nov_12_TOTALdemand]*[sp_Nov_12])+([Dec_12_TOTALdemand]*[sp_Dec_12]) as 'Cal_12_Sales1' 
		
		,[Jan_13_TOTALdemand]*[sp_Jan_13] as 'Jan_13_Sales1'
		,[Feb_13_TOTALdemand]*[sp_Feb_13] as 'Feb_13_Sales1'
		,[Mar_13_TOTALdemand]*[sp_Mar_13] as 'Mar_13_Sales1'
		,[Apr_13_TOTALdemand]*[sp_Apr_13] as 'Apr_13_Sales1'
		,[May_13_TOTALdemand]*[sp_May_13] as 'May_13_Sales1'
		,[Jun_13_TOTALdemand]*[sp_Jun_13] as 'Jun_13_Sales1'
		,[Jul_13_TOTALdemand]*[sp_Jul_13] as 'Jul_13_Sales1'
		,[Aug_13_TOTALdemand]*[sp_Aug_13] as 'Aug_13_Sales1'
		,[Sep_13_TOTALdemand]*[sp_Sep_13] as 'Sep_13_Sales1'
		,[Oct_13_TOTALdemand]*[sp_Oct_13] as 'Oct_13_Sales1'
		,[Nov_13_TOTALdemand]*[sp_Nov_13] as 'Nov_13_Sales1'
		,[Dec_13_TOTALdemand]*[sp_Dec_13] as 'Dec_13_Sales1'
		,([Jan_13_TOTALdemand]*[sp_Jan_13])+([Feb_13_TOTALdemand]*[sp_Feb_13])+([Mar_13_TOTALdemand]*[sp_Mar_13])+([Apr_13_TOTALdemand]*[sp_Apr_13])
		+([May_13_TOTALdemand]*[sp_May_13])+([Jun_13_TOTALdemand]*[sp_Jun_13])+([Jul_13_TOTALdemand]*[sp_Jul_13])+([Aug_13_TOTALdemand]*[sp_Aug_13])
		+([Sep_13_TOTALdemand]*[sp_Sep_13])+([Oct_13_TOTALdemand]*[sp_Oct_13])+([Nov_13_TOTALdemand]*[sp_Nov_13])+([Dec_13_TOTALdemand]*[sp_Dec_13]) as 'Cal_13_Sales1' 
		
		,[Jan_14_TOTALdemand]*[sp_Jan_14] as 'Jan_14_Sales1'
		,[Feb_14_TOTALdemand]*[sp_Feb_14] as 'Feb_14_Sales1'
		,[Mar_14_TOTALdemand]*[sp_Mar_14] as 'Mar_14_Sales1'
		,[Apr_14_TOTALdemand]*[sp_Apr_14] as 'Apr_14_Sales1'
		,[May_14_TOTALdemand]*[sp_May_14] as 'May_14_Sales1'
		,[Jun_14_TOTALdemand]*[sp_Jun_14] as 'Jun_14_Sales1'
		,[Jul_14_TOTALdemand]*[sp_Jul_14] as 'Jul_14_Sales1'
		,[Aug_14_TOTALdemand]*[sp_Aug_14] as 'Aug_14_Sales1'
		,[Sep_14_TOTALdemand]*[sp_Sep_14] as 'Sep_14_Sales1'
		,[Oct_14_TOTALdemand]*[sp_Oct_14] as 'Oct_14_Sales1'
		,[Nov_14_TOTALdemand]*[sp_Nov_14] as 'Nov_14_Sales1'
		,[Dec_14_TOTALdemand]*[sp_Dec_14] as 'Dec_14_Sales1'
		,([Jan_14_TOTALdemand]*[sp_Jan_14])+([Feb_14_TOTALdemand]*[sp_Feb_14])+([Mar_14_TOTALdemand]*[sp_Mar_14])+([Apr_14_TOTALdemand]*[sp_Apr_14])
		+([May_14_TOTALdemand]*[sp_May_14])+([Jun_14_TOTALdemand]*[sp_Jun_14])+([Jul_14_TOTALdemand]*[sp_Jul_14])+([Aug_14_TOTALdemand]*[sp_Aug_14])
		+([Sep_14_TOTALdemand]*[sp_Sep_14])+([Oct_14_TOTALdemand]*[sp_Oct_14])+([Nov_14_TOTALdemand]*[sp_Nov_14])+([Dec_14_TOTALdemand]*[sp_Dec_14]) as 'Cal_14_Sales1' 
		
		,[Cal15_TOTALdemand]*[sp_Dec_15] as 'Cal_15_Sales1'
		,[Cal16_TOTALdemand]*[sp_Dec_16] as 'Cal_16_Sales1'
		,[Cal17_TOTALdemand]*[sp_Dec_17] as 'Cal_17_Sales1'
		,[Cal18_TOTALdemand]*[sp_Dec_18] as 'Cal_18_Sales1'
		,[Cal19_TOTALdemand]*[sp_Dec_19] as 'Cal_19_Sales1'
		
		,([Jan_12_TOTALdemand]*[sp_Jan_12])+([Feb_12_TOTALdemand]*[sp_Feb_12])+([Mar_12_TOTALdemand]*[sp_Mar_12])+([Apr_12_TOTALdemand]*[sp_Apr_12])
		+([May_12_TOTALdemand]*[sp_May_12])+([Jun_12_TOTALdemand]*[sp_Jun_12])+([Jul_12_TOTALdemand]*[sp_Jul_12])+([Aug_12_TOTALdemand]*[sp_Aug_12])
		+([Sep_12_TOTALdemand]*[sp_Sep_12])+([Oct_12_TOTALdemand]*[sp_Oct_12])+([Nov_12_TOTALdemand]*[sp_Nov_12])+([Dec_12_TOTALdemand]*[sp_Dec_12])
		+([Jan_13_TOTALdemand]*[sp_Jan_13])+([Feb_13_TOTALdemand]*[sp_Feb_13])+([Mar_13_TOTALdemand]*[sp_Mar_13])+([Apr_13_TOTALdemand]*[sp_Apr_13])
		+([May_13_TOTALdemand]*[sp_May_13])+([Jun_13_TOTALdemand]*[sp_Jun_13])+([Jul_13_TOTALdemand]*[sp_Jul_13])+([Aug_13_TOTALdemand]*[sp_Aug_13])
		+([Sep_13_TOTALdemand]*[sp_Sep_13])+([Oct_13_TOTALdemand]*[sp_Oct_13])+([Nov_13_TOTALdemand]*[sp_Nov_13])+([Dec_13_TOTALdemand]*[sp_Dec_13]) 
		+([Jan_14_TOTALdemand]*[sp_Jan_14])+([Feb_14_TOTALdemand]*[sp_Feb_14])+([Mar_14_TOTALdemand]*[sp_Mar_14])+([Apr_14_TOTALdemand]*[sp_Apr_14])
		+([May_14_TOTALdemand]*[sp_May_14])+([Jun_14_TOTALdemand]*[sp_Jun_14])+([Jul_14_TOTALdemand]*[sp_Jul_14])+([Aug_14_TOTALdemand]*[sp_Aug_14])
		+([Sep_14_TOTALdemand]*[sp_Sep_14])+([Oct_14_TOTALdemand]*[sp_Oct_14])+([Nov_14_TOTALdemand]*[sp_Nov_14])+([Dec_14_TOTALdemand]*[sp_Dec_14]) 
		+([Cal15_TOTALdemand]*[sp_Dec_15])
		+([Cal16_TOTALdemand]*[sp_Dec_16])
		+([Cal17_TOTALdemand]*[sp_Dec_17])
		+([Cal18_TOTALdemand]*[sp_Dec_18])
		+([Cal19_TOTALdemand]*[sp_Dec_19]) as '2012-2019 Sales1'
		
		,Coalesce((ActivePartMaterialAccum.CurrentRevPart),'NoActivePartDefined') as ActiveRevLevel1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0) as ActiveRevPartMaterialAccum1
		
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand] as Jan_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand] as Feb_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand] as Mar_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand] as Apr_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand] as May_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand] as Jun_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand] as Jul_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand] as Aug_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand] as Sep_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand] as Oct_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand] as Nov_10_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand] as Dec_10_TOTALMaterialCUM1
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand]) as Cal10_Material_cost1
	
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand] as Jan_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand] as Feb_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand] as Mar_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand] as Apr_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand] as May_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand] as Jun_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand] as Jul_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand] as Aug_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand] as Sep_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand] as Oct_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand] as Nov_11_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand] as Dec_11_TOTALMaterialCUM1
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand]) as Cal11_Material_cost1
	
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand] as Jan_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand] as Feb_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand] as Mar_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand] as Apr_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand] as May_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand] as Jun_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand] as Jul_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand] as Aug_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand] as Sep_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand] as Oct_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand] as Nov_12_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand] as Dec_12_TOTALMaterialCUM1
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand]) as Cal12_Material_cost1

		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand] as Jan_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand] as Feb_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand] as Mar_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand] as Apr_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand] as May_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand] as Jun_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand] as Jul_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand] as Aug_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand] as Sep_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand] as Oct_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand] as Nov_13_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand] as Dec_13_TOTALMaterialCUM1
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand]) as Cal13_Material_cost1
		
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_14_TOTALdemand] as Jan_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_14_TOTALdemand] as Feb_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_14_TOTALdemand] as Mar_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_14_TOTALdemand] as Apr_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_14_TOTALdemand] as May_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_14_TOTALdemand] as Jun_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_14_TOTALdemand] as Jul_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_14_TOTALdemand] as Aug_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_14_TOTALdemand] as Sep_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_14_TOTALdemand] as Oct_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_14_TOTALdemand] as Nov_14_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_14_TOTALdemand] as Dec_14_TOTALMaterialCUM1
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_14_TOTALdemand]) as Cal14_Material_cost1
				
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal15_TOTALdemand] as Cal15_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal16_TOTALdemand] as Cal16_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal17_TOTALdemand] as Cal17_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal18_TOTALdemand] as Cal18_TOTALMaterialCUM1
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal19_TOTALdemand] as Cal19_TOTALMaterialCUM1
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
		
				isnull(aa.Jan_13_CSMdemand,0) as Jan_13_CSMdemand,
				isnull(aa.Feb_13_CSMdemand,0) as Feb_13_CSMdemand,
				isnull(aa.Mar_13_CSMdemand,0) as Mar_13_CSMdemand,
				isnull(aa.Apr_13_CSMdemand,0) as Apr_13_CSMdemand,
				isnull(aa.May_13_CSMdemand,0) as May_13_CSMdemand,
				isnull(aa.Jun_13_CSMdemand,0) as Jun_13_CSMdemand,
				isnull(aa.Jul_13_CSMdemand,0) as Jul_13_CSMdemand,
				isnull(aa.Aug_13_CSMdemand,0) as Aug_13_CSMdemand,
				isnull(aa.Sep_13_CSMdemand,0) as Sep_13_CSMdemand,
				isnull(aa.Oct_13_CSMdemand,0) as Oct_13_CSMdemand,
				isnull(aa.Nov_13_CSMdemand,0) as Nov_13_CSMdemand,
				isnull(aa.Dec_13_CSMdemand,0) as Dec_13_CSMdemand,
				isnull(aa.Total_13_CSMdemand,0) as Total_13_CSMdemand,
		
				isnull(aa.Jan_14_CSMdemand,0) as Jan_14_CSMdemand,
				isnull(aa.Feb_14_CSMdemand,0) as Feb_14_CSMdemand,
				isnull(aa.Mar_14_CSMdemand,0) as Mar_14_CSMdemand,
				isnull(aa.Apr_14_CSMdemand,0) as Apr_14_CSMdemand,
				isnull(aa.May_14_CSMdemand,0) as May_14_CSMdemand,
				isnull(aa.Jun_14_CSMdemand,0) as Jun_14_CSMdemand,
				isnull(aa.Jul_14_CSMdemand,0) as Jul_14_CSMdemand,
				isnull(aa.Aug_14_CSMdemand,0) as Aug_14_CSMdemand,
				isnull(aa.Sep_14_CSMdemand,0) as Sep_14_CSMdemand,
				isnull(aa.Oct_14_CSMdemand,0) as Oct_14_CSMdemand,
				isnull(aa.Nov_14_CSMdemand,0) as Nov_14_CSMdemand,
				isnull(aa.Dec_14_CSMdemand,0) as Dec_14_CSMdemand,
				isnull(aa.Total_14_CSMdemand,0) as Total_14_CSMdemand,
				
				isnull(aa.Cal15_CSMdemand,0) as Cal15_CSMdemand,
				isnull(aa.Cal16_CSMdemand,0) as Cal16_CSMdemand,
				isnull(aa.Cal17_CSMdemand,0) as Cal17_CSMdemand,
				isnull(aa.Cal18_CSMdemand,0) as Cal18_CSMdemand,
				isnull(aa.Cal19_CSMdemand,0) as Cal19_CSMdemand,
		
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
				
				isnull(aa.Jan_13_factor,1) as Jan_13_factor,
				isnull(aa.Feb_13_factor,1) as Feb_13_factor,
				isnull(aa.Mar_13_factor,1) as Mar_13_factor,
				isnull(aa.Apr_13_factor,1) as Apr_13_factor,
				isnull(aa.May_13_factor,1) as May_13_factor,
				isnull(aa.Jun_13_factor,1) as Jun_13_factor,
				isnull(aa.Jul_13_factor,1) as Jul_13_factor,
				isnull(aa.Aug_13_factor,1) as Aug_13_factor,
				isnull(aa.Sep_13_factor,1) as Sep_13_factor,
				isnull(aa.Oct_13_factor,1) as Oct_13_factor,
				isnull(aa.Nov_13_factor,1) as Nov_13_factor,
				isnull(aa.Dec_13_factor,1) as Dec_13_factor,			
				
				isnull(aa.Jan_14_factor,1) as Jan_14_factor,
				isnull(aa.Feb_14_factor,1) as Feb_14_factor,
				isnull(aa.Mar_14_factor,1) as Mar_14_factor,
				isnull(aa.Apr_14_factor,1) as Apr_14_factor,
				isnull(aa.May_14_factor,1) as May_14_factor,
				isnull(aa.Jun_14_factor,1) as Jun_14_factor,
				isnull(aa.Jul_14_factor,1) as Jul_14_factor,
				isnull(aa.Aug_14_factor,1) as Aug_14_factor,
				isnull(aa.Sep_14_factor,1) as Sep_14_factor,
				isnull(aa.Oct_14_factor,1) as Oct_14_factor,
				isnull(aa.Nov_14_factor,1) as Nov_14_factor,
				isnull(aa.Dec_14_factor,1) as Dec_14_factor,			
			
				isnull(aa.Cal15_factor,1) as Cal15_factor,
				isnull(aa.Cal16_factor,1) as Cal16_factor,
				isnull(aa.Cal17_factor,1) as Cal17_factor,
				isnull(aa.Cal18_factor,1) as Cal18_factor,
				isnull(aa.CAL19_factor,1) as Cal19_factor,
		
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
	
				isnull(bb.Jan_13,0) as Jan_13_Empire_Adj,
				isnull(bb.Feb_13,0) as Feb_13_Empire_Adj,
				isnull(bb.Mar_13,0) as Mar_13_Empire_Adj,
				isnull(bb.Apr_13,0) as Apr_13_Empire_Adj,
				isnull(bb.May_13,0) as May_13_Empire_Adj,
				isnull(bb.Jun_13,0) as Jun_13_Empire_Adj,		
				isnull(bb.Jul_13,0) as Jul_13_Empire_Adj,
				isnull(bb.Aug_13,0) as Aug_13_Empire_Adj,
				isnull(bb.Sep_13,0) as Sep_13_Empire_Adj,		
				isnull(bb.Oct_13,0) as Oct_13_Empire_Adj,
				isnull(bb.Nov_13,0) as Nov_13_Empire_Adj,
				isnull(bb.Dec_13,0) as Dec_13_Empire_Adj,
				isnull(bb.Total_2013,0) as Total_13_Empire_Adj,
	
				isnull(bb.Jan_14,0) as Jan_14_Empire_Adj,
				isnull(bb.Feb_14,0) as Feb_14_Empire_Adj,
				isnull(bb.Mar_14,0) as Mar_14_Empire_Adj,
				isnull(bb.Apr_14,0) as Apr_14_Empire_Adj,
				isnull(bb.May_14,0) as May_14_Empire_Adj,
				isnull(bb.Jun_14,0) as Jun_14_Empire_Adj,		
				isnull(bb.Jul_14,0) as Jul_14_Empire_Adj,
				isnull(bb.Aug_14,0) as Aug_14_Empire_Adj,
				isnull(bb.Sep_14,0) as Sep_14_Empire_Adj,		
				isnull(bb.Oct_14,0) as Oct_14_Empire_Adj,
				isnull(bb.Nov_14,0) as Nov_14_Empire_Adj,
				isnull(bb.Dec_14,0) as Dec_14_Empire_Adj,
				isnull(bb.Total_2014,0) as Total_14_Empire_Adj,
				
				ISNULL(bb.cal15,0) as Cal15_Empire_Adj,
				isnull(bb.Cal16,0) as Cal16_Empire_Adj,
				isnull(bb.Cal17,0) as Cal17_Empire_Adj,
				isnull(bb.Cal18,0) as Cal18_Empire_Adj,
				isnull(bb.Cal19,0) as Cal19_Empire_Adj,			
				
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
				
	
				isnull(aa.Jan_13_CSMdemand,0) + (isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) as Jan_13_TOTALdemand,
				isnull(aa.Feb_13_CSMdemand,0) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) as Feb_13_TOTALdemand,
				isnull(aa.Mar_13_CSMdemand,0) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) as Mar_13_TOTALdemand,
				isnull(aa.Apr_13_CSMdemand,0) + (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) as Apr_13_TOTALdemand,
				isnull(aa.May_13_CSMdemand,0) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) as May_13_TOTALdemand,
				isnull(aa.Jun_13_CSMdemand,0) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) as Jun_13_TOTALdemand,
				isnull(aa.Jul_13_CSMdemand,0) + (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) as Jul_13_TOTALdemand,
				isnull(aa.Aug_13_CSMdemand,0) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) as Aug_13_TOTALdemand,
				isnull(aa.Sep_13_CSMdemand,0) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) as Sep_13_TOTALdemand,
				isnull(aa.Oct_13_CSMdemand,0) + (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) as Oct_13_TOTALdemand,
				isnull(aa.Nov_13_CSMdemand,0) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) as Nov_13_TOTALdemand,
				isnull(aa.Dec_13_CSMdemand,0) + (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0)) as Dec_13_TOTALdemand,		
				isnull(aa.Total_13_CSMdemand,0) + ((isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) + (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) + (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) +  (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) +  (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0))) as Total_2013_TOTALdemand,
				
				isnull(aa.Jan_14_CSMdemand,0) + (isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) as Jan_14_TOTALdemand,
				isnull(aa.Feb_14_CSMdemand,0) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) as Feb_14_TOTALdemand,
				isnull(aa.Mar_14_CSMdemand,0) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) as Mar_14_TOTALdemand,
				isnull(aa.Apr_14_CSMdemand,0) + (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) as Apr_14_TOTALdemand,
				isnull(aa.May_14_CSMdemand,0) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) as May_14_TOTALdemand,
				isnull(aa.Jun_14_CSMdemand,0) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0)) as Jun_14_TOTALdemand,
				isnull(aa.Jul_14_CSMdemand,0) + (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) as Jul_14_TOTALdemand,
				isnull(aa.Aug_14_CSMdemand,0) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) as Aug_14_TOTALdemand,
				isnull(aa.Sep_14_CSMdemand,0) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) as Sep_14_TOTALdemand,
				isnull(aa.Oct_14_CSMdemand,0) + (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) as Oct_14_TOTALdemand,
				isnull(aa.Nov_14_CSMdemand,0) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) as Nov_14_TOTALdemand,
				isnull(aa.Dec_14_CSMdemand,0) + (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0)) as Dec_14_TOTALdemand,		
				isnull(aa.Total_14_CSMdemand,0) + ((isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) + (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0)) + (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) +  (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) +  (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0))) as Total_2014_TOTALdemand,
							
				isnull(aa.Cal15_CSMdemand,0) + (isnull(aa.Cal15_factor,1)*isnull(bb.Cal15,0)) as Cal15_TOTALdemand,	
				isnull(aa.Cal16_CSMdemand,0) + (isnull(aa.Cal16_factor,1)*isnull(bb.Cal16,0)) as Cal16_TOTALdemand,	
				isnull(aa.Cal17_CSMdemand,0) + (isnull(aa.cal17_factor,1)*isnull(bb.Cal17,0)) as Cal17_TOTALdemand,	
				isnull(aa.Cal18_CSMdemand,0) + (isnull(aa.Cal18_factor,1)*isnull(bb.Cal18,0)) as Cal18_TOTALdemand,	
				isnull(aa.Cal19_CSMdemand,0) + (isnull(aa.Cal19_factor,1)*isnull(bb.Cal19,0)) as Cal19_TOTALdemand	
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
		
						a.jan_13 as Jan_13_CSMdemand,
						a.feb_13 as Feb_13_CSMdemand,
						a.mar_13 as Mar_13_CSMdemand,
						a.apr_13 as Apr_13_CSMdemand,
						a.may_13 as May_13_CSMdemand,
						a.jun_13 as Jun_13_CSMdemand,
						a.jul_13 as Jul_13_CSMdemand,
						a.aug_13 as Aug_13_CSMdemand,
						a.sep_13 as Sep_13_CSMdemand,
						a.oct_13 as Oct_13_CSMdemand,
						a.nov_13 as Nov_13_CSMdemand,
						a.dec_13 as Dec_13_CSMdemand, 
						a.total_2013 as Total_13_CSMdemand,
						
						a.jan_14 as Jan_14_CSMdemand,
						a.feb_14 as Feb_14_CSMdemand,
						a.mar_14 as Mar_14_CSMdemand,
						a.apr_14 as Apr_14_CSMdemand,
						a.may_14 as May_14_CSMdemand,
						a.jun_14 as Jun_14_CSMdemand,
						a.jul_14 as Jul_14_CSMdemand,
						a.aug_14 as Aug_14_CSMdemand,
						a.sep_14 as Sep_14_CSMdemand,
						a.oct_14 as Oct_14_CSMdemand,
						a.nov_14 as Nov_14_CSMdemand,
						a.dec_14 as Dec_14_CSMdemand, 
						a.total_2014 as Total_14_CSMdemand,		
						
						a.cal15 as CAL15_CSMdemand,
						a.cal16 as CAL16_CSMdemand,
						a.cal17 as CAL17_CSMdemand,
						a.cal18 as CAL18_CSMdemand,
						a.cal19 as CAL19_CSMdemand,
						
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
						(case when isnull(b.nov_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.nov_10/NULLIF(b.nov_10,0) end) as nov_10_factor,
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
		
						(case when isnull(b.jan_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jan_13/NULLIF(b.jan_13,0) end) as jan_13_factor, 
						(case when isnull(b.feb_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.feb_13/NULLIF(b.feb_13,0) end) as feb_13_factor,
						(case when isnull(b.mar_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.mar_13/NULLIF(b.mar_13,0) end) as mar_13_factor,
						(case when isnull(b.apr_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.apr_13/NULLIF(b.apr_13,0) end) as apr_13_factor,
						(case when isnull(b.may_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.may_13/NULLIF(b.may_13,0) end) as may_13_factor,
						(case when isnull(b.jun_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jun_13/NULLIF(b.jun_13,0) end) as jun_13_factor,
						(case when isnull(b.jul_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jul_13/NULLIF(b.jul_13,0) end) as jul_13_factor, 
						(case when isnull(b.aug_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.aug_13/NULLIF(b.aug_13,0) end) as aug_13_factor,
						(case when isnull(b.sep_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.sep_13/NULLIF(b.sep_13,0) end) as sep_13_factor,
						(case when isnull(b.oct_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.oct_13/NULLIF(b.oct_13,0) end) as oct_13_factor,
						(case when isnull(b.nov_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.nov_13/NULLIF(b.nov_13,0) end) as nov_13_factor,
						(case when isnull(b.dec_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.dec_13/NULLIF(b.dec_13,0) end) as dec_13_factor,
								
						(case when isnull(b.jan_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jan_14/NULLIF(b.jan_14,0) end) as jan_14_factor, 
						(case when isnull(b.feb_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.feb_14/NULLIF(b.feb_14,0) end) as feb_14_factor,
						(case when isnull(b.mar_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.mar_14/NULLIF(b.mar_14,0) end) as mar_14_factor,
						(case when isnull(b.apr_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.apr_14/NULLIF(b.apr_14,0) end) as apr_14_factor,
						(case when isnull(b.may_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.may_14/NULLIF(b.may_14,0) end) as may_14_factor,
						(case when isnull(b.jun_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jun_14/NULLIF(b.jun_14,0) end) as jun_14_factor,
						(case when isnull(b.jul_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jul_14/NULLIF(b.jul_14,0) end) as jul_14_factor, 
						(case when isnull(b.aug_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.aug_14/NULLIF(b.aug_14,0) end) as aug_14_factor,
						(case when isnull(b.sep_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.sep_14/NULLIF(b.sep_14,0) end) as sep_14_factor,
						(case when isnull(b.oct_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.oct_14/NULLIF(b.oct_14,0) end) as oct_14_factor,
						(case when isnull(b.nov_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.nov_14/NULLIF(b.nov_14,0) end) as nov_14_factor,
						(case when isnull(b.dec_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.dec_14/NULLIF(b.dec_14,0) end) as dec_14_factor,
						
						(case when isnull(b.cal15,0)=0 then 1 else a.cal15/NULLIF(b.cal15,0) end) as cal15_factor,
						(case when isnull(b.cal16,0)=0 then 1 else a.cal16/NULLIF(b.cal16,0) end) as cal16_factor,
						(case when isnull(b.cal17,0)=0 then 1 else a.cal17/NULLIF(b.cal17,0) end) as cal17_factor,
						(case when isnull(b.cal18,0)=0 then 1 else a.cal18/NULLIF(b.cal18,0) end) as cal18_factor,
						(case when isnull(b.cal19,0)=0 then 1 else a.cal19/NULLIF(b.cal19,0) end) as cal19_factor
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
								
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13*c.jan_13,0) as jan_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13*c.feb_13,0) as feb_13,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13*c.mar_13,0) as mar_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13*c.apr_13,0) as apr_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13*c.may_13,0) as may_13,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13*c.jun_13,0) as jun_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13*c.jul_13,0) as jul_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13*c.aug_13,0) as aug_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13*c.sep_13,0) as sep_13,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13*c.oct_13,0) as oct_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13*c.nov_13,0) as nov_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13*c.dec_13,0) as dec_13,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13*c.jan_13,0)+ISNULL(b.feb_13*c.feb_13,0)+ISNULL(b.mar_13*c.mar_13,0)+ISNULL(b.apr_13*c.apr_13,0)+ISNULL(b.may_13*c.may_13,0)+ISNULL(b.jun_13*c.jun_13,0)+ISNULL(b.jul_13*c.jul_13,0)+ISNULL(b.aug_13*c.aug_13,0)+ISNULL(b.sep_13*c.sep_13,0)+ISNULL(b.oct_13*c.oct_13,0)+ISNULL(b.nov_13*c.nov_13,0)+ISNULL(b.dec_13*c.dec_13,0)) as total_2013,
								
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14*c.jan_14,0) as jan_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14*c.feb_14,0) as feb_14,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14*c.mar_14,0) as mar_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14*c.apr_14,0) as apr_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14*c.may_14,0) as may_14,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14*c.jun_14,0) as jun_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14*c.jul_14,0) as jul_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14*c.aug_14,0) as aug_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14*c.sep_14,0) as sep_14,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14*c.oct_14,0) as oct_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14*c.nov_14,0) as nov_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14*c.dec_14,0) as dec_14,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14*c.jan_14,0)+ISNULL(b.feb_14*c.feb_14,0)+ISNULL(b.mar_14*c.mar_14,0)+ISNULL(b.apr_14*c.apr_14,0)+ISNULL(b.may_14*c.may_14,0)+ISNULL(b.jun_14*c.jun_14,0)+ISNULL(b.jul_14*c.jul_14,0)+ISNULL(b.aug_14*c.aug_14,0)+ISNULL(b.sep_14*c.sep_14,0)+ISNULL(b.oct_14*c.oct_14,0)+ISNULL(b.nov_14*c.nov_14,0)+ISNULL(b.dec_14*c.dec_14,0)) as total_2014,
														
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal15*c.cal15,0) as cal15, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL16*c.cal16,0) as cal16, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL17*c.cal17,0) as cal17, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL18*c.cal18,0) as cal18,
								ISNULL(a.QTY_PER*a.take_rate*a.family_allocation*b.CAL19*c.cal19,0) as cal19
						from	
					
								/* LEVEL 5 */
								(select * from eeiuser.acctg_csm_base_part_mnemonic
								) a 
								left outer join 
								(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03' 
								(SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
								and version = 'CSM'
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
										(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
										
										ISNULL(b.jan_13,0) as jan_13, 
										ISNULL(b.feb_13,0) as feb_13,
										ISNULL(b.mar_13,0) as mar_13, 
										ISNULL(b.apr_13,0) as apr_13, 
										ISNULL(b.may_13,0) as may_13,
										ISNULL(b.jun_13,0) as jun_13, 
										ISNULL(b.jul_13,0) as jul_13, 
										ISNULL(b.aug_13,0) as aug_13, 
										ISNULL(b.sep_13,0) as sep_13,  
										ISNULL(b.oct_13,0) as oct_13, 
										ISNULL(b.nov_13,0) as nov_13, 
										ISNULL(b.dec_13,0) as dec_13,  
										(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
					
										ISNULL(b.jan_14,0) as jan_14, 
										ISNULL(b.feb_14,0) as feb_14,
										ISNULL(b.mar_14,0) as mar_14, 
										ISNULL(b.apr_14,0) as apr_14, 
										ISNULL(b.may_14,0) as may_14,
										ISNULL(b.jun_14,0) as jun_14, 
										ISNULL(b.jul_14,0) as jul_14, 
										ISNULL(b.aug_14,0) as aug_14, 
										ISNULL(b.sep_14,0) as sep_14,  
										ISNULL(b.oct_14,0) as oct_14, 
										ISNULL(b.nov_14,0) as nov_14, 
										ISNULL(b.dec_14,0) as dec_14,  
										(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,
																									
										ISNULL(b.CAL15,0) as cal15, 
										ISNULL(b.CAL16,0) as cal16, 
										ISNULL(b.CAL17,0) as cal17, 
										ISNULL(b.CAL18,0) as cal18,
										ISNULL(b.CAL19,0) as cal19 
								from 
								
										/* LEVEL 6 */
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
										left outer join
										(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03' 
										(Select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										and version = 'Empire Factor'
										) b
										on a.mnemonic = b.mnemonic
										
										where b.mnemonic is not null 
								) c
								on a.base_part = c.base_part
								
							 	where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.cal17,0)+ISNULL(b.cal18,0)+ISNULL(b.cal19,0)) <>  0 
												
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
								
								sum(a.jan_13*b.jan_13) as jan_13, 
								sum(a.feb_13*b.feb_13) as feb_13, 
								sum(a.mar_13*b.mar_13) as mar_13, 
								sum(a.apr_13*b.apr_13) as apr_13, 
								sum(a.may_13*b.may_13) as may_13, 
								sum(a.jun_13*b.jun_13) as jun_13, 
								sum(a.jul_13*b.jul_13) as jul_13, 
								sum(a.aug_13*b.aug_13) as aug_13,
								sum(a.sep_13*b.sep_13) as sep_13, 
								sum(a.oct_13*b.oct_13) as oct_13, 
								sum(a.nov_13*b.nov_13) as nov_13, 
								sum(a.dec_13*b.dec_13) as dec_13,
								(sum(a.jan_13*b.jan_13)+sum(a.feb_13*b.feb_13)+sum(a.mar_13*b.mar_13)+sum(a.apr_13*b.apr_13)+sum(a.may_13*b.may_13)+sum(a.jun_13*b.jun_13)+sum(a.jul_13*b.jul_13)+sum(a.aug_13*b.aug_13)+sum(a.sep_13*b.sep_13)+sum(a.oct_13*b.oct_13)+sum(a.nov_13*b.nov_13)+sum(a.dec_13*b.dec_13)) as total_2013,
								
								sum(a.jan_14*b.jan_14) as jan_14, 
								sum(a.feb_14*b.feb_14) as feb_14, 
								sum(a.mar_14*b.mar_14) as mar_14, 
								sum(a.apr_14*b.apr_14) as apr_14, 
								sum(a.may_14*b.may_14) as may_14, 
								sum(a.jun_14*b.jun_14) as jun_14, 
								sum(a.jul_14*b.jul_14) as jul_14, 
								sum(a.aug_14*b.aug_14) as aug_14,
								sum(a.sep_14*b.sep_14) as sep_14, 
								sum(a.oct_14*b.oct_14) as oct_14, 
								sum(a.nov_14*b.nov_14) as nov_14, 
								sum(a.dec_14*b.dec_14) as dec_14,
								(sum(a.jan_14*b.jan_14)+sum(a.feb_14*b.feb_14)+sum(a.mar_14*b.mar_14)+sum(a.apr_14*b.apr_14)+sum(a.may_14*b.may_14)+sum(a.jun_14*b.jun_14)+sum(a.jul_14*b.jul_14)+sum(a.aug_14*b.aug_14)+sum(a.sep_14*b.sep_14)+sum(a.oct_14*b.oct_14)+sum(a.nov_14*b.nov_14)+sum(a.dec_14*b.dec_14)) as total_2014,
														
								sum(a.cal15*b.cal15) as cal15, 
								sum(a.cal16*b.cal16) as cal16, 
								sum(a.cal17*b.cal17) as cal17, 
								sum(a.cal18*b.cal18) as cal18,
								sum(a.cal19*b.cal19) as cal19
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
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13,0) as jan_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13,0) as feb_13,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13,0) as mar_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13,0) as apr_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13,0) as may_13,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13,0) as jun_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13,0) as jul_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13,0) as aug_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13,0) as sep_13,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13,0) as oct_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13,0) as nov_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13,0) as dec_13,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14,0) as jan_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14,0) as feb_14,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14,0) as mar_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14,0) as apr_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14,0) as may_14,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14,0) as jun_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14,0) as jul_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14,0) as aug_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14,0) as sep_14,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14,0) as oct_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14,0) as nov_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14,0) as dec_14,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,							
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL15,0) as cal15, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL16,0) as cal16, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL17,0) as cal17, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL18,0) as cal18,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal19,0) as cal19   
								from	
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a 
								
										left outer join 
								
										( select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
										(Select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										and version = 'CSM'
										) b
										on a.mnemonic = b.mnemonic 
								 
								 		where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.cal17,0)+ISNULL(b.CAL18,0)+ISNULL(b.CAL19,0)) <>  0 
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
		
										--removed a.qty_per*a.take_rate*a.family_allocation* as I couldn't see why it should be here (DW 4/17/2012)
										(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
		
										ISNULL(b.jan_13,0) as jan_13, 
										ISNULL(b.feb_13,0) as feb_13,
										ISNULL(b.mar_13,0) as mar_13, 
										ISNULL(b.apr_13,0) as apr_13, 
										ISNULL(b.may_13,0) as may_13,
										ISNULL(b.jun_13,0) as jun_13, 
										ISNULL(b.jul_13,0) as jul_13, 
										ISNULL(b.aug_13,0) as aug_13, 
										ISNULL(b.sep_13,0) as sep_13,  
										ISNULL(b.oct_13,0) as oct_13, 
										ISNULL(b.nov_13,0) as nov_13, 
										ISNULL(b.dec_13,0) as dec_13,  
										(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
												
										ISNULL(b.jan_14,0) as jan_14, 
										ISNULL(b.feb_14,0) as feb_14,
										ISNULL(b.mar_14,0) as mar_14, 
										ISNULL(b.apr_14,0) as apr_14, 
										ISNULL(b.may_14,0) as may_14,
										ISNULL(b.jun_14,0) as jun_14, 
										ISNULL(b.jul_14,0) as jul_14, 
										ISNULL(b.aug_14,0) as aug_14, 
										ISNULL(b.sep_14,0) as sep_14,  
										ISNULL(b.oct_14,0) as oct_14, 
										ISNULL(b.nov_14,0) as nov_14, 
										ISNULL(b.dec_14,0) as dec_14,  
										(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,
			
										ISNULL(b.cal15,0) as cal15, 
										ISNULL(b.cal16,0) as cal16, 
										ISNULL(b.cal17,0) as cal17, 
										ISNULL(b.cal18,0) as cal18,
										ISNULL(b.cal19,0) as cal19    
								
								from 
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
								
										left outer join
									
										( select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
										(Select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
										and version = 'Empire Factor'
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
		
						ISNULL(b.jan_13,0) as jan_13, 
						ISNULL(b.feb_13,0) as feb_13, 
						ISNULL(b.mar_13,0) as mar_13, 
						ISNULL(b.apr_13,0) as apr_13, 
						ISNULL(b.may_13,0) as may_13, 
						ISNULL(b.jun_13,0) as jun_13, 
						ISNULL(b.jul_13,0) as jul_13, 
						ISNULL(b.aug_13,0) as aug_13, 
						ISNULL(b.sep_13,0) as sep_13, 
						ISNULL(b.oct_13,0) as oct_13, 
						ISNULL(b.nov_13,0) as nov_13, 
						ISNULL(b.dec_13,0) as dec_13, 
						(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0))  as total_2013,
		
						ISNULL(b.jan_14,0) as jan_14, 
						ISNULL(b.feb_14,0) as feb_14, 
						ISNULL(b.mar_14,0) as mar_14, 
						ISNULL(b.apr_14,0) as apr_14, 
						ISNULL(b.may_14,0) as may_14, 
						ISNULL(b.jun_14,0) as jun_14, 
						ISNULL(b.jul_14,0) as jul_14, 
						ISNULL(b.aug_14,0) as aug_14, 
						ISNULL(b.sep_14,0) as sep_14, 
						ISNULL(b.oct_14,0) as oct_14, 
						ISNULL(b.nov_14,0) as nov_14, 
						ISNULL(b.dec_14,0) as dec_14, 
						(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0))  as total_2014,
				
						ISNULL(b.cal15,0) as cal15,
						ISNULL(b.cal16,0) as cal16,
						ISNULL(b.cal17,0) as cal17,
						ISNULL(b.cal18,0) as cal18,
						ISNULL(b.cal19,0) as cal19
				from    
						(select * from eeiuser.acctg_csm_base_part_mnemonic
						) a 
						left outer join 
						(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
						(SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
						) b
						on b.mnemonic = a.mnemonic 
						where	b.version = 'Empire Adjustment'
							and b.mnemonic is not null
							and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.CAL17,0)+ISNULL(b.CAL18,0)+ISNULL(b.CAL19,0)) <>  0
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
		
		left join   (	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevMaterialAccum ,0) as CurrentRevMaterialAccum,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNUll(BOMFlag,0) = 0 and 
				MCBASEPart not in (Select MCBasePart from vwft_ActivePartMaterialAccum where BOMFlag = 1) and
				PartDataBase = 'EEH'
	Union
	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevFrozenMaterialCost ,0) as CurrentRevMaterialAccum,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNull(BOMFlag,0) = 1 and 
				PartDataBase = 'EEI'
						)	ActivePartMaterialAccum
									
		on cc.base_part = MCBasePart
		
		where cc.base_part not in (select base_part from eeiuser.acctg_csm_excluded_base_parts where release_id = --'2011-03'
		(SELECT [dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
		and include_in_forecast = 0)

) a


full outer join 


/* LEVEL 1 */
(select	(SELECT [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) as [csm_Release2] 
		,(case when left(cc.base_part,3) = 'GUI' then 'VPP' else left(cc.base_part,3) end) as customer
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
		
		,[Jan_13_CSMdemand]
		,[Feb_13_CSMdemand]
		,[Mar_13_CSMdemand]
		,[Apr_13_CSMdemand]
		,[May_13_CSMdemand]
		,[Jun_13_CSMdemand]
		,[Jul_13_CSMdemand]
		,[Aug_13_CSMdemand]
		,[Sep_13_CSMdemand]
		,[Oct_13_CSMdemand]
		,[Nov_13_CSMdemand]
		,[Dec_13_CSMdemand]
		,[Total_13_CSMdemand]
		
		,[Jan_14_CSMdemand]
		,[Feb_14_CSMdemand]
		,[Mar_14_CSMdemand]
		,[Apr_14_CSMdemand]
		,[May_14_CSMdemand]
		,[Jun_14_CSMdemand]
		,[Jul_14_CSMdemand]
		,[Aug_14_CSMdemand]
		,[Sep_14_CSMdemand]
		,[Oct_14_CSMdemand]
		,[Nov_14_CSMdemand]
		,[Dec_14_CSMdemand]
		,[Total_14_CSMdemand]
		
		,[Cal15_CSMdemand]
		,[Cal16_CSMdemand]
		,[Cal17_CSMdemand]
		,[Cal18_CSMdemand]
		,[Cal19_CSMdemand]
		
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
		
		,[Jan_13_factor]
		,[Feb_13_factor]
		,[Mar_13_factor]
		,[Apr_13_factor]
		,[May_13_factor]
		,[Jun_13_factor]
		,[Jul_13_factor]
		,[Aug_13_factor]
		,[Sep_13_factor]
		,[Oct_13_factor]
		,[Nov_13_factor]
		,[Dec_13_factor]
		
		,[Jan_14_factor]
		,[Feb_14_factor]
		,[Mar_14_factor]
		,[Apr_14_factor]
		,[May_14_factor]
		,[Jun_14_factor]
		,[Jul_14_factor]
		,[Aug_14_factor]
		,[Sep_14_factor]
		,[Oct_14_factor]
		,[Nov_14_factor]
		,[Dec_14_factor]
		
		,[Cal15_factor]
		,[Cal16_factor]
		,[Cal17_factor]
		,[Cal18_factor]
		,[Cal19_factor]
		
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
		
		,[Jan_13_Empire_Adj]
		,[Feb_13_Empire_Adj]
		,[Mar_13_Empire_Adj]
		,[Apr_13_Empire_Adj]
		,[May_13_Empire_Adj]
		,[Jun_13_Empire_Adj]
		,[Jul_13_Empire_Adj]
		,[Aug_13_Empire_Adj]
		,[Sep_13_Empire_Adj]
		,[Oct_13_Empire_Adj]
		,[Nov_13_Empire_Adj]
		,[Dec_13_Empire_Adj]
		,[Total_13_Empire_Adj]
		
		,[Jan_14_Empire_Adj]
		,[Feb_14_Empire_Adj]
		,[Mar_14_Empire_Adj]
		,[Apr_14_Empire_Adj]
		,[May_14_Empire_Adj]
		,[Jun_14_Empire_Adj]
		,[Jul_14_Empire_Adj]
		,[Aug_14_Empire_Adj]
		,[Sep_14_Empire_Adj]
		,[Oct_14_Empire_Adj]
		,[Nov_14_Empire_Adj]
		,[Dec_14_Empire_Adj]
		,[Total_14_Empire_Adj]
		
		,[Cal15_Empire_Adj]
		,[Cal16_Empire_Adj]
		,[Cal17_Empire_Adj]
		,[Cal18_Empire_Adj]
		,[Cal19_Empire_adj]
		
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
		
		,[Jan_13_Allocated_Empire_Adj]
		,[Feb_13_Allocated_Empire_Adj]
		,[Mar_13_Allocated_Empire_Adj]
		,[Apr_13_Allocated_Empire_Adj]
		,[May_13_Allocated_Empire_Adj]
		,[Jun_13_Allocated_Empire_Adj]
		,[Jul_13_Allocated_Empire_Adj]
		,[Aug_13_Allocated_Empire_Adj]
		,[Sep_13_Allocated_Empire_Adj]
		,[Oct_13_Allocated_Empire_Adj]
		,[Nov_13_Allocated_Empire_Adj]
		,[Dec_13_Allocated_Empire_Adj]
		,[Total_13_Allocated_Empire_Adj]
		
		,[Jan_14_Allocated_Empire_Adj]
		,[Feb_14_Allocated_Empire_Adj]
		,[Mar_14_Allocated_Empire_Adj]
		,[Apr_14_Allocated_Empire_Adj]
		,[May_14_Allocated_Empire_Adj]
		,[Jun_14_Allocated_Empire_Adj]
		,[Jul_14_Allocated_Empire_Adj]
		,[Aug_14_Allocated_Empire_Adj]
		,[Sep_14_Allocated_Empire_Adj]
		,[Oct_14_Allocated_Empire_Adj]
		,[Nov_14_Allocated_Empire_Adj]
		,[Dec_14_Allocated_Empire_Adj]
		,[Total_14_Allocated_Empire_Adj]
		
		,[Cal15_Allocated_Empire_Adj]
		,[Cal16_Allocated_Empire_Adj]
		,[Cal17_Allocated_Empire_Adj]
		,[Cal18_Allocated_Empire_Adj]
		,[Cal19_Allocated_Empire_Adj]
		
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
		
		,[Jan_13_TOTALdemand]
		,[Feb_13_TOTALdemand]
		,[Mar_13_TOTALdemand]
		,[Apr_13_TOTALdemand]
		,[May_13_TOTALdemand]
		,[Jun_13_TOTALdemand]
		,[Jul_13_TOTALdemand]
		,[Aug_13_TOTALdemand]
		,[Sep_13_TOTALdemand]
		,[Oct_13_TOTALdemand]
		,[Nov_13_TOTALdemand]
		,[Dec_13_TOTALdemand]
		,[Total_2013_TOTALdemand]
		
		,[Jan_14_TOTALdemand]
		,[Feb_14_TOTALdemand]
		,[Mar_14_TOTALdemand]
		,[Apr_14_TOTALdemand]
		,[May_14_TOTALdemand]
		,[Jun_14_TOTALdemand]
		,[Jul_14_TOTALdemand]
		,[Aug_14_TOTALdemand]
		,[Sep_14_TOTALdemand]
		,[Oct_14_TOTALdemand]
		,[Nov_14_TOTALdemand]
		,[Dec_14_TOTALdemand]
		,[Total_2014_TOTALdemand]
		
		,[Cal15_TOTALdemand]
		,[Cal16_TOTALdemand]
		,[Cal17_TOTALdemand]
		,[Cal18_TOTALdemand]
		,[Cal19_TOTALdemand]
		
		,[sp_Dec_10]
		,[sp_Dec_11]
		,[sp_Dec_12]
		,[sp_Dec_13]
		,[sp_Dec_14]
		,[sp_Dec_15]
		,[sp_Dec_16]
		,[sp_Dec_17]
		,[sp_Dec_18]
		,[sp_Dec_19]
		
		,[Jan_10_TOTALdemand]*[sp_Jan_10] as 'Jan_10_Sales'
		,[Feb_10_TOTALdemand]*[sp_Feb_10] as 'Feb_10_Sales'
		,[Mar_10_TOTALdemand]*[sp_Mar_10] as 'Mar_10_Sales'
		,[Apr_10_TOTALdemand]*[sp_Apr_10] as 'Apr_10_Sales'
		,[May_10_TOTALdemand]*[sp_May_10] as 'May_10_Sales'
		,[Jun_10_TOTALdemand]*[sp_Jun_10] as 'Jun_10_Sales'
		,[Jul_10_TOTALdemand]*[sp_Jul_10] as 'Jul_10_Sales'
		,[Aug_10_TOTALdemand]*[sp_Aug_10] as 'Aug_10_Sales'
		,[Sep_10_TOTALdemand]*[sp_Sep_10] as 'Sep_10_Sales'
		,[Oct_10_TOTALdemand]*[sp_Oct_10] as 'Oct_10_Sales'
		,[Nov_10_TOTALdemand]*[sp_Nov_10] as 'Nov_10_Sales'
		,[Dec_10_TOTALdemand]*[sp_Dec_10] as 'Dec_10_Sales'
		,([Jan_10_TOTALdemand]*[sp_Jan_10])+([Feb_10_TOTALdemand]*[sp_Feb_10])+([Mar_10_TOTALdemand]*[sp_Mar_10])+([Apr_10_TOTALdemand]*[sp_Apr_10])
		+([May_10_TOTALdemand]*[sp_May_10])+([Jun_10_TOTALdemand]*[sp_Jun_10])+([Jul_10_TOTALdemand]*[sp_Jul_10])+([Aug_10_TOTALdemand]*[sp_Aug_10])
		+([Sep_10_TOTALdemand]*[sp_Sep_10])+([Oct_10_TOTALdemand]*[sp_Oct_10])+([Nov_10_TOTALdemand]*[sp_Nov_10])+([Dec_10_TOTALdemand]*[sp_Dec_10]) as 'Cal_10_Sales' 
		
		,[Jan_11_TOTALdemand]*[sp_Jan_11] as 'Jan_11_Sales'
		,[Feb_11_TOTALdemand]*[sp_Feb_11] as 'Feb_11_Sales'
		,[Mar_11_TOTALdemand]*[sp_Mar_11] as 'Mar_11_Sales'
		,[Apr_11_TOTALdemand]*[sp_Apr_11] as 'Apr_11_Sales'
		,[May_11_TOTALdemand]*[sp_May_11] as 'May_11_Sales'
		,[Jun_11_TOTALdemand]*[sp_Jun_11] as 'Jun_11_Sales'
		,[Jul_11_TOTALdemand]*[sp_Jul_11] as 'Jul_11_Sales'
		,[Aug_11_TOTALdemand]*[sp_Aug_11] as 'Aug_11_Sales'
		,[Sep_11_TOTALdemand]*[sp_Sep_11] as 'Sep_11_Sales'
		,[Oct_11_TOTALdemand]*[sp_Oct_11] as 'Oct_11_Sales'
		,[Nov_11_TOTALdemand]*[sp_Nov_11] as 'Nov_11_Sales'
		,[Dec_11_TOTALdemand]*[sp_Dec_11] as 'Dec_11_Sales'
		,([Jan_11_TOTALdemand]*[sp_Jan_11])+([Feb_11_TOTALdemand]*[sp_Feb_11])+([Mar_11_TOTALdemand]*[sp_Mar_11])+([Apr_11_TOTALdemand]*[sp_Apr_11])
		+([May_11_TOTALdemand]*[sp_May_11])+([Jun_11_TOTALdemand]*[sp_Jun_11])+([Jul_11_TOTALdemand]*[sp_Jul_11])+([Aug_11_TOTALdemand]*[sp_Aug_11])
		+([Sep_11_TOTALdemand]*[sp_Sep_11])+([Oct_11_TOTALdemand]*[sp_Oct_11])+([Nov_11_TOTALdemand]*[sp_Nov_11])+([Dec_11_TOTALdemand]*[sp_Dec_11]) as 'Cal_11_Sales' 
		
		,[Jan_12_TOTALdemand]*[sp_Jan_12] as 'Jan_12_Sales'
		,[Feb_12_TOTALdemand]*[sp_Feb_12] as 'Feb_12_Sales'
		,[Mar_12_TOTALdemand]*[sp_Mar_12] as 'Mar_12_Sales'
		,[Apr_12_TOTALdemand]*[sp_Apr_12] as 'Apr_12_Sales'
		,[May_12_TOTALdemand]*[sp_May_12] as 'May_12_Sales'
		,[Jun_12_TOTALdemand]*[sp_Jun_12] as 'Jun_12_Sales'
		,[Jul_12_TOTALdemand]*[sp_Jul_12] as 'Jul_12_Sales'
		,[Aug_12_TOTALdemand]*[sp_Aug_12] as 'Aug_12_Sales'
		,[Sep_12_TOTALdemand]*[sp_Sep_12] as 'Sep_12_Sales'
		,[Oct_12_TOTALdemand]*[sp_Oct_12] as 'Oct_12_Sales'
		,[Nov_12_TOTALdemand]*[sp_Nov_12] as 'Nov_12_Sales'
		,[Dec_12_TOTALdemand]*[sp_Dec_12] as 'Dec_12_Sales'
		,([Jan_12_TOTALdemand]*[sp_Jan_12])+([Feb_12_TOTALdemand]*[sp_Feb_12])+([Mar_12_TOTALdemand]*[sp_Mar_12])+([Apr_12_TOTALdemand]*[sp_Apr_12])
		+([May_12_TOTALdemand]*[sp_May_12])+([Jun_12_TOTALdemand]*[sp_Jun_12])+([Jul_12_TOTALdemand]*[sp_Jul_12])+([Aug_12_TOTALdemand]*[sp_Aug_12])
		+([Sep_12_TOTALdemand]*[sp_Sep_12])+([Oct_12_TOTALdemand]*[sp_Oct_12])+([Nov_12_TOTALdemand]*[sp_Nov_12])+([Dec_12_TOTALdemand]*[sp_Dec_12]) as 'Cal_12_Sales' 
		
		,[Jan_13_TOTALdemand]*[sp_Jan_13] as 'Jan_13_Sales'
		,[Feb_13_TOTALdemand]*[sp_Feb_13] as 'Feb_13_Sales'
		,[Mar_13_TOTALdemand]*[sp_Mar_13] as 'Mar_13_Sales'
		,[Apr_13_TOTALdemand]*[sp_Apr_13] as 'Apr_13_Sales'
		,[May_13_TOTALdemand]*[sp_May_13] as 'May_13_Sales'
		,[Jun_13_TOTALdemand]*[sp_Jun_13] as 'Jun_13_Sales'
		,[Jul_13_TOTALdemand]*[sp_Jul_13] as 'Jul_13_Sales'
		,[Aug_13_TOTALdemand]*[sp_Aug_13] as 'Aug_13_Sales'
		,[Sep_13_TOTALdemand]*[sp_Sep_13] as 'Sep_13_Sales'
		,[Oct_13_TOTALdemand]*[sp_Oct_13] as 'Oct_13_Sales'
		,[Nov_13_TOTALdemand]*[sp_Nov_13] as 'Nov_13_Sales'
		,[Dec_13_TOTALdemand]*[sp_Dec_13] as 'Dec_13_Sales'
		,([Jan_13_TOTALdemand]*[sp_Jan_13])+([Feb_13_TOTALdemand]*[sp_Feb_13])+([Mar_13_TOTALdemand]*[sp_Mar_13])+([Apr_13_TOTALdemand]*[sp_Apr_13])
		+([May_13_TOTALdemand]*[sp_May_13])+([Jun_13_TOTALdemand]*[sp_Jun_13])+([Jul_13_TOTALdemand]*[sp_Jul_13])+([Aug_13_TOTALdemand]*[sp_Aug_13])
		+([Sep_13_TOTALdemand]*[sp_Sep_13])+([Oct_13_TOTALdemand]*[sp_Oct_13])+([Nov_13_TOTALdemand]*[sp_Nov_13])+([Dec_13_TOTALdemand]*[sp_Dec_13]) as 'Cal_13_Sales' 
		
		,[Jan_14_TOTALdemand]*[sp_Jan_14] as 'Jan_14_Sales'
		,[Feb_14_TOTALdemand]*[sp_Feb_14] as 'Feb_14_Sales'
		,[Mar_14_TOTALdemand]*[sp_Mar_14] as 'Mar_14_Sales'
		,[Apr_14_TOTALdemand]*[sp_Apr_14] as 'Apr_14_Sales'
		,[May_14_TOTALdemand]*[sp_May_14] as 'May_14_Sales'
		,[Jun_14_TOTALdemand]*[sp_Jun_14] as 'Jun_14_Sales'
		,[Jul_14_TOTALdemand]*[sp_Jul_14] as 'Jul_14_Sales'
		,[Aug_14_TOTALdemand]*[sp_Aug_14] as 'Aug_14_Sales'
		,[Sep_14_TOTALdemand]*[sp_Sep_14] as 'Sep_14_Sales'
		,[Oct_14_TOTALdemand]*[sp_Oct_14] as 'Oct_14_Sales'
		,[Nov_14_TOTALdemand]*[sp_Nov_14] as 'Nov_14_Sales'
		,[Dec_14_TOTALdemand]*[sp_Dec_14] as 'Dec_14_Sales'
		,([Jan_14_TOTALdemand]*[sp_Jan_14])+([Feb_14_TOTALdemand]*[sp_Feb_14])+([Mar_14_TOTALdemand]*[sp_Mar_14])+([Apr_14_TOTALdemand]*[sp_Apr_14])
		+([May_14_TOTALdemand]*[sp_May_14])+([Jun_14_TOTALdemand]*[sp_Jun_14])+([Jul_14_TOTALdemand]*[sp_Jul_14])+([Aug_14_TOTALdemand]*[sp_Aug_14])
		+([Sep_14_TOTALdemand]*[sp_Sep_14])+([Oct_14_TOTALdemand]*[sp_Oct_14])+([Nov_14_TOTALdemand]*[sp_Nov_14])+([Dec_14_TOTALdemand]*[sp_Dec_14]) as 'Cal_14_Sales' 
		
		,[Cal15_TOTALdemand]*[sp_Dec_15] as 'Cal_15_Sales'
		,[Cal16_TOTALdemand]*[sp_Dec_16] as 'Cal_16_Sales'
		,[Cal17_TOTALdemand]*[sp_Dec_17] as 'Cal_17_Sales'
		,[Cal18_TOTALdemand]*[sp_Dec_18] as 'Cal_18_Sales'
		,[Cal19_TOTALdemand]*[sp_Dec_19] as 'Cal_19_Sales'
		
		,([Jan_12_TOTALdemand]*[sp_Jan_12])+([Feb_12_TOTALdemand]*[sp_Feb_12])+([Mar_12_TOTALdemand]*[sp_Mar_12])+([Apr_12_TOTALdemand]*[sp_Apr_12])
		+([May_12_TOTALdemand]*[sp_May_12])+([Jun_12_TOTALdemand]*[sp_Jun_12])+([Jul_12_TOTALdemand]*[sp_Jul_12])+([Aug_12_TOTALdemand]*[sp_Aug_12])
		+([Sep_12_TOTALdemand]*[sp_Sep_12])+([Oct_12_TOTALdemand]*[sp_Oct_12])+([Nov_12_TOTALdemand]*[sp_Nov_12])+([Dec_12_TOTALdemand]*[sp_Dec_12])
		+([Jan_13_TOTALdemand]*[sp_Jan_13])+([Feb_13_TOTALdemand]*[sp_Feb_13])+([Mar_13_TOTALdemand]*[sp_Mar_13])+([Apr_13_TOTALdemand]*[sp_Apr_13])
		+([May_13_TOTALdemand]*[sp_May_13])+([Jun_13_TOTALdemand]*[sp_Jun_13])+([Jul_13_TOTALdemand]*[sp_Jul_13])+([Aug_13_TOTALdemand]*[sp_Aug_13])
		+([Sep_13_TOTALdemand]*[sp_Sep_13])+([Oct_13_TOTALdemand]*[sp_Oct_13])+([Nov_13_TOTALdemand]*[sp_Nov_13])+([Dec_13_TOTALdemand]*[sp_Dec_13]) 
		+([Jan_14_TOTALdemand]*[sp_Jan_14])+([Feb_14_TOTALdemand]*[sp_Feb_14])+([Mar_14_TOTALdemand]*[sp_Mar_14])+([Apr_14_TOTALdemand]*[sp_Apr_14])
		+([May_14_TOTALdemand]*[sp_May_14])+([Jun_14_TOTALdemand]*[sp_Jun_14])+([Jul_14_TOTALdemand]*[sp_Jul_14])+([Aug_14_TOTALdemand]*[sp_Aug_14])
		+([Sep_14_TOTALdemand]*[sp_Sep_14])+([Oct_14_TOTALdemand]*[sp_Oct_14])+([Nov_14_TOTALdemand]*[sp_Nov_14])+([Dec_14_TOTALdemand]*[sp_Dec_14]) 
		+([Cal15_TOTALdemand]*[sp_Dec_15])
		+([Cal16_TOTALdemand]*[sp_Dec_16])
		+([Cal17_TOTALdemand]*[sp_Dec_17])
		+([Cal18_TOTALdemand]*[sp_Dec_18])
		+([Cal19_TOTALdemand]*[sp_Dec_19]) as '2012-2019 Sales'
		
		,Coalesce((ActivePartMaterialAccum.CurrentRevPart),'NoActivePartDefined') as ActiveRevLevel
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0) as ActiveRevPartMaterialAccum
		
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand] as Jan_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand] as Feb_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand] as Mar_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand] as Apr_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand] as May_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand] as Jun_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand] as Jul_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand] as Aug_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand] as Sep_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand] as Oct_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand] as Nov_10_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand] as Dec_10_TOTALMaterialCUM
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_10_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_10_TOTALdemand]) as Cal10_Material_cost
	
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand] as Jan_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand] as Feb_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand] as Mar_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand] as Apr_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand] as May_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand] as Jun_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand] as Jul_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand] as Aug_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand] as Sep_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand] as Oct_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand] as Nov_11_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand] as Dec_11_TOTALMaterialCUM
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_11_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_11_TOTALdemand]) as Cal11_Material_cost
	
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand] as Jan_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand] as Feb_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand] as Mar_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand] as Apr_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand] as May_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand] as Jun_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand] as Jul_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand] as Aug_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand] as Sep_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand] as Oct_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand] as Nov_12_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand] as Dec_12_TOTALMaterialCUM
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_12_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_12_TOTALdemand]) as Cal12_Material_cost

		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand] as Jan_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand] as Feb_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand] as Mar_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand] as Apr_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand] as May_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand] as Jun_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand] as Jul_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand] as Aug_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand] as Sep_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand] as Oct_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand] as Nov_13_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand] as Dec_13_TOTALMaterialCUM
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_13_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_13_TOTALdemand]) as Cal13_Material_cost
		
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_14_TOTALdemand] as Jan_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_14_TOTALdemand] as Feb_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_14_TOTALdemand] as Mar_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_14_TOTALdemand] as Apr_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_14_TOTALdemand] as May_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_14_TOTALdemand] as Jun_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_14_TOTALdemand] as Jul_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_14_TOTALdemand] as Aug_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_14_TOTALdemand] as Sep_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_14_TOTALdemand] as Oct_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_14_TOTALdemand] as Nov_14_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_14_TOTALdemand] as Dec_14_TOTALMaterialCUM
		,(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jan_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Feb_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Mar_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Apr_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[May_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jun_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Jul_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Aug_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Sep_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Oct_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Nov_14_TOTALdemand])+(Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Dec_14_TOTALdemand]) as Cal14_Material_cost
				
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal15_TOTALdemand] as Cal15_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal16_TOTALdemand] as Cal16_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal17_TOTALdemand] as Cal17_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal18_TOTALdemand] as Cal18_TOTALMaterialCUM
		,Coalesce(ActivePartMaterialAccum.CurrentRevMaterialAccum,0)*[Cal19_TOTALdemand] as Cal19_TOTALMaterialCUM
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
		
				isnull(aa.Jan_13_CSMdemand,0) as Jan_13_CSMdemand,
				isnull(aa.Feb_13_CSMdemand,0) as Feb_13_CSMdemand,
				isnull(aa.Mar_13_CSMdemand,0) as Mar_13_CSMdemand,
				isnull(aa.Apr_13_CSMdemand,0) as Apr_13_CSMdemand,
				isnull(aa.May_13_CSMdemand,0) as May_13_CSMdemand,
				isnull(aa.Jun_13_CSMdemand,0) as Jun_13_CSMdemand,
				isnull(aa.Jul_13_CSMdemand,0) as Jul_13_CSMdemand,
				isnull(aa.Aug_13_CSMdemand,0) as Aug_13_CSMdemand,
				isnull(aa.Sep_13_CSMdemand,0) as Sep_13_CSMdemand,
				isnull(aa.Oct_13_CSMdemand,0) as Oct_13_CSMdemand,
				isnull(aa.Nov_13_CSMdemand,0) as Nov_13_CSMdemand,
				isnull(aa.Dec_13_CSMdemand,0) as Dec_13_CSMdemand,
				isnull(aa.Total_13_CSMdemand,0) as Total_13_CSMdemand,
		
				isnull(aa.Jan_14_CSMdemand,0) as Jan_14_CSMdemand,
				isnull(aa.Feb_14_CSMdemand,0) as Feb_14_CSMdemand,
				isnull(aa.Mar_14_CSMdemand,0) as Mar_14_CSMdemand,
				isnull(aa.Apr_14_CSMdemand,0) as Apr_14_CSMdemand,
				isnull(aa.May_14_CSMdemand,0) as May_14_CSMdemand,
				isnull(aa.Jun_14_CSMdemand,0) as Jun_14_CSMdemand,
				isnull(aa.Jul_14_CSMdemand,0) as Jul_14_CSMdemand,
				isnull(aa.Aug_14_CSMdemand,0) as Aug_14_CSMdemand,
				isnull(aa.Sep_14_CSMdemand,0) as Sep_14_CSMdemand,
				isnull(aa.Oct_14_CSMdemand,0) as Oct_14_CSMdemand,
				isnull(aa.Nov_14_CSMdemand,0) as Nov_14_CSMdemand,
				isnull(aa.Dec_14_CSMdemand,0) as Dec_14_CSMdemand,
				isnull(aa.Total_14_CSMdemand,0) as Total_14_CSMdemand,
				
				isnull(aa.Cal15_CSMdemand,0) as Cal15_CSMdemand,
				isnull(aa.Cal16_CSMdemand,0) as Cal16_CSMdemand,
				isnull(aa.Cal17_CSMdemand,0) as Cal17_CSMdemand,
				isnull(aa.Cal18_CSMdemand,0) as Cal18_CSMdemand,
				isnull(aa.Cal19_CSMdemand,0) as Cal19_CSMdemand,
		
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
				
				isnull(aa.Jan_13_factor,1) as Jan_13_factor,
				isnull(aa.Feb_13_factor,1) as Feb_13_factor,
				isnull(aa.Mar_13_factor,1) as Mar_13_factor,
				isnull(aa.Apr_13_factor,1) as Apr_13_factor,
				isnull(aa.May_13_factor,1) as May_13_factor,
				isnull(aa.Jun_13_factor,1) as Jun_13_factor,
				isnull(aa.Jul_13_factor,1) as Jul_13_factor,
				isnull(aa.Aug_13_factor,1) as Aug_13_factor,
				isnull(aa.Sep_13_factor,1) as Sep_13_factor,
				isnull(aa.Oct_13_factor,1) as Oct_13_factor,
				isnull(aa.Nov_13_factor,1) as Nov_13_factor,
				isnull(aa.Dec_13_factor,1) as Dec_13_factor,			
				
				isnull(aa.Jan_14_factor,1) as Jan_14_factor,
				isnull(aa.Feb_14_factor,1) as Feb_14_factor,
				isnull(aa.Mar_14_factor,1) as Mar_14_factor,
				isnull(aa.Apr_14_factor,1) as Apr_14_factor,
				isnull(aa.May_14_factor,1) as May_14_factor,
				isnull(aa.Jun_14_factor,1) as Jun_14_factor,
				isnull(aa.Jul_14_factor,1) as Jul_14_factor,
				isnull(aa.Aug_14_factor,1) as Aug_14_factor,
				isnull(aa.Sep_14_factor,1) as Sep_14_factor,
				isnull(aa.Oct_14_factor,1) as Oct_14_factor,
				isnull(aa.Nov_14_factor,1) as Nov_14_factor,
				isnull(aa.Dec_14_factor,1) as Dec_14_factor,			
			
				isnull(aa.Cal15_factor,1) as Cal15_factor,
				isnull(aa.Cal16_factor,1) as Cal16_factor,
				isnull(aa.Cal17_factor,1) as Cal17_factor,
				isnull(aa.Cal18_factor,1) as Cal18_factor,
				isnull(aa.CAL19_factor,1) as Cal19_factor,
		
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
	
				isnull(bb.Jan_13,0) as Jan_13_Empire_Adj,
				isnull(bb.Feb_13,0) as Feb_13_Empire_Adj,
				isnull(bb.Mar_13,0) as Mar_13_Empire_Adj,
				isnull(bb.Apr_13,0) as Apr_13_Empire_Adj,
				isnull(bb.May_13,0) as May_13_Empire_Adj,
				isnull(bb.Jun_13,0) as Jun_13_Empire_Adj,		
				isnull(bb.Jul_13,0) as Jul_13_Empire_Adj,
				isnull(bb.Aug_13,0) as Aug_13_Empire_Adj,
				isnull(bb.Sep_13,0) as Sep_13_Empire_Adj,		
				isnull(bb.Oct_13,0) as Oct_13_Empire_Adj,
				isnull(bb.Nov_13,0) as Nov_13_Empire_Adj,
				isnull(bb.Dec_13,0) as Dec_13_Empire_Adj,
				isnull(bb.Total_2013,0) as Total_13_Empire_Adj,
	
				isnull(bb.Jan_14,0) as Jan_14_Empire_Adj,
				isnull(bb.Feb_14,0) as Feb_14_Empire_Adj,
				isnull(bb.Mar_14,0) as Mar_14_Empire_Adj,
				isnull(bb.Apr_14,0) as Apr_14_Empire_Adj,
				isnull(bb.May_14,0) as May_14_Empire_Adj,
				isnull(bb.Jun_14,0) as Jun_14_Empire_Adj,		
				isnull(bb.Jul_14,0) as Jul_14_Empire_Adj,
				isnull(bb.Aug_14,0) as Aug_14_Empire_Adj,
				isnull(bb.Sep_14,0) as Sep_14_Empire_Adj,		
				isnull(bb.Oct_14,0) as Oct_14_Empire_Adj,
				isnull(bb.Nov_14,0) as Nov_14_Empire_Adj,
				isnull(bb.Dec_14,0) as Dec_14_Empire_Adj,
				isnull(bb.Total_2014,0) as Total_14_Empire_Adj,
				
				ISNULL(bb.cal15,0) as Cal15_Empire_Adj,
				isnull(bb.Cal16,0) as Cal16_Empire_Adj,
				isnull(bb.Cal17,0) as Cal17_Empire_Adj,
				isnull(bb.Cal18,0) as Cal18_Empire_Adj,
				isnull(bb.Cal19,0) as Cal19_Empire_Adj,			
				
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
				
				isnull(aa.Jan_13_factor,1)*bb.Jan_13 as Jan_13_Allocated_Empire_Adj,
				isnull(aa.Feb_13_factor,1)*bb.Feb_13 as Feb_13_Allocated_Empire_Adj,
				isnull(aa.Mar_13_factor,1)*bb.Mar_13 as Mar_13_Allocated_Empire_Adj,
				isnull(aa.Apr_13_factor,1)*bb.Apr_13 as Apr_13_Allocated_Empire_Adj,
				isnull(aa.May_13_factor,1)*bb.May_13 as May_13_Allocated_Empire_Adj,
				isnull(aa.Jun_13_factor,1)*bb.Jun_13 as Jun_13_Allocated_Empire_Adj,
				isnull(aa.Jul_13_factor,1)*bb.Jul_13 as Jul_13_Allocated_Empire_Adj,
				isnull(aa.Aug_13_factor,1)*bb.Aug_13 as Aug_13_Allocated_Empire_Adj,
				isnull(aa.Sep_13_factor,1)*bb.Sep_13 as Sep_13_Allocated_Empire_Adj,
				isnull(aa.Oct_13_factor,1)*bb.Oct_13 as Oct_13_Allocated_Empire_Adj,
				isnull(aa.Nov_13_factor,1)*bb.Nov_13 as Nov_13_Allocated_Empire_Adj,
				isnull(aa.Dec_13_factor,1)*bb.Dec_13 as Dec_13_Allocated_Empire_Adj,
				((isnull(aa.Jan_13_factor,1)*bb.Jan_13) + (isnull(aa.Feb_13_factor,1)*bb.Feb_13) + (isnull(aa.Mar_13_factor,1)*bb.Mar_13) + (isnull(aa.Apr_13_factor,1)*bb.Apr_13) + (isnull(aa.May_13_factor,1)*bb.May_13) + (isnull(aa.Jun_13_factor,1)*bb.Jun_13) + (isnull(aa.Jul_13_factor,1)*bb.Jul_13) + (isnull(aa.Aug_13_factor,1)*bb.Aug_13) + (isnull(aa.Sep_13_factor,1)*bb.Sep_13) +  (isnull(aa.Oct_13_factor,1)*bb.Oct_13) + (isnull(aa.Nov_13_factor,1)*bb.Nov_13) +  (isnull(aa.Dec_13_factor,1)*bb.Dec_13)) as Total_13_Allocated_Empire_Adj,
				
				isnull(aa.Jan_14_factor,1)*bb.Jan_14 as Jan_14_Allocated_Empire_Adj,
				isnull(aa.Feb_14_factor,1)*bb.Feb_14 as Feb_14_Allocated_Empire_Adj,
				isnull(aa.Mar_14_factor,1)*bb.Mar_14 as Mar_14_Allocated_Empire_Adj,
				isnull(aa.Apr_14_factor,1)*bb.Apr_14 as Apr_14_Allocated_Empire_Adj,
				isnull(aa.May_14_factor,1)*bb.May_14 as May_14_Allocated_Empire_Adj,
				isnull(aa.Jun_14_factor,1)*bb.Jun_14 as Jun_14_Allocated_Empire_Adj,
				isnull(aa.Jul_14_factor,1)*bb.Jul_14 as Jul_14_Allocated_Empire_Adj,
				isnull(aa.Aug_14_factor,1)*bb.Aug_14 as Aug_14_Allocated_Empire_Adj,
				isnull(aa.Sep_14_factor,1)*bb.Sep_14 as Sep_14_Allocated_Empire_Adj,
				isnull(aa.Oct_14_factor,1)*bb.Oct_14 as Oct_14_Allocated_Empire_Adj,
				isnull(aa.Nov_14_factor,1)*bb.Nov_14 as Nov_14_Allocated_Empire_Adj,
				isnull(aa.Dec_14_factor,1)*bb.Dec_14 as Dec_14_Allocated_Empire_Adj,
				((isnull(aa.Jan_14_factor,1)*bb.Jan_14) + (isnull(aa.Feb_14_factor,1)*bb.Feb_14) + (isnull(aa.Mar_14_factor,1)*bb.Mar_14) + (isnull(aa.Apr_14_factor,1)*bb.Apr_14) + (isnull(aa.May_14_factor,1)*bb.May_14) + (isnull(aa.Jun_14_factor,1)*bb.Jun_14) + (isnull(aa.Jul_14_factor,1)*bb.Jul_14) + (isnull(aa.Aug_14_factor,1)*bb.Aug_14) + (isnull(aa.Sep_14_factor,1)*bb.Sep_14) +  (isnull(aa.Oct_14_factor,1)*bb.Oct_14) + (isnull(aa.Nov_14_factor,1)*bb.Nov_14) +  (isnull(aa.Dec_14_factor,1)*bb.Dec_14)) as Total_14_Allocated_Empire_Adj,
				
				isnull(aa.Cal15_factor,1)*bb.Cal15 as Cal15_Allocated_Empire_Adj,
				isnull(aa.Cal16_factor,1)*bb.Cal16 as Cal16_Allocated_Empire_Adj,
				isnull(aa.Cal17_factor,1)*bb.Cal17 as Cal17_Allocated_Empire_Adj,
				isnull(aa.Cal18_factor,1)*bb.Cal18 as Cal18_Allocated_Empire_Adj,
				isnull(aa.CAL19_factor,1)*bb.CAL19 as CAL19_Allocated_Empire_Adj,
				
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
				
	
				isnull(aa.Jan_13_CSMdemand,0) + (isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) as Jan_13_TOTALdemand,
				isnull(aa.Feb_13_CSMdemand,0) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) as Feb_13_TOTALdemand,
				isnull(aa.Mar_13_CSMdemand,0) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) as Mar_13_TOTALdemand,
				isnull(aa.Apr_13_CSMdemand,0) + (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) as Apr_13_TOTALdemand,
				isnull(aa.May_13_CSMdemand,0) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) as May_13_TOTALdemand,
				isnull(aa.Jun_13_CSMdemand,0) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) as Jun_13_TOTALdemand,
				isnull(aa.Jul_13_CSMdemand,0) + (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) as Jul_13_TOTALdemand,
				isnull(aa.Aug_13_CSMdemand,0) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) as Aug_13_TOTALdemand,
				isnull(aa.Sep_13_CSMdemand,0) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) as Sep_13_TOTALdemand,
				isnull(aa.Oct_13_CSMdemand,0) + (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) as Oct_13_TOTALdemand,
				isnull(aa.Nov_13_CSMdemand,0) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) as Nov_13_TOTALdemand,
				isnull(aa.Dec_13_CSMdemand,0) + (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0)) as Dec_13_TOTALdemand,		
				isnull(aa.Total_13_CSMdemand,0) + ((isnull(aa.Jan_13_factor,1)*isnull(bb.Jan_13,0)) + (isnull(aa.Feb_13_factor,1)*isnull(bb.Feb_13,0)) + (isnull(aa.Mar_13_factor,1)*isnull(bb.Mar_13,0)) + (isnull(aa.Apr_13_factor,1)*isnull(bb.Apr_13,0)) + (isnull(aa.May_13_factor,1)*isnull(bb.May_13,0)) + (isnull(aa.Jun_13_factor,1)*isnull(bb.Jun_13,0)) + (isnull(aa.Jul_13_factor,1)*isnull(bb.Jul_13,0)) + (isnull(aa.Aug_13_factor,1)*isnull(bb.Aug_13,0)) + (isnull(aa.Sep_13_factor,1)*isnull(bb.Sep_13,0)) +  (isnull(aa.Oct_13_factor,1)*isnull(bb.Oct_13,0)) + (isnull(aa.Nov_13_factor,1)*isnull(bb.Nov_13,0)) +  (isnull(aa.Dec_13_factor,1)*isnull(bb.Dec_13,0))) as Total_2013_TOTALdemand,
				
				isnull(aa.Jan_14_CSMdemand,0) + (isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) as Jan_14_TOTALdemand,
				isnull(aa.Feb_14_CSMdemand,0) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) as Feb_14_TOTALdemand,
				isnull(aa.Mar_14_CSMdemand,0) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) as Mar_14_TOTALdemand,
				isnull(aa.Apr_14_CSMdemand,0) + (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) as Apr_14_TOTALdemand,
				isnull(aa.May_14_CSMdemand,0) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) as May_14_TOTALdemand,
				isnull(aa.Jun_14_CSMdemand,0) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0)) as Jun_14_TOTALdemand,
				isnull(aa.Jul_14_CSMdemand,0) + (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) as Jul_14_TOTALdemand,
				isnull(aa.Aug_14_CSMdemand,0) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) as Aug_14_TOTALdemand,
				isnull(aa.Sep_14_CSMdemand,0) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) as Sep_14_TOTALdemand,
				isnull(aa.Oct_14_CSMdemand,0) + (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) as Oct_14_TOTALdemand,
				isnull(aa.Nov_14_CSMdemand,0) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) as Nov_14_TOTALdemand,
				isnull(aa.Dec_14_CSMdemand,0) + (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0)) as Dec_14_TOTALdemand,		
				isnull(aa.Total_14_CSMdemand,0) + ((isnull(aa.Jan_14_factor,1)*isnull(bb.Jan_14,0)) + (isnull(aa.Feb_14_factor,1)*isnull(bb.Feb_14,0)) + (isnull(aa.Mar_14_factor,1)*isnull(bb.Mar_14,0)) + (isnull(aa.Apr_14_factor,1)*isnull(bb.Apr_14,0)) + (isnull(aa.May_14_factor,1)*isnull(bb.May_14,0)) + (isnull(aa.Jun_14_factor,1)*isnull(bb.Jun_14,0)) + (isnull(aa.Jul_14_factor,1)*isnull(bb.Jul_14,0)) + (isnull(aa.Aug_14_factor,1)*isnull(bb.Aug_14,0)) + (isnull(aa.Sep_14_factor,1)*isnull(bb.Sep_14,0)) +  (isnull(aa.Oct_14_factor,1)*isnull(bb.Oct_14,0)) + (isnull(aa.Nov_14_factor,1)*isnull(bb.Nov_14,0)) +  (isnull(aa.Dec_14_factor,1)*isnull(bb.Dec_14,0))) as Total_2014_TOTALdemand,
							
				isnull(aa.Cal15_CSMdemand,0) + (isnull(aa.Cal15_factor,1)*isnull(bb.Cal15,0)) as Cal15_TOTALdemand,	
				isnull(aa.Cal16_CSMdemand,0) + (isnull(aa.Cal16_factor,1)*isnull(bb.Cal16,0)) as Cal16_TOTALdemand,	
				isnull(aa.Cal17_CSMdemand,0) + (isnull(aa.cal17_factor,1)*isnull(bb.Cal17,0)) as Cal17_TOTALdemand,	
				isnull(aa.Cal18_CSMdemand,0) + (isnull(aa.Cal18_factor,1)*isnull(bb.Cal18,0)) as Cal18_TOTALdemand,	
				isnull(aa.Cal19_CSMdemand,0) + (isnull(aa.Cal19_factor,1)*isnull(bb.Cal19,0)) as Cal19_TOTALdemand	
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
		
						a.jan_13 as Jan_13_CSMdemand,
						a.feb_13 as Feb_13_CSMdemand,
						a.mar_13 as Mar_13_CSMdemand,
						a.apr_13 as Apr_13_CSMdemand,
						a.may_13 as May_13_CSMdemand,
						a.jun_13 as Jun_13_CSMdemand,
						a.jul_13 as Jul_13_CSMdemand,
						a.aug_13 as Aug_13_CSMdemand,
						a.sep_13 as Sep_13_CSMdemand,
						a.oct_13 as Oct_13_CSMdemand,
						a.nov_13 as Nov_13_CSMdemand,
						a.dec_13 as Dec_13_CSMdemand, 
						a.total_2013 as Total_13_CSMdemand,
						
						a.jan_14 as Jan_14_CSMdemand,
						a.feb_14 as Feb_14_CSMdemand,
						a.mar_14 as Mar_14_CSMdemand,
						a.apr_14 as Apr_14_CSMdemand,
						a.may_14 as May_14_CSMdemand,
						a.jun_14 as Jun_14_CSMdemand,
						a.jul_14 as Jul_14_CSMdemand,
						a.aug_14 as Aug_14_CSMdemand,
						a.sep_14 as Sep_14_CSMdemand,
						a.oct_14 as Oct_14_CSMdemand,
						a.nov_14 as Nov_14_CSMdemand,
						a.dec_14 as Dec_14_CSMdemand, 
						a.total_2014 as Total_14_CSMdemand,		
						
						a.cal15 as CAL15_CSMdemand,
						a.cal16 as CAL16_CSMdemand,
						a.cal17 as CAL17_CSMdemand,
						a.cal18 as CAL18_CSMdemand,
						a.cal19 as CAL19_CSMdemand,
						
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
						(case when isnull(b.nov_10,0)=0 then a.total_2010/NULLIF(b.total_2010,0) else a.nov_10/NULLIF(b.nov_10,0) end) as nov_10_factor,
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
		
						(case when isnull(b.jan_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jan_13/NULLIF(b.jan_13,0) end) as jan_13_factor, 
						(case when isnull(b.feb_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.feb_13/NULLIF(b.feb_13,0) end) as feb_13_factor,
						(case when isnull(b.mar_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.mar_13/NULLIF(b.mar_13,0) end) as mar_13_factor,
						(case when isnull(b.apr_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.apr_13/NULLIF(b.apr_13,0) end) as apr_13_factor,
						(case when isnull(b.may_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.may_13/NULLIF(b.may_13,0) end) as may_13_factor,
						(case when isnull(b.jun_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jun_13/NULLIF(b.jun_13,0) end) as jun_13_factor,
						(case when isnull(b.jul_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.jul_13/NULLIF(b.jul_13,0) end) as jul_13_factor, 
						(case when isnull(b.aug_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.aug_13/NULLIF(b.aug_13,0) end) as aug_13_factor,
						(case when isnull(b.sep_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.sep_13/NULLIF(b.sep_13,0) end) as sep_13_factor,
						(case when isnull(b.oct_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.oct_13/NULLIF(b.oct_13,0) end) as oct_13_factor,
						(case when isnull(b.nov_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.nov_13/NULLIF(b.nov_13,0) end) as nov_13_factor,
						(case when isnull(b.dec_13,0)=0 then a.total_2013/NULLIF(b.total_2013,0) else a.dec_13/NULLIF(b.dec_13,0) end) as dec_13_factor,
								
						(case when isnull(b.jan_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jan_14/NULLIF(b.jan_14,0) end) as jan_14_factor, 
						(case when isnull(b.feb_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.feb_14/NULLIF(b.feb_14,0) end) as feb_14_factor,
						(case when isnull(b.mar_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.mar_14/NULLIF(b.mar_14,0) end) as mar_14_factor,
						(case when isnull(b.apr_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.apr_14/NULLIF(b.apr_14,0) end) as apr_14_factor,
						(case when isnull(b.may_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.may_14/NULLIF(b.may_14,0) end) as may_14_factor,
						(case when isnull(b.jun_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jun_14/NULLIF(b.jun_14,0) end) as jun_14_factor,
						(case when isnull(b.jul_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.jul_14/NULLIF(b.jul_14,0) end) as jul_14_factor, 
						(case when isnull(b.aug_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.aug_14/NULLIF(b.aug_14,0) end) as aug_14_factor,
						(case when isnull(b.sep_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.sep_14/NULLIF(b.sep_14,0) end) as sep_14_factor,
						(case when isnull(b.oct_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.oct_14/NULLIF(b.oct_14,0) end) as oct_14_factor,
						(case when isnull(b.nov_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.nov_14/NULLIF(b.nov_14,0) end) as nov_14_factor,
						(case when isnull(b.dec_14,0)=0 then a.total_2014/NULLIF(b.total_2014,0) else a.dec_14/NULLIF(b.dec_14,0) end) as dec_14_factor,
						
						(case when isnull(b.cal15,0)=0 then 1 else a.cal15/NULLIF(b.cal15,0) end) as cal15_factor,
						(case when isnull(b.cal16,0)=0 then 1 else a.cal16/NULLIF(b.cal16,0) end) as cal16_factor,
						(case when isnull(b.cal17,0)=0 then 1 else a.cal17/NULLIF(b.cal17,0) end) as cal17_factor,
						(case when isnull(b.cal18,0)=0 then 1 else a.cal18/NULLIF(b.cal18,0) end) as cal18_factor,
						(case when isnull(b.cal19,0)=0 then 1 else a.cal19/NULLIF(b.cal19,0) end) as cal19_factor
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
								
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13*c.jan_13,0) as jan_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13*c.feb_13,0) as feb_13,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13*c.mar_13,0) as mar_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13*c.apr_13,0) as apr_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13*c.may_13,0) as may_13,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13*c.jun_13,0) as jun_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13*c.jul_13,0) as jul_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13*c.aug_13,0) as aug_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13*c.sep_13,0) as sep_13,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13*c.oct_13,0) as oct_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13*c.nov_13,0) as nov_13, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13*c.dec_13,0) as dec_13,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13*c.jan_13,0)+ISNULL(b.feb_13*c.feb_13,0)+ISNULL(b.mar_13*c.mar_13,0)+ISNULL(b.apr_13*c.apr_13,0)+ISNULL(b.may_13*c.may_13,0)+ISNULL(b.jun_13*c.jun_13,0)+ISNULL(b.jul_13*c.jul_13,0)+ISNULL(b.aug_13*c.aug_13,0)+ISNULL(b.sep_13*c.sep_13,0)+ISNULL(b.oct_13*c.oct_13,0)+ISNULL(b.nov_13*c.nov_13,0)+ISNULL(b.dec_13*c.dec_13,0)) as total_2013,
								
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14*c.jan_14,0) as jan_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14*c.feb_14,0) as feb_14,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14*c.mar_14,0) as mar_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14*c.apr_14,0) as apr_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14*c.may_14,0) as may_14,
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14*c.jun_14,0) as jun_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14*c.jul_14,0) as jul_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14*c.aug_14,0) as aug_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14*c.sep_14,0) as sep_14,  
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14*c.oct_14,0) as oct_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14*c.nov_14,0) as nov_14, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14*c.dec_14,0) as dec_14,  
								(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14*c.jan_14,0)+ISNULL(b.feb_14*c.feb_14,0)+ISNULL(b.mar_14*c.mar_14,0)+ISNULL(b.apr_14*c.apr_14,0)+ISNULL(b.may_14*c.may_14,0)+ISNULL(b.jun_14*c.jun_14,0)+ISNULL(b.jul_14*c.jul_14,0)+ISNULL(b.aug_14*c.aug_14,0)+ISNULL(b.sep_14*c.sep_14,0)+ISNULL(b.oct_14*c.oct_14,0)+ISNULL(b.nov_14*c.nov_14,0)+ISNULL(b.dec_14*c.dec_14,0)) as total_2014,
														
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal15*c.cal15,0) as cal15, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL16*c.cal16,0) as cal16, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL17*c.cal17,0) as cal17, 
								ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL18*c.cal18,0) as cal18,
								ISNULL(a.QTY_PER*a.take_rate*a.family_allocation*b.CAL19*c.cal19,0) as cal19
						from	
					
								/* LEVEL 5 */
								(select * from eeiuser.acctg_csm_base_part_mnemonic
								) a 
								left outer join 
								(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03' 
								(SELECT [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) 
								and version = 'CSM'
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
										(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
										
										ISNULL(b.jan_13,0) as jan_13, 
										ISNULL(b.feb_13,0) as feb_13,
										ISNULL(b.mar_13,0) as mar_13, 
										ISNULL(b.apr_13,0) as apr_13, 
										ISNULL(b.may_13,0) as may_13,
										ISNULL(b.jun_13,0) as jun_13, 
										ISNULL(b.jul_13,0) as jul_13, 
										ISNULL(b.aug_13,0) as aug_13, 
										ISNULL(b.sep_13,0) as sep_13,  
										ISNULL(b.oct_13,0) as oct_13, 
										ISNULL(b.nov_13,0) as nov_13, 
										ISNULL(b.dec_13,0) as dec_13,  
										(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
					
										ISNULL(b.jan_14,0) as jan_14, 
										ISNULL(b.feb_14,0) as feb_14,
										ISNULL(b.mar_14,0) as mar_14, 
										ISNULL(b.apr_14,0) as apr_14, 
										ISNULL(b.may_14,0) as may_14,
										ISNULL(b.jun_14,0) as jun_14, 
										ISNULL(b.jul_14,0) as jul_14, 
										ISNULL(b.aug_14,0) as aug_14, 
										ISNULL(b.sep_14,0) as sep_14,  
										ISNULL(b.oct_14,0) as oct_14, 
										ISNULL(b.nov_14,0) as nov_14, 
										ISNULL(b.dec_14,0) as dec_14,  
										(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,
																									
										ISNULL(b.CAL15,0) as cal15, 
										ISNULL(b.CAL16,0) as cal16, 
										ISNULL(b.CAL17,0) as cal17, 
										ISNULL(b.CAL18,0) as cal18,
										ISNULL(b.CAL19,0) as cal19 
								from 
								
										/* LEVEL 6 */
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
										left outer join
										(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03' 
										(Select [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) 
										and version = 'Empire Factor'
										) b
										on a.mnemonic = b.mnemonic
										
										where b.mnemonic is not null 
								) c
								on a.base_part = c.base_part
								
							 	where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.cal17,0)+ISNULL(b.cal18,0)+ISNULL(b.cal19,0)) <>  0 
												
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
								
								sum(a.jan_13*b.jan_13) as jan_13, 
								sum(a.feb_13*b.feb_13) as feb_13, 
								sum(a.mar_13*b.mar_13) as mar_13, 
								sum(a.apr_13*b.apr_13) as apr_13, 
								sum(a.may_13*b.may_13) as may_13, 
								sum(a.jun_13*b.jun_13) as jun_13, 
								sum(a.jul_13*b.jul_13) as jul_13, 
								sum(a.aug_13*b.aug_13) as aug_13,
								sum(a.sep_13*b.sep_13) as sep_13, 
								sum(a.oct_13*b.oct_13) as oct_13, 
								sum(a.nov_13*b.nov_13) as nov_13, 
								sum(a.dec_13*b.dec_13) as dec_13,
								(sum(a.jan_13*b.jan_13)+sum(a.feb_13*b.feb_13)+sum(a.mar_13*b.mar_13)+sum(a.apr_13*b.apr_13)+sum(a.may_13*b.may_13)+sum(a.jun_13*b.jun_13)+sum(a.jul_13*b.jul_13)+sum(a.aug_13*b.aug_13)+sum(a.sep_13*b.sep_13)+sum(a.oct_13*b.oct_13)+sum(a.nov_13*b.nov_13)+sum(a.dec_13*b.dec_13)) as total_2013,
								
								sum(a.jan_14*b.jan_14) as jan_14, 
								sum(a.feb_14*b.feb_14) as feb_14, 
								sum(a.mar_14*b.mar_14) as mar_14, 
								sum(a.apr_14*b.apr_14) as apr_14, 
								sum(a.may_14*b.may_14) as may_14, 
								sum(a.jun_14*b.jun_14) as jun_14, 
								sum(a.jul_14*b.jul_14) as jul_14, 
								sum(a.aug_14*b.aug_14) as aug_14,
								sum(a.sep_14*b.sep_14) as sep_14, 
								sum(a.oct_14*b.oct_14) as oct_14, 
								sum(a.nov_14*b.nov_14) as nov_14, 
								sum(a.dec_14*b.dec_14) as dec_14,
								(sum(a.jan_14*b.jan_14)+sum(a.feb_14*b.feb_14)+sum(a.mar_14*b.mar_14)+sum(a.apr_14*b.apr_14)+sum(a.may_14*b.may_14)+sum(a.jun_14*b.jun_14)+sum(a.jul_14*b.jul_14)+sum(a.aug_14*b.aug_14)+sum(a.sep_14*b.sep_14)+sum(a.oct_14*b.oct_14)+sum(a.nov_14*b.nov_14)+sum(a.dec_14*b.dec_14)) as total_2014,
														
								sum(a.cal15*b.cal15) as cal15, 
								sum(a.cal16*b.cal16) as cal16, 
								sum(a.cal17*b.cal17) as cal17, 
								sum(a.cal18*b.cal18) as cal18,
								sum(a.cal19*b.cal19) as cal19
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
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_13,0) as jan_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_13,0) as feb_13,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_13,0) as mar_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_13,0) as apr_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_13,0) as may_13,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_13,0) as jun_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_13,0) as jul_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_13,0) as aug_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_13,0) as sep_13,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_13,0) as oct_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_13,0) as nov_13, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_13,0) as dec_13,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jan_14,0) as jan_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.feb_14,0) as feb_14,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.mar_14,0) as mar_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.apr_14,0) as apr_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.may_14,0) as may_14,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jun_14,0) as jun_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.jul_14,0) as jul_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.aug_14,0) as aug_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.sep_14,0) as sep_14,  
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.oct_14,0) as oct_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.nov_14,0) as nov_14, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.dec_14,0) as dec_14,  
										(a.qty_per*a.take_rate*a.family_allocation)*(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,							
										
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL15,0) as cal15, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL16,0) as cal16, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL17,0) as cal17, 
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.CAL18,0) as cal18,
										ISNULL(a.qty_per*a.take_rate*a.family_allocation*b.cal19,0) as cal19   
								from	
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a 
								
										left outer join 
								
										( select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
										(Select	[dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) 
										and version = 'CSM'
										) b
										on a.mnemonic = b.mnemonic 
								 
								 		where b.mnemonic is not null and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.cal17,0)+ISNULL(b.CAL18,0)+ISNULL(b.CAL19,0)) <>  0 
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
		
										--removed a.qty_per*a.take_rate*a.family_allocation* as I couldn't see why it should be here (DW 4/17/2012)
										(ISNULL(b.jan_12,0)+ISNULL(b.feb_12,0)+ISNULL(b.mar_12,0)+ISNULL(b.apr_12,0)+ISNULL(b.may_12,0)+ISNULL(b.jun_12,0)+ISNULL(b.jul_12,0)+ISNULL(b.aug_12,0)+ISNULL(b.sep_12,0)+ISNULL(b.oct_12,0)+ISNULL(b.nov_12,0)+ISNULL(b.dec_12,0)) as total_2012,
		
										ISNULL(b.jan_13,0) as jan_13, 
										ISNULL(b.feb_13,0) as feb_13,
										ISNULL(b.mar_13,0) as mar_13, 
										ISNULL(b.apr_13,0) as apr_13, 
										ISNULL(b.may_13,0) as may_13,
										ISNULL(b.jun_13,0) as jun_13, 
										ISNULL(b.jul_13,0) as jul_13, 
										ISNULL(b.aug_13,0) as aug_13, 
										ISNULL(b.sep_13,0) as sep_13,  
										ISNULL(b.oct_13,0) as oct_13, 
										ISNULL(b.nov_13,0) as nov_13, 
										ISNULL(b.dec_13,0) as dec_13,  
										(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0)) as total_2013,
												
										ISNULL(b.jan_14,0) as jan_14, 
										ISNULL(b.feb_14,0) as feb_14,
										ISNULL(b.mar_14,0) as mar_14, 
										ISNULL(b.apr_14,0) as apr_14, 
										ISNULL(b.may_14,0) as may_14,
										ISNULL(b.jun_14,0) as jun_14, 
										ISNULL(b.jul_14,0) as jul_14, 
										ISNULL(b.aug_14,0) as aug_14, 
										ISNULL(b.sep_14,0) as sep_14,  
										ISNULL(b.oct_14,0) as oct_14, 
										ISNULL(b.nov_14,0) as nov_14, 
										ISNULL(b.dec_14,0) as dec_14,  
										(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0)) as total_2014,
			
										ISNULL(b.cal15,0) as cal15, 
										ISNULL(b.cal16,0) as cal16, 
										ISNULL(b.cal17,0) as cal17, 
										ISNULL(b.cal18,0) as cal18,
										ISNULL(b.cal19,0) as cal19    
								
								from 
							
										(select * from eeiuser.acctg_csm_base_part_mnemonic
										) a
								
										left outer join
									
										( select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
										(Select [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) 
										and version = 'Empire Factor'
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
		
						ISNULL(b.jan_13,0) as jan_13, 
						ISNULL(b.feb_13,0) as feb_13, 
						ISNULL(b.mar_13,0) as mar_13, 
						ISNULL(b.apr_13,0) as apr_13, 
						ISNULL(b.may_13,0) as may_13, 
						ISNULL(b.jun_13,0) as jun_13, 
						ISNULL(b.jul_13,0) as jul_13, 
						ISNULL(b.aug_13,0) as aug_13, 
						ISNULL(b.sep_13,0) as sep_13, 
						ISNULL(b.oct_13,0) as oct_13, 
						ISNULL(b.nov_13,0) as nov_13, 
						ISNULL(b.dec_13,0) as dec_13, 
						(ISNULL(b.jan_13,0)+ISNULL(b.feb_13,0)+ISNULL(b.mar_13,0)+ISNULL(b.apr_13,0)+ISNULL(b.may_13,0)+ISNULL(b.jun_13,0)+ISNULL(b.jul_13,0)+ISNULL(b.aug_13,0)+ISNULL(b.sep_13,0)+ISNULL(b.oct_13,0)+ISNULL(b.nov_13,0)+ISNULL(b.dec_13,0))  as total_2013,
		
						ISNULL(b.jan_14,0) as jan_14, 
						ISNULL(b.feb_14,0) as feb_14, 
						ISNULL(b.mar_14,0) as mar_14, 
						ISNULL(b.apr_14,0) as apr_14, 
						ISNULL(b.may_14,0) as may_14, 
						ISNULL(b.jun_14,0) as jun_14, 
						ISNULL(b.jul_14,0) as jul_14, 
						ISNULL(b.aug_14,0) as aug_14, 
						ISNULL(b.sep_14,0) as sep_14, 
						ISNULL(b.oct_14,0) as oct_14, 
						ISNULL(b.nov_14,0) as nov_14, 
						ISNULL(b.dec_14,0) as dec_14, 
						(ISNULL(b.jan_14,0)+ISNULL(b.feb_14,0)+ISNULL(b.mar_14,0)+ISNULL(b.apr_14,0)+ISNULL(b.may_14,0)+ISNULL(b.jun_14,0)+ISNULL(b.jul_14,0)+ISNULL(b.aug_14,0)+ISNULL(b.sep_14,0)+ISNULL(b.oct_14,0)+ISNULL(b.nov_14,0)+ISNULL(b.dec_14,0))  as total_2014,
				
						ISNULL(b.cal15,0) as cal15,
						ISNULL(b.cal16,0) as cal16,
						ISNULL(b.cal17,0) as cal17,
						ISNULL(b.cal18,0) as cal18,
						ISNULL(b.cal19,0) as cal19
				from    
						(select * from eeiuser.acctg_csm_base_part_mnemonic
						) a 
						left outer join 
						(select * from eeiuser.acctg_csm_NACSM where release_id = --'2011-03'
						(SELECT [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') )
						) b
						on b.mnemonic = a.mnemonic 
						where	b.version = 'Empire Adjustment'
							and b.mnemonic is not null
							and (ISNULL(b.cal10,0)+ISNULL(b.cal11,0)+ISNULL(b.cal12,0)+ISNULL(b.cal13,0)+ISNULL(b.cal14,0)+ISNULL(b.cal15,0)+ISNULL(b.cal16,0)+ISNULL(b.CAL17,0)+ISNULL(b.CAL18,0)+ISNULL(b.CAL19,0)) <>  0
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
		
		left join   (	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevMaterialAccum ,0) as CurrentRevMaterialAccum,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNUll(BOMFlag,0) = 0 and 
				MCBASEPart not in (Select MCBasePart from vwft_ActivePartMaterialAccum where BOMFlag = 1) and
				PartDataBase = 'EEH'
	Union
	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevFrozenMaterialCost ,0) as CurrentRevMaterialAccum,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNull(BOMFlag,0) = 1 and 
				PartDataBase = 'EEI'
						)	ActivePartMaterialAccum
									
		on cc.base_part = MCBasePart
		
		where cc.base_part not in (select base_part from eeiuser.acctg_csm_excluded_base_parts where release_id = --'2011-03'
		(SELECT [dbo].[fn_ReturnSecondLatestCSMRelease] ('CSM') ) 
		and include_in_forecast = 0)

) b 

on a.base_part1 = b.base_part and a.mnemonic1 = b.mnemonic


GO
