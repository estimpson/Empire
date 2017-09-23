SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDI_XML_NASCOTE_ASN].[ASNHeader]
AS
SELECT
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ASNDate = GETDATE()
,	ASNTime = GETDATE()
,	TradingPartner	= es.trading_partner_code
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = CONVERT(INT, (ISNULL(NULLIF(s.gross_weight,0),(s.staged_objs*1))))
,	NetWeightLbs = CONVERT(INT, (ISNULL(NULLIF(s.net_weight,0),(s.staged_objs*.95))))
,	PackCount = s.staged_objs
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	TrailerNumber = COALESCE(NULLIF(s.truck_number,''), CONVERT(VARCHAR(25), s.id))
,	SupplierCode = COALESCE(es.supplier_code, '047380894')
,	ShipToName =  d.name
,	ShipToID = COALESCE(NULLIF(es.parent_destination,''),es.destination)
,	BOLNumber =  COALESCE(NULLIF(s.bill_of_lading_number,0),s.id)
FROM 
	dbo.shipper s
	JOIN dbo.edi_setups es
		ON s.destination = es.destination
	JOIN dbo.destination d
		ON d.destination = s.destination	


GO
