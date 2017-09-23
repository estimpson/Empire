SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwSchedulerBasePartSales]
as
select	PartBasePart_Crossref.BasePart,
	AccumShipped = max (order_header.our_cum),
	LastShipper = max (order_header.shipper)
from	FT.vwPartBasePart_Crossref PartBasePart_Crossref
	join order_header on PartBasePart_Crossref.PartECN = order_header.blanket_part and
		order_header.shipper =
		(	select	max (shipper)
			from	order_header
			where	PartBasePart_Crossref.PartECN = order_header.blanket_part)
group by
	PartBasePart_Crossref.BasePart
GO
