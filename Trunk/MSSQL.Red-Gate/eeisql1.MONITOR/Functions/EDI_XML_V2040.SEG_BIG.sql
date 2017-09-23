SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V2040].[SEG_BIG]
(	@invoiceDate date
,	@invoiceNumber varchar(12)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('002040', 'BIG')
			,	EDI_XML.DE('002040', '0373', EDI_XML.FormatDate('002040', @invoiceDate))
			,	EDI_XML.DE('002040', '0076', @invoiceNumber)
			for xml raw ('SEG-BIG'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
