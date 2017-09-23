SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EDI_XML_NORPLAS_ASN].[udf_ASNLinePackQtyDetails]
(	@ShipperID int
)
returns @ASNLinePackQtyDetails table
(	ShipperID int
,	CustomerPart varchar(30)
,	PackQty int
,	PackCount int
,	PackType varchar(20)
)
as
begin
--- <Body>
	declare
		@at table
	(	Part varchar(25)
	,	PackType varchar(20)
	,	PackQty int
	)

	insert
		@at
	(	Part
	,	PackType
	,	PackQty
	)
	select
		Part = at.part
	,	PackType = at.package_type
	,	PackQty = at.quantity
	from
		dbo.audit_trail at
	where
		at.shipper = convert(varchar, @ShipperID)
		and at.type = 'S'

	insert
		@ASNLinePackQtyDetails
	(	ShipperID
	,	CustomerPart
	,	PackQty
	,	PackCount
	,	PackType
	)
	select
		ShipperID = sd.shipper
	,	CustomerPart = sd.customer_part
	,	PackQty = at.PackQty
	,	PackCount = convert(varchar, count(*))
	,	PackType = coalesce(at.PackType, 'CNT90')
	from
		dbo.shipper_detail sd
		join @at at
			on at.Part = sd.part_original
	where
		sd.shipper = @ShipperID
	group by
		sd.shipper
	,	sd.customer_part
	,	at.PackType
	,	at.PackQty
--- </Body>

---	<Return>
	return
end

GO
