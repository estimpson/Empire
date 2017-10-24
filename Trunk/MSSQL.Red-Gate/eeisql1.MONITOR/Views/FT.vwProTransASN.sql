SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwProTransASN]
as
select	ProTransASN.Serial,
	ProTransASN.Quantity,
	ProTransASN.CustomerPart,
	ProTransASN.OrderNo,
	ProTransASN.ShipDate,
	ProTransASN.ShipTime,
	ShipTo = edi_setups.destination,
	InvSerial = object.serial,
	InvCustomerPart = isnull (InvPart.cross_ref, ProTransASN.CustomerPart),
	InvPart = InvPart.part,
	InvQuantity = Coalesce (
	(	select	sum (quantity)
		from	object
		where	parent_serial = ProTransASN.Serial), object.quantity, 0),
	ProTransASN.Status
from	FT.ProTransASN ProTransASN
	left join edi_setups on ProTransASN.ShipToID = edi_setups.trading_partner_code
	left join object on ProTransASN.Serial = object.serial
	left join part InvPart on isnull (nullif (object.part, 'PALLET'),
		(	select	min (part)
			from	object
			where	parent_serial = ProTransASN.Serial)) = InvPart.part
GO
