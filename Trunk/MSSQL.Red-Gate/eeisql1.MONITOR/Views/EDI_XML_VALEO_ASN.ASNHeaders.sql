SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_VALEO_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner	= es.trading_partner_code
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	TimeZoneCode = [dbo].[udfGetDSTIndication](date_shipped)
,	GrossWeightLbs = convert(int, s.gross_weight)
,	NetWeightLbs = convert(int, s.net_weight)
,	PackagingCode = 'PLT71'
,	PackCount = s.staged_objs
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	EquipDesc = coalesce(es.equipment_description, 'TL')
,	EquipInitial = coalesce(bol.equipment_initial, s.ship_via)
,	TruckNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25),s.id))
,	ShipToID = coalesce(es.EDIShipToID, es.parent_destination, es.destination)
,	ShipToName = d.name
,	SupplierCode = coalesce(es.supplier_code, 'US0811')
,	REFBMValue = coalesce(bill_of_lading_number, id)
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
	join dbo.destination d
		on d.destination = s.destination
	left join dbo.bill_of_lading bol 
			on s.bill_of_lading_number = bol_number


GO
