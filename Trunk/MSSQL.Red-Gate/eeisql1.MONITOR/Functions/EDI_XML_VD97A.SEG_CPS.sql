SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_CPS]
(	@hierarchialID varchar(15)
,	@parentID varchar(15)
,	@packagingLevel varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'CPS')
			,	EDI_XML_VD97A.DE('7164', @hierarchialID)
			,	EDI_XML_VD97A.DE('7166', @parentID)
			,	EDI_XML_VD97A.DE('7075', @packagingLevel)
			for xml raw ('SEG-CPS'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
