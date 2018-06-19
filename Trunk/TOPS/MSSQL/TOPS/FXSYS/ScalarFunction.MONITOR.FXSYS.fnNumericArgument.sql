
/*
Create ScalarFunction.MONITOR.FXSYS.fnNumericArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnNumericArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnNumericArgument
end
go

create function FXSYS.fnNumericArgument
(	@Argument numeric(30,12)
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose convert numeric value to string. */
	declare
		@Output nvarchar(max) = coalesce(convert(varchar(31), @Argument), 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

