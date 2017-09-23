SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EDI_XML_PLEX_ASN].[ASNObjects]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerSerial = COALESCE(nullif(es.material_issuer,''),'EE') + convert(varchar(12), at.serial)
--,	at.std_quantity 
from
	dbo.shipper s
	join
		edi_setups es 
		on es.destination = s.destination
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type = 'S'
		and at.shipper = convert(varchar(50), s.id)
		and at.part = sd.part
where
	coalesce(s.type, 'N') in ('N', 'M')


GO
