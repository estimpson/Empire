SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EDI_XML_MAGNA_ITC_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	TradingPartner = es.trading_partner_code
,	ASNDate = getdate()
,	ASNTime = getdate()
,	GrossWeight = convert(int,s.gross_weight)
,	NetWeight = convert(int,s.net_weight)
,	PackCount = COALESCE(NULLIF(s.staged_objs,0), ISNULL(ShipperDetail.sdBoxesStaged,0),0 )
,	ShipDateTime = s.date_shipped
,	TimeZonecode = [dbo].[udfGetDSTIndication](date_shipped)
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	TrailerNumber = coalesce(s.truck_number, CONVERT(VARCHAR(50),s.id))
,	EquipDesc = coalesce( es.equipment_description, 'TL')
,	EquipInitial = coalesce( bol.equipment_initial, s.ship_via)
,	REFBMValue = coalesce(s.bill_of_lading_number, s.id)
,	REFPKValue = s.id
,	REFCNValue = s.pro_number
,	FOB = case when freight_type =  'Collect' then 'CC' when s.freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when s.freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when s.freight_type = 'Prepaid' then 'PP' else 'CC' end
,	ShipToName =  d.name
,	ShipToID = coalesce(es.EDIShipToID,nullif(es.parent_destination,''),es.destination)
,	ShipToIDtype = case when datalength(coalesce(es.parent_destination, es.destination)) =  9 then 1 else 92 end
,	SupplierCode = coalesce(es.supplier_code, 'US0811')
,	SupplierIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
	join dbo.bill_of_lading bol
		on bol.bol_number = s.bill_of_lading_number
	join dbo.destination d
		on d.destination = s.destination
	OUTER APPLY ( SELECT TOP 1 CONVERT(INT, SUM(sd.boxes_staged) ) sdBoxesStaged FROM shipper_detail sd WHERE sd.shipper = s.id AND sd.boxes_staged IS NOT NULL ) AS ShipperDetail
GO
