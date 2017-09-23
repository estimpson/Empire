SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_TRW_ASN].[ASNHeaders]
as
select
	ShipperID = isnull(s.id,0)
,	IConnectID = es.IConnectID
,	ShipDateTime = convert(varchar(25), s.date_shipped, 112)
,	ASNDate = convert(varchar(25), getdate(), 112)
,	TradingPartner = COALESCE(es.trading_partner_code,'TRW')
,	GrossWeightKG = convert(int, ceiling(isnull(nullif(s.gross_weight,0),100) * .45359237))
,	NetWeightKG = convert(int, ceiling(isnull(nullif(s.net_weight,0),100) * .45359237))
,	BOL = coalesce(s.bill_of_lading_number,s.id, 0)
,	EDIShipTo = coalesce(nullif(es.parent_destination,''),nullif(es.EDIShipToID,''),es.destination, '')
,	SupplierCode = isnull(es.supplier_code,'')
,	SCAC = isnull(s.ship_via,'')
,	TruckNumber = upper(isnull(nullif(s.truck_number,''), convert(varchar(25), s.id)))
,	TransMode = 
	case s.trans_mode 
		when 'A' then '40' 
		else '30' 
	end
,	Lifts =
	isnull((select	count(distinct Parent_serial) 
			from	audit_trail at
			where	at.shipper = convert(char(10),s.id) and
					at.type = 'S' and 
					isnull(at.parent_serial,0) >0 ),0) +
	isnull((select	count(at.serial) 
			from	audit_trail at,
					package_materials pm
			where	at.shipper = convert(char(10),s.id) and
					at.type = 'S' and
					part <> 'PALLET' and 
					at.parent_serial is NULL ),0)
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination and isNULL(s.date_shipped,'1999-01-01') >getdate()-30 and es.asn_overlay_group = 'TR1' and es.auto_create_asn != 'Y'
	join dbo.destination d
		on d.destination = s.destination

GO
