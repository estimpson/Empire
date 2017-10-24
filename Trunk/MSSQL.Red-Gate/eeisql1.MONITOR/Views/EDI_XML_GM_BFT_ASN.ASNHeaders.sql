SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_GM_BFT_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = coalesce(es.trading_partner_code,'MGOEDIFACT')
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	ArrivalDate = dateadd(dd,1,s.date_shipped)
,	GrossWeightLbs = convert(int,(s.gross_weight))
,	NetWeightLbs = convert(int,(s.net_weight))
,	StagedObjs = s.staged_objs
,	BOL =  coalesce(s.bill_of_lading_number,s.id, 0)
,	MAterialIssuer = CASE WHEN len(es.material_issuer)<5 and asn_overlay_group like 'GM%' then '88835'  ELSE es.material_issuer END
,	Destination = coalesce(es.parent_destination, s.destination)
,	ShippingDock = s.shipping_dock
,	SupplierCode = es.supplier_code
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	TruckNumber = coalesce(s.truck_number, 'TruckNo')
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination

GO
