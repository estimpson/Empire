SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RFPhysInv_PhysicalProgress_ByAddress]
(	@Aisle char(1) = null,
	@Shelf int = null,
	@Subshelf int = null)
as
/*
execute	FT.ftsp_RFPhysInv_PhysicalProgress_ByAddress
	@Aisle = 'C',
	@Shelf = 1,
	@Subshelf = null
*/
select	Aisle = min (WarehouseInventory.Aisle),
	Shelf = min (WarehouseInventory.Shelf),
	Subshelf = min (WarehouseInventory.Subshelf),
	WarehouseInventory.Address,
	WarehouseInventory.Part,
	FoundCount = Count (case when WarehouseInventory.Type = 'INV' then 1 end),
	FoundQuantity = Sum (case when WarehouseInventory.Type = 'INV' then WarehouseInventory.Quantity end),
	MissingCount = Count (case when WarehouseInventory.Type = 'PHYS' then 1 end),
	MissingQuantity = isnull (Sum (case when WarehouseInventory.Type = 'PHYS' then WarehouseInventory.Quantity end), 0)
from	FT.WarehouseInventory WarehouseInventory
	join FT.WarehouseLocations WarehouseLocations on WarehouseInventory.Address = WarehouseLocations.Address
where	WarehouseInventory.Aisle = isnull (@Aisle, WarehouseInventory.Aisle) and
	WarehouseInventory.Shelf = isnull (@Shelf, WarehouseInventory.Shelf) and
	WarehouseInventory.Subshelf = isnull (@Subshelf, WarehouseInventory.Subshelf)
group by
	WarehouseInventory.Subshelf,
	WarehouseInventory.Address,
	WarehouseInventory.Part
order by
	1, 2, 3
GO
