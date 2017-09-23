
/*
Create View.MONITOR.FT.WarehouseProductDensity.sql
*/

use MONITOR
go

--drop table FT.WarehouseProductDensity
if	objectproperty(object_id('FT.WarehouseProductDensity'), 'IsView') = 1 begin
	drop view FT.WarehouseProductDensity
end
go

create view FT.WarehouseProductDensity
as
select
	wi.Part
,	DifferentLocations = count(distinct wi.LocationCode)
,	AverageBoxesPerLocation = sum(wi.Boxes) / nullif(count(distinct wi.LocationCode), 0)
,	LocationList = Fx.ToList(wi.LocationCode + ' (' + convert(varchar, wi.Boxes) + ')')
from
	(	select
			wi.Part
		,	wi.LocationCode
		,	Boxes = count(*)
		from
			FT.WarehouseInventory wi
		where
			wi.Part != 'PALLET'
			and wi.Type = 'INV'
		group by
			wi.Part
		,	wi.LocationCode
	) wi
group by
	wi.Part
