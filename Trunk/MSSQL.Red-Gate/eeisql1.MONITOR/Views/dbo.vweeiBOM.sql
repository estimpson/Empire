SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vweeiBOM]

as
select		FinishedPart = 	XRt.TopPart,
			RawPart = 	XRt.ChildPart,
			Quantity = Sum(XRt.XQty),
			cost = part_standard.material_cum,
			extended = Sum(XRt.XQty*cost),
			vendor = default_vendor,
			p2.name RawPartDesc,
			p1.name FinPartDesc
from		FT.XRT XRt,
			part p1,
			part p2
join		part_standard on p2.part = part_standard.part
join		part_online on p2.part = part_online.part
where	
			XRt.TopPart = p1.part and
			XRt.ChildPart = p2.part and
			p1.type = 'F' and
			p1.class = 'M' AND
			XRt.TopPart != XRT.Childpart
group by
					XRt.TopPart,
					XRt.ChildPart,
					part_standard.material_cum,
					default_vendor,
					p2.name,
					p1.name



GO
