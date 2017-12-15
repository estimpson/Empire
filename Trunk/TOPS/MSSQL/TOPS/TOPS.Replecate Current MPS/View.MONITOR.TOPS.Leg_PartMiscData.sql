
/*
Create View.MONITOR.TOPS.Leg_PartMiscData.sql
*/

use MONITOR
go

--drop table TOPS.Leg_PartMiscData
if	objectproperty(object_id('TOPS.Leg_PartMiscData'), 'IsView') = 1 begin
	drop view TOPS.Leg_PartMiscData
end
go

create view TOPS.Leg_PartMiscData
as
select
	Part = part.part
,	Description = part.name
,	CrossRef = part.cross_ref
,	Type = part.type
,	UserDefined1 = part.user_defined_1
,	StandardPack = part_inventory.standard_pack
,	Price = part_customer_price_matrix.price
,	LongestLT = part_inventory.longest_lt
,	MinProdRun = part_inventory.min_prod_run
,	ProdEnd = part_eecustom.prod_end
,	EAU = part_eecustom.eau
,	ProdStart = part_online.prod_start
,	ProdEnd2 = part_online.prod_end
from
	MONITOR.dbo.part part
,	MONITOR.dbo.part_customer_price_matrix part_customer_price_matrix
,	MONITOR.dbo.part_eecustom part_eecustom
,	MONITOR.dbo.part_inventory part_inventory
,	MONITOR.dbo.part_online part_online
where
	part.part = part_inventory.part
	and part_customer_price_matrix.part = part_inventory.part
	and part_inventory.part = part_online.part
	and part_online.part = part_eecustom.part
	and ((part.type = 'f'))
go

