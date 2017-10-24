SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create function [EDI_XML_HELLA_ASN].[SEG_LIN]
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
				EDI_XML.SEG_INFO('00D07A', 'LIN')
			,	EDI_XML.DE('00D97A', '1082', @LINNumber)
			,	EDI_XML.DE('00D97A', '1229', null)
			,	EDI_XML_TRW_ASN.CE('C212', convert( varchar(max), EDI_XML.DE('00D07A', '7140', @partNumber)) + Convert( varchar(max), EDI_XML.DE('00D07A', '7143', 'IN')))
			for xml raw ('SEG-LIN'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
