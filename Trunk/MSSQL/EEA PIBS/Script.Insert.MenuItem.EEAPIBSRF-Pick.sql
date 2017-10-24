
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Pick.sql
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
	MenuItemName = 'EEAPIBSRF-Pick'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Pick'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Pick'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Pick'
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
	MenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
,	MenuItemName = 'EEAPIBSRF-Pick'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Pick'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Pick'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
,	Sequence = 2
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
		)
