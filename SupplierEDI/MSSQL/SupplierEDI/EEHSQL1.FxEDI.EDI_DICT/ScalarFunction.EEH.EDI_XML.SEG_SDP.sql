
/*
Create ScalarFunction.EEH.EDI_XML.SEG_SDP.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_SDP'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_SDP
end
go

create function EDI_XML.SEG_SDP
(	@dictionaryVersion varchar(25)
,	@deliveryPatternCode varchar(2)
,	@deliveryPatternTimeCode char(1)
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'SDP')
			,	EDI_XML.DE(@dictionaryVersion, '0678', @deliveryPatternCode)
			,	EDI_XML.DE(@dictionaryVersion, '0679', @deliveryPatternTimeCode)
			for xml raw ('SEG-SDP'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_SDP('003060', 'Y', 'A')