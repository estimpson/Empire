SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_MAGNA_PT_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = sum(convert(int, sd.alternative_qty))
,	AccumShipped = max(convert(int, (sd.accum_shipped)))
,	CustomerPO = sd.customer_po
,	EngLevel = max(coalesce(oh.engineering_level,''))
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	left join order_header oh 
		on sd.order_no = oh.order_no
where 
	part not like 'CUM%'
group by
	s.id
,	sd.customer_part
,	sd.customer_po
GO
