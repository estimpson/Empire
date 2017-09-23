SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_Autosystems_ASN].[SEG_PRF]
(	@poNumber varchar(22)
,	@date char(8)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('004010', 'PRF')
			,	EDI_XML.DE('004010', '0324', @poNumber)
			,	EDI_XML.DE('004010', '0373', @date)
			for xml raw ('SEG-PRF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
