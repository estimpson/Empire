SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure	[dbo].[eeisp_rpt_materials_ARSException_PartsSpecifiedARSNo]

as
Begin
select	part_eecustom.part,  
		part.name, 
		part_vendor.vendor ,
		non_order_note,
		non_order_operator,
		standard_pack,
		part_eecustom.auto_releases		
from	part_vendor
	 join part_inventory on part_vendor.part = part_inventory.part
	join part_eecustom on part_vendor.part = part_eecustom.part 
	join part_online on part_eecustom.part = part_online.part and default_vendor = part_vendor.vendor
	join part on part_vendor.part = part.part
where	isnull (part_eecustom.auto_releases, 'N') ='N' and  
	part.class in ('P','R') and
	--part_vendor.vendor in
	--(	select	default_vendor 
	--	from	part_online
	--		join part_eecustom on part_online.part = part_eecustom.part 
	--	where 	isnull (part_eecustom.auto_releases, 'X') = 'Y') and
	part_vendor.part in
	(	select	Part
		from	FT.NetMPS)
End


GO
