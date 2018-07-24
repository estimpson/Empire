SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnXMLArgument]
(	@Argument xml
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + convert(nvarchar(max), @Argument) + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
GO
