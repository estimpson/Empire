SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDI_XML_VALEOMEX_ASN].[ASNLines]
AS
SELECT
	ShipperID = s.id 
,	CustomerPart = sd.customer_part
,	QtyPacked = CONVERT(INT, sd.alternative_qty)
,	AccumShipped = CONVERT(INT, sd.accum_shipped)
,	CustomerPO = LEFT(sd.customer_po,15)
,	RowNumber = ROW_NUMBER() OVER (PARTITION BY s.id ORDER BY sd.customer_part)
,	CustomerECL = oh.engineering_level
,	DockCode  = ISNULL(NULLIF(oh.dock_code,''),'DK')
,	Part = LEFT(sd.part_original,7)
FROM
	dbo.shipper s
	JOIN dbo.shipper_detail sd
		ON sd.shipper = s.id
	JOIN dbo.order_header oh
		ON oh.order_no = sd.order_no
	JOIN dbo.edi_setups es
		ON es.destination = s.destination
WHERE
	COALESCE(s.type, 'N') IN ('N', 'M')


GO
