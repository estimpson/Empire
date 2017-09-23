
/*
Create ScalarFunction.FxUtilities.dbo.udf_Today.sql
*/

use FxUtilities
go

if	objectproperty(object_id('dbo.udf_Today'), 'IsScalarFunction') = 1 begin
	drop function dbo.udf_Today
end
go

create function dbo.udf_Today
()
returns	datetime
as
begin
	declare	@ResultDT datetime

	select	@ResultDT = DateAdd ( day, DateDiff ( day, '2001-01-01', getdate() ), '2001-01-01' )

	return	@ResultDT
end

GO

