
/*
Create ScalarFunction.MONITOR.FXSYS.fnXMLArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnXMLArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnXMLArgument
end
go

create function FXSYS.fnXMLArgument
(	@Argument xml
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + convert(nvarchar(max), @Argument) + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

