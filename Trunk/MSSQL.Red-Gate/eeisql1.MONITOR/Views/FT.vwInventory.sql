SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwInventory]
as
select	Serial = object.serial,
	PartECN = object.part,
	Status = isnull (object.status, 'X'),
	Location = object.location,
	Plant = isnull (location.plant,
		case	when object.location like 'TRAN%' then 'INTRANSIT'
			when object.location like '%LOST%' then 'LOST'
			else 'EEI'
		end),
	StdQty = object.std_quantity
from	object
	left join location on object.location = location.code
	join part on object.part = part.part
where	object.part != 'PALLET'
GO
