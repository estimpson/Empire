SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_DELPHI_ASN].[SEG_PIA]
(	@productQualifier varchar(5)
,	@customerPO varchar(35)
,	@itemCode varchar(5)
,	@customerPO2 varchar(35)
,	@itemCode2 varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'PIA')
			,	EDI_XML.DE('00D97A', '4347', @productQualifier)
			,	EDI_XML_VD97A.CE('C212', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7140', @customerPO)) + convert(varchar(max), EDI_XML_VD97A.DE('7143', @itemCode))))
			,	EDI_XML_VD97A.CE('C212', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7140', @customerPO2)) + convert(varchar(max), EDI_XML_VD97A.DE('7143', @itemCode2))))
			for xml raw ('SEG-PIA'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
