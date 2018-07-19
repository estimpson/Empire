
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionaryTransactionSegments.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionaryTransactionSegments

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionaryTransactionSegments'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionaryTransactionSegments
	(	DictionaryVersion varchar(25) not null
	,	TransactionType varchar(25) not null
	,	SegmentOrdinal int not null
	,	SegmentCode varchar(25) not null
	,	Usage char(1) not null
	,	OccurrencesMin int not null
	,	OccurrencesMax int not null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
insert
	FxEDI_EDI_DICT.DictionaryTransactionSegments
(	DictionaryVersion
,	TransactionType
,	SegmentOrdinal
,	SegmentCode
,	Usage
,	OccurrencesMin
,	OccurrencesMax
,	DictionaryRowID
)
select
	dts.DictionaryVersion
,	dts.TransactionType
,	dts.SegmentOrdinal
,	dts.SegmentCode
,	dts.Usage
,	dts.OccurrencesMin
,	dts.OccurrencesMax
,	dts.DictionaryRowID
from
	EEISQL1.FxEDI.EDI_DICT.DictionaryTransactionSegments dts
*/

select
	*
from
	FxEDI_EDI_DICT.DictionaryTransactionSegments dts
