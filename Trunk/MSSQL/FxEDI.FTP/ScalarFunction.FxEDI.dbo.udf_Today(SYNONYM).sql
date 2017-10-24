
/*
Create ScalarFunction.FxEDI.dbo.udf_Today(SYNONYM).sql
*/

use FxEDI
go

if	(select objectpropertyex(object_id('dbo.udf_Today'), 'BaseType')) = 'FN' begin
	drop synonym dbo.udf_Today
end
go

create synonym dbo.udf_Today for FxUtilities.dbo.udf_Today
go

