--Part_EEH - $A$1:$E$16930
--EEH

use Monitor;
go

select
	part.part
,	part.name
,	part.cross_ref
,	part.type
,	part_eecustom.eau
from
	Monitor.dbo.part part
,	Monitor.dbo.part_customer_price_matrix part_customer_price_matrix
,	Monitor.dbo.part_eecustom part_eecustom
,	Monitor.dbo.part_inventory part_inventory
,	Monitor.dbo.part_online part_online
where
	part.part = part_inventory.part
	and part_customer_price_matrix.part = part_inventory.part
	and part_inventory.part = part_online.part
	and part_online.part = part_eecustom.part
	and ((part.type = 'f'))
order by
	part.part;