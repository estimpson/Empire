SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_LEAR_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerPO = max(sd.customer_po)
,	VendorPart = at.part
,	QtyPacked = max(convert(int, sd.alternative_qty))
,	PackCount = count(distinct at.parent_serial)
,	AccumShipped = max(convert(int, sd.accum_shipped))
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type ='S'
		and at.shipper = convert(varchar, (sd.shipper))
		and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id	
,	sd.customer_part
,	sd.customer_po
,	at.std_quantity
,	at.part
GO
