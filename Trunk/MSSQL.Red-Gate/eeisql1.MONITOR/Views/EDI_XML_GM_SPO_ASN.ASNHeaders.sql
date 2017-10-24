SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_GM_SPO_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = coalesce(es.trading_partner_code,'SPOEDIFACT')
,	ASNDate = getdate()
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = convert(int, coalesce(s.gross_weight,0))
,	NetWeightLbs = convert(int, coalesce(s.net_weight,0))
,	StagedObjs = convert(int, coalesce(s.staged_objs,0))
,	TruckNo = s.truck_number
,	SCAC = s.ship_via
,	MaterialIssuer = es.material_issuer
,	Destination = coalesce(nullif(es.parent_destination,''), s.destination,'')
,	ShippingDock =s.shipping_dock
,	SupplierCode = es.supplier_code
,	TransMode = s.trans_mode
,	ProNumber = s.pro_number
from
	dbo.shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination
	join dbo.shipper_detail sd
		on sd.shipper = s.id
GO
