SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_YAZAKI_ASN].[ASNObjects]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerSerial = '3000846160' + convert(varchar(18), at.serial)
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
GO
