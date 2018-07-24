
/*
Create ScalarFunction.MONITOR.FXSYS.fnHierarchyIDArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnHierarchyIDArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnHierarchyIDArgument
end
go

create function FXSYS.fnHierarchyIDArgument
(	@Argument hierarchyid
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + @Argument.ToString() + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

