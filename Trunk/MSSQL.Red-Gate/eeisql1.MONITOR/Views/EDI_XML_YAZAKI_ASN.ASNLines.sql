SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_YAZAKI_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = replace(sd.customer_part,'-','')
,	QtyPacked = convert(int, sd.qty_packed)
,	AccumShipped = convert(int, sd.accum_shipped)
,	VendorPart = sd.part_original
,	PartDescription = left(p.name,48)
,	CustomerPO = sd.customer_po
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	Price = convert(numeric(6,2), round (sd.alternate_price, 2))
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.edi_setups es
		on es.destination = s.destination
	join part p 
		on sd.part_original = p.part
where
	coalesce(s.type, 'N') in ('N', 'M')

GO
