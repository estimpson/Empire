SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_V2040].[SEG_SN1]
(	@identification varchar(20)
,	@units int
,	@unitMeasure char(2)
,	@accum int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput = EDI_XML.SEG_SN1('002040', @identification, @units, @unitMeasure, @accum)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
