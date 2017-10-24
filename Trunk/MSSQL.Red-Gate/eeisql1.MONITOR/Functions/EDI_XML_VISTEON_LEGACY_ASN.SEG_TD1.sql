SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VISTEON_LEGACY_ASN].[SEG_TD1]
(	@packageCode varchar(12)
,	@ladingQuantity int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_TD1('002002FORD', @packageCode, @ladingQuantity)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
