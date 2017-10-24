
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Prod.sql
*/

--use Fx
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
	MenuItemName = 'EEAPIBSRF-Prod'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Prod'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.prod'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Prod'
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
	MenuID = '88C0E4FA-AEDB-4E63-A3C2-90E1A18F0025'
,	MenuItemName = 'EEAPIBSRF-Prod'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Prod'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.prod'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '88C0E4FA-AEDB-4E63-A3C2-90E1A18F0025'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = '88C0E4FA-AEDB-4E63-A3C2-90E1A18F0025'
,	Sequence = 1
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = '88C0E4FA-AEDB-4E63-A3C2-90E1A18F0025'
		)