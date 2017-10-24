SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_AL_MEXICO_ASN].[SEG_IMD]
(	@itemDescType varchar(5)
,	@itemChar varchar(5)
,	@itemDescID varchar(20)
,	@clQual varchar(5)
,	@clResponsible varchar(5)
,	@itemDesc varchar(35)
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
			,	EDI_XML_VD97A.DE('7077', @itemDescType)
			,	EDI_XML_VD97A.DE('7081', @itemChar)
			,	EDI_XML_VD97A.CE('C273', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7009', @itemDescID)) +  convert(varchar(max), EDI_XML_VD97A.DE('1131', @clQual)) +  convert(varchar(max), EDI_XML_VD97A.DE('3055', @clResponsible))+  convert(varchar(max), EDI_XML_VD97A.DE('7008', @itemDesc))))	
			for xml raw ('SEG-NAD'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
