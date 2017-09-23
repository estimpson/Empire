SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [EDI_XML_HELLA_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = COALESCE(NULLIF(es.trading_partner_code,''),'HELLA')
,	ASNDate = getdate()
,	ArrivalDate = dateadd(dd,Coalesce(es.TransitDays,0) ,s.date_shipped)
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = convert(int,s.gross_weight)
,	NetWeightLbs = convert(int,s.gross_weight)
,	LadingQty = s.staged_objs
,	REFCNValue = coalesce(s.pro_number, s.truck_number, '1')
,	REFCOFValue =  coalesce(nullif(s.shipping_dock,''), 'CallOffNumber')
,	MaterialIssuerID = es.material_issuer
,	SupplierCode =  coalesce(es.supplier_code, 'SUPP')
,	SupplierCode2 =  coalesce(es.supplier_code, 'SUPP')
,	SCAC = COALESCE( Nullif(s.ship_via,''),LastSCAC) 
,	TransPortNumber = COALESCE(NULLIF(s.pro_number,''),s.truck_number, CONVERT(VARCHAR(25), s.id))
,	NADIDBuyer = COALESCE(es.parent_destination, s.destination)
,	NADIDSeller = COALESCE(NULLIF(es.supplier_code,''), '0043712581')
,	EDIShipTo = COALESCE(NULLIF(es.EDIShipToID,''), '3272')
,	Buyer = COALESCE(NULLIF(es.Material_Issuer,''), 'HELLA')
,	LOCDock =  COALESCE(s.shipping_dock, '')
,	TransMode = CASE WHEN s.trans_mode LIKE '%A%' THEN '40' ELSE '30' END
,	EquipmentType = 'TE'
,	TruckNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25),s.id))
,	BOL =  coalesce(s.bill_of_lading_number, s.id)
,	ProNumber = coalesce(s.pro_number,'')

from
	dbo.shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination
Outer Apply ( select top 1 ship_via LastSCAC from shipper s2 where s2.date_shipped is not NULL and s2.destination = s.destination and nullif(s.ship_via,'') is NULL order by s2.date_shipped DESC) CheckSCAC



GO
