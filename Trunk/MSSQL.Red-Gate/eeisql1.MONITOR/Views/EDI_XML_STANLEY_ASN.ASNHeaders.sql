SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_STANLEY_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = convert(date, s.date_shipped)
,	ASNTime = convert(time, s.date_shipped)
,	TimeZoneCode = 'ED'
,	TradingPartner = es.trading_partner_code
,	ShipToID = coalesce(nullif(es.EDIShipToID, ''), nullif(es.parent_destination, ''), es.destination)
,	ShipToName = d.name
,	SupplierName = 'Empire Electronics, Inc.'
,	SupplierCode = es.supplier_code
,	EquipDesc = coalesce( Nullif(es.equipment_description,''), 'TL' )
,	EquipInitial = coalesce( bol.equipment_initial, s.ship_via )
,	TrailerNumber = coalesce( nullif(s.truck_number,''), convert(varchar(max),s.id))
,	BOLQuantity = s.staged_objs
,	GrossWeight = convert(int, round(coalesce(s.gross_weight,0), 0))+1
,	NetWeight = convert(int, round(coalesce(s.net_weight,0), 0))+1
,	Carrier = s.ship_via
,	TransMode = case when s.trans_mode = 'A' then 'U' else s.trans_mode end
,	BOLNumber = coalesce(s.bill_of_lading_number, id)
,	PackingListNumber = s.id
,	PackageType = 'CTN90'
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
		   and es.trading_partner_code = 'STANLEY'
	join dbo.destination d
		on es.destination = d.destination
	left join dbo.bill_of_lading bol
		on s.bill_of_lading_number = bol_number
where
	s.date_shipped is not null
GO
