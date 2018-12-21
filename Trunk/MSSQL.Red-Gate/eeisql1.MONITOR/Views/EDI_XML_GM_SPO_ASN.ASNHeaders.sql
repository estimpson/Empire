SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDI_XML_GM_SPO_ASN].[ASNHeaders]
AS
SELECT
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = COALESCE(es.trading_partner_code,'SPOEDIFACT')
,	ASNDate = GETDATE()
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = CONVERT(INT, COALESCE(s.gross_weight,0))
,	NetWeightLbs = CONVERT(INT, COALESCE(s.net_weight,0))
,	StagedObjs = CONVERT(INT, COALESCE(s.staged_objs,0))
,	TruckNo = COALESCE(NULLIF(s.truck_number,''), '001')
,	SCAC = s.ship_via
,	MaterialIssuer = es.material_issuer
,	Destination = COALESCE(NULLIF(es.parent_destination,''), s.destination,'')
,	ShippingDock =s.shipping_dock
,	SupplierCode = es.supplier_code
,	TransMode = s.trans_mode
,	ProNumber = s.pro_number
,	CNNumber = RIGHT(s.aetc_number,7)
FROM
	dbo.shipper s 
	JOIN dbo.edi_setups es
		ON es.destination = s.destination
	


GO
