SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_AUTOLIV_ASN].[SEG_PRF]
(	@poNumber varchar(22)
,	@crNumber varchar(25)
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
			,	EDI_XML.DE('004010', '0328', @crNumber)
			for xml raw ('SEG-PRF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
