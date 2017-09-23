SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_RFF]
(	@referenceQualifier varchar(5)
,	@referenceNumber varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'RFF')
			,	EDI_XML_VD97A.CE('C506', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('1153', @referenceQualifier)) + convert(varchar(max), EDI_XML_VD97A.DE('1154', @referenceNumber))))
			for xml raw ('SEG-RFF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
