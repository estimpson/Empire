SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_TroyOnHand]
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
GO
