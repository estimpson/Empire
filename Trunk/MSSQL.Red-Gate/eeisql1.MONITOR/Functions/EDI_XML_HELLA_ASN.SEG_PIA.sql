SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_HELLA_ASN].[SEG_PIA]
(	
	@InternalItem varchar(35)
,	@DrawingRevisionNumber varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'PIA')
			,	EDI_XML.DE('00D97A', '4347', '1')
			,	EDI_XML_HELLA_ASN.CE('C212', convert(xml, convert(varchar(max), EDI_XML.DE('00D97A', '7140', @InternalItem)) + convert(varchar(max), EDI_XML.DE('00D97A', '7143', 'SA'))))
			,	EDI_XML_HELLA_ASN.CE('C212', convert(xml, convert(varchar(max), EDI_XML.DE('00D97A', '7140', @DrawingRevisionNumber)) + convert(varchar(max), EDI_XML.DE('00D97A', '7143', 'DR'))))
			for xml raw ('SEG-PIA'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
