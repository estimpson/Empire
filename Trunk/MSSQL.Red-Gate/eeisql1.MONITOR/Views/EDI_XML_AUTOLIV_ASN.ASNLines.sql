SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [EDI_XML_AUTOLIV_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyShipped = max(rans.Qty)
,	QtyPacked = max(convert(int, sd.alternative_qty))
,	AccumShipped = max(sd.accum_shipped)
,	CustomerPO = sd.customer_po
,	CustomerR = rans.RanNumber
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	ProNumber = max (coalesce (s.pro_number, ''))
,	PackType = coalesce
		(	(	select
		 			max(at.package_type)
		 		from
		 			dbo.audit_trail at
				where
					at.shipper = convert(varchar, s.id)
					and at.type = 'S'
					and at.part = max(sd.part)
		 	)
		,	'BOX34'
		)
,	LadingQty = max(sd.boxes_staged)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	left join AutoLivRanNumbersShipped rans
		on Rans.shipper =  sd.shipper
		and rans.Orderno = sd.order_no
group by
	s.id
,	sd.customer_part
,	sd.customer_po
,	rans.RanNumber
GO
