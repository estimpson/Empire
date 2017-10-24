
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Combine.sql
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
	MenuItemName = 'EEAPIBSRF-Combine'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Combine'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Combine'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Combine'
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
	MenuID = 'D66FE5EC-A528-4E5C-BE75-CA6A6387C4CA'
,	MenuItemName = 'EEAPIBSRF-Combine'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Combine'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Combine'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = 'D66FE5EC-A528-4E5C-BE75-CA6A6387C4CA'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = 'D66FE5EC-A528-4E5C-BE75-CA6A6387C4CA'
,	Sequence = 7
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = 'D66FE5EC-A528-4E5C-BE75-CA6A6387C4CA'
		)

select
	*
from
	FT.MenuStructure ms
where
	ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'