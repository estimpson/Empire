
/*
Script Script.Insert.MenuItem.Shipping-ContainerManagement.sql
*/

--use Fx
--go

/*
delete
	mi
from
	FT.MenuItems mi
where
	MenuItemName = 'Shipping/ContainerManagement'

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
	MenuItemName = 'Shipping/ContainerManagement'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 1
,	MenuText = 'Container Management'
,	MenuIcon = 'Container-32.bmp'
,	ObjectClass = 'w_shipping_cntnrmng'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'Shipping/ContainerManagement'
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
	MenuID = '2FE51D35-E242-4704-AA7C-124B68FA7A9C'
,	MenuItemName = 'Shipping/ContainerManagement'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 1
,	MenuText = 'Container Management'
,	MenuIcon = 'Container-32.bmp'
,	ObjectClass = 'w_shipping_cntnrmng'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = '2FE51D35-E242-4704-AA7C-124B68FA7A9C'
	)

select
	*
from
	FT.MenuItems mi
where
	mi.MenuID = '2FE51D35-E242-4704-AA7C-124B68FA7A9C'

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'BFBFECE7-1080-4676-BD6F-04BC4D6224B1'
,	ChildMenuID = '2FE51D35-E242-4704-AA7C-124B68FA7A9C'
,	Sequence = 12
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'BFBFECE7-1080-4676-BD6F-04BC4D6224B1'
				and ms.ChildMenuID = '2FE51D35-E242-4704-AA7C-124B68FA7A9C'
		)