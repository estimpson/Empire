SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_LIN]
(	@linNumber varchar (10)
,	@action varchar(5)
,	@itemNumber varchar(35)
,	@itemType varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'LIN')
			,	EDI_XML_VD97A.DE('1082', @linNumber)
			,	EDI_XML_VD97A.DE('1229', @action)
			,	EDI_XML_TRW_ASN.CE('C212', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7140', @itemNumber)) + convert(varchar(max), EDI_XML_VD97A.DE('7143', @itemType))))
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
