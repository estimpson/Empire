
/*
Create View.MONITOR.FT.PlantWarehouseLocations.sql
*/

use MONITOR
go

--drop table FT.PlantWarehouseLocations
if	objectproperty(object_id('FT.PlantWarehouseLocations'), 'IsView') = 1 begin
	drop view FT.PlantWarehouseLocations
end
go

create view FT.PlantWarehouseLocations
as
select
	Plant = l.plant
,	Rack = substring(l.code, 1, 1)
,	Shelf = convert(varchar, convert (int, substring(l.code, 3, 1)))
,	Position = convert(varchar, convert (int, substring(l.code, 5, 2)))
,	Address = l.code
,	LocationCode = l.code
,	PhysicalWIPLocationCode = l.code + '-FIS'
,	LostLocationCode = l.code + '-LST'
from
    dbo.location l
where
	l.plant = 'EEI'
	and
	(	l.code like '[A-Z]-[1234]-[0-9]'
		or l.code like '[A-Z]-[1234]-[0-9][0-9]'
	)
union all
select
	Plant = l.plant
,	Rack = substring(l.code, 3, 1)
,	Shelf = substring(l.code, 8, 1)
,	Position = substring(l.code, 5, 2) + '-' + substring(l.code, 10, 1)
,	Address = l.code
,	LocationCode = l.code
,	PhysicalWIPLocationCode = 'PH' + substring(l.code, 3, 8)
,	LostLocationCode = 'LS' + substring(l.code, 3, 8)
from
	dbo.location l
where
	l.plant = 'EEP'
	and l.code like 'EE[1-9]-[0-9][0-9]-[A-Z]-[0-9]'
go

select
	*
from
	FT.PlantWarehouseLocations pwl
order by
	1, 2, 3, 4