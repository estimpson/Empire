SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnNumericArgument]
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
GO
