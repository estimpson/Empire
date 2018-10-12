SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[csm_q_RawMaterial_FG_forcast_sumary] as 
select	Version,
		Part = childpart,
		description = Name,
		Supplier = default_vendor,
		PurchasePrice = Avg(cost),
		AVG_Purcharse = AVG(AVG_Purcharse)*4.3,
		assembly_plant,program, manufacturer,
		badge, eop,
		qty_jan_17_TOTALdemand=Sum(xQty*jan_17_TOTALdemand),qty_feb_17_TOTALdemand=Sum(xQty*feb_17_TOTALdemand),
		qty_mar_17_TOTALdemand=Sum(xQty*mar_17_TOTALdemand),qty_apr_17_TOTALdemand=Sum(xQty*apr_17_TOTALdemand),
		qty_may_17_TOTALdemand=Sum(xQty*may_17_TOTALdemand),qty_jun_17_TOTALdemand=Sum(xQty*jun_17_TOTALdemand),
		qty_jul_17_TOTALdemand=Sum(xQty*jul_17_TOTALdemand),qty_aug_17_TOTALdemand=Sum(xQty*aug_17_TOTALdemand),
		qty_sep_17_TOTALdemand=Sum(xQty*sep_17_TOTALdemand),qty_oct_17_TOTALdemand=Sum(xQty*oct_17_TOTALdemand),
		qty_nov_17_TOTALdemand=Sum(xQty*nov_17_TOTALdemand),qty_dec_17_TOTALdemand=Sum(xQty*dec_17_TOTALdemand),

		qty_jan_18_TOTALdemand=Sum(xQty*jan_18_TOTALdemand),qty_feb_18_TOTALdemand=Sum(xQty*feb_18_TOTALdemand),
		qty_mar_18_TOTALdemand=Sum(xQty*mar_18_TOTALdemand),qty_apr_18_TOTALdemand=Sum(xQty*apr_18_TOTALdemand),
		qty_may_18_TOTALdemand=Sum(xQty*may_18_TOTALdemand),qty_jun_18_TOTALdemand=Sum(xQty*jun_18_TOTALdemand),
		qty_jul_18_TOTALdemand=Sum(xQty*jul_18_TOTALdemand),qty_aug_18_TOTALdemand=Sum(xQty*aug_18_TOTALdemand),
		qty_sep_18_TOTALdemand=Sum(xQty*sep_18_TOTALdemand),qty_oct_18_TOTALdemand=Sum(xQty*oct_18_TOTALdemand),
		qty_nov_18_TOTALdemand=Sum(xQty*nov_18_TOTALdemand),qty_dec_18_TOTALdemand=Sum(xQty*dec_18_TOTALdemand),

				qty_jan_19_TOTALdemand=Sum(xQty*jan_19_TOTALdemand),qty_feb_19_TOTALdemand=Sum(xQty*feb_19_TOTALdemand),
		qty_mar_19_TOTALdemand=Sum(xQty*mar_19_TOTALdemand),qty_apr_19_TOTALdemand=Sum(xQty*apr_19_TOTALdemand),
		qty_may_19_TOTALdemand=Sum(xQty*may_19_TOTALdemand),qty_jun_19_TOTALdemand=Sum(xQty*jun_19_TOTALdemand),
		qty_jul_19_TOTALdemand=Sum(xQty*jul_19_TOTALdemand),qty_aug_19_TOTALdemand=Sum(xQty*aug_19_TOTALdemand),
		qty_sep_19_TOTALdemand=Sum(xQty*sep_19_TOTALdemand),qty_oct_19_TOTALdemand=Sum(xQty*oct_19_TOTALdemand),
		qty_nov_19_TOTALdemand=Sum(xQty*nov_19_TOTALdemand),qty_dec_19_TOTALdemand=Sum(xQty*dec_19_TOTALdemand),


		cost_jan_17_TOTALdemand=Sum(xQty*cost*jan_17_TOTALdemand),cost_feb_17_TOTALdemand=Sum(xQty*cost*feb_17_TOTALdemand),
		cost_mar_17_TOTALdemand=Sum(xQty*cost*mar_17_TOTALdemand),cost_apr_17_TOTALdemand=Sum(xQty*cost*apr_17_TOTALdemand),
		cost_may_17_TOTALdemand=Sum(xQty*cost*may_17_TOTALdemand),cost_jun_17_TOTALdemand=Sum(xQty*cost*jun_17_TOTALdemand),
		cost_jul_17_TOTALdemand=Sum(xQty*cost*jul_17_TOTALdemand),cost_aug_17_TOTALdemand=Sum(xQty*cost*aug_17_TOTALdemand),
		cost_sep_17_TOTALdemand=Sum(xQty*cost*sep_17_TOTALdemand),cost_oct_17_TOTALdemand=Sum(xQty*cost*oct_17_TOTALdemand),
		cost_nov_17_TOTALdemand=Sum(xQty*cost*nov_17_TOTALdemand),cost_dec_17_TOTALdemand=Sum(xQty*cost*dec_17_TOTALdemand),

		cost_jan_18_TOTALdemand=Sum(xQty*cost*jan_18_TOTALdemand),cost_feb_18_TOTALdemand=Sum(xQty*cost*feb_18_TOTALdemand),
		cost_mar_18_TOTALdemand=Sum(xQty*cost*mar_18_TOTALdemand),cost_apr_18_TOTALdemand=Sum(xQty*cost*apr_18_TOTALdemand),
		cost_may_18_TOTALdemand=Sum(xQty*cost*may_18_TOTALdemand),cost_jun_18_TOTALdemand=Sum(xQty*cost*jun_18_TOTALdemand),
		cost_jul_18_TOTALdemand=Sum(xQty*cost*jul_18_TOTALdemand),cost_aug_18_TOTALdemand=Sum(xQty*cost*aug_18_TOTALdemand),
		cost_sep_18_TOTALdemand=Sum(xQty*cost*sep_18_TOTALdemand),cost_oct_18_TOTALdemand=Sum(xQty*cost*oct_18_TOTALdemand),
		cost_nov_18_TOTALdemand=Sum(xQty*cost*nov_18_TOTALdemand),cost_dec_18_TOTALdemand=Sum(xQty*cost*dec_18_TOTALdemand),

				cost_jan_19_TOTALdemand=Sum(xQty*cost*jan_19_TOTALdemand),cost_feb_19_TOTALdemand=Sum(xQty*cost*feb_19_TOTALdemand),
		cost_mar_19_TOTALdemand=Sum(xQty*cost*mar_19_TOTALdemand),cost_apr_19_TOTALdemand=Sum(xQty*cost*apr_19_TOTALdemand),
		cost_may_19_TOTALdemand=Sum(xQty*cost*may_19_TOTALdemand),cost_jun_19_TOTALdemand=Sum(xQty*cost*jun_19_TOTALdemand),
		cost_jul_19_TOTALdemand=Sum(xQty*cost*jul_19_TOTALdemand),cost_aug_19_TOTALdemand=Sum(xQty*cost*aug_19_TOTALdemand),
		cost_sep_19_TOTALdemand=Sum(xQty*cost*sep_19_TOTALdemand),cost_oct_19_TOTALdemand=Sum(xQty*cost*oct_19_TOTALdemand),
		cost_nov_19_TOTALdemand=Sum(xQty*cost*nov_19_TOTALdemand),cost_dec_19_TOTALdemand=Sum(xQty*cost*dec_19_TOTALdemand),

		Qty_Total_2017 = sum(XQty * Total_2017_TOTALdemand ),
		Qty_Total_2018 = sum(XQty * Total_2018_TOTALdemand ),
		Qty_Total_2019 = sum(XQty * Total_2019_TOTALdemand )

		
from	part
		join part_standard on part.part = part_standard.part
		join part_online on part.part = part_online.part
		join ft.xrt xrt on xrt.ChildPart = part.part
		join EEH.dbo.CSM_MonitorPart Future on xrt.TopPart = Future.Part
		join eeh.dbo.CSM_NACSM csmData on Future.BasePart = csmData.base_part
		left join (	select	Part, AVG_Purcharse = sum( qnty ) / 4
					from	master_prod_sched
					where	due < DATEADD(WEEK, 5, GETDATE())
							and type = 'P'
					group by Part ) PurcarseAverage on PurcarseAverage.part = part.part
where	xrt.bomlevel > 0
		and Part.type = 'R'
group by Version, childpart, Name, default_vendor,
		assembly_plant,program,	badge, manufacturer, eop












GO
