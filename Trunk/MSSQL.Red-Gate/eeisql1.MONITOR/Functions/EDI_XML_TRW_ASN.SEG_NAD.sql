SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_NAD]
(	@partyQualifier varchar(5)
,	@partyID varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'NAD')
			,	EDI_XML.DE('00D97A', '3035', @partyQualifier)
			,	EDI_XML_TRW_ASN.CE('C082', EDI_XML.DE('00D97A', '3039', @partyID))
			for xml raw ('SEG-NAD'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
