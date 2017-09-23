SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_POLYCON_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = max(convert(int, sd.alternative_qty))
,	CustomerPO = sd.customer_po
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	AccumShipped = max(convert(int, sd.accum_shipped))
,	UM = coalesce(sd.alternative_unit, 'EA')
,	DockCode = coalesce(oh.dock_code,'POLYCON')
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.shipper = s.id
group by
	s.id
,	sd.customer_part
,	sd.customer_po
,	oh.dock_code
,	sd.alternative_unit
GO
