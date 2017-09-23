
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Final.sql
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
	MenuItemName = 'EEAPIBSRF-Final'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Final'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Final'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Final'
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
	MenuID = '0050F10D-6E19-46B5-828E-2B9B951E88D8'
,	MenuItemName = 'EEAPIBSRF-Final'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'Final'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'formEEAPIBS.Final'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '0050F10D-6E19-46B5-828E-2B9B951E88D8'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	ChildMenuID = '0050F10D-6E19-46B5-828E-2B9B951E88D8'
,	Sequence = 4
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
				and ms.ChildMenuID = '0050F10D-6E19-46B5-828E-2B9B951E88D8'
		)
