SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V3060].[SEG_PRF]
(	@poNumber varchar(22)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_PRF('003060', @poNumber)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
