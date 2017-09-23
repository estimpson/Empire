SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_NALPLEX_ASN].[ASNHeaders]
as
select 
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = convert(date, s.date_shipped)
,	ASNTime = convert(time, s.date_shipped)
,	TimeZoneCode = 'ED'
,	TradingPartner	= es.trading_partner_code
,	ShipToCode = es.parent_destination
,	ShipToID = COALESCE(nullif(es.EDIShipToID,''),nullif(es.parent_destination,''),es.destination)
,	ShipToName = d.name
,	SupplierCode = es.supplier_code
,	SupplierName = 'Empire Electronics, Inc.'
,	EquipInitial = coalesce( bol.equipment_initial, s.ship_via )
,	BOLQuantity = s.staged_objs
,	GrossWeight = convert(int, round(coalesce(s.gross_weight,0), 0))+1
,	NetWeight = convert(int, round(coalesce(s.net_weight,0), 0))+1
,	Carrier = s.ship_via
,	TransMode = s.trans_mode
,	TruckNumber = LEFT(upper(coalesce(nullif(s.truck_number,''), 'TRUCKNO')),10)
,	BOLNumber = coalesce(s.bill_of_lading_number, id)
,	PackingListNumber = s.id
,	PackageType = 'CTN90'
,	FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end

from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	left join
		dbo.bill_of_lading bol on s.bill_of_lading_number = bol_number
where
	es.asn_overlay_group = 'NAL'

GO
