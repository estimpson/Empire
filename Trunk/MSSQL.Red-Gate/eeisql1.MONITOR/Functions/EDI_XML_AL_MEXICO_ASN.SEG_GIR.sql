SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_AL_MEXICO_ASN].[SEG_GIR]
(	@idSetQualifier varchar(5)
,	@idNum varchar(35)
,	@idNumQualifier varchar(5)
,	@idNum2 varchar(35)
,	@idNumQualifier2 varchar(5)
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
			,	EDI_XML_VD97A.DE('7297', @idSetQualifier)
			,	EDI_XML_VD97A.CE('C273', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7402', @idNum)) +  convert(varchar(max), EDI_XML_VD97A.DE('7405', @idNumQualifier))))
			,	EDI_XML_VD97A.CE('C273', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('7402', @idNum2)) +  convert(varchar(max), EDI_XML_VD97A.DE('7405', @idNumQualifier2))))
			for xml raw ('SEG-GIR'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
