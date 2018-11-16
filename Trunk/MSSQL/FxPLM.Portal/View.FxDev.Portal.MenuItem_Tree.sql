
/*
Create View.FxDev.Portal.MenuItem_Tree.sql
*/

use FxPLM
go

--drop table Portal.MenuItem_Tree
if	objectproperty(object_id('Portal.MenuItem_Tree'), 'IsView') = 1 begin
	drop view Portal.MenuItem_Tree
end
go

create view Portal.MenuItem_Tree
as
with
root
	(	Id
	,	ShortName
	,	Caption
	,	Url
	,	MenuOrder
	,	IsModule
	,	Chain
	,	Level
	)
as
(	select
		Id = mi.RowID
	,	mi.ShortName
	,	mi.Caption
	,	mi.Url
	,	mi.MenuOrder
	,	mi.IsModule
	,	Chain = convert(varchar(max), right('00000' + convert(varchar, row_number() over (order by mi.MenuOrder)), 5) + ':' + mi.ShortName)
	,	Level = 0
	from
		Portal.MenuItems mi
	where
		mi.ParentMenuItemRowID is null
)
,	nested
	(	Id
	,	ShortName
	,	ParentMenuId
	,	ParentMenuName
	,	Caption
	,	Url
	,	MenuOrder
	,	IsModule
	,	Chain
	,	Level
	)
as
(	select
		r.Id
	,	r.ShortName
	,	ParentMenuId = convert(int, null)
	,	ParentMenuName = convert(varchar(100), null)
	,	r.Caption
	,	r.Url
	,	r.MenuOrder
	,	r.IsModule
	,	convert(varchar(max), r.Chain)
	,	r.Level
	from
		root r
	union all
	select
		Id = mi.RowID
	,	mi.ShortName
	,	ParentMenuId = convert(int, n.Id)
	,	ParentMenuName = convert(varchar(100), n.ShortName)
	,	mi.Caption
	,	mi.Url
	,	mi.MenuOrder
	,	mi.IsModule
	,	Chain = convert(varchar(max), n.Chain + '/' + right('00000' + convert(varchar, row_number() over (partition by mi.ParentMenuItemRowID order by mi.MenuOrder)), 5) + ':' + mi.ShortName)
	,	Level = n.Level + 1
	from
		nested n
		join Portal.MenuItems mi
			on n.Id = mi.ParentMenuItemRowID
)
select
	n.Id
,	n.ShortName
,	PartialName = coalesce(right(n.ShortName, len(n.ShortName) - len(n.ParentMenuName) - 1), n.ShortName)
,	n.ParentMenuName
,	n.Caption
,	n.Url
,	n.MenuOrder
,	IsModule = convert(bit, n.IsModule)
,	n.Level
,	HasChildren = convert
		(	bit
		,	case
				when exists
					(	select
							*
						from
							nested n2
						where
							n2.ParentMenuId = n.Id
					) then 1
				else 0
			end
		)
,	Sequence = isnull(convert(int, row_number() over (order by n.Chain)), 0)
from
	nested n
go

select
	mit.Id
,	mit.ShortName
,	mit.PartialName
,	mit.ParentMenuName
,	mit.Caption
,	mit.Url
,	mit.MenuOrder
,	mit.IsModule
,	mit.Level
,	mit.HasChildren
,	mit.Sequence
from
	Portal.MenuItem_Tree mit
order by
	mit.Sequence
