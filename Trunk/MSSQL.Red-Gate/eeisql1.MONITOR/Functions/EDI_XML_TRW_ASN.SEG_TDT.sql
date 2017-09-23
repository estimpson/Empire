SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_TDT]
(	@transportQualifier varchar (5)
,	@CRN varchar(20)
,	@transportMode varchar(5)
,	@carrierID varchar (20) 
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
			,	EDI_XML.DE('00D97A', '8051', @transportQualifier)
			,	EDI_XML.DE('00D97A', '8028', @CRN)
			,	EDI_XML_TRW_ASN.CE('C220', EDI_XML.DE('00D97A', '8067', @transportMode))
			,	EDI_XML_TRW_ASN.CE('C228', null)
			,	EDI_XML_TRW_ASN.CE('C040', EDI_XML.DE('00D97A', '3127', @carrierID))
			for xml raw ('SEG-TDT'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
