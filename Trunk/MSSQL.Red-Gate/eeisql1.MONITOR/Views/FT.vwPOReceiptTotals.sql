SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[vwPOReceiptTotals]
as
select	PONumber = po_header.po_number,
	Part = po_header.blanket_part,
	StdQty = EEIReceiveAccum.CurrentAccum,
	AccumAdjust = 0,
	LastReceivedAmount =
	(	select	sum (Quantity)
		from	FT.CommonSerialShipLog
		where	Part = po_header.blanket_part and
			ShipDT =
			(	select	max (ShipDT)
				from	FT.CommonSerialShipLog
				where	Part = po_header.blanket_part)),
	LastReceivedDT = ReceiptHistory.LastReceivedDT,
	ReceiptCount = ReceiptCount,
	LastUpdated = GetDate ()
from	FT.EEIReceiveAccum EEIReceiveAccum
	join FT.vwPartBasePart_Crossref PartBasePart_Crossref on EEIReceiveAccum.BasePart = PartBasePart_Crossref.BasePart
	join po_header on PartBasePart_Crossref.PartECN = po_header.blanket_part
	join 
	(	select	Part,
			LastReceivedDT = max (ShipDT),
			ReceiptCount = count (distinct Shipper)
		from	FT.CommonSerialShipLog
		group by
			Part) ReceiptHistory on PartBasePart_Crossref.PartECN = ReceiptHistory.Part
GO
