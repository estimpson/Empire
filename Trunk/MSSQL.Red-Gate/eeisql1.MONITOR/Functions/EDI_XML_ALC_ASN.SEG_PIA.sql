SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [EDI_XML_ALC_ASN].[SEG_PIA]
(	@productQualifier VARCHAR(5)
,	@LotNumber VARCHAR(35)
,	@LotNumberQualifier VARCHAR(5)
)
RETURNS XML
AS
BEGIN
--- <Body>
	DECLARE
		@xmlOutput XML

	SET	@xmlOutput =
		(	SELECT
				EDI_XML.SEG_INFO('00D97A', 'PIA')
			,	EDI_XML.DE('00D97A', '4347', @productQualifier)
			,	EDI_XML_TRW_ASN.CE('C212', CONVERT(XML, CONVERT(VARCHAR(MAX), EDI_XML.DE('00D97A', '7140', @LotNumber)) + CONVERT(VARCHAR(MAX), EDI_XML.DE('00D97A', '7143', @LotNumberQualifier))))
			FOR XML RAW ('SEG-PIA'), TYPE
		)
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END

GO
