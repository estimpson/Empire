SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_VISTEON_LEGACY_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	CustomerPO = max(sd.customer_po)
,	ShipQty = sum(convert(int, sd.alternative_qty))
,	AccumQty = sum(convert(int, sd.accum_shipped))
,	CustomerECL = max(oh.engineering_level)
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
where
	coalesce(s.type, 'N') in ('N', 'M')
	and sd.part NOT LIKE 'CUM%' and s.date_shipped > getdate() - 60
group by
	s.id
,	sd.customer_part

GO