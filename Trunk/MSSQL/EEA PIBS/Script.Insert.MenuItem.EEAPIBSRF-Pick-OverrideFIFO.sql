
/*
Script Script.Insert.MenuItem.EEAPIBSRF-Pick-OverrideFIFO.sql
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
	MenuItemName = 'EEAPIBSRF-Pick-OverrideFIFO'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 5
,	MenuText = 'Pick'
,	MenuIcon = 'Function!'
,	ObjectClass = 'OverrideFIFOView.uxOverride'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EEAPIBSRF-Pick-OverrideFIFO'
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
	MenuID = '85720D29-43D7-4652-8BA5-F0105A8C56A4'
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
			mi.MenuID = '85720D29-43D7-4652-8BA5-F0105A8C56A4'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
,	ChildMenuID = '85720D29-43D7-4652-8BA5-F0105A8C56A4'
,	Sequence = 1
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = '7CA21F11-0C15-4AD5-8DD7-276146F2AA2E'
				and ms.ChildMenuID = '85720D29-43D7-4652-8BA5-F0105A8C56A4'
		)

