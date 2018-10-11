
/*
Create ScalarFunction.EEH.EDI_XML.SEG_N1.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_N1'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_N1
end
go

create function EDI_XML.SEG_N1
(	@dictionaryVersion varchar(25)
,	@entityIdentifierCode varchar(3)
,	@name varchar(60) = null
,	@identificationQualifier varchar(3)
,	@identificationCode varchar(12)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'N1')
			,	EDI_XML.DE(@dictionaryVersion, '0098', @entityIdentifierCode)
			,	case when @name is not null then EDI_XML.DE(@dictionaryVersion, '0093', @name) end
			,	EDI_XML.DE(@dictionaryVersion, '0066', @identificationQualifier)
			,	EDI_XML.DE(@dictionaryVersion, '0067', @identificationCode)
			for xml raw ('SEG-N1'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_N1('004010', 'SU', 'EMPIRE ELECTRONICS', 'ZZ', '00109489')