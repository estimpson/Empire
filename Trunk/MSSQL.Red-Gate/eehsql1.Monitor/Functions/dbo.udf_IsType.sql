SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create function [dbo].[udf_IsType]
(
	@ClassName sysname,
	@TypeName varchar (25),
	@Type int
)
RETURNS bit
AS
BEGIN
	declare	@Mask int,
		@Value int,
		@Result bit
	
	select	@Mask = Mask,
		@Value = Value
	from	eeh.FT.TypeDefinitions
	where	ClassName = @ClassName and
		TypeName = @TypeName
	
	set	@Result = case when @Type & @Mask = @Value then 1 else 0 end
	
	return	@Result
END
GO
