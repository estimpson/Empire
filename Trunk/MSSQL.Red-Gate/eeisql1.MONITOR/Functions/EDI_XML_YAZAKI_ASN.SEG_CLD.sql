SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_YAZAKI_ASN].[SEG_CLD]
(	@loads int
,	@unitsShipped int
,	@packageCode varchar(12)
,	@size varchar(10)
,	@unitsCode varchar(5) 
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('004010', 'CLD')
			,	EDI_XML_V4010.DE('0622', @loads)
			,	EDI_XML_V4010.DE('0382', @unitsShipped)
			,	EDI_XML_V4010.DE('0103', @packageCode)
			,	EDI_XML_V4010.DE('0357', @size)
			,	EDI_XML_V4010.DE('0355', @unitsCode)
			for xml raw ('SEG-CLD'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
