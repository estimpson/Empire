SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EDI_XML_NORPLAS_ASN].[ASNLinePackQtyDetails]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = convert(int,(at.quantity))
,	PackCount = convert(varchar(max), count(1))
,	PackType = coalesce(at.package_type, 'CNT90')
,	RowNumber = (row_number() over (partition by s.id order by sd.customer_part))
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
		and sd.date_shipped is not null
		and sd.qty_packed is not null
	join dbo.audit_trail at
		on at.type ='S'
		and at.shipper = convert(varchar, s.id)
		and at.part = sd.part_original
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id
,	sd.customer_part
,	at.package_type
,	at.quantity
GO
