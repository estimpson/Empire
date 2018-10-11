
/*
Create ScalarFunction.FxEDI.EDI_XML.SEG_PID.sql
*/

use FxEDI
go

if	objectproperty(object_id('EDI_XML.SEG_PID'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_PID
end
go

create function EDI_XML.SEG_PID
(	@dictionaryVersion varchar(25)
,	@itemDescriptionType char(1)
,	@description varchar(80)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'PID')
			,	EDI_XML.DE(@dictionaryVersion, '0349', @itemDescriptionType)
			,	EDI_XML.DE(@dictionaryVersion, '0352', @description)
			for xml raw ('SEG-PID'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_PID('002002', 'F', 'ABX5 Pigtail Assembly')