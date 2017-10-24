SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VISTEON_LEGACY_ASN].[SEG_LIN2]
(	@assignedIdentification varchar(20)
,	@productQualifier varchar(3)
,	@productNumber varchar(25)

)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML_V4010.SEG_INFO('LIN')
			,	EDI_XML_V4010.DE('0350', @assignedIdentification)
			,	EDI_XML_V4010.DE('0235', @productQualifier)
			,	EDI_XML_V4010.DE('0234', @productNumber)
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
