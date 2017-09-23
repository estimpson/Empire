SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_SUMMIT_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	PackageCount = sum(sd.boxes_staged)
,	CustomerPart = sd.customer_part
,	CustomerPO = max(sd.Customer_Po)
,	QtyShipped = convert(int, sum(sd.alternative_qty))
,	AccumShipped = convert(int, max(sd.accum_shipped))
--,	ShipperLine = row_number() over (partition by s.id order by sd.customer_part) 
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
group by
	s.id
,	sd.customer_part

GO
