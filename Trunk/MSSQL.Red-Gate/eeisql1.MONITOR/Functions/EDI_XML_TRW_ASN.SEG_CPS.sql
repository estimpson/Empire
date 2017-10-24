SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_CPS]
(	@hierarchialID varchar(15)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'CPS')
			,	EDI_XML.DE('00D97A', '7164', @hierarchialID)
			for xml raw ('SEG-CPS'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
