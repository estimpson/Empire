/*
Use this migration script to make data changes only. You must commit any additive schema changes first.
Schema changes and migration scripts are deployed in the order they're committed.

Migration scripts must not reference static data. When you deploy migration scripts alongside static data 
changes, the migration scripts will run first. This can cause the deployment to fail. 
Read more at https://documentation.red-gate.com/display/SOC6/Static+data+and+migrations.
*/


begin transaction
go

/*	FxPLM.Notes.Notes table migrations. */
if	(select columnproperty(object_id('Notes.Notes'), 'NoteGUID', 'ColumnId')) is null begin
	exec FT.sp_DropForeignKeys
	
	exec sp_rename 'FxPLM.Notes.Notes', 'NotesTemp'

	create table Notes.Notes
	(	Status int not null default(0)
	,	Type int not null default(0)
	,	Author int not null references PM.Employees(RowID)
	,	SubjectLine varchar(max) null
	--,	Body varbinary(max) null
	--,	ThumbnailImage varbinary(max) null
	,	Body varchar(max) null
	,	ReferencedURI varchar(max) null
	,	Category int null references Notes.NoteCategories(RowID)
	,	ImportanceFlag int null check(ImportanceFlag between 0 and 3)
	,	PrivacyFlag int null check(PrivacyFlag between 0 and 1)
	,	EntityGUID uniqueidentifier not null references Notes.Entities(EntityGUID)
	,	Hierarchy hierarchyid not null
	,	NoteGUID uniqueidentifier not null default(newid())
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique
		(	Hierarchy
		)
	)

	set identity_insert Notes.Notes on

	insert
		Notes.Notes
	(	Status
	,	Type
	,	Author
	,	SubjectLine
	,	Body
	,	ReferencedURI
	,	Category
	,	ImportanceFlag
	,	PrivacyFlag
	,	EntityGUID
	,	Hierarchy
	,	RowID
	,	RowCreateDT
	,	RowCreateUser
	,	RowModifiedDT
	,	RowModifiedUser
	)
	select
		n.Status
	,	n.Type
	,	n.Author
	,	n.SubjectLine
	,	n.Body
	,	n.ReferencedURI
	,	n.Category
	,	n.ImportanceFlag
	,	n.PrivacyFlag
	,	n.EntityGUID
	,	n.Hierarchy
	,	n.RowID
	,	n.RowCreateDT
	,	n.RowCreateUser
	,	n.RowModifiedDT
	,	n.RowModifiedUser
	from
		Notes.NotesTemp n

	set identity_insert Notes.Notes off

	exec FT.sp_AddForeignKeys

	drop table Notes.NotesTemp

	select
		*
	from
		Notes.Notes
end

/*	Commit or rollback */
go

commit

