SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create function [EDI_XML_HELLA_ASN].[SEG_BGM]
(	@MessageID varchar(5)
,	@DocumentType2 varchar(35)
,	@MessageNumber varchar(35)
,	@MessageFunction varchar(5)
,	@ResponseType varchar(5)

)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'BGM')
			,	EDI_XML_HELLA_ASN.CE('C002', convert(xml, convert(varchar(max), EDI_XML.DE('00D07A', '1001', @MessageID)) + convert(varchar(max), EDI_XML.DE('00D07A', '1131', null)) + convert(varchar(max), EDI_XML.DE('00D07A', '3055', null)) + convert(varchar(max), EDI_XML.DE('00D07A', '1000', @DocumentType2))))
			,	EDI_XML_HELLA_ASN.CE('C106', convert(xml, convert(varchar(max), EDI_XML.DE('00D07A', '1004', @MessageNumber))))
			,	EDI_XML.DE('00D07A', '1225', @MessageFunction)
			,	EDI_XML.DE('00D07A', '4343', @ResponseType)
			for xml raw ('SEG-BGM'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
