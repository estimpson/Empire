
/*
Create View.MONITOR.EDI_XML_Autosystems_ASN.ASNLines.sql
*/

use MONITOR
go

--drop table EDI_XML_Autosystems_ASN.ASNLines
if	objectproperty(object_id('EDI_XML_Autosystems_ASN.ASNLines'), 'IsView') = 1 begin
	drop view EDI_XML_Autosystems_ASN.ASNLines
end
go

create view EDI_XML_Autosystems_ASN.ASNLines
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = convert(int, sd.alternative_qty)
,	Unit = 'EA'
,	AccumShipped = sd.accum_shipped
,	CustomerPO = sd.customer_po
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.edi_setups es
		on es.destination = s.destination
		and es.asn_overlay_group like 'AO%'
where
	coalesce(s.type, 'N') in ('N', 'M')
go

select
	*
from
	EDI_XML_Autosystems_ASN.ASNLines al
where
	al.ShipperID in (99622)
go

