SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_DELPHI_ASN].[SEG_TDT]
(	@transportQualifier varchar (5)
,	@CRN varchar(20)
,	@transportMode varchar(5)
,	@carrierID varchar (20) 
,	@clQualifier varchar(5)
,	@clResponsible varchar(5)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'TDT')
			,	EDI_XML_VD97A.DE('8051', @transportQualifier)
			,	EDI_XML_VD97A.DE('8028', @CRN)
			,	EDI_XML_TRW_ASN.CE('C220', EDI_XML_VD97A.DE('8067', @transportMode))
			,	EDI_XML_TRW_ASN.CE('C228', null)
			,	EDI_XML_TRW_ASN.CE('C040', convert(xml, convert(varchar(max), EDI_XML_VD97A.DE('3127', @carrierID)) + convert(varchar(max), EDI_XML_VD97A.DE('1131', @clQualifier)) + convert(varchar(max), EDI_XML_VD97A.DE('3055', @clResponsible))))
			for xml raw ('SEG-TDT'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
