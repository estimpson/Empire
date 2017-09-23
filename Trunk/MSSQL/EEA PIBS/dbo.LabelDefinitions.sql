/*
begin transaction
go

exec sp_rename 'dbo.LabelDefinitions', 'LabelDefinitions_bk'

*/

--drop table dbo.LabelDefinitions
if	object_id ('dbo.LabelDefinitions') is null begin

	create table dbo.LabelDefinitions
	(	LabelName sysname
	,	PrinterType sysname
	,	ProcedureName sysname null
	,	ProcedureArguments text null
	,	LabelCode text null
	,	primary key
		(	LabelName
		,	PrinterType
		)
	)
end
go

/*
insert
	dbo.LabelDefinitions
(
	LabelName
,	PrinterType
,	LabelCode
)
select
	LabelName
,	PrinterType
,	LabelCode
from
	dbo.LabelDefinitions_bk ld
go

drop table dbo.LabelDefinitions_bk
go

select
	*
from
	dbo.LabelDefinitions ld
go

--commit
rollback
go
*/
