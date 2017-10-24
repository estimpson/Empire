SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_materials_eeiqtydemand_in_EEHMaterialCUM]
as

Begin
	Select	LEFT(part_number,7) as BasePart,
			part_number,
			sum(eeiqty*material_cum) as DemandinMaterialCUM,
			ft.fn_truncdate('wk', due_date) as WeekDue
	From	order_detail
	left join	[EEHSQL1].[EEH].[dbo].part_standard eehps on order_detail.part_number = eehps.part
	where	due_date > dateadd(dd, -30, getdate())
	Group by 		LEFT(part_number,7) ,
					part_number,	
					ft.fn_truncdate('wk', due_date)
end
	
			
GO
