SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_NASCOTE_ASN].[ASNLinePackQuantityDetails] 
as
select
	ShipperID = s.id
,	PackQty =sum(at.quantity) 
,	PackCount = count(distinct at.parent_serial)
,	CustomerPart = sd.customer_part

,	Serial = at.parent_serial
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
,	at.std_quantity
,	at.parent_serial
GO
