
/*
Create ScalarFunction.FxEDI.dbo.udf_StringStack_Pop.sql
*/

use FxEDI
go

if	objectproperty(object_id('dbo.udf_StringStack_Pop'), 'IsScalarFunction') = 1 begin
	drop function dbo.udf_StringStack_Pop
end
go

create function dbo.udf_StringStack_Pop
(	@Stack varchar(max)
,	@Separator varchar(max)
)
returns @StringStack_Pop table
(	Stack varchar(max)
,	Value varchar(max)
)
as
begin
--- <Body>
	declare
		@reverseStack varchar(max) = reverse(@Stack)

	declare
		@separatorPos int = charindex(reverse(@Separator), @reverseStack)

	if	@separatorPos = 0 begin
		
		insert
			@StringStack_Pop
			(	Stack
			,	Value
			)
			values
			(	''
			,	@Stack
			)
	end else begin

		insert
			@StringStack_Pop
			(	Stack
			,	Value
			)
			values
			(	left(@Stack, len(@Stack) - len(@Separator) - @separatorPos + 1)
			,	right(@Stack, @separatorPos - 1)
			) 
	end

--- </Body>

---	<Return>
	return
end
go

