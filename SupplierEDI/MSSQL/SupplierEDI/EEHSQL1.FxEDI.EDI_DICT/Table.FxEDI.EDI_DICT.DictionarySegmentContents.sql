
/*
Create Table.FxEDI.EDI_DICT.DictionarySegmentContents.sql
*/

use FxEDI
go

/*
exec FT.sp_DropForeignKeys

drop table EDI_DICT.DictionarySegmentContents

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EDI_DICT.DictionarySegmentContents'), 'IsTable') is null begin

	create table EDI_DICT.DictionarySegmentContents
	(	DictionaryVersion varchar(25) not null
	,	ContentType char(1) not null
	,	Segment varchar(25) not null
	,	ElementOrdinal int not null
	,	ElementCode varchar(25) not null
	,	ElementUsage char(1) not null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
insert
	EDI_DICT.DictionarySegmentContents
(	DictionaryVersion
,	ContentType
,	Segment
,	ElementOrdinal
,	ElementCode
,	ElementUsage
,	DictionaryRowID
)
select
	*
from
	EEISQL1.FxEDI.EDI_DICT.DictionarySegmentContents dsc
*/

select
	*
from
	EDI_DICT.DictionarySegmentContents dsc
