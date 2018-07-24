
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionaryElementValueCodes.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionaryElementValueCodes

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionaryElementValueCodes'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionaryElementValueCodes
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
	on FxEDI_EDI_DICT.DictionaryElementValueCodes
	(	DictionaryVersion
	,	ElementCode
	,	ValueCode
	)
	include (Description)
go

create index ix_DEVC_2
	on FxEDI_EDI_DICT.DictionaryElementValueCodes
	(	ElementCode
	,	ValueCode
	,	DictionaryVersion
	)
	include (Description)
go

insert
	FxEDI_EDI_DICT.DictionaryElementValueCodes
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
	FxEDI_EDI_DICT.DictionaryElementValueCodes devc
