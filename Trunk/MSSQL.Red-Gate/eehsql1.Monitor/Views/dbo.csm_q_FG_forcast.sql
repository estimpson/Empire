SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE	view [dbo].[csm_q_FG_forcast] as 
select	
		Version,
		Future.Part,
		description = Name,base_part,
		assembly_plant,program, manufacturer,
		badge, platform, empire_market_segment,
		sop,eop,
		SalesPrice = csmData.SalesPrice,
		CostCum = part_standard.cost_cum,		

		jan_17_TOTALdemand,feb_17_TOTALdemand,mar_17_TOTALdemand,apr_17_TOTALdemand,may_17_TOTALdemand,jun_17_TOTALdemand,
		jul_17_TOTALdemand,aug_17_TOTALdemand,sep_17_TOTALdemand,oct_17_TOTALdemand,nov_17_TOTALdemand,dec_17_TOTALdemand,

		jan_18_TOTALdemand,feb_18_TOTALdemand,mar_18_TOTALdemand,apr_18_TOTALdemand,may_18_TOTALdemand,jun_18_TOTALdemand,
		jul_18_TOTALdemand,aug_18_TOTALdemand,sep_18_TOTALdemand,oct_18_TOTALdemand,nov_18_TOTALdemand,dec_18_TOTALdemand,

		jan_19_TOTALdemand,feb_19_TOTALdemand,mar_19_TOTALdemand,apr_19_TOTALdemand,may_19_TOTALdemand,jun_19_TOTALdemand,
		jul_19_TOTALdemand,aug_19_TOTALdemand,sep_19_TOTALdemand,oct_19_TOTALdemand,nov_19_TOTALdemand,dec_19_TOTALdemand,

		Demand2017 = Total_2017_TOTALdemand,
		Demand2018 = Total_2018_TOTALdemand, Demand2019 = Total_2019_TOTALdemand,
		Demand2020 = Cal_20_TOTALdemand
from	eeh.dbo.CSM_MonitorPart Future 
		join eeh.dbo.csm_NACSM csmData on csmData.base_part = Future.BasePart
		join part on part.part = Future.part
		join part_standard on part_standard.part = Future.Part





GO
