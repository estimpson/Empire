SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [EDI_XML_AL_MEXICO_ASN].[ASNHeaders]
AS
SELECT
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = COALESCE(es.trading_partner_code,'ALC')
,	ASNDate = GETDATE()
,	ShipDateTime = s.date_shipped
,	GrossWeightKg = CONVERT(INT, CEILING(ISNULL(NULLIF(s.gross_weight,0),100) * .45359237))
,	NetWeightKg = CONVERT(INT, CEILING(ISNULL(NULLIF(s.net_weight,0),100) * .45359237))
,	MEAShippedQty = s.staged_objs
,	BOL = COALESCE(s.bill_of_lading_number, s.id)
,	SupplierCode = COALESCE(es.supplier_code,'0000002203')
,	SupplierName = p.company_name
,	BuyerCode = COALESCE(es.parent_destination, 'UP01')
,	ShipToCode = COALESCE(es.parent_destination, 'UP01')
,	ShipToName = d.name
,	SCAC = s.ship_via
,	DockNumber = s.shipping_dock
,	TruckNumber = ISNULL(NULLIF(s.truck_number,''),CONVERT(VARCHAR(25), s.id))
,  transMode = COALESCE(NULLIF(s.trans_mode,''), 'M')
FROM
	dbo.shipper s 
	JOIN dbo.edi_setups es 
		ON es.destination = s.destination
	JOIN dbo.destination d
		ON d.destination = s.destination
	CROSS JOIN dbo.parameters p
		

GO
