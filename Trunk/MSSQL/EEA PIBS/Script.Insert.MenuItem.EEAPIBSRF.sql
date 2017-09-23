
/*
Script Script.Insert.MenuItem.EEAPIBSRF.sql
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
	MenuItemName = 'EEAPIBSRF'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 4
,	MenuText = 'EEAPIBS'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'EEAPIBS_RF.exe'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF'
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
	MenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
,	MenuItemName = 'EEAPIBSRF'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 1
,	MenuText = 'EEAPIBS'
,	MenuIcon = 'rf.ico'
,	ObjectClass = 'EEAPIBS_RF.exe'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = 'F351C513-8636-4FE8-90B3-65BEB2C21791'
	)
