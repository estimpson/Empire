SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vw_eei_rpt_FrozenCUM_MaterialCUM]
as
Select		Company,
			BasePart,
			eeips.Part,
			ft.fn_Truncdate('mm', date_shipped) as MonthShipped,
			max(eeips.frozen_material_cum) as EEIFrozenMaterialCUM,
			max(eehps.material_cum) as EEHMaterialCUM,
			max(eehps.material_cum)- max(eeips.frozen_material_cum) as DiffEEHEEI,			
			abs(max(eehps.material_cum)- max(eeips.frozen_material_cum)) as AbsDiffEEHEEI,
			sum(qty_shipped) as ShippedEEIQty,
			sum(qty_shipped*eeips.frozen_material_cum) as 	ShippedFrozenMaterialCUM,
			sum(qty_shipped*eehps.material_cum) as 	ShippedEEHMaterialCUM,
			sum(eeiMaterialCumExt) as TransferPriceExtended,
			sum(Extended) as Shipped
 		 
from		vw_eei_sales_history
join		part_standard eeips on vw_eei_sales_history.part = eeips.part
left join	[EEHSQL1].[EEH].[dbo].part_standard eehps on vw_eei_sales_history.part = eehps.part
where		date_shipped >= dateadd(mm ,-1, ft.fn_Truncdate('mm', getdate())) and
			date_shipped < dateadd(mm ,0, ft.fn_Truncdate('mm', getdate()))
group by	Company,
			BasePart,
			eeips.Part,
			ft.fn_Truncdate('mm', date_shipped)	
GO
