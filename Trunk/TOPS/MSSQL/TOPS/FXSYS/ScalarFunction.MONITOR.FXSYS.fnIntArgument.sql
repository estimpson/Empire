
/*
Create ScalarFunction.MONITOR.FXSYS.fnIntArgument.sql
*/

use MONITOR
go

if	objectproperty(object_id('FXSYS.fnIntArgument'), 'IsScalarFunction') = 1 begin
	drop function FXSYS.fnIntArgument
end
go

create function FXSYS.fnIntArgument
(	@Argument bigint
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce(convert(varchar(24), @Argument), 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
go

