
/*
Create schema Schema.MONITOR.EDI_XML_STANLEY_ASN.sql
*/

use MONITOR
go

-- Create the database schema
if schema_id('EDI_XML_STANLEY_ASN') is null
	begin
		exec sys.sp_executesql
			N'create schema EDI_XML_STANLEY_ASN authorization dbo'
	end
go


alter view EDI_XML_STANLEY_ASN.ASNHeaders
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
go

select
	*
from
	EDI_XML_STANLEY_ASN.ASNHeaders ah
where
	ah.ShipperID in (107447, 107389)
order by
	ah.ShipperID desc
go

alter view EDI_XML_STANLEY_ASN.ASNLines
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerPO = rtrim(sd.customer_po)
,	QtyPacked = convert(int, sd.alternative_qty)
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
go

select
	*
from
	EDI_XML_STANLEY_ASN.ASNLines al
where
	al.ShipperID in (107447, 107389)
go

alter view EDI_XML_STANLEY_ASN.ASNLinePackQtyDetails
as
-- Loose boxes
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = at.std_quantity
,	PackCount = count(*)
,	PackageType = 'CTN90'
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type = 'S'
		   and at.shipper = convert(varchar, sd.shipper)
		   and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id
,	sd.customer_part
,	at.std_quantity
go

select
	*
from
	EDI_XML_STANLEY_ASN.ASNLinePackQtyDetails alpqd
where
	alpqd.ShipperID in (107447, 107389)
go

alter view EDI_XML_STANLEY_ASN.ASNObjects
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerSerial = at.serial
,	PackageType = 'CTN90'
,	Quantity = at.quantity
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type = 'S'
		   and at.shipper = convert(varchar(50), s.id)
		   and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')
go

select
	*
from
	EDI_XML_STANLEY_ASN.ASNObjects ao
where
	ao.ShipperID in (107447, 107389)
go

alter function EDI_XML_V4010.SEG_N1_NAME
(	@entityIdentifierCode varchar(3)
,	@identificationQualifier varchar(3)
,	@identificationCode varchar(25)
,	@identificationName varchar(60)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('004010', 'N1')
			,	EDI_XML.DE('004010', '0098', @entityIdentifierCode)
			,	EDI_XML.DE('004010', '0093', @identificationName)
			,	EDI_XML.DE('004010', '0066', @identificationQualifier)
			,	EDI_XML.DE('004010', '0067', @identificationCode)
			for xml raw ('SEG-N1'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO

--update
--	es
--set	EDIShipToID = '034909358ALP'
--,	es.IConnectID = '13504'
--from
--	dbo.edi_setups es
--where
--	es.trading_partner_code = 'STANLEY'