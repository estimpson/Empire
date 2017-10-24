SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_HELLA_ASN].[SEG_IMD]
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
				EDI_XML.SEG_INFO('00D07A', 'NAD')
			,	EDI_XML_VD07A.DE('7077', @itemDescType)
			,	EDI_XML_VD07A.CE('C272', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('7081', @itemChar))))	
			,	EDI_XML_VD07A.CE('C273', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('7009', @itemDescID)) +  convert(varchar(max), EDI_XML_VD07A.DE('1131', @clQual)) +  convert(varchar(max), EDI_XML_VD07A.DE('3055', @clResponsible))+  convert(varchar(max), EDI_XML_VD97A.DE('7008', @itemDesc))))	
			for xml raw ('SEG-IMD'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
