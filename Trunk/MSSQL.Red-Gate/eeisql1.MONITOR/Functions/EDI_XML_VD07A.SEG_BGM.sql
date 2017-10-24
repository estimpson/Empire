SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD07A].[SEG_BGM]
(	@MessageID varchar(5)
,	@DocumentType2 varchar(35)
,	@MessageNumber varchar(35)
,	@MessageFunction varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'BGM')
			,	EDI_XML_VD07A.CE('C002', EDI_XML_VD07A.DE('1001', @MessageID))
			,	EDI_XML_VD07A.CE('C106', EDI_XML_VD07A.DE('1004', @MessageNumber))
			,	EDI_XML_VD07A.DE('1225', @MessageFunction)
			for xml raw ('SEG-BGM'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
