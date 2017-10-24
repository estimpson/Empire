SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE view [EDI_XML_HELLA_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	CustomerPart = left(sd.customer_part,35)
,	InternalPart =  max(LEFT(sd.part_original,7))
,	DrawingRevisionNumber = max(coalesce(LEFT(oh.engineering_level,3), LEFT(PartRev.el,3),''))
,	PartName =  max( LEFT ( p.name, 35))
,	CustomerPO = max(LEFT(sd.customer_po,10))
--,	CustomerPOLine = max(RIGHT(sd.customer_po,4))
,	CustomerPOLine ='10' -- modified per Btighitta email 11/28/2016 asb
,	QtyShipped = convert(int, sum(sd.qty_packed))
,	LineFeed = max( isNULL(nullif(oh.line_feed_code,''),'LF'))
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)

from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join part p
		on p.part =  sd.part_original
	left join dbo.order_header oh
		on oh.order_no = sd.order_no
	join dbo.edi_setups es
		on es.destination = s.destination
outer apply
	( select top 1 engineering_level el from part_revision pr where pr.part =  sd.part_original order by effective_datetime desc ) as PartRev
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id
,	sd.customer_part







GO
