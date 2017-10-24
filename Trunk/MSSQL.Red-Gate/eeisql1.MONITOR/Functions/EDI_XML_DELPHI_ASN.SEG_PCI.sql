SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_DELPHI_ASN].[SEG_PCI]
(	@instructions varchar(5)
,	@shippingMarks varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'PCI')
			,	EDI_XML_VD97A.DE('4233', @instructions)
			,	EDI_XML_VD97A.CE('C202', EDI_XML_VD97A.DE('7102', @shippingMarks))
			for xml raw ('SEG-PCI'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
