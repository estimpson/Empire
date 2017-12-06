SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [EDI_XML_ALC_ASN].[SEG_RFF]
(	@referenceQualifier VARCHAR(5)
,	@referenceNumber VARCHAR(35)
,	@referenceNumber2 VARCHAR(35)
)
RETURNS XML
AS
BEGIN
--- <Body>
	DECLARE
		@xmlOutput XML

	SET	@xmlOutput =
		(	SELECT
				EDI_XML.SEG_INFO('00D97A', 'RFF')
			,	EDI_XML_VD07A.CE('C506', CONVERT(XML, CONVERT(VARCHAR(MAX), EDI_XML_VD07A.DE('1153', @referenceQualifier)) + CONVERT(VARCHAR(MAX), EDI_XML_VD07A.DE('1154', @referenceNumber)) + + CONVERT(VARCHAR(MAX), EDI_XML_VD07A.DE('1156', @referenceNumber2))))
			FOR XML RAW ('SEG-RFF'), TYPE
		)
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END


GO
