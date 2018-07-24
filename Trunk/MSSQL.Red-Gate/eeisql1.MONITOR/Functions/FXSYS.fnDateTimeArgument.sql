SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnDateTimeArgument]
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
GO
