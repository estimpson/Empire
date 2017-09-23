SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREatE view [EDI_XML_PLEX_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = convert(int, sd.alternative_qty)
,	AccumShipped = sd.accum_shipped
,	CustomerPO = sd.customer_po
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	CustomerECL = oh.engineering_level
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
		and es.asn_overlay_group = 'PLX'
where
	coalesce(s.type, 'N') in ('N', 'M')

GO
