SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [EDI_XML_Chrysler_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	iConnectID = es.IConnectID
,	TradingPartnerID = es.trading_partner_code
,	ShipDateTime = s.date_shipped
,	ShipDate = convert(date, s.date_shipped)
,	ShipTime = convert(time, s.date_shipped)
,	TimeZoneCode = [dbo].[udfGetDSTIndication](s.date_shipped)
,	GrossWeight = convert(int, round(s.gross_weight, 0))
,	NetWeight = convert(int, round(s.net_weight, 0))
,	PackageType = 'CTN25'
,	BOLQuantity = s.staged_objs
,	Carrier = s.ship_via
,	BOLCarrier = coalesce(s.bol_carrier, s.ship_via)
,	TransMode = s.trans_mode
,	EquipInitial = coalesce(bol.equipment_initial, s.ship_via)
,	LocationQualifier =
		case
			when s.trans_mode = 'E' then null
			when s.trans_mode in ('A', 'AE') then 'OR'
			when es.pool_code != '' then 'PP'
		end
,	PoolCode =
		case
			when s.trans_mode not in ('A', 'AC', 'AE', 'E', 'U') then es.pool_code
		end
,	EquipmentType = es.equipment_description
,	TruckNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25), s.id))
,	PRONumber = s.pro_number
,	BOLNumber =
		case
			when es.parent_destination = 'milkrun' then substring(es.material_issuer, datepart(dw, s.date_shipped)*2-1, 2) + right('0'+convert(varchar, datepart(month, s.date_shipped)),2) + right('0'+convert(varchar, datepart(day, s.date_shipped)),2)
			else convert(varchar, coalesce(s.bill_of_lading_number, s.id))
		end
,	ShipTo = coalesce(nullif(es.parent_destination, ''), es.destination)
,	SupplierCode = es.supplier_code
,	AETCResponsibility = case
		when left(s.aetc_number, 2) = 'CE' then 'A'
		when left(s.aetc_number, 2) = 'SR' then 'S'
		when left(s.aetc_number, 2) = 'CR' then 'Z'
	end
,	AETC = s.aetc_number
--,	*
from
	dbo.shipper s
	left join dbo.bill_of_lading bol
		on bol.bol_number = s.bill_of_lading_number
	join dbo.edi_setups es
		on s.destination = es.destination
		and es.trading_partner_code like '%MOPAR%'
	join dbo.destination d
		on d.destination = s.destination
where
	coalesce(s.type, 'N') in ('N', 'M')
	--and s.id = 75964



GO
