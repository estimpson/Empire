SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create function [dbo].[udf_GetTypeValue]
(
	@ClassName sysname,
	@TypeName varchar (25)
)
RETURNS int
AS
BEGIN
	declare	@Value int
	
	select	@Value = Value
	from	eeh.FT.TypeDefinitions
	where	ClassName = @ClassName and
		TypeName = @TypeName
	
	return	@Value
END
GO
