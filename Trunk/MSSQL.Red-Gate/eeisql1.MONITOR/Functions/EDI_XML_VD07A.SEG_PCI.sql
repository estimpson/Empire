SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_PCI]
(		@Instructions varchar(5) -- 4233
	,	@MarksDescription varchar(35) --7102
	,	@FullOrEmpty varchar(3) -- 8169
	,	@MarkingTypeCode varchar(3) -- 7511


)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'PCI')
			,	EDI_XML_VD07A.DE('4233', @Instructions)
			,	EDI_XML_VD07A.CE('C210', convert( varchar(max), EDI_XML_VD07A.DE('7102', @MarksDescription))  )
			,	EDI_XML_VD07A.DE('8169', @FullOrEmpty)
			,	EDI_XML_VD07A.CE('C827', convert( varchar(max), EDI_XML_VD07A.DE('7511', @MarkingTypeCode))  )
			for xml raw ('SEG-PCI'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
