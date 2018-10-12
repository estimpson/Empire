SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_eei_raw_material] 

as



SELECT		object.serial, 
		object.part, 
		object.location, 
		object.status, 
		object.quantity,
		object.plant, 
		part.product_line, 
		part_standard.cost_cum, 
		part.type,
		VendorCode,
		(part_standard.cost_cum*object.quantity) as ExtendedCost
 FROM		dbo.object object 

left join	( Select	part_online.part,
				default_vendor as VendorCode
		    from	part_online
		   join		part on part_online.part = part.part
			where	part.type = 'R' 
		) VendorCode on object.part  = VendorCode.part
JOIN	dbo.part_standard ON object.part=part_standard.part
JOIN	dbo.part on part_standard.part = part.part 
 WHERE  isNULL(part.type, 'X') = 'R'
		and isNULL(object.user_defined_status, 'XXX') !=  'PRESTOCK' 

GO
