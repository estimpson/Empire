SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VISTEON_LEGACY_ASN].[DE]
(	@elementCode char(4)
,	@value varchar(max)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.DE('002002FORD', @elementCode, @value)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
