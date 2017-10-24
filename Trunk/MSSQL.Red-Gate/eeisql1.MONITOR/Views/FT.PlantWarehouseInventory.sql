SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[PlantWarehouseInventory]
as
select
	Plant = l.plant
,	Rack = substring(l.code, 1, 1)
,	Shelf = convert(varchar, convert (int, substring(l.code, 3, 1)))
,	Position = convert(varchar, convert (int, substring(l.code, 5, 2)))
,	Address = convert(varchar(10), o.location)
,	LocationCode = o.location
,	Serial = o.serial
,	Part = o.part
,	Quantity = o.quantity
,	Type = 'INV'
,	Operator = o.operator
from
	dbo.object o
	join dbo.location l
		on l.code = o.location
where
	l.plant = 'EEI'
	and
	(	l.code like '[A-Z]-[1234]-[0-9]'
		or l.code like '[A-Z]-[1234]-[0-9][0-9]'
	)
union all
select
	Plant = l.plant
,	Rack = substring(l.code, 1, 1)
,	Shelf = convert(varchar, convert (int, substring(l.code, 3, 1)))
,	Position = convert(varchar, convert (int, substring(l.code, 5, 1)))
,	Address = substring(o.location, 1, 5)
,	LocationCode = o.location
,	Serial = o.serial
,	Part = o.part
,	Quantity = o.quantity
,	Type = substring(o.location, 7, 4)
,	Operator = o.operator
from
	dbo.object o
	join dbo.location l
		on l.code = o.location
where
	l.plant = 'EEI'
	and
	(	l.code like '[A-Z]-[1234]-[0-9]-FIS'
		or l.code like '[A-Z]-[1234]-[0-9]-LST'
	)
union all
select
	Plant = l.plant
,	Rack = substring(l.code, 1, 1)
,	Shelf = convert(varchar, convert (int, substring(l.code, 3, 1)))
,	Position = convert(varchar, convert (int, substring(l.code, 5, 2)))
,	Address = substring(o.location, 1, 6)
,	LocationCode = o.location
,	Serial = o.serial
,	Part = o.part
,	Quantity = o.quantity
,	Type = substring(o.location, 8, 4)
,	Operator = o.operator
from
	dbo.object o
	join dbo.location l
		on l.code = o.location
where
	l.plant = 'EEI'
	and
	(	l.code like '[A-Z]-[1234]-[0-9][0-9]-FIS'
		or l.code like '[A-Z]-[1234]-[0-9][0-9]-LST'
	)
union all
select
	Plant = l.plant
,	Rack = substring(l.code, 3, 1)
,	Shelf = substring(l.code, 8, 1)
,	Position = substring(l.code, 5, 2) + '-' + substring(l.code, 10, 1)
,	Address = o.location
,	LocationCode = o.location
,	Serial = o.serial
,	Part = o.part
,	Quantity = o.quantity
,	Type = 'INV'
,	Operator = o.operator
from
	dbo.object o
	join dbo.location l
		on l.code = o.location
where
	l.plant = 'EEP'
	and l.code like 'EE[1-9]-[0-9][0-9]-[A-Z]-[0-9]'
union all
select
	Plant = coalesce(l.plant, o.plant)
,	Rack = substring(o.location, 3, 1)
,	Shelf = substring(o.location, 8, 1)
,	Position = substring(o.location, 5, 2) + '-' + substring(o.location, 10, 1)
,	Address = substring(o.location, 1, 6)
,	LocationCode = o.location
,	Serial = o.serial
,	Part = o.part
,	Quantity = o.quantity
,	Type = case left(o.location, 1) when 'P' then 'FIS' when 'L' then 'LST' end
,	Operator = o.operator
from
	dbo.object o
	left join dbo.location l
		on l.code = o.location
where
	coalesce(l.plant, o.plant) = 'EEP'
	and
	(	o.location like 'PH[1-9]-[0-9][0-9]-[A-Z]-[0-9]'
		or o.location like 'LS[1-9]-[0-9][0-9]-[A-Z]-[0-9]'
	)
GO
