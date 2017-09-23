SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_MOPAR_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	iConnectID = es.IConnectID
--,	PartialComplete = ''AS partial_complete
,	TradingPartner = es.trading_partner_code
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	DSTIndicator = dbo.udfGetDSTIndication(s.date_shipped)
,	GrossWeightLbs = case
						when (convert(int, s.gross_weight) <= 1) then 1 
						else (convert(int, s.gross_weight))
						end
,	NetWeightLbs = case
						when (convert(int, s.net_weight)<= 1) then 1  
						else (convert(int, s.net_weight))
						end
,	LadingQty = s.staged_objs
,	SCACTransfer = coalesce(bol.scac_transfer, s.ship_via)
,	TransMode = s.trans_mode
,	TruckNo = coalesce(s.truck_number, '001')
,	SCACPickUp = bol.scac_pickup
--,	pool =   if( shipper_trans_mode = 'AE', mid(  equipment_initial  , 1, 3 ), if(  shipper_trans_mode = 'A', mid(  equipment_initial  , 1, 3 ),  if(  shipper_trans_mode = 'E','',   edi_setups_pool_code   )  ) )
--,	bol3 = if(  shipper_trans_mode in ('A', 'E', 'AE'), string( bill_of_lading_number ), if ( edi_setups_parent_destination = 'milkrun', mid ( edi_setups_material_issuer ,( daynumber ( today ( ) ) * 2 - 1) + (daynumber ( today ( ) ) -1) ,3 ) + string(day_of_year,'000'), if( isNull( bill_of_lading_number ), string( shipper_id ), string( bill_of_lading_number ) ) )
,	AirBill = case
				when s.trans_mode in ( 'A', 'AE') and  s.pro_number > '' then  s.pro_number
				else ''
				end
,	FreightBill = upper(	case
								when s.trans_mode not in ( 'A', 'AE') and  s.pro_number > '' then  s.pro_number
								else ''
								end
						)
,	SealNo = coalesce(s.seal_number, s.id)
,	SupplierCode = es.supplier_code
,	ShipFrom = case 
				when s.destination = '90990' then (es.supplier_code + 'A')
				when s.destination = '03111' then (es.supplier_code + 'D') 
				else es.supplier_code 
				end
,	ParentDestination = es.parent_destination
--,	aetcreason = if( len(  shipper_aetc_number )>0, 'ZZ', '' )
--,	aetc_responsibility = if( len(  shipper_aetc_number )>0, case( left(  shipper_aetc_number , 2 ) when 'SR' then 'S' when 'CE' then 'A' else 'Z'), '' )
--,	aetcqualifier = if( len(  shipper_aetc_number )>0, 'AE', '' )
,	AETCNo= s.aetc_number
from
	dbo.Shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination
	left join dbo.bill_of_lading bol 
		on s.bill_of_lading_number = bol.bol_number
	left join dbo.trans_mode tm 
		on tm.code = s.trans_mode  
GO
