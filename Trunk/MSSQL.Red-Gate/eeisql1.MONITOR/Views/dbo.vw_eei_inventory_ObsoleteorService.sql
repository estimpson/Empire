SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_inventory_ObsoleteorService] as
Select	substring(part.part, 1,7) as BasePart,
		object.serial,
		object.part,
		object.quantity,
		object.location,
		(Case when ISNULL(part_eecustom.ServicePart, 'N') = 'Y' Then ('Service' + ' - '+(CASE WHEN part.class= 'P' THEN 'Purchased' WHEN part.class = 'O' THEN 'Obsolete' WHEN part.class = 'M' THEN 'Manufactured'  ELSE 'Other' END)) ELSE (CASE WHEN part.class= 'P' THEN 'Purchased' WHEN part.class = 'O' THEN 'Obsolete' WHEN part.class = 'M' THEN 'Manufactured'  ELSE 'Other' END) END) as PartClassification,
		isNULL(part_standard.cost_cum,0) as partCost,
		isNULL(part_standard.price,0)as partPrice,
		(isNULL(part_standard.cost_cum,0)*Object.std_quantity) as ExtendedCost,
		(isNULL(part_standard.price,0)*Object.std_quantity) as ExtendedPrice		
		
From	object
join		part on object.part = part.part
join		part_standard on part.part = part_standard.part
join		part_eecustom on part_standard.part = part_eecustom.part
Where	(object.quantity > 0) and (part.class = 'O' or ServicePart = 'Y') and object.part not in (select part from eeiVW_MG)
GO
