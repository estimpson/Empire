
/*
Create ScalarFunction.FxEDI.EDI_XML.TD5.sql
*/

use FxEDI
go

if	objectproperty(object_id('EDI_XML.TD5'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.TD5
end
go

create function EDI_XML.TD5
(	@dictionaryVersion varchar(25)
,	@routingSequenceCode varchar(3)
,	@identificaitonQualifier varchar(3)
,	@identificaitonCode varchar(12)
,	@transMethodCode varchar(3)
,	@locationQualifier varchar(3)
,	@locationIdentifier varchar(25)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'TD5')
			,	EDI_XML.DE(@dictionaryVersion, '0133', @routingSequenceCode)
			,	EDI_XML.DE(@dictionaryVersion, '0066', @identificaitonQualifier)
			,	EDI_XML.DE(@dictionaryVersion, '0067', @identificaitonCode)
			,	EDI_XML.DE(@dictionaryVersion, '0091', @transMethodCode)
			,	case
					when @locationQualifier is not null then EDI_XML.DE(@dictionaryVersion, '0309', @locationQualifier)
				end
			,	case
					when @locationQualifier is not null then EDI_XML.DE(@dictionaryVersion, '0310', @locationIdentifier)
				end
			for xml raw ('SEG-TD5'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

