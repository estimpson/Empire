SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create function [dbo].[udf_GetStatusValue]
(
	@ClassName sysname,
	@StatusName varchar (25)
)
RETURNS int
AS
BEGIN
	declare	@Value int
	
	select	@Value = Value
	from	eeh.FT.StatusDefinitions
	where	ClassName = @ClassName and
		StatusName = @StatusName
	
	return	@Value
END
GO
