SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_TRW_ASN].[SEG_LIN]
(	@LINNumber varchar (10)
,	@partNumber varchar(35)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'LIN')
			,	EDI_XML.DE('00D97A', '1082', @LINNumber)
			,	EDI_XML.DE('00D97A', '1229', null)
			,	EDI_XML_TRW_ASN.CE('C212', EDI_XML.DE('00D97A', '7140', @partNumber))
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
