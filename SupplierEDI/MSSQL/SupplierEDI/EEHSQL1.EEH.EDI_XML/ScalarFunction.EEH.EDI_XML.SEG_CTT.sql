
/*
Create ScalarFunction.EEH.EDI_XML.SEG_CTT.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_CTT'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_CTT
end
go

create function EDI_XML.SEG_CTT
(	@dictionaryVersion varchar(25)
,	@lineCount int
,	@hashTotal int
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'CTT')
			,	EDI_XML.DE(@dictionaryVersion, '0354', @lineCount)
			,	case when @hashTotal is not null then EDI_XML.DE(@dictionaryVersion, '0347', @hashTotal) end
			for xml raw ('SEG-CTT'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

