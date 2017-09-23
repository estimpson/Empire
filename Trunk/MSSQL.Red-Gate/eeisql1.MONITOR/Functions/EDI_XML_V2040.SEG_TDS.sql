SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V2040].[SEG_TDS]
(	@totalMonetaryValue numeric(9,2)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_TDS('002040', @totalMonetaryValue)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
