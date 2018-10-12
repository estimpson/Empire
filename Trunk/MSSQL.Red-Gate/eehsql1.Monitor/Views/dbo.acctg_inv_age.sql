SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [dbo].[acctg_inv_age]
as
select		type,
			location,
			default_vendor, 
			part, 
			name, 
			commodity, 
			description_short, 
			SUM(ext_quantity) as ext_quantity, 
			SUM(ext_selling_price) as ext_selling_price, 
			SUM(ext_material_cum) as ext_material_cum, 
			FISCAL_YEAR, 
			FISCAL_MONTH 
from
(	
	select		object.serial,
				object.location,
				part_online.default_vendor,
				part.type,
				object.part, 
				part.name,
				part.commodity,
				part.description_short,
				object.quantity as ext_quantity,
				object.quantity*part_standard.price as ext_selling_price,
				object.quantity*part_standard.material_cum as ext_material_cum,
				datepart(yyyy,(select isnull(max(date_stamp),'2005-01-01') from audit_trail where type in ('A', 'R','U','J','B') and audit_trail.serial = object.serial)) as fiscal_year,
				datepart(m,(select isnull(max(date_stamp),'2005-01-01') from audit_trail where type in ('A', 'R','U','J','B') and audit_trail.serial = object.serial)) as fiscal_month
	from		object
				left join part_standard on object.part = part_standard.part
				left join part on object.part = part.part
				left join part_online on object.part = part_online.part
				where object.part not in ('PALLET', 'RMA') and object.location <> 'PREOBJECT'
) A
	group by	type,
				location,
				default_vendor, 
				part, 
				name, 
				commodity, 
				description_short, 
				FISCAL_YEAR, 
				FISCAL_MONTH 
				


		
		
		






















GO
