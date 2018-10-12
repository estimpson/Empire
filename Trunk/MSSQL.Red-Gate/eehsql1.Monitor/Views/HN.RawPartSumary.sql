SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  view [HN].[RawPartSumary] as 
select	part_Standard.Part,
	part.name,
	material_cum,
	part_online.default_vendor,
	part_vendor.lead_time,
	part_vendor.FABAuthDays,
	Inventory = (select sum(Quantity) from object where Object.Part = part_standard.part),  
	Requirement8Week = (select	sum( qnty ) 
	               from	master_prod_sched 
	               where	Due <= dateadd( wk, 8, getdate())
				and Part = part_Standard.Part),
	AllRequirements = (select	sum( qnty ) 
	               from	master_prod_sched 
	               where	Part = part_Standard.Part),
	POS8Week = (	select	sum(balance)
		from	po_detail
		where	part_number = part_Standard.Part
			and date_due <= dateadd( wk, 8, getdate())),
	AllPOS = (	select	sum(balance)
		from	po_detail
		where	part_number = part_Standard.Part),
	POSFirms = (	select	sum(balance)
			from	po_detail
			where	part_number = part_Standard.Part
				and date_due <= dateadd( wk, VendorPart.FirmWeeks, getdate())),
	FirmWeeks
from	Part
	join part_Standard on Part_standard.part = Part.part
	join part_online on part_online.part = part_Standard.part
	join part_vendor on part_vendor.part = part_standard.part 
			    and part_online.default_vendor = part_vendor.vendor
	join (select	VendorPart.part, VendorPart.vendor, FirmWeeks = case when ( ( convert(int, isnull( nullif( FABAuthdays, 0), 14)) ) % 7)+1 <= isnull((case when custom4 like '[0-7]' then convert(integer,custom4) end),2) 
									then isnull( nullif( FABAuthdays, 0), 14)/7 
									else 1+isnull( nullif( FABAuthdays, 0), 14)/7 end	
							    from	part_vendor VendorPart
								    left join vendor_custom on VendorPart.vendor = vendor_custom.code
							    ) VendorPart on  VendorPart.part = part_online.part 
								   and VendorPart.vendor = part_online.default_Vendor

GO
