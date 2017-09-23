
/*
Script Script.Insert.MenuItem.InventoryConsolidation-Begin.sql
*/

--use Monitor
--go

/*
delete
	mi
from
	FT.MenuItems mi
where
	mi.MenuID = '26CF4B27-DC7F-4A79-AE80-3A1362911DE5'
	
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
	MenuItemName = 'InventoryConsolidation-Begin'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Begin'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'Consolidation.BeginConsolidation, Consolidation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'InventoryConsolidation-Begin'
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
	MenuID = '26CF4B27-DC7F-4A79-AE80-3A1362911DE5'
,	MenuItemName = 'InventoryConsolidation-Begin'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Begin'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'Consolidation.BeginConsolidation, Consolidation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '26CF4B27-DC7F-4A79-AE80-3A1362911DE5'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = '9F6A5E25-15FA-42F8-A2CE-226B894DBF72'
,	ChildMenuID = '26CF4B27-DC7F-4A79-AE80-3A1362911DE5'
,	Sequence = 1
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = '9F6A5E25-15FA-42F8-A2CE-226B894DBF72'
				and ms.ChildMenuID = '26CF4B27-DC7F-4A79-AE80-3A1362911DE5'
		)