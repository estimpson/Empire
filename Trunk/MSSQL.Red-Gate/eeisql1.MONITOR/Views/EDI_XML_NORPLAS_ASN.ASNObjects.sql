SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [EDI_XML_NORPLAS_ASN].[ASNObjects]
AS
SELECT
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	PackQty = CONVERT(INT,(at.quantity))
,	PackType = COALESCE(NULLIF(at.package_type,''), 'CTN90')
,	ParentSerialN = COALESCE(at.parent_serial, 0)
,	SerialN = at.serial
FROM
	dbo.shipper s
	JOIN dbo.shipper_detail sd
		ON sd.shipper = s.id
	JOIN dbo.audit_trail at
		ON at.type ='S'
		AND at.shipper = CONVERT(VARCHAR, sd.shipper)
		AND at.part = sd.part
WHERE
	COALESCE(s.type, 'N') IN ('N', 'M')

GO
