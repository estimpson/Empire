SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwSchedulerBasePartInventory]
as
select	BasePart = PartBasePart_Crossref.BasePart,
	EEHInventory = isnull (sum (
		case	when Inventory.Plant = 'EEH' and
			Inventory.Status = 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	EEHInventoryOnHold = isnull (sum (
		case	when Inventory.Plant = 'EEH' and
			Inventory.Status != 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	InTransitInventory = isnull (sum (
		case	when Inventory.Plant = 'InTransit' and
			Inventory.Status = 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	InTransitInventoryOnHold = isnull (sum (
		case	when Inventory.Plant = 'InTransit' and
			Inventory.Status != 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	EEIInventory = isnull (sum (
		case	when Inventory.Plant = 'EEI' and
			Inventory.Status = 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	EEIInventoryOnHold = isnull (sum (
		case	when Inventory.Plant = 'EEI' and
			Inventory.Status != 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	ElPasoInventory = isnull (sum (
		case	when Inventory.Plant = 'ELPASO' and
			Inventory.Status = 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	ElPasoInventoryOnHold = isnull (sum (
		case	when Inventory.Plant = 'ELPASO' and
			Inventory.Status != 'A'
				then Inventory.StdQty
			else 0
		end), 0),
	LostInventory = isnull (sum (
		case	when Inventory.Plant = 'LOST'
				then Inventory.StdQty
			else 0
		end), 0)
from	FT.vwPartBasePart_Crossref PartBasePart_Crossref
	left join FT.vwInventory Inventory on PartBasePart_Crossref.PartECN = Inventory.PartECN
group by
	PartBasePart_Crossref.BasePart
GO
