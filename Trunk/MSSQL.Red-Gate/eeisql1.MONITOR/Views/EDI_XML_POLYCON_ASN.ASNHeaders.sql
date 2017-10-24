SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_POLYCON_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	TradingPartner = coalesce(es.trading_partner_code,'POLYCON2')
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	GrossWeightLBS = convert(int, isnull(s.gross_weight,0)) 
,	NetWeightLBS = convert(int, isnull(s.net_weight,0)) 
,	PackCount = isnull(s.staged_objs,0)
,	SCAC = isnull(s.ship_via,0)
,	TransMode = s.trans_mode
,	TrailerNumber = upper(coalesce(nullif(s.truck_number,''), 'TRUCKNO'))
,	BOL = coalesce(s.bill_of_lading_number,s.id, 0)
,	SupplierCode = es.supplier_code
,	ShipToID = es.parent_destination
,	ShipToName = d.name
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
	join dbo.destination d
		on s.destination = d.destination
GO
