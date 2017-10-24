SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_GM_BFT_ASN].[ASNLines]
as


select
	ShipperID = s.id	
,	PackagingIndicator = (case when coalesce(pm0.returnable,'N') = 'Y'  then '1' else '4' end )
,	CustomerPart = sd.customer_part
,	PalletPackCode = coalesce(at.package_type, '0000PALT')
,	PalletPackCount = count(distinct at.Parent_serial)
,	ObjectPackCode = coalesce(at.package_type,'0000CART')
,	ObjectPackCount = count(at.serial)
,	ObjectQty = max(convert(int, at.quantity))
,	AccumQty = max(convert(int, sd.accum_shipped))
,	CustomerPO = max(sd.customer_po)
,	ModelYear = convert(varchar(2),RIGHT(isNull(nullif(oh.model_year,''), datepart(yy, getdate())),1))
,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.type ='S'
		and at.shipper = convert(varchar, (sd.shipper))
		and at.part = sd.part
	join dbo.order_header oh
		on oh.order_no = sd.order_no
	left  join
		dbo.package_materials pm0 
			on oh.package_type = pm0.code
where
	coalesce(s.type, 'N') in ('N', 'M')
group by
	s.id	
,	sd.customer_part
,	at.std_quantity
,	at.package_type
,	pm0.returnable
,	oh.model_year

GO
