SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create function [dbo].[udf_IsStatus]
(
	@ClassName sysname,
	@StatusName varchar (25),
	@Status int
)
RETURNS bit
AS
BEGIN
	declare	@Mask int,
		@Value int,
		@Result bit
	
	select	@Mask = Mask,
		@Value = Value
	from	eeh.FT.StatusDefinitions
	where	ClassName = @ClassName and
		StatusName = @StatusName
	
	set	@Result = case when @Status & @Mask = @Value then 1 else 0 end
	
	return	@Result
END
GO
