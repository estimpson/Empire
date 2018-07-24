SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [EDI_XML_MOPAR_ASN].[ASNHeaders]
AS
SELECT
	ShipperID = s.id 
,	iConnectID = es.IConnectID
--,	PartialComplete = ''AS partial_complete
,	TradingPartner = es.trading_partner_code
,	ASNDate = GETDATE()
,	ASNTime = GETDATE()
,	ShipDateTime = s.date_shipped
,	DSTIndicator = dbo.udfGetDSTIndication(s.date_shipped)
,	GrossWeightLbs = CASE
						WHEN (CONVERT(INT, s.gross_weight) <= 1) THEN 1 
						ELSE (CONVERT(INT, s.gross_weight))
						END
,	NetWeightLbs = CASE
						WHEN (CONVERT(INT, s.net_weight)<= 1) THEN 1  
						ELSE (CONVERT(INT, s.net_weight))
						END
,	LadingQty = s.staged_objs
,	SCACTransfer = COALESCE(bol.scac_transfer, s.ship_via)
,	TransMode = s.trans_mode
,	TruckNo = LEFT(COALESCE(s.truck_number, '001'),8)
,	SCACPickUp = bol.scac_pickup
--,	pool =   if( shipper_trans_mode = 'AE', mid(  equipment_initial  , 1, 3 ), if(  shipper_trans_mode = 'A', mid(  equipment_initial  , 1, 3 ),  if(  shipper_trans_mode = 'E','',   edi_setups_pool_code   )  ) )
--,	bol3 = if(  shipper_trans_mode in ('A', 'E', 'AE'), string( bill_of_lading_number ), if ( edi_setups_parent_destination = 'milkrun', mid ( edi_setups_material_issuer ,( daynumber ( today ( ) ) * 2 - 1) + (daynumber ( today ( ) ) -1) ,3 ) + string(day_of_year,'000'), if( isNull( bill_of_lading_number ), string( shipper_id ), string( bill_of_lading_number ) ) )
,	AirBill = CASE
				WHEN s.trans_mode IN ( 'A', 'AE') AND  s.pro_number > '' THEN  s.pro_number
				ELSE ''
				END
,	FreightBill = UPPER(	CASE
								WHEN s.trans_mode NOT IN ( 'A', 'AE') AND  s.pro_number > '' THEN  s.pro_number
								ELSE ''
								END
						)
,	SealNo = COALESCE(s.seal_number, s.id)
,	SupplierCode = es.supplier_code
,	ShipFrom = CASE 
				WHEN s.destination = '90990' THEN (es.supplier_code + 'A')
				WHEN s.destination = '03111' THEN (es.supplier_code + 'D') 
				ELSE es.supplier_code 
				END
,	ParentDestination = es.parent_destination
--,	aetcreason = if( len(  shipper_aetc_number )>0, 'ZZ', '' )
--,	aetc_responsibility = if( len(  shipper_aetc_number )>0, case( left(  shipper_aetc_number , 2 ) when 'SR' then 'S' when 'CE' then 'A' else 'Z'), '' )
--,	aetcqualifier = if( len(  shipper_aetc_number )>0, 'AE', '' )
,	AETCNo= s.aetc_number
FROM
	dbo.Shipper s 
	JOIN dbo.edi_setups es
		ON es.destination = s.destination
	LEFT JOIN dbo.bill_of_lading bol 
		ON s.bill_of_lading_number = bol.bol_number
	LEFT JOIN dbo.trans_mode tm 
		ON tm.code = s.trans_mode  

GO
