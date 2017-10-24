SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_DTM]
(	@dateID varchar(5)
,	@shipDate date
,   @dateFormat varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'DTM')
			,	EDI_XML_TRW_ASN.CE('C507', convert(xml, convert(varchar(max), EDI_XML.DE('00D97A', '2005', @DateID)) + convert(varchar(max), EDI_XML.DE('00D97A', '2380', @ShipDate)) + convert(varchar(max), EDI_XML.DE('00D97A', '2379', @dateFormat))))
			for xml raw ('SEG-DTM'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
