SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_NASCOTE_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = max(convert(int, sd.alternative_qty))
,	AccumShipped = max(sd.accum_shipped)
,	CustomerPO = sd.customer_po
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
group by
	s.id
,	sd.customer_part
,	sd.customer_po
GO
