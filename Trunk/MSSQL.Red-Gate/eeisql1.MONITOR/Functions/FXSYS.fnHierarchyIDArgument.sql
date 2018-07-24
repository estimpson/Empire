SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnHierarchyIDArgument]
(	@Argument hierarchyid
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce('''' + @Argument.ToString() + '''', 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
GO
