SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_TRW_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyShipped = convert(int, sum(sd.alternative_qty))
,	AccumShipped = convert(int, max(sd.accum_shipped))
,	CustomerPO = sd.Customer_Po
,	UM = coalesce(max(sd.alternative_unit), 'PCE')
,	ShipperLine = row_number() over (partition by s.id order by sd.customer_part) 
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
Group by 
	s.id,
	sd.customer_part,
	sd.customer_po


GO
