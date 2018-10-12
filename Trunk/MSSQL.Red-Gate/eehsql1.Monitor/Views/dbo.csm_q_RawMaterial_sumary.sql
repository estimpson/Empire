SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view [dbo].[csm_q_RawMaterial_sumary] as 
select	
		Part = childpart,
		description = Name,
		commodity,
		Supplier = default_vendor,
		PurchasePrice = Avg(cost),
		Avg_Weekly_MPS = avg(MPSAvg.average),
		AVG_Purcharse = AVG(AVG_Purcharse)*4.3,
		AVG_Demand15 = sum(	(	jan_15_TOTALdemand + feb_15_TOTALdemand + mar_15_TOTALdemand  + apr_15_TOTALdemand +
								may_15_TOTALdemand + jun_15_TOTALdemand + jul_15_TOTALdemand + aug_15_TOTALdemand +
								sep_15_TOTALdemand + oct_15_TOTALdemand + nov_15_TOTALdemand + dec_15_TOTALdemand )) / 12,
		AVG_Demand16 = sum(	(	jan_16_TOTALdemand + feb_16_TOTALdemand + mar_16_TOTALdemand  + apr_16_TOTALdemand +
								may_16_TOTALdemand + jun_16_TOTALdemand + jul_16_TOTALdemand + aug_16_TOTALdemand +
								sep_16_TOTALdemand + oct_16_TOTALdemand + nov_16_TOTALdemand + dec_16_TOTALdemand )) / 12,
		qty_jan_15=Sum(xQty*jan_15_TOTALdemand),qty_feb_15=Sum(xQty*feb_15_TOTALdemand),
		qty_mar_15=Sum(xQty*mar_15_TOTALdemand),qty_apr_15=Sum(xQty*apr_15_TOTALdemand),
		qty_may_15=Sum(xQty*may_15_TOTALdemand),qty_jun_15=Sum(xQty*jun_15_TOTALdemand),
		qty_jul_15=Sum(xQty*jul_15_TOTALdemand),qty_aug_15=Sum(xQty*aug_15_TOTALdemand),
		qty_sep_15=Sum(xQty*sep_15_TOTALdemand),qty_oct_15=Sum(xQty*oct_15_TOTALdemand),
		qty_nov_15=Sum(xQty*nov_15_TOTALdemand),qty_dec_15=Sum(xQty*dec_15_TOTALdemand),

		qty_jan_16=Sum(xQty*jan_16_TOTALdemand),qty_feb_16=Sum(xQty*feb_16_TOTALdemand),
		qty_mar_16=Sum(xQty*mar_16_TOTALdemand),qty_apr_16=Sum(xQty*apr_16_TOTALdemand),
		qty_may_16=Sum(xQty*may_16_TOTALdemand),qty_jun_16=Sum(xQty*jun_16_TOTALdemand),
		qty_jul_16=Sum(xQty*jul_16_TOTALdemand),qty_aug_16=Sum(xQty*aug_16_TOTALdemand),
		qty_sep_16=Sum(xQty*sep_16_TOTALdemand),qty_oct_16=Sum(xQty*oct_16_TOTALdemand),
		qty_nov_16=Sum(xQty*nov_16_TOTALdemand),qty_dec_16=Sum(xQty*dec_16_TOTALdemand),

		cost_jan_15=Sum(xQty*cost*jan_15_TOTALdemand),cost_feb_15=Sum(xQty*cost*feb_15_TOTALdemand),
		cost_mar_15=Sum(xQty*cost*mar_15_TOTALdemand),cost_apr_15=Sum(xQty*cost*apr_15_TOTALdemand),
		cost_may_15=Sum(xQty*cost*may_15_TOTALdemand),cost_jun_15=Sum(xQty*cost*jun_15_TOTALdemand),
		cost_jul_15=Sum(xQty*cost*jul_15_TOTALdemand),cost_aug_15=Sum(xQty*cost*aug_15_TOTALdemand),
		cost_sep_15=Sum(xQty*cost*sep_15_TOTALdemand),cost_oct_15=Sum(xQty*cost*oct_15_TOTALdemand),
		cost_nov_15=Sum(xQty*cost*nov_15_TOTALdemand),cost_dec_15=Sum(xQty*cost*dec_15_TOTALdemand),

		cost_jan_16=Sum(xQty*cost*jan_16_TOTALdemand),cost_feb_16=Sum(xQty*cost*feb_16_TOTALdemand),
		cost_mar_16=Sum(xQty*cost*mar_16_TOTALdemand),cost_apr_16=Sum(xQty*cost*apr_16_TOTALdemand),
		cost_may_16=Sum(xQty*cost*may_16_TOTALdemand),cost_jun_16=Sum(xQty*cost*jun_16_TOTALdemand),
		cost_jul_16=Sum(xQty*cost*jul_16_TOTALdemand),cost_aug_16=Sum(xQty*cost*aug_16_TOTALdemand),
		cost_sep_16=Sum(xQty*cost*sep_16_TOTALdemand),cost_oct_16=Sum(xQty*cost*oct_16_TOTALdemand),
		cost_nov_16=Sum(xQty*cost*nov_16_TOTALdemand),cost_dec_16=Sum(xQty*cost*dec_16_TOTALdemand),

		Qty_Total_2015 = sum(XQty * Total_2015_TOTALdemand ),
		Qty_Total_2016 = sum(XQty * Total_2016_TOTALdemand ),
		Qty_Total_2017 = sum(XQty * Total_2017_TOTALdemand ),
		Qty_Total_2018 = sum(XQty * Cal18_TOTALdemand )
from	part
		join part_standard on part.part = part_standard.part
		join part_online on part.part = part_online.part
		join ft.xrt xrt on xrt.ChildPart = part.part
		join fn_CSM_MonitorPart() Future on xrt.TopPart = Future.Part
		join eeh.dbo.CSM_NACSM csmData on Future.BasePart = csmData.base_part
		left join (	select	Part, AVG_Purcharse = sum( qnty ) / 4
					from	master_prod_sched
					where	due < DATEADD(WEEK, 5, GETDATE())
							and type = 'P'
					group by Part ) PurcarseAverage on PurcarseAverage.part = part.part
		left join (	select	part, Average = AVG( Qnty)
					from	master_prod_sched
					group by part ) MPSAvg on MPSAvg.part = xrt.ChildPart
where	xrt.bomlevel > 0
		and Part.type = 'R'
group by childpart, Name,commodity, default_vendor












GO
