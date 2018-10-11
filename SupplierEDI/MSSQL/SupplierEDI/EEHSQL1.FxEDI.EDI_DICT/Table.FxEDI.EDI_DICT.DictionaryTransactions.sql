
/*
Create Table.FxEDI.EDI_DICT.DictionaryTransactions.sql
*/

use FxEDI
go

/*
exec FT.sp_DropForeignKeys

drop table EDI_DICT.DictionaryTransactions

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EDI_DICT.DictionaryTransactions'), 'IsTable') is null begin

	create table EDI_DICT.DictionaryTransactions
	(	DictionaryVersion varchar(25) not null
	,	TransactionType varchar(25) not null
	,	TransactionDescription varchar(max) null
	,	DictionaryRowID int not null primary key
	)
end
go

/*
insert
	EDI_DICT.DictionaryTransactions
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
	EDI_DICT.DictionaryTransactions dt
