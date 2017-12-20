
/*
Create View.MONITOR.TOPS.Leg_TroyOnHand.sql
*/

use MONITOR
go

--drop table TOPS.Leg_TroyOnHand
if	objectproperty(object_id('TOPS.Leg_TroyOnHand'), 'IsView') = 1 begin
	drop view TOPS.Leg_TroyOnHand
end
go

create view TOPS.Leg_TroyOnHand
as
select
	Serial = serial
,	Part = object.part
,	Location = object.location
,	Quantity = object.quantity
,	Type = part.type
,	LocationCode = location.code
from
	MONITOR.dbo.object object
	join MONITOR.dbo.part part
		on object.part = part.part
	left outer join MONITOR.dbo.location location
		on object.location = location.code
where
	(
		object.location not like '%EEH%'
		and object.location not like '%lost%'
		and object.location not like '%tran%'
		and object.location not like '%Lost%'
		and part.type = 'f'
		and isnull(object.field2, 'XXX') <> 'ASB'
		and isnull(location.code, 'Lost') <> 'Lost'
		and isnull(location.secured_location, 'N') <> 'Y'
	)
	or
	(
		object.location = 'TEEH-WAREH'
		and object.part != 'PALLET'
	)
go

select
	*
from
	TOPS.Leg_TroyOnHand ltoh
order by
	ltoh.Part