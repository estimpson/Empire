SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnStringArgument]
(	@Argument nvarchar(max)
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + @Argument + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
GO
