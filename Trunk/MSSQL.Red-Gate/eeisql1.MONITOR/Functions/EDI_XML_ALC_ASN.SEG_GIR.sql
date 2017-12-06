SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [EDI_XML_ALC_ASN].[SEG_GIR]
(	@idSetQualifier VARCHAR(5)
,	@idNum VARCHAR(35)
,	@idNumQualifier VARCHAR(5)
,	@idNum2 VARCHAR(35)
,	@idNumQualifier2 VARCHAR(5)
)
RETURNS XML
AS
BEGIN
--- <Body>
	DECLARE
		@xmlOutput XML

	SET	@xmlOutput =
		(	SELECT
				EDI_XML.SEG_INFO('00D97A', 'GIR')
			,	EDI_XML_VD97A.DE('7297', @idSetQualifier)
			,	EDI_XML_VD97A.CE('C206', CONVERT(XML, CONVERT(VARCHAR(MAX), EDI_XML_VD97A.DE('7402', @idNum)) +  CONVERT(VARCHAR(MAX), EDI_XML_VD97A.DE('7405', @idNumQualifier))))
			,	EDI_XML_VD97A.CE('C206', CONVERT(XML, CONVERT(VARCHAR(MAX), EDI_XML_VD97A.DE('7402', @idNum2)) +  CONVERT(VARCHAR(MAX), EDI_XML_VD97A.DE('7405', @idNumQualifier2))))
			FOR XML RAW ('SEG-GIR'), TYPE
		)
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END

GO
