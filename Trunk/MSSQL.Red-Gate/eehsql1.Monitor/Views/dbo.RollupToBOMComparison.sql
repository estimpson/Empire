SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[RollupToBOMComparison]
as
select	XRt.TopPart,
	CostRollup = min (MaterialCostAccum.material_cum),
	BOMCost = sum (MaterialCost.material * XRt.XQty),
	CostDifference = min (MaterialCostAccum.material_cum) - sum (MaterialCost.material * XRt.XQty)
from	FT.XRt XRt
	join part Finished on Finished.type = 'F' and
		XRt.TopPart = Finished.part
	join part_standard MaterialCostAccum on XRt.TopPart = MaterialCostAccum.part
	join part_standard MaterialCost on XRt.ChildPart = MaterialCost.part
group by
	XRt.TopPart
GO
