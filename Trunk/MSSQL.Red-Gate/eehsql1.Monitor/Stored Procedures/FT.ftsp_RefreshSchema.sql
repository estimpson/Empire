SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_RefreshSchema]
AS
SET LOCK_TIMEOUT 5000

DECLARE	@SingleUser NVARCHAR(1000),
	@MultiUser NVARCHAR(1000)

SET	@SingleUser = 'ALTER DATABASE ' + db_name () + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
SET	@MultiUser = 'ALTER DATABASE ' + db_name () + ' SET MULTI_USER'

execute	sp_executesql
	@SingleUser

declare	@ProcReturn INT,
	@ObjectName sysname,
	@DropView nvarchar (1000),
	@ViewDefn nvarchar (1000)

declare	viewdefinitions cursor local for
select	ObjectName = '[' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + ']',
	DropView = 'if	Object_ID (''[' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + ']'') is not null drop view [' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + ']',
	ViewDefn = 'create view [' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + '] as
select	*
from	EEH.[' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + '] with (READUNCOMMITTED)'
from	EEH..sysobjects sysobjects
	join EEH..sysusers sysusers
                on sysobjects.UID = sysusers.UID
where	sysobjects.Type in ('v','u') and
	sysusers.Name not like '%\%' and
	sysobjects.Name not like 'SYS%' AND
	'[' + convert (varchar (1000), SYSUSERS.Name) + '].[' + convert (varchar (1000), SYSOBJECTS.Name) + ']' NOT IN
	(	SELECT	ObjectName
		FROM	FT.InvalidDefinitions)

open	viewdefinitions

fetch	viewdefinitions
into	@ObjectName,
	@DropView,
	@ViewDefn

while	@@fetch_status = 0 begin

	execute	sp_executesql
		@DropView

	execute	@ProcReturn = sp_executesql
		@ViewDefn
		
	IF	@ProcReturn != 0 BEGIN
		INSERT	FT.InvalidDefinitions
		(	ObjectName)
		SELECT	@ObjectName
	END

	fetch	viewdefinitions
	into	@ObjectName,
		@DropView,
		@ViewDefn
end

execute	sp_executesql
	@MultiUser
GO
