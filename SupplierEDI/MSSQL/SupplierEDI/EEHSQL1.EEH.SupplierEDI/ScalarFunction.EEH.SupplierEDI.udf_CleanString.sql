
/*
Create ScalarFunction.EEH.SupplierEDI.udf_CleanString.sql
*/

use EEH
go

if	objectproperty(object_id('SupplierEDI.udf_CleanString'), 'IsScalarFunction') = 1 begin
	drop function SupplierEDI.udf_CleanString
end
go

create function SupplierEDI.udf_CleanString
(	@dirtyString varchar(max)
)
returns varchar(max)
with encryption
as
begin
--- <Body>
	declare
		@dirtyPattern varchar(100) = '%[^ ,.0-9A-Z]%'
	,	@strLen int = len(@dirtyString)

	while
		@dirtyString like @dirtyPattern begin

		set @dirtyString = substring(@dirtyString, 1, patindex(@dirtyPattern, @dirtyString)-1) + substring(@dirtyString, patindex(@dirtyPattern, @dirtyString) + 1, @strLen)
	end
--- </Body>

---	<Return>
	return
		@dirtyString
end
go

select
	p.part
,	left(SupplierEDI.udf_CleanString(p.name), 78)
,	p.name
,	patindex('%[^ ,.0-9A-Z]%', p.name)
from
	dbo.part p
where
	p.name like '%[^ ,.0-9A-Z]%'