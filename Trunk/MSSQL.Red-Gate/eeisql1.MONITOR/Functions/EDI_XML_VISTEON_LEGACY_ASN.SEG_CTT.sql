SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VISTEON_LEGACY_ASN].[SEG_CTT]
(	@lineCount int
,	@hashTotal int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_CTT('002002FORD', @lineCount, @hashTotal)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
