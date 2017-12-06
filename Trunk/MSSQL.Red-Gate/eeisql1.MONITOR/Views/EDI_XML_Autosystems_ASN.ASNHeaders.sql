SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EDI_XML_Autosystems_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	TradingPartnerID = es.trading_partner_code
,	ASNDate = convert(date, getdate())
,	ASNTime = convert(time, getdate())
,	ShipDateTime = s.date_shipped
,	ArrivalDateTime = convert(datetime, convert(varchar(10), s.date_shipped, 126) + 'T' + '17:00:00')
,	ShipDate = convert(date, s.date_shipped)
,	ShipTime = convert(time, s.date_shipped)
,	GrossWeight = CEILING(convert(numeric(10,2), round(s.staged_objs * (2 + 10/24.0),2))+s.staged_objs)
,	TareWeight = CEILING(convert(numeric(10,2), round(s.staged_objs * (2 + 10/24.0),2)))
,	PackageType = 'CTN'
,	BOLQuantity = staged_objs
,	Carrier = s.ship_via
,	TransMode = s.trans_mode
,	LocationQualifier =
		case
			when s.trans_mode in ('A', 'AE') then 'OR'
		end
,	AirportCode =
		case
			when s.trans_mode in ('A', 'AE') then coalesce(nullif(s.seal_number,''),'SAP')
		end
,	EquipmentType =
		case
			when s.trans_mode in ('A', 'AE') then 'AF'
			else 'TL'
		end
,	TruckNumber = COALESCE(NULLIF(s.truck_number,''), '1')
,	PRONumber = s.pro_number
,	BOLNumber = s.id
,	ShipTo = es.parent_destination
,	SupplierCode = es.supplier_code
--,	*
from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
		and es.asn_overlay_group like 'AO%'
	join dbo.destination d
		on d.destination = s.destination
where
	coalesce(s.type, 'N') in ('N', 'M')
	--and s.id = 75964

GO
