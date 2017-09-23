SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	                                   
CREATE view [EDI_XML_FNG_ASN].[ASNLinePackQtyDetails]
as
-- Loose boxes
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = at.std_quantity
,	PackCount = count(*)
,	ParentSerial = null
,	PackageType = 'CTN90'
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
	--and nullif(at.parent_serial,0) is null
group by
	s.id
,	sd.customer_part
,	at.std_quantity
--union all
---- Palletized boxes
--select
--	ShipperID = s.id
--,	CustomerPart = sd.customer_part
--,	PackQty = sum(at.quantity)
--,	PackCount = 1
--,	ParentSerial = at.parent_serial
--,	PackageType = 'PLT71'
--from
--	dbo.shipper s
--	join dbo.shipper_detail sd
--		on sd.shipper = s.id
--	join dbo.audit_trail at
--		on at.type ='S'
--		and at.shipper = convert(varchar, sd.shipper)
--		and at.part = sd.part
--where
--	coalesce(s.type, 'N') in ('N', 'M')
--	and nullif(at.parent_serial,0) is not null
--group by
--	s.id
--,	sd.customer_part
--,	at.parent_serial

GO
