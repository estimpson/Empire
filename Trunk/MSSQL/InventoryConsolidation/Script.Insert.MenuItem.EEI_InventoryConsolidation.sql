
/*
Script Script.Insert.MenuItem.EEI_InventoryConsolidation.sql
*/

--use Monitor
--go

/*
insert
	FT.MenuItems
(	MenuItemName
,	ItemOwner
,	Status
,	Type
,	MenuText
,	MenuIcon
,	ObjectClass
)
select
	MenuItemName = 'EEI_InventoryConsolidation'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 3
,	MenuText = 'Inventory Consolidation'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'Consolidation.exe'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEI_InventoryConsolidation'
*/
insert
	FT.MenuItems
(	MenuID
,	MenuItemName
,	ItemOwner
,	Status
,	Type
,	MenuText
,	MenuIcon
,	ObjectClass
)
select
	MenuID = '9F6A5E25-15FA-42F8-A2CE-226B894DBF72'
,	MenuItemName = 'EEI_InventoryConsolidation'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 3
,	MenuText = 'Inventory Consolidation'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'Consolidation.exe'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '9F6A5E25-15FA-42F8-A2CE-226B894DBF72'
	)
