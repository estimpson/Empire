SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EDI_XML_MAGNA_PT_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TimeZone = [dbo].[udfGetDSTIndication](date_shipped)
,	TradingPartner = es.trading_partner_code
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = convert(int,coalesce(nullif(s.gross_weight,0), (staged_objs*1)+(staged_objs*.25)))
,	NetWeightLbs = convert(int,coalesce(nullif(s.net_weight,0), staged_objs*1))
,	PackCount = s.staged_objs
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	TrailerNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25),s.id))
,	SupplierCode = coalesce(es.supplier_code, 'US0811')
,	ShipToName = d.name
,	ShipToID = coalesce(nullif(es.parent_destination,''),es.destination)
,	EquipDesc = coalesce( es.equipment_description, 'TL')
,	EquipInitial = coalesce( left(truck_number,4), s.ship_via)
,	REFBMValue = coalesce(s.bill_of_lading_number, s.id)
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
	join dbo.destination d
		on s.destination = d.destination


GO
