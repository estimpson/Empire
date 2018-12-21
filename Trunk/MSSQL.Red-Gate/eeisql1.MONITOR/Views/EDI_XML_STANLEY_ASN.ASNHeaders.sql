SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [EDI_XML_STANLEY_ASN].[ASNHeaders]
AS
SELECT
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = CONVERT(DATE, s.date_shipped)
,	ASNTime = CONVERT(TIME, s.date_shipped)
,	TimeZoneCode = [dbo].[udfGetDSTIndication](s.date_shipped) 
,	TradingPartner = es.trading_partner_code
,	ShipToID = COALESCE(NULLIF(es.EDIShipToID, ''), NULLIF(es.parent_destination, ''), es.destination)
,	ShipToName = d.name
,	SupplierName = 'Empire Electronics, Inc.'
,	SupplierCode = es.supplier_code
,	EquipDesc = COALESCE( NULLIF(es.equipment_description,''), 'TL' )
,	EquipInitial = COALESCE( bol.equipment_initial, s.ship_via )
,	TrailerNumber = LEFT(COALESCE( NULLIF(s.truck_number,''), CONVERT(VARCHAR(MAX),s.id)),10)
,	BOLQuantity = s.staged_objs
,	GrossWeight = CONVERT(INT, ROUND(COALESCE(s.gross_weight,0), 0))+1
,	NetWeight = CONVERT(INT, ROUND(COALESCE(s.net_weight,0), 0))+1
,	Carrier = s.ship_via
,	TransMode = CASE WHEN s.trans_mode = 'A' THEN 'U' ELSE s.trans_mode END
,	BOLNumber = COALESCE(s.bill_of_lading_number, id)
,	PackingListNumber = s.id
,	PackageType = 'CTN90'
FROM
	dbo.shipper s
	JOIN dbo.edi_setups es
		ON s.destination = es.destination
		   AND es.trading_partner_code = 'STANLEY'
	JOIN dbo.destination d
		ON es.destination = d.destination
	LEFT JOIN dbo.bill_of_lading bol
		ON s.bill_of_lading_number = bol_number
WHERE
	s.date_shipped IS NOT NULL


GO
