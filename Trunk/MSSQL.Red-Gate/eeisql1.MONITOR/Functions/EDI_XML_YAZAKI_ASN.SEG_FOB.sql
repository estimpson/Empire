SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_YAZAKI_ASN].[SEG_FOB]
(	@PaymentMethod varchar(5)
,	@locQual varchar(5)
,	@desc varchar(80)
,	@transQual varchar(5)
,	@transCode varchar(5)
,	@locQual2 varchar(5)
,	@desc2 varchar(80)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('004010', 'FOB')
			,	EDI_XML.DE('004010', '0146', @PaymentMethod)
			,	EDI_XML.DE('004010', '0309', @locQual)
			,	EDI_XML.DE('004010', '0352', @desc)
			,	EDI_XML.DE('004010', '0334', @transQual)
			,	EDI_XML.DE('004010', '0335', @transCode)
			,	EDI_XML.DE('004010', '0309', @locQual2)
			,	EDI_XML.DE('004010', '0352', @desc2)
			for xml raw ('SEG-FOB'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
