SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwPOHeader]
as
select	PONumber = po_number,
	Part = blanket_part,
	AccumReceived = IsNull ( POReceiptTotals.StdQty, 0 ),
	FabDate = DateAdd ( week, DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ) + part_vendor.lead_time / 7, FT.fn_DTGlobal ( 'BaseWeek' ) ) - 1,
	HighFabQty = coalesce ( AuthorizedAccum, POReceiptTotals.StdQty, 0 )
from	dbo.po_header
	left outer join FT.POReceiptTotals POReceiptTotals on po_header.po_number = POReceiptTotals.PONumber and
		po_header.blanket_part = POReceiptTotals.Part
	join dbo.part_vendor on po_header.blanket_part = part_vendor.part and
		po_header.vendor_code = part_vendor.vendor
	left outer join FT.HighFabAuthorizations HighFabAuthorizations on po_header.po_number = HighFabAuthorizations.PONumber and
		po_header.blanket_part = HighFabAuthorizations.Part
GO
