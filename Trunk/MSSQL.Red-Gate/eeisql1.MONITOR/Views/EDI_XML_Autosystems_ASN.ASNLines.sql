SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_Autosystems_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = Sum(convert(int, sd.alternative_qty))
,	Unit = 'EA'
,	AccumShipped = max(sd.accum_shipped)
,	CustomerPO = max(sd.customer_po)
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.edi_setups es
		on es.destination = s.destination
		and es.asn_overlay_group like 'AO%'
where
	coalesce(s.type, 'N') in ('N', 'M')
	group by 
		s.id, sd.customer_part

GO
