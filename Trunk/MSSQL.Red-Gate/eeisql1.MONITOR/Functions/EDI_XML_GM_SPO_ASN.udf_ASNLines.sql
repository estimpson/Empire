SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_GM_SPO_ASN].[udf_ASNLines]
(	@ShipperID int
)
returns @ASNLines table
(	ShipperID int
,	CustomerPart varchar(30)
,	CustomerPO varchar(30)
,	ObjectQty int
,	AccumQty int
,	PackagingIndicator char(1)
,	ModelYear char(2)
,	ObjectPackCount int
,	RowNumber int
)
as
begin
--- <Body>

--- </Body>
	declare
		@at table
	(	Part varchar(25)
	,	PackType varchar(20)
	,	ObjectQty int
	,	ObjectPackCount int
	)
	insert
		@at
	(	Part
	,	PackType
	,	ObjectQty
	,	ObjectPackCount
	)
	select
		Part = at.part
	,	PackType = at.package_type
	,	ObjectQty = convert(int, at.std_quantity)
	,	ObjectPackCount = count(*)
	from
		dbo.audit_trail at
	where
		at.type = 'S'
		and at.shipper = convert(varchar, @ShipperID)
	group by
		at.part
	,	at.package_type
	,	at.std_quantity		

	insert
		@ASNLines
	(	ShipperID
	,	CustomerPart
	,	CustomerPO
	,	ObjectQty
	,	AccumQty
	,	PackagingIndicator
	,	ModelYear
	,	ObjectPackCount
	,	RowNumber
	)
	select
		ShipperID = sd.shipper
	,	CustomerPart = sd.customer_part
	,	CustomerPO = max(sd.customer_po)
	,	ObjectQty = at.ObjectQty * at.ObjectPackCount
	,	AccumQty = max(convert(int, sd.accum_shipped))
	,	PackagingIndicator = case when coalesce(pm0.returnable,'N') = 'Y'  then '1' else '4' end
	,	ModelYear = convert(varchar(2),right(isnull(nullif(oh.model_year,''), datepart(yy, getdate())),2))
	,	at.ObjectPackCount
	,	RowNumber = row_number() over (partition by sd.shipper order by sd.customer_part)
	from
		dbo.shipper_detail sd
		join @at at
			on at.part = sd.part_original
		join dbo.order_header oh
			on oh.order_no = sd.order_no
		left join dbo.package_materials pm0 
			on oh.package_type = pm0.code
	where
		sd.shipper = @ShipperID
	group by
		sd.shipper
	,	sd.customer_part
	,	pm0.returnable
	,	oh.model_year
	,	at.ObjectQty
	,	at.ObjectPackCount

---	<Return>
	return
end
GO
