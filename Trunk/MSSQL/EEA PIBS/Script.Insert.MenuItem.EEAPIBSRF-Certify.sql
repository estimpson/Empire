
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Certify.sql
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
	MenuItemName = 'EEAPIBSRF-Certify'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Certify'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Certify'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Certify'
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
	MenuID = 'ADBEF461-8D5F-41E7-9127-38F4CE6AE4E2'
,	MenuItemName = 'EEAPIBSRF-Certify'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Certify'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Certify'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = 'ADBEF461-8D5F-41E7-9127-38F4CE6AE4E2'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = 'ADBEF461-8D5F-41E7-9127-38F4CE6AE4E2'
,	Sequence = 5
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = 'ADBEF461-8D5F-41E7-9127-38F4CE6AE4E2'
		)
