SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_AUTOSYSTEMS].[ASNHeaders]
as
select
	ShipperID = s.id
,	ShipDateTime = s.date_shipped
,	ASNDate = convert(date, getdate())
,	ASNTime = convert(time, getdate())
,	MaterialIssuer = '00004'
,	MaterialIssuerName = ''
,	ShipToCode = es.parent_destination
,	ShipToName = d.name
,	SupplierCode = es.supplier_code
,	SupplierName = 'Empire Electronics'
,	PackageType = 'CTN'
,	GrossWeight = convert(int, round(s.gross_weight, 1))
,	NetWeight = convert(int, round(s.net_weight, 1))
,	TareWeight = convert(int, round(s.tare_weight, 1))
,	Carrier = s.ship_via
,	TransMode = s.trans_mode
,	TruckNumber = upper(coalesce(nullif(s.truck_number,''), 'TRUCKNO'))
,	BOLNumber = s.id
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
	join dbo.destination d
		on d.destination = s.destination

GO
