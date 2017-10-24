SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_LOC]
(	@locQualifier varchar(5)
,	@locID varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'LOC')
			,	EDI_XML_VD97A.DE('3227', @locQualifier)
			,	EDI_XML_VD97A.CE('C506', EDI_XML_VD97A.DE('3225', @locID))
			for xml raw ('SEG-LOC'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
