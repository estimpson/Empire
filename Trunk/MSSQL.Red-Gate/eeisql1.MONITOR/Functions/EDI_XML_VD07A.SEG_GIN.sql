SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [EDI_XML_VD07A].[SEG_GIN]
(		@IDQualifier varchar(3)
	,	@SerialRange varchar(50)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'GIN')
			,	EDI_XML_VD07A.DE('7405', @IDQualifier)
			,	EDI_XML_VD07A.CE('C208', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('7402', @SerialRange)) ))
			for xml raw ('SEG-GIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end


GO
