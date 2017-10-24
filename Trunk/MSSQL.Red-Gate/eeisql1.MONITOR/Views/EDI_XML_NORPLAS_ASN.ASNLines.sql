SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EDI_XML_NORPLAS_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = convert(int, (sum(sd.alternative_qty)))
,	AccumShipped = max(sd.accum_shipped)
,	CustomerPO = max(sd.customer_po)
,	RowNumber = (row_number() over (partition by s.id order by sd.customer_part)) + 1
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
		   and sd.date_shipped is not null
		   and sd.qty_packed is not null
	join dbo.edi_setups es
		on es.destination = s.destination
group by
	s.id
,	sd.customer_part
GO
