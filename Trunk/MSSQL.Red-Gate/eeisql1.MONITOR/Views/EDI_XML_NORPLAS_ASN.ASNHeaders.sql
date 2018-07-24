SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDI_XML_NORPLAS_ASN].[ASNHeaders]
AS
SELECT
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = GETDATE()
,	ASNTime = GETDATE()
,	TimeZoneCode = [dbo].[udfGetDSTIndication](GETDATE())
,	TradingPartner	= COALESCE(NULLIF(trading_partner_code,''), 'Formet Testing')
,	ShipToCode = es.parent_destination
,	ShipToID = COALESCE(es.parent_destination, '966850612')
,	ShipToName = d.name
,	SupplierCode = COALESCE(NULLIF(es.supplier_code,''),'2485858130')
,	MaterialIssuerCode = COALESCE(es.material_issuer,'966850612')
,	PackCount = s.staged_objs
,	GrossWeight = CONVERT(INT, ROUND(COALESCE(NULLIF(s.gross_weight,0),(s.staged_objs*1.1)+1), 0))
,	NetWeight =  CONVERT(INT, ROUND(COALESCE(NULLIF(s.net_weight,0),s.staged_objs), 0))
,	Carrier = s.ship_via
,	TrailerNumber =LEFT(COALESCE( NULLIF(s.truck_number,''), CONVERT(VARCHAR(MAX),s.id)),8)
,	TransMode = s.trans_mode
,	PackingListNumber = s.id
,	REFBMValue = COALESCE(s.bill_of_lading_number, id)
,	REFPKValue = s.id


FROM
	dbo.shipper s
	JOIN dbo.edi_setups es
		ON s.destination = es.destination
	JOIN dbo.destination d
		ON s.destination = d.destination
	LEFT JOIN dbo.bill_of_lading bol
		ON s.bill_of_lading_number = bol_number


GO
