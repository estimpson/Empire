SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [eeiuser].[acctg_unique_raw_material]
as
select * from 
(select		distinct(LEFT(finishedpart,7)) as finishedpart, 
			rawpart 
 from		vweeiBOM 
 where		rawpart in (select		rawpart 
						from		vweeiBOM 
						group by	RawPart 
						having		COUNT(distinct(left(finishedpart,7))) <= 1 )
) a
left join
(select		part_online.part,
			part.name, 
			part.commodity,
			part_online.on_hand,			
			part_online.default_vendor, 				
			part_inventory.standard_pack,
			part_vendor.lead_time,
			part_vendor.min_on_order
  from		part_online
	left join part on part_online.part = part.part
	left join part_inventory on part_online.part = part_inventory.part
	left join part_vendor on part_online.part = part_vendor.part and part_online.default_vendor = part_vendor.vendor
) b
on a.rawpart = b.part
GO
