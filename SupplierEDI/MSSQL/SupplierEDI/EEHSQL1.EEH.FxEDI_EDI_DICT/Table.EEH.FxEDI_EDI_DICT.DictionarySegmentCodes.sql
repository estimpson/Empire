
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionarySegmentCodes.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionarySegmentCodes

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionarySegmentCodes'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionarySegmentCodes
	(	DictionaryVersion varchar(25) not null
	,	Code varchar(25) not null
	,	Description varchar(max) null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
create index ix_DSC_1
	on FxEDI_EDI_DICT.DictionarySegmentCodes
		(	DictionaryVersion
		,	Code
		)
	include
		(	Description
		)
go

create index ix_DSC_2
	on FxEDI_EDI_DICT.DictionarySegmentCodes
		(	Code
		,	DictionaryVersion
		)
	include
		(	Description
		)
go

insert
	FxEDI_EDI_DICT.DictionarySegmentCodes
(	DictionaryVersion
,	Code
,	Description
,	DictionaryRowID
)
select
	dsc.DictionaryVersion
,	dsc.Code
,	dsc.Description
,	dsc.DictionaryRowID
from
	EEISQL1.FxEDI.EDI_DICT.DictionarySegmentCodes dsc
*/

select
	*
from
	FxEDI_EDI_DICT.DictionarySegmentCodes