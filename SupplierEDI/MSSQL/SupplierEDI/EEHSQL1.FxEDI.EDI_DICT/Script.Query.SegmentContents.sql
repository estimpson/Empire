use FxEDI
go

declare
	@DictionaryVersion varchar(25) = '003060'
,	@Segment varchar(25) = 'SDP'

select
	dsc.DictionaryVersion
,	dsc.Segment
,	dsc.ElementOrdinal
,	dsc.ElementCode
,	dsc.ElementUsage
,	de.ElementName
,	de.ElementDataType
,	de.ElementLengthMin
,	de.ElementLengthMax
,	dscChild.ElementOrdinal
,	dscChild.ElementCode
,	dscChild.ElementUsage
,	deChild.ElementName
,	deChild.ElementDataType
,	deChild.ElementLengthMin
,	deChild.ElementLengthMax
from
	EDI_DICT.DictionarySegmentContents dsc
	left join EDI_DICT.DictionaryElements de
		left join EDI_DICT.DictionarySegmentContents dscChild
			left join EDI_DICT.DictionaryElements deChild
				on deChild.DictionaryVersion = dscChild.DictionaryVersion
				and deChild.ElementCode = right('0000' + dscChild.ElementCode, 4)
			on dscChild.DictionaryVersion = de.DictionaryVersion
			and dscChild.Segment = de.ElementCode
		on de.DictionaryVersion = dsc.DictionaryVersion
		and de.ElementCode = dsc.ElementCode
where
	dsc.DictionaryVersion like @DictionaryVersion
	and dsc.Segment like @Segment
	and dsc.ContentType = 'S'
order by
	dsc.Segment
,	dsc.ElementOrdinal
,	dscChild.ElementOrdinal

/*
select
	dsc.Segment
,	dsc.ElementOrdinal
,	dsc.ElementUsage
from
	EDI_DICT.DictionarySegmentContents dsc
	left join EDI_DICT.DictionaryElements de
		on de.DictionaryVersion = dsc.DictionaryVersion
		and de.ElementCode = dsc.ElementCode
where
	dsc.DictionaryVersion = '004010'
	and de.ElementDataType = 'CP'
order by
	dsc.Segment
,	dsc.ElementOrdinal
*/