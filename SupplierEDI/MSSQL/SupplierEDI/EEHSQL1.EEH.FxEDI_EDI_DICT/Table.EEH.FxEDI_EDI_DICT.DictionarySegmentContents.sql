
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionarySegmentContents.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionarySegmentContents

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionarySegmentContents'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionarySegmentContents
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
	FxEDI_EDI_DICT.DictionarySegmentContents
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
	FxEDI_EDI_DICT.DictionarySegmentContents dsc
