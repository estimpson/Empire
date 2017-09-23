SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_MEA]
(	@measurementPurpose varchar (5)
,	@measurementUnit varchar(5)
,	@measurementValue varchar(20)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'MEA')
			,	EDI_XML.DE('00D97A', '6311', @measurementPurpose)
			,	EDI_XML_TRW_ASN.CE('C502', null)
			,	EDI_XML_TRW_ASN.CE('C174', convert(xml, convert(varchar(max), EDI_XML.DE('00D97A', '6411', @measurementUnit)) + convert(varchar(max), EDI_XML.DE('00D97A', '6314', @measurementValue))))
			for xml raw ('SEG-MEA'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
