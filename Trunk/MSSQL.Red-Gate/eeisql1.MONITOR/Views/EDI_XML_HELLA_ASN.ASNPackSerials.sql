SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EDI_XML_HELLA_ASN].[ASNPackSerials]
as
select
	ShipperID = s.id
,	CustomerPart = left(sd.customer_part,35)
,	PackageType = Coalesce(nullif(at.package_type,''), 'XXX.XXX-XX')
,	PackageQty = at.quantity
,	SerialNumber = at.serial


from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join part p
		on p.part =  sd.part_original
	join dbo.edi_setups es
		on es.destination = s.destination
	join audit_trail at 
		on at.part = sd.part_original and 
			at.shipper = convert(varchar(25), s.id) and
			at.type = 'S' and
			at.part != 'PALLET'
where
	coalesce(s.type, 'N') in ('N', 'M')





GO
