SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select * from  [dbo].[vwOD]


CREATE view [dbo].[vwOD]
as
--	Description:
--	Get sales order details (must be an updateable view).
select	*,
	FABAuthorized= ( CASE WHEN DeliveryWeek<=(CurrentWeek + FABAuthWeeks)   THEN 'Y' ELSE 'N' END),
	MATAuthorized = ( CASE WHEN DeliveryWeek <= (CurrentWeek + MATAuthWeeks)  THEN 'Y' ELSE 'N' END),
	PosAllowedVariance = isnull (
	(	select	part_customer.AllowedPosVariance
		from	dbo.part_customer
		where	OD.Part = part_customer.part and
			part_customer.customer = OD.customer ), 0 ),
	NegAllowedVariance = isnull (
	(	select	part_customer.AllowedNegVariance
		from	dbo.part_customer
		where	OD.Part = part_customer.part and
			part_customer.customer = OD.customer ), 0 ),
	LastShippedAmount =
	(	Select	qty_packed
		from	shipper_detail
		where	shipper_detail.part_original = OD.blanket_part and
			shipper_detail.order_no = OD.OrderNumber and
			shipper_detail.shipper = OD.LastShipper and
 			shipper_detail.date_shipped = LastShippedDate)
from	(	select	OrderNumber = order_detail.order_no,
			Customer = order_header.customer,
			Part = order_detail.part_number,
			order_header.blanket_part,
			DueDT = order_detail.due_date,
			LineID = order_detail.id,
			CurrentWeek = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ),
			DeliveryWeek = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), order_detail.due_date ) - DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ) + DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ),
			StdQty = order_detail.quantity,
			PriorAccum = order_detail.our_cum,
			PostAccum = order_detail.the_cum,
			Firmweeks = isnull (
			(	select	part_customer.leadtime
				from	dbo.part_customer
				where	order_detail.part_number = part_customer.part and
							part_customer.customer = order_header.customer ), 2 ),
			FABAuthWeeks = isnull (
			(	select	part_customer.FABleadtime
				from	dbo.part_customer
				where	order_detail.part_number = part_customer.part and
							part_customer.customer = order_header.customer ), 6 ),
			MATAuthWeeks = isnull (
			(	select	part_customer.Materialleadtime
				from	dbo.part_customer
				where	order_detail.part_number = part_customer.part and
							part_customer.customer = order_header.customer ), 12 ),
			LastShippedDate= (Select 		max(date_shipped) 
											from			shipper_detail
											where		shipper_detail.order_no = order_header.order_no and
															shipper_detail.part_original = order_header.blanket_part and
															shipper_detail.type is NULL and
															shipper_detail.part not like 'CUM_CHANGE%' and
															shipper_detail.date_shipped is NOT NULL),
			EEIEntry = order_detail.EEIEntry,
			ReleaseNo = order_detail.release_no,
			AccumShipped = order_header.our_cum,
			LastShipper=order_header.shipper,
			ShipToDestination = order_header.destination
		from	dbo.order_detail
			join order_header on order_detail.order_no = order_header.order_no
		where	order_detail.quantity > 0  and
			isNULL(order_header.order_type, 'N') = 'B' ) OD


GO
