
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionaryElements.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionaryElements

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionaryElements'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionaryElements
	(	DictionaryVersion varchar(25) null
	,	ElementCode varchar(25) null
	,	ElementName varchar(max) null
	,	ElementDataType varchar(3) null
	,	ElementLengthMin int null
	,	ElementLengthMax int null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
create nonclustered index ix_DE_1
	on FxEDI_EDI_DICT.DictionaryElements
	(	DictionaryVersion
	,	ElementCode
	)
	include
	(	ElementName
	,	ElementDataType
	)
go

create nonclustered index ix_DE_2
	on FxEDI_EDI_DICT.DictionaryElements
	(	ElementCode
	,	DictionaryVersion
	)
	include
	(	ElementName
	,	ElementDataType
	)
go

insert
	FxEDI_EDI_DICT.DictionaryElements
(	DictionaryVersion
,	ElementCode
,	ElementName
,	ElementDataType
,	ElementLengthMin
,	ElementLengthMax
,	DictionaryRowID
)
select
	de.DictionaryVersion
,	de.ElementCode
,	de.ElementName
,	de.ElementDataType
,	de.ElementLengthMin
,	de.ElementLengthMax
,	de.DictionaryRowID
from
	EEISQL1.FxEDI.EDI_DICT.DictionaryElements de
*/

select
	*
from
	FxEDI_EDI_DICT.DictionaryElements de
