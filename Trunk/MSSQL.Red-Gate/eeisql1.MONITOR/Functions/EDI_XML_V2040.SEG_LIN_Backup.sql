SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create function [EDI_XML_V2040].[SEG_LIN_Backup]
(	@assignedIdentification varchar(20)
,	@productQualifier varchar(3)
,	@productNumber varchar(25)
,	@containerQualifier varchar(3)
,	@containerNumber varchar(25)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML_V2040.SEG_INFO('LIN')
			,	EDI_XML_V2040.DE('0350', @assignedIdentification)
			,	EDI_XML_V2040.DE('0235', @productQualifier)
			,	EDI_XML_V2040.DE('0234', @productNumber)
			,	EDI_XML_V2040.DE('0235', @containerQualifier)
			,	EDI_XML_V2040.DE('0234', @containerNumber)
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
