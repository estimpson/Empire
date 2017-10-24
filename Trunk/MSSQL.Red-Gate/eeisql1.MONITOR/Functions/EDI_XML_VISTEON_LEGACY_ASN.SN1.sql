SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_VISTEON_LEGACY_ASN].[SN1]
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

	set	@xmlOutput = EDI_XML.SEG_SN1('002002FORD', @identification, @units, @unitMeasure, @accum)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
GO
