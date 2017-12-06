SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [EDI_XML_ALC_ASN].[udf_ASNLines]
(	@ShipperID INT
)
RETURNS @ASNLines TABLE
(	ShipperID INT
,	CustomerPart VARCHAR(30)
,	CustomerPO VARCHAR(30)
,	CustomerPOLine VARCHAR(30)
,	ObjectQty INT
,	AccumQty INT
,	PackagingIndicator CHAR(1)
,	ModelYear CHAR(2)
,	ObjectPackCount INT
,	RowNumber INT
)
AS
BEGIN
--- <Body>

--- </Body>
	declare
		@at table
	(	Part varchar(25)
	,	PackType varchar(20)
	,	ObjectQty int
	,	ObjectPackCount int
	)
	INSERT
		@at
	(	Part
	,	PackType
	,	ObjectQty
	,	ObjectPackCount
	)
	SELECT
		Part = at.part
	,	PackType = at.package_type
	,	ObjectQty = CONVERT(INT, at.std_quantity)
	,	ObjectPackCount = COUNT(*)
	FROM
		dbo.audit_trail at
	WHERE
		at.type = 'S'
		AND at.shipper = CONVERT(VARCHAR, @ShipperID)
	GROUP BY
		at.part
	,	at.package_type
	,	at.std_quantity		

	INSERT
		@ASNLines
	(	ShipperID
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	ObjectQty
	,	AccumQty
	,	PackagingIndicator
	,	ModelYear
	,	ObjectPackCount
	,	RowNumber
	)
	SELECT
		ShipperID = sd.shipper
	,	CustomerPart = sd.customer_part
	,	CustomerPO = MAX(SUBSTRING(sd.customer_po, 1, ISNULL(PATINDEX('%:%', sd.customer_po),25)-1))
	,	CustomerPOLine =  MAX(SUBSTRING(sd.customer_po, ISNULL(PATINDEX('%:%', sd.customer_po),35)+1,  25 ))
	,	ObjectQty = at.ObjectQty * at.ObjectPackCount
	,	AccumQty = MAX(CONVERT(INT, sd.accum_shipped))
	,	PackagingIndicator = CASE WHEN COALESCE(pm0.returnable,'N') = 'Y'  THEN '1' ELSE '4' END
	,	ModelYear = CONVERT(VARCHAR(2),RIGHT(ISNULL(NULLIF(oh.model_year,''), DATEPART(yy, GETDATE())),2))
	,	at.ObjectPackCount
	,	RowNumber = ROW_NUMBER() OVER (PARTITION BY sd.shipper ORDER BY sd.customer_part)
	FROM
		dbo.shipper_detail sd
		JOIN @at at
			ON at.part = sd.part_original
		JOIN dbo.order_header oh
			ON oh.order_no = sd.order_no
		LEFT JOIN dbo.package_materials pm0 
			ON oh.package_type = pm0.code
	WHERE
		sd.shipper = @ShipperID
	GROUP BY
		sd.shipper
	,	sd.customer_part
	,	pm0.returnable
	,	oh.model_year
	,	at.ObjectQty
	,	at.ObjectPackCount

---	<Return>
	RETURN
END



GO
