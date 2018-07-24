
/*
Create Table.EEH.FxEDI_EDI_DICT.DictionaryTransactions.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table FxEDI_EDI_DICT.DictionaryTransactions

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('FxEDI_EDI_DICT.DictionaryTransactions'), 'IsTable') is null begin

	create table FxEDI_EDI_DICT.DictionaryTransactions
	(	DictionaryVersion varchar(25) not null
	,	TransactionType varchar(25) not null
	,	TransactionDescription varchar(max) null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
insert
	FxEDI_EDI_DICT.DictionaryTransactions
(	DictionaryVersion
,	TransactionType
,	TransactionDescription
,	DictionaryRowID
)
select
	dt.DictionaryVersion
,	dt.TransactionType
,	dt.TransactionDescription
,	dt.DictionaryRowID
from
	EEISQL1.FxEDI.EDI_DICT.DictionaryTransactions dt
*/

select
	*
from
	FxEDI_EDI_DICT.DictionaryTransactions dt
