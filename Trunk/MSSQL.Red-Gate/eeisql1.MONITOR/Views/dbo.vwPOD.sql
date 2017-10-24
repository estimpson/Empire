SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--select * from  [dbo].[vwOD]


CREATE view [dbo].[vwPOD]
as
--	Description:
--	Get sales order details (must be an updateable view).
select	*,
	FABAuthorized= 0,
	MATAuthorized = 0,
	PosAllowedVariance = 0,
	NegAllowedVariance = 0,
	LastShippedAmount = 0
from	(	select	OrderNumber = po_detail.po_number,
			Customer = po_header.vendor_code,
			Part = po_detail.part_number,
			po_header.blanket_part,
			DueDT = po_detail.date_due,
			LineID = po_detail.row_id,
			CurrentWeek = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ),
			DeliveryWeek = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), po_detail.date_due) - DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ) + DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ),
			StdQty = po_detail.balance,
			PriorAccum = 0,
			PostAccum = 0,
			Firmweeks = 0,
			FABAuthWeeks = 0,
			MATAuthWeeks = 0,
			LastShippedDate = NULL,
			EEIEntry = 0,
			ReleaseNo = po_detail.release_no,
			AccumShipped = 0,
			LastShipper= 0,
			ShipToDestination = po_header.ship_to_destination
		from	dbo.po_detail
			join po_header on po_detail.po_number = po_header.po_number
		where	po_detail.balance > 0  and
			isNULL(po_header.type, 'N') = 'B' and 
			po_header.vendor_code like 'EEH%' ) OD



GO
