SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[CreateRma_RTV_PackingSlip]
as
select
	RTVShipperID = s.id
,	ShipperNotes = s.notes
,	AETCNumber = s.aetc_number
,	Carrier = s.ship_via
,	BoxCount = s.staged_objs
,	Freight = s.freight
,	DestinationName = d.name
,	DestinationAddress1 = d.address_1
,	DestinationAddress2 = d.address_2
,	DestinationAddress3 = d.address_3
,	DestinationCode = d.destination
,	LineNote = sd.note
,	LineBoxCount = sd.boxes_staged
,	QtyPacked = sd.qty_packed
,	LineNetWeight = sd.net_weight
,	LineTareWeight = sd.tare_weight
,	LineGrossWeight = sd.gross_weight
,	PartName = p.name
,	PartCode = p.part
,	Terms = s.terms
,	UnitMeasure = sd.alternative_unit
,	VendorName = v.name
,	VendorAddress1 = v.address_1
,	VendorAddress2 = v.address_2
,	VendorAddress3 = v.address_3
,	CompanyName = parameters.company_name
,	CompanyAddress1 = parameters.address_1
,	CompanyAddress2 = parameters.address_2
,	CompanyAddress3 = parameters.address_3
,	CompanyPhone = parameters.phone_number
,	o.SerialList
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on s.id = sd.shipper
	join dbo.destination d
		on s.destination = d.destination
	join dbo.part p
		on p.part = sd.part_original
	join dbo.vendor v
		on d.vendor = v.code
	cross join parameters
	outer apply
		(	select
				SerialList = FX.ToList(Serial)
			from
				(	select
						Serial = o.serial
					from
						dbo.object o
					where
						o.shipper = s.id
						and o.part = sd.part_original
					union
					select
						at.serial
					from
						dbo.audit_trail at
					where
						at.shipper = convert(varchar(25), s.id)
						and at.part = sd.part_original
						and at.type = 'V'
				) o
		) o
GO
