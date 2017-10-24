SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD07A].[SEG_CNT]
(	@controlQualifier varchar (5)
,	@controlValue varchar(20)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'CNT')
			,	EDI_XML_TRW_ASN.CE('C270', convert(xml, convert(varchar(max), EDI_XML.DE('00D07A', '6069', @controlQualifier)) + convert(varchar(max), EDI_XML.DE('00D07A', '6066', @controlValue))))
			for xml raw ('SEG-CNT'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
