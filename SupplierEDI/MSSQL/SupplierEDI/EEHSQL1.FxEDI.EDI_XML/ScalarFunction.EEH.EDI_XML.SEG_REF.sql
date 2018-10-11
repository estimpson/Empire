
/*
Create ScalarFunction.EEH.EDI_XML.SEG_REF.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_REF'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_REF
end
go

create function EDI_XML.SEG_REF
(	@dictionaryVersion varchar(25)
,	@refenceNumberQualifier varchar(3)
,	@refenceNumber varchar(30) = null
,	@description varchar(80) = null
,	@referenceIdentifier xml = null
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'REF')
			,	EDI_XML.DE(@dictionaryVersion, '0128', @refenceNumberQualifier)
			,	case when @refenceNumber is not null then EDI_XML.DE(@dictionaryVersion, '0127', @refenceNumber) end
			,	case when @description is not null then EDI_XML.DE(@dictionaryVersion, '0352', @description) end
			,	@referenceIdentifier
			for xml raw ('SEG-REF'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_REF('004010', 'PO', '130490B', default, default)