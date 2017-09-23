SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_DELPHI_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	PackageType = coalesce(pm.name,'CTN90')
,	DockCode = max(s.shipping_dock)
,	CustomerPart = sd.customer_part
,	CustomerPO = max(sd.customer_po)
,	StorageLocation = coalesce(oh.line11,'0001')
,	QtyShipped = convert(int, max(sd.qty_packed))
,	AccumShipped = convert(int, max(sd.accum_shipped))
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	CustomerECL = max(coalesce(oh.engineering_level, oh.customer_part,''))
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type ='S'
		and at.shipper = convert(varchar, sd.shipper)
		and at.part = sd.part
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
	left join dbo.package_materials pm 
		on pm.code = at.package_type
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id
,	sd.customer_part
,	at.package_type
,	at.parent_serial
,	oh.line11
,	pm.name
GO
