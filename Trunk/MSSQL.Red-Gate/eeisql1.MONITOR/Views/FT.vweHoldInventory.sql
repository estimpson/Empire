SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweHoldInventory]
(	Part,
	Description )
as
--	Description:
--	Exceptions are on hold inventories.
select	Part = object.part,
	Description = 'Hold inventory present but counted for part ' + object.part + ' in the amount of ' +
	Convert ( varchar, sum ( std_quantity ) ) + ' ' + Max ( part_inventory.standard_unit ) + '.'
from	dbo.object
	join dbo.part_inventory on object.part = part_inventory.part
	join dbo.location on object.location = location.code and
		IsNull ( location.secured_location, 'N' ) != 'Y'
where	object.status = 'H'
group by
	object.part
GO
