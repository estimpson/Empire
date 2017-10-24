SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Andre Boulanger>
-- Create date: <2015-02-18>
-- Description:	<Returns Std. pack for part using count of pack quantities in object table>
-- =============================================
Create FUNCTION [FT].[fn_InventoryStdPack_PickList]
(
	
	@PartNumber VARCHAR(25)
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Stdpack INT,
			@PartStdPack INT

	-- Add the T-SQL statements to compute the return value here
	SELECT @Stdpack=quantity 
	FROM object WHERE part = @PartNumber
	GROUP BY part, quantity
	HAVING COUNT(1) =(

	SELECT MAX(Countofpacks)
	FROM(
	SELECT 
	COUNT(1) AS Countofpacks, 
	part, 
	quantity 
	FROM object WHERE part = @PartNumber
	GROUP BY part, quantity
) AS packCounts
)
	SELECT @PartStdPack = Nullif(standard_pack,1) FROM dbo.part_inventory WHERE part = @PartNumber
	-- Return the result of the function
	RETURN COALESCE(@PartStdPack, @Stdpack)

END


GO
