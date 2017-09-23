SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_FNG_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = getdate()
,	ASNTime = getdate()
,	TimeZoneCode = [dbo].[udfGetDSTIndication](date_shipped)
,	TradingPartner	= es.trading_partner_code
,	ShipToCode = es.parent_destination
,	ShipToID = COALESCE(nullif(es.parent_destination,''),es.destination)
,	ShipToName = d.name
,	SupplierCode = coalesce(es.supplier_code, '047380894')
,	SupplierName = 'Empire Electronics, Inc.'
,	EquipInitial = coalesce( bol.equipment_initial, s.ship_via )
,	EquipDesc = coalesce( Nullif(es.equipment_description,''), 'TL' )
,	PackCount = s.staged_objs
,	GrossWeight = convert(int, round(s.gross_weight, 0))
,	NetWeight = convert(int, round(s.net_weight, 0))
,	Carrier = s.ship_via
,	TrailerNumber = coalesce( nullif(s.truck_number,''), convert(varchar(max),s.id))
,	TransMode = s.trans_mode
,	PackingListNumber = s.id
,	REFBMValue = coalesce(s.bill_of_lading_number, id)
,	REFPKValue = s.id

from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	left join
		dbo.bill_of_lading bol on s.bill_of_lading_number = bol_number
GO
