
/*
Create Table.FxEDI.EDI_DICT.DictionaryElementValueCodes.sql
*/

use FxEDI
go

/*
exec FT.sp_DropForeignKeys

drop table EDI_DICT.DictionaryElementValueCodes

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EDI_DICT.DictionaryElementValueCodes'), 'IsTable') is null begin

	create table EDI_DICT.DictionaryElementValueCodes
	(	DictionaryVersion varchar(25) not null
	,	ElementCode char(4) not null
	,	ValueCode varchar(25) not null
	,	Description varchar(max) null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
create index ix_DEVC_1
	on EDI_DICT.DictionaryElementValueCodes
	(	DictionaryVersion
	,	ElementCode
	,	ValueCode
	)
	include (Description)
go

create index ix_DEVC_2
	on EDI_DICT.DictionaryElementValueCodes
	(	ElementCode
	,	ValueCode
	,	DictionaryVersion
	)
	include (Description)
go

insert
	EDI_DICT.DictionaryElementValueCodes
(	DictionaryVersion
,	ElementCode
,	ValueCode
,	Description
,	DictionaryRowID
)
select
	devc.DictionaryVersion
  ,	devc.ElementCode
  ,	devc.ValueCode
  ,	devc.Description
  ,	devc.DictionaryRowID
from
	EEISQL1.FxEDI.EDI_DICT.DictionaryElementValueCodes devc
*/

select
	*
from
	EDI_DICT.DictionaryElementValueCodes devc
