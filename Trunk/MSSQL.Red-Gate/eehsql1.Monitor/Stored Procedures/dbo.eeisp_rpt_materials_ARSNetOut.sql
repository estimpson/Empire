SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	Procedure	[dbo].[eeisp_rpt_materials_ARSNetOut]	(@Part varchar(25))
as
Select		due_date as OrderDueDate,
			RequiredDT as PORequiredDate,
			OrderNo,
			part_number,
			FT.NetMPS.Part,
			Balance,
			std_qty,
			[EEH].[dbo].[vw_RawQtyPerFinPart].quantity BOMQty,
			std_qty*[EEH].[dbo].[vw_RawQtyPerFinPart].quantity ExtendedBOMQty
			
from		FT.NetMPS
left join	order_detail on FT.NetMPS.OrderNo = order_detail.order_no and 
			FT.NetMPS.LineID = order_detail.sequence
left join	[EEH].[dbo].[vw_RawQtyPerFinPart] on FT.NetMPS.Part = [EEH].[dbo].[vw_RawQtyPerFinPart].ChildPart and [EEH].[dbo].[vw_RawQtyPerFinPart].TopPart= order_detail.part_number
where		Part = @part
order by	2
GO
