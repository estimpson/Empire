SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create view [dbo].[vw_RawQtyPerFinPartwithCost]

as
select	TopPart, 
		ChildPart, 
		Sum(XQty)as QuantityPer,
		max(ps1.material_cum) as StdCost,
		Sum(ps1.material_cum*XQty) as ExtendedCost
from	FT.XRT
JOIN	part on FT.XRT.TopPart = Part.part
JOIN	part P2 on FT.XRT.ChildPart =P2.part
join	part_standard ps1 on P2.part = ps1.part
Where	part.type = 'F' and P2.Type = 'R'
GROUP	BY TopPart, ChildPart



GO
