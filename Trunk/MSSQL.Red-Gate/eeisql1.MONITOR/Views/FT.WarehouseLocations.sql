SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[WarehouseLocations]
as
select	Aisle = Substring (location.code, 1, 1),
	Shelf = convert (int, Substring (location.code, 3, 1)),
	Subshelf = convert (int, Substring (location.code, 5, 2)),
	Address = location.code,
	LocationCode = location.code,
	PhysicalWIPLocationCode = location.code + '-FIS',
	LostLocationCode = location.code + '-LST'
from	location
where	(	location.code like '[A-Z]-[1234]-[0-9]' or
		location.code like '[A-Z]-[1234]-[0-9][0-9]')
GO
