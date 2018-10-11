
/*
Create Table.FxEDI.EDI_DICT.DictionarySegmentCodes.sql
*/

use FxEDI
go

/*
exec FT.sp_DropForeignKeys

drop table EDI_DICT.DictionarySegmentCodes

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EDI_DICT.DictionarySegmentCodes'), 'IsTable') is null begin

	create table EDI_DICT.DictionarySegmentCodes
	(	DictionaryVersion varchar(25) not null
	,	Code varchar(25) not null
	,	Description varchar(max) null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
create index ix_DSC_1
	on EDI_DICT.DictionarySegmentCodes
		(	DictionaryVersion
		,	Code
		)
	include
		(	Description
		)
go

create index ix_DSC_2
	on EDI_DICT.DictionarySegmentCodes
		(	Code
		,	DictionaryVersion
		)
	include
		(	Description
		)
go

insert
	EDI_DICT.DictionarySegmentCodes
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
	EDI_DICT.DictionarySegmentCodes