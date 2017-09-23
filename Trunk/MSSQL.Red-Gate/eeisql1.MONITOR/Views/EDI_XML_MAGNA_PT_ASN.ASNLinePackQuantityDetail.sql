SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_MAGNA_PT_ASN].[ASNLinePackQuantityDetail]
as
select
	ShipperID = s.id
,	PackQty =sum(distinct convert(int, at.quantity)) 
,	ContainerCount = count(*)
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
GO
