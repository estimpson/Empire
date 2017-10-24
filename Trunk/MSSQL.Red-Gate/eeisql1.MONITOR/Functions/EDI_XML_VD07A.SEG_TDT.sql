SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_TDT]
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
				EDI_XML.SEG_INFO('00D07A', 'TDT')
			,	EDI_XML_VD07A.DE('8051', @transportQualifier)
			,	EDI_XML_VD07A.DE('8028', @CRN)
			,	EDI_XML_TRW_ASN.CE('C220', EDI_XML_VD07A.DE('8067', @transportMode))
			for xml raw ('SEG-TDT'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
