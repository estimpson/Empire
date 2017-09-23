SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_RFF]
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
			,	EDI_XML_TRW_ASN.CE('C506', convert(xml, convert(varchar(max), EDI_XML.DE('00D97A', '1153', @referenceQualifier)) + convert(varchar(max), EDI_XML.DE('00D97A', '1154', @referenceNumber))))
			for xml raw ('SEG-RFF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
