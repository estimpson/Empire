SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnGUIDArgument]
(	@Argument uniqueidentifier
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + convert(nchar(36), @Argument) + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
GO
