SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXSYS].[fnIntArgument]
(	@Argument bigint
)
returns nvarchar(max)
as
begin
	--- <Body>
	/*	Enclose value in single quotes. */
	declare
		@Output nvarchar(max) = coalesce(convert(varchar(24), @Argument), 'null')
	--- </Body>

	---	<Return>
	return
		@Output
end
GO
