
/*
Create ScalarFunction.EEH.EDI_XML.SEG_SHP.sql
*/

use EEH
go

if	objectproperty(object_id('EDI_XML.SEG_SHP'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.SEG_SHP
end
go

create function EDI_XML.SEG_SHP
(	@dictionaryVersion varchar(25)
,	@quantityQualifier char(2)
,	@quantity int
,	@dateTimeQualifier char(3)
,	@date1 datetime
,	@time1 datetime
,	@date2 datetime
,	@time2 datetime
)
returns xml
as
begin
--- <Body>
	declare
		@xmlOutput xml

	set	@xmlOutput =
		(	select
				EDI_XML.SEG_INFO(@dictionaryVersion, 'SHP')
			,	EDI_XML.DE(@dictionaryVersion, '0673', @quantityQualifier)
			,	case when @quantity is not null then EDI_XML.DE(@dictionaryVersion, '0380', @quantity) end
			,	case when @dateTimeQualifier is not null then EDI_XML.DE(@dictionaryVersion, '0374', @dateTimeQualifier) end
			,	case when @date1 is not null then EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date1)) end
			,	case when @time1 is not null then EDI_XML.DE(@dictionaryVersion, '0337', EDI_XML.FormatTime(@dictionaryVersion, @time1)) end
			,	case when @date2 is not null then EDI_XML.DE(@dictionaryVersion, '0373', EDI_XML.FormatDate(@dictionaryVersion, @date2)) end
			,	case when @time2 is not null then EDI_XML.DE(@dictionaryVersion, '0337', EDI_XML.FormatTime(@dictionaryVersion, @time2)) end
			for xml raw ('SEG-SHP'), type
		)
--- </Body>

---	<Return>
	return
		@xmlOutput
end
go

select
	EDI_XML.SEG_SHP('004010', '01', 32040, '050', '2015-12-02', default, default, default)
