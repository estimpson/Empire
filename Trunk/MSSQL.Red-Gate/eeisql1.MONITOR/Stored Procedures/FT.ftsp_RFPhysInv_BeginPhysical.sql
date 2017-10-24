SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RFPhysInv_BeginPhysical]
(	@Operator varchar (10),
	@Aisle char(1) = null,
	@Shelf int = null,
	@Subshelf int = null,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = FT.ftsp_RFPhysInv_BeginPhysical
	@Operator = 'MON',
	@Aisle = 'C',
	@Shelf = 1,
	@Subshelf = null,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	Aisle = min (WarehouseInventory.Aisle),
	Shelf = min (WarehouseInventory.Shelf),
	Subshelf = min (WarehouseInventory.Subshelf),
	WarehouseInventory.Address,
	WarehouseInventory.Part,
	InvCount = Count (case when WarehouseInventory.Type = 'INV' then 1 end),
	InvQuantity = Sum (case when WarehouseInventory.Type = 'INV' then WarehouseInventory.Quantity end),
	LostCount = Count (case when WarehouseInventory.Type = 'LOST' then 1 end),
	LostQuantity = isnull (Sum (case when WarehouseInventory.Type = 'LOST' then WarehouseInventory.Quantity end), 0),
	WIPCount = Count (case when WarehouseInventory.Type = 'WIP' then 1 end),
	WIPQuantity = isnull (Sum (case when WarehouseInventory.Type = 'WIP' then WarehouseInventory.Quantity end), 0)
from	FT.WarehouseInventory WarehouseInventory
	join FT.WarehouseLocations WarehouseLocations on WarehouseInventory.Address = WarehouseLocations.Address
group by
	WarehouseInventory.Subshelf,
	WarehouseInventory.Address,
	WarehouseInventory.Part
order by
	1, 2, 3

select	*
from	audit_trail
where	type = 'G'

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=No>
if	@@TranCount = 0 begin
	set	@Result = 900001
	RAISERROR (@Result, 16, 1, 'BeginPhysical')
	return	@Result
end
save tran BeginPhysical 
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	I.	Update the Warehouse Inventory.
update	FT.WarehouseInventory
set	Operator = @Operator,
	LocationCode =
	(	select	min (WL.PhysicalWIPLocationCode)
		from	FT.WarehouseLocations WL
		where	WL.Address = FT.WarehouseInventory.Address)
where	FT.WarehouseInventory.Aisle = isnull (nullif (@Aisle, ''), FT.WarehouseInventory.Aisle) and
	FT.WarehouseInventory.Shelf = isnull (nullif (@Shelf, 0), FT.WarehouseInventory.Shelf) and
	FT.WarehouseInventory.Subshelf = isnull (nullif (@Subshelf, 0), FT.WarehouseInventory.Subshelf)

set	@Error = @@Error
if @Error != 0 begin
	set	@Result = 201
	rollback tran BeginPhysical
	return	@Result
end

--	III.	Staged.
set	@Result = 0
return	@Result
GO
