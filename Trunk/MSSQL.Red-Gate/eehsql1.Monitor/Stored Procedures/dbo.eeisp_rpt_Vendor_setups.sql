SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_Vendor_setups] (@Vendor varchar(15))
as
select	Part_vendor.part,
		Coalesce(part_vendor.fabAuthDays, Lead_time,0) LeadTime,
		isNULL(part_standard.material_cum,0 ) StandardCost,
		isNULL(part_vendor_Price_matrix.price, 0) Price,
		isNULL(standard_pack,0) StdPack
 from	part_vendor
join		part_standard on part_vendor.part = part_standard.part
join		part_inventory on part_vendor.part = part_inventory.part
left join	part_vendor_price_matrix  on part_vendor.vendor = part_vendor_price_matrix.vendor  and part_vendor.part = part_vendor_price_matrix.part
where	part_vendor.vendor = @Vendor and
		part_vendor.part in ( select		distinct audit_trail.part
				from audit_trail 
				join part on audit_trail.part = part.part 
				join part_vendor on  audit_trail.part = part_vendor.part and part_vendor.vendor = @Vendor
				where date_stamp >= dateadd(mm, -6, getdate()) and part.type = 'R' and audit_trail.type in  ('R', 'M')
				union all
				select distinct part_number from po_detail)
GO
