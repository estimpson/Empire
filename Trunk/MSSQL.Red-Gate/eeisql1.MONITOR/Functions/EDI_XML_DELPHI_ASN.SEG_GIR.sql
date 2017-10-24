SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_DELPHI_ASN].[SEG_GIR]
(	@idQual varchar(5)
,	@idNum varchar(35)
,	@idNumQual varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'GIR')
			,	EDI_XML_VD97A.DE('7297', @idQual)
			,	EDI_XML_VD97A.CE('C206', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7402', @idNum))+convert(varchar(max), EDI_XML_VD97A.DE('7405', @idNumQual))))
			for xml raw ('SEG-GIR'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
