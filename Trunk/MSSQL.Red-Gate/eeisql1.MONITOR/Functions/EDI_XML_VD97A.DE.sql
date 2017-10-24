SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[DE]
(	@elementCode char(4)
,	@value varchar(max)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.DE('00D97A', @elementCode, @value)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
