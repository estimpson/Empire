SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_HELLA_ASN].[ASNPalletSerialPackTypes]
as
select
	ShipperID = s.id
,	PackTypeCount = count(1)
,	PackType = COALESCE(nullif(at.package_type,''), 'BBB.BBB-B')
from
	dbo.shipper s
join dbo.audit_trail at
		on at.type = 'S'
		and at.shipper = convert(varchar(50), s.id)
		and at.part = 'PALLET'
where
	coalesce(s.type, 'N') in ('N', 'M') and
	s.date_shipped is Not NULL and exists ( select 1 from audit_trail at2 where at2.type = 'S' and at2.shipper = convert(varchar(50), s.id) and at2.parent_serial = at.serial )
Group by
	S.id,
	 COALESCE(nullif(at.package_type,''), 'BBB.BBB-B')

GO
