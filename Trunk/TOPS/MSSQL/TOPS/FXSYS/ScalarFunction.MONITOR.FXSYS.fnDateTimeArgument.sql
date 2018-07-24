
/*
Create ScalarFunction.MONITOR.FXSYS.fnDateTimeArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnDateTimeArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnDateTimeArgument
end
go

create function FXSYS.fnDateTimeArgument
(	@Argument datetime
)
returns nvarchar(23)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + convert(nchar(23), @Argument, 121) + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

