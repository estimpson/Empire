SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_EQD]
(	@equipQualifier varchar(5)
,	@equipID varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'EQD')
			,	EDI_XML_VD97A.DE('8053', @equipQualifier)
			,	EDI_XML_VD97A.CE('C237', EDI_XML_VD97A.DE('8260', @equipID))
			for xml raw ('SEG-EQD'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
