SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EDI_XML_AUTOLIV_ASN].[ASNHeaders]
as


select
	ShipperID = s.id
,	ShipDateTime = s.date_shipped
,	ASNDate = getdate()
,	ASNTime = getdate()
,	TimeZoneCode = 'ED'
,	TradingPartner = COALESCE(es.trading_partner_code,'Autoliv')
,	MaterialIssuer = ISNULL(es.material_issuer,'')
,	MaterialIssuerName = 'Autoliv ABK'
,	ProNumber = ISNULL(s.pro_number, '')
,	ShipToCode = es.parent_destination
,	ShipToName = d.name
,	SupplierCode = es.supplier_code
,	SupplierName = 'Empire Electronics'
,	GrossWeight = convert(int, round(s.gross_weight, 0))
,	NetWeight = convert(int, round(s.net_weight, 0))
,	Carrier = COALESCE (Nullif(s.ship_via, ''),
				CASE WHEN s.plant = 'EEP' THEN 'TMQJ'
				WHEN s.plant = 'EEI' THEN 'BRYN'
				WHEN s.plant = 'EEH' THEN 'FEDE'
				ELSE 'TMQJ'
				END)
,	TransMode = COALESCE (Nullif(s.trans_mode, ''),
				CASE WHEN s.plant = 'EEP' THEN 'LT'
				WHEN s.plant = 'EEI' THEN 'LT'
				WHEN s.plant = 'EEH' THEN 'A'
				ELSE 'LT'
				END)
,	TruckNumber = upper(coalesce(nullif(s.truck_number,''), 'TRUCKNO'))
,	BOLNumber = s.id
,	iConnectID =  es.IConnectID
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
	join dbo.destination d
		on d.destination = s.destination

GO
