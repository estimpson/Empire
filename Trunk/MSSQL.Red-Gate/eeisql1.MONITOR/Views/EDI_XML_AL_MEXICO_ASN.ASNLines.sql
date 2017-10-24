SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_AL_MEXICO_ASN].[ASNLines]
as
select
	ShipperID = s.id
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
,	CustomerPart = sd.customer_part
,	CustomerPO = CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po, 1, PATINDEX('%:%', sd.customer_po)-1) ELSE sd.customer_po end
,	CustomerPOLine = CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po,  PATINDEX('%:%', sd.customer_po)+1, 35) ELSE sd.customer_po end
--,	PackageType = '0000'
--,	PackageCount  = COUNT(1)
,	QtyShipped = convert(int, sd.alternative_qty)
,	PartName = LEFT(sd.part_name,35)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
GO
