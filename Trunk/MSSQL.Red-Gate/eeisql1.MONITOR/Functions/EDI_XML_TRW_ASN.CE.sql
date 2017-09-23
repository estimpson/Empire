SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[CE]
(	@elementCode char(4)
,	@de xml
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.CE('00D97A', @elementCode, @de)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
