SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VD97A].[SEG_PAC]
(	@packageCount varchar(10)
,	@packageID varchar(20)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO('00D97A', 'PAC')
			,	EDI_XML_VD97A.DE('7224', @packageCount)
			,	EDI_XML_VD97A.CE('C202', EDI_XML_VD97A.DE('7065', @packageID))
			for xml raw ('SEG-PAC'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
