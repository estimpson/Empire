SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[PlantWarehouseLocations]
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
from /* This somewhat goofy structure is necessary to prevent problems with conversions. */
	(	select
    			code = case when l.code like '[A-Z]-[1234]-[0-9]'
				or l.code like '[A-Z]-[1234]-[0-9][0-9]' then l.code end
    		,   l.name
    		,   l.type
    		,   l.group_no
    		,   l.sequence
    		,   l.plant
    		,   l.status
    		,   l.secured_location
    		,   l.label_on_transfer
    		,   l.hazardous
    	from
    		dbo.location l
		where
			l.plant = 'EEI'
			and
			(	l.code like '[A-Z]-[1234]-[0-9]'
				or l.code like '[A-Z]-[1234]-[0-9][0-9]'
			)
    ) l
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
	(	select
			code = case when l.code like 'EE[1-9]-[0-9][0-9]-[A-Z]-[0-9]' then l.code end
		,   l.name
		,   l.type
		,   l.group_no
		,   l.sequence
		,   l.plant
		,   l.status
		,   l.secured_location
		,   l.label_on_transfer
		,   l.hazardous
		from
			dbo.location l
		where
			l.plant = 'EEP'
			and l.code like 'EE[1-9]-[0-9][0-9]-[A-Z]-[0-9]'
	) l
GO
