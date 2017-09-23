SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_ALI]
(	
	@COO varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'ALI')
			,	EDI_XML_VD07A.DE('3239', @COO)
			for xml raw ('SEG-ALI'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
