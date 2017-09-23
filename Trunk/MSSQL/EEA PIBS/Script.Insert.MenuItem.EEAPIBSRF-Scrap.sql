
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Scrap.sql
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
	MenuItemName = 'EEAPIBSRF-Scrap'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Scrap'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Scrap'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Scrap'
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
	MenuID = '5EE304CE-D520-41CF-BDCE-CFAD1A90E3F8'
,	MenuItemName = 'EEAPIBSRF-Scrap'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Scrap'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Scrap'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '5EE304CE-D520-41CF-BDCE-CFAD1A90E3F8'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = '5EE304CE-D520-41CF-BDCE-CFAD1A90E3F8'
,	Sequence = 3
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = '5EE304CE-D520-41CF-BDCE-CFAD1A90E3F8'
		)
