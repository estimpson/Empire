
/*
Create TableFunction.FxEDI.dbo.udf_StringStack_Pop(SYNONYM).sql
*/

use FxEDI
go

if	(select object_id('dbo.udf_StringStack_Pop')) is not null begin
	drop synonym dbo.udf_StringStack_Pop
end
go

create synonym dbo.udf_StringStack_Pop for FxUtilities.dbo.StringStack_Pop
go

