SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VISTEON_LEGACY_ASN].[SEG_N1]
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

	set	@xmlOutput = EDI_XML.SEG_N1('002002FORD', @entityIdentifierCode, @identificationQualifier, @identificationCode)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
