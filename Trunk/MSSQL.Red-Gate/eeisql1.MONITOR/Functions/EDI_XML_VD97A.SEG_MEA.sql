SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_MEA]
(	@measurementPurpose varchar (5)
,	@measurementQualifier varchar (5)
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
			,	EDI_XML_VD97A.DE('6311', @measurementPurpose)
			,	EDI_XML_VD97A.CE('C502', EDI_XML_VD97A.DE('6313', @measurementQualifier))
			,	EDI_XML_VD97A.CE('C174', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('6411', @measurementUnit)) + convert(varchar(max), EDI_XML_VD97A.DE('6314', @measurementValue))))
			for xml raw ('SEG-MEA'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
