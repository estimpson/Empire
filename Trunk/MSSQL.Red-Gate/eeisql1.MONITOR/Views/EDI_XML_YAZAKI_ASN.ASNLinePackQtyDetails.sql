SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_YAZAKI_ASN].[ASNLinePackQtyDetails]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = at.quantity
,	LoadCount = count(at.serial)
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
group by
	s.id
,	sd.customer_part
,	at.quantity
GO
