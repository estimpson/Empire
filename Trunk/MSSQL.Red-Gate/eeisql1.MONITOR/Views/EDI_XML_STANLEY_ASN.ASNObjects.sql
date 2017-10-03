SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_STANLEY_ASN].[ASNObjects]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerSerial = isNULL(es.supplier_code,'') + convert ( varchar(50), at.serial )
,	PackageType = 'CTN90'
,	Quantity = at.quantity
from
	dbo.shipper s
	join dbo.edi_setups es on es.destination = s.destination
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type = 'S'
		   and at.shipper = convert(varchar(50), s.id)
		   and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')

GO
