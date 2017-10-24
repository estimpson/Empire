SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_YAZAKI_ASN].[SEG_SLN]
(	@assignedIdentification varchar(20)
,	@relationshipCode varchar (1)
,	@unitPrice numeric(6,2)
,	@unitCode varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML_V4010.SEG_INFO('SLN')
			,	EDI_XML_V4010.DE('0350', @assignedIdentification)
			,	EDI_XML_V4010.DE('0662', @relationshipCode)
			,	EDI_XML_V4010.DE('0212', @unitPrice)
			,	EDI_XML_V4010.DE('0639', @unitCode)
			for xml raw ('SEG-SLN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
