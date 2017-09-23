
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Quality.sql
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
	MenuItemName = 'EEAPIBSRF-Quality'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Quality'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Quality'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Quality'
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
	MenuID = 'A9570569-4A2C-494D-9AB8-27158F56B765'
,	MenuItemName = 'EEAPIBSRF-Quality'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Quality'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Quality'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = 'A9570569-4A2C-494D-9AB8-27158F56B765'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = 'A9570569-4A2C-494D-9AB8-27158F56B765'
,	Sequence = 6
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = 'A9570569-4A2C-494D-9AB8-27158F56B765'
		)

select
	*
from
	FT.MenuStructure ms
where
	ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'