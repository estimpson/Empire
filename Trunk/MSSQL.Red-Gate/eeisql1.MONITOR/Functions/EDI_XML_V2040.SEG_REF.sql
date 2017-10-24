SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V2040].[SEG_REF]
(	@refenceQualifier varchar(3)
,	@refenceNumber varchar(30)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_REF('002040', @refenceQualifier, @refenceNumber)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
