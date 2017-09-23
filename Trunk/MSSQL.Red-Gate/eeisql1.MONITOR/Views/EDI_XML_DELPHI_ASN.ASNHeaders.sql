SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_DELPHI_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = es.trading_partner_code
,	ASNDate = getdate()
,	ArrivalDate = dateadd(dd,1,s.date_shipped)
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = convert(int,s.gross_weight)
,	NetWeightLbs = convert(int,s.gross_weight)
,	LadingQty = s.staged_objs
,	REFCNValue = coalesce(s.pro_number, s.truck_number, '1')
,	REFCOFValue = s.shipping_dock
,	MaterialIssuerID = es.material_issuer
,	ShipToID = coalesce(es.parent_destination, es.destination)
,	ShipToID2 = coalesce(es.parent_destination, es.destination)
,	SupplierCode =  coalesce(es.supplier_code, 'SUPP')
,	SupplierCode2 =  coalesce(es.supplier_code, 'SUPP')
,	TransMode = s.trans_mode
,	SCAC = s.ship_via
,	TrailerNumber = coalesce(s.truck_number, s.id)
from
	dbo.shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination
GO
