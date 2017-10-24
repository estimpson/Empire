SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD07A].[SEG_QTY]
(	@quantityQualifier varchar (5)
,	@quantity varchar(15)
,	@quantityUnit varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'QTY')
			,	EDI_XML_TRW_ASN.CE('C186', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('6063', @quantityQualifier)) + convert(varchar(max), EDI_XML_VD07A.DE('6060', @quantity)) + convert(varchar(max), EDI_XML_VD07A.DE('6411', @quantityUnit))))
			for xml raw ('SEG-QTY'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
