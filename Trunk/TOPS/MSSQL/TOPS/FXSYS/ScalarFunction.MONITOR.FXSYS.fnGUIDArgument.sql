
/*
Create ScalarFunction.MONITOR.FXSYS.fnGUIDArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnGUIDArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnGUIDArgument
end
go

create function FXSYS.fnGUIDArgument
(	@Argument uniqueidentifier
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + convert(nchar(36), @Argument) + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

