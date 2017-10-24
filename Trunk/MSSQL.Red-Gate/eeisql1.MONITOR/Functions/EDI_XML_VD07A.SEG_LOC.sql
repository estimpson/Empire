SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_VD07A].[SEG_LOC]
(	@partyQualifier varchar(5)
,	@partyID varchar(35)
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
				EDI_XML.SEG_INFO('00D07A', 'LOC')
			,	EDI_XML_VD07A.DE('3227', @partyQualifier)
			,	EDI_XML_VD07A.CE('C517', convert(xml, convert(varchar(max), EDI_XML_VD07A.DE('3225', @partyID)) +  convert(varchar(max), EDI_XML_VD07A.DE('1131', @clQualifier)) +  convert(varchar(max), EDI_XML_VD07A.DE('3055', @clResponsible))))
			for xml raw ('SEG-LOC'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
