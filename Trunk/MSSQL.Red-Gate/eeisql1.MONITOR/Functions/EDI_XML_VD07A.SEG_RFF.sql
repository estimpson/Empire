SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_RFF]
(	@referenceQualifier varchar(5)
,	@referenceNumber varchar(35)
,	@referenceNumber2 varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D07A', 'RFF')
			,	EDI_XML_VD07A.CE('C506', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('1153', @referenceQualifier)) + convert(varchar(max), EDI_XML_VD07A.DE('1154', @referenceNumber)) + + convert(varchar(max), EDI_XML_VD07A.DE('1156', @referenceNumber2))))
			for xml raw ('SEG-RFF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
