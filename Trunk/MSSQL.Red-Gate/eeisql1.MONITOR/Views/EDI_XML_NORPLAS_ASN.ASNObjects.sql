SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_NORPLAS_ASN].[ASNObjects]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = convert(int,(at.quantity))
,	PackType = coalesce(at.package_type, 'CNT90')
,	ParentSerialN = coalesce(at.parent_serial, 0)
,	SerialN = at.serial
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type ='S'
		and at.shipper = convert(varchar, sd.shipper)
		and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')
GO
