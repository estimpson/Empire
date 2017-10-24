
/*
Script Script.Insert.MenuItem.EditEmpowerPOs.sql
*/

--use MONITOR
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
	MenuItemName = 'EditEmpowerPOs'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 1
,	MenuText = 'Edit Empower POs'
,	MenuIcon = 'empcube.ico'
,	ObjectClass = 'w_emp_editpos'

select
	*
from
	FT.MenuItems mi
where
	MenuItemName = 'EditEmpowerPOs'
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
	MenuID = 'DE0A2882-D2B2-4984-BECA-14D30F10D9F4'
,	MenuItemName = 'EditEmpowerPOs'
,	ItemOwner = 'sys'
,	Status = 0
,	Type = 1
,	MenuText = 'Edit Empower POs'
,	MenuIcon = 'empcube.ico'
,	ObjectClass = 'w_emp_editpos'
where
	not exists
	(	select
			*
		from
			FT.MenuItems mi
		where
			mi.MenuID = 'DE0A2882-D2B2-4984-BECA-14D30F10D9F4'
	)

insert
	FT.MenuStructure
(	ParentMenuID
,	ChildMenuID
,	Sequence
)
select
	ParentMenuID = 'FE9037B1-24C7-424E-AF37-EAA1FCECBB99'
,	ChildMenuID = 'DE0A2882-D2B2-4984-BECA-14D30F10D9F4'
,	Sequence = coalesce
		(	(	select
					max(ms.Sequence) + 1
				from
					FT.MenuStructure ms
				where
					ms.ParentMenuID = 'FE9037B1-24C7-424E-AF37-EAA1FCECBB99'
			)
		,	1
		)
where
	not exists
		(	select
				*
			from
				FT.MenuStructure ms
			where
				ms.ParentMenuID = 'FE9037B1-24C7-424E-AF37-EAA1FCECBB99'
				and ms.ChildMenuID = 'DE0A2882-D2B2-4984-BECA-14D30F10D9F4'
		)