
/*
Create ScalarFunction.FxEDI.EDI_XML.FormatDate.sql
*/

use FxEDI
go

if	objectproperty(object_id('EDI_XML.FormatDate'), 'IsScalarFunction') = 1 begin
	drop function EDI_XML.FormatDate
end
go

create function EDI_XML.FormatDate
(	@dictionaryVersion varchar(25)
,	@date date
)
returns varchar(12)
as
begin
--- <Body>
	declare
		@dateString varchar(12)
	,	@dateFormat varchar(12)

	select
		@dateFormat = ddf.FormatString
	from
		EDI_DICT.DictionaryDTFormats ddf
	where
		ddf.DictionaryVersion = coalesce
			(	(	select
						ddfR.DictionaryVersion
					from
						EDI_DICT.DictionaryDTFormats ddfR
					where
						ddfR.DictionaryVersion = @dictionaryVersion
						and ddfR.Type = 1
				)
			,	(	select
						max(ddfP.DictionaryVersion)
					from
						EDI_DICT.DictionaryDTFormats ddfP
					where
						ddfP.DictionaryVersion < @dictionaryVersion
						and ddfP.Type = 1
				)
			,	(	select
						min(ddfP.DictionaryVersion)
					from
						EDI_DICT.DictionaryDTFormats ddfP
					where
						ddfP.DictionaryVersion > @dictionaryVersion
						and ddfP.Type = 1
				)
			)
		and ddf.Type = 1

	set @dateString = EDI_XML.FormatDT(@dateFormat, @date)
--- </Body>

---	<Return>
	return
		@dateString
end
go

select
	EDI_XML.FormatDate('004010', getdate())
