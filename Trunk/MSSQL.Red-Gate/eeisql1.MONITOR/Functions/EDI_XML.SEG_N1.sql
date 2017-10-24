SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [EDI_XML].[SEG_N1]
(	@dictionaryVersion varchar(25)
,	@entityIdentifierCode varchar(3)
,	@identificationQualifier varchar(3)
,	@identificationCode varchar(12)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'N1')
			,	EDI_XML.DE(@dictionaryVersion, '0098', @entityIdentifierCode)
			,	EDI_XML.DE(@dictionaryVersion, '0093', null)
			,	EDI_XML.DE(@dictionaryVersion, '0066', @identificationQualifier)
			,	EDI_XML.DE(@dictionaryVersion, '0067', @identificationCode)
			for xml raw ('SEG-N1'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
