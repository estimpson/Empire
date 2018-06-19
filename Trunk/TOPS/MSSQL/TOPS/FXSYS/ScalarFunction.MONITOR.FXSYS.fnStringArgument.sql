
/*
Create ScalarFunction.MONITOR.FXSYS.fnStringArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnStringArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnStringArgument
end
go

create function FXSYS.fnStringArgument
(	@Argument nvarchar(max)
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + @Argument + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

