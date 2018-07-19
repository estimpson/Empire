USE EEH
go

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

/****** Object:  UserDefinedFunction [FXSYS].[fnGUIDArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  UserDefinedFunction [FXSYS].[fnHierarchyIDArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  UserDefinedFunction [FXSYS].[fnIntArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  UserDefinedFunction [FXSYS].[fnNumericArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  UserDefinedFunction [FXSYS].[fnStringArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  UserDefinedFunction [FXSYS].[fnXMLArgument]    Script Date: 6/20/2018 2:36:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

