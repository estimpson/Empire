SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V3060].[SEG_CTT]
(	@lineCount int
,	@hashTotal int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_CTT('003060', @lineCount, @hashTotal)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
