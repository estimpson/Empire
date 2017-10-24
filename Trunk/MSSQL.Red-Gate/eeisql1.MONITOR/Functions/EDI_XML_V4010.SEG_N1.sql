SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EDI_XML_V4010].[SEG_N1]
(	@entityIdentifierCode varchar(3)
,	@identificationQualifier varchar(3)
,	@identificationCode varchar(12)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_N1('004010', @entityIdentifierCode, @identificationQualifier, @identificationCode)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
