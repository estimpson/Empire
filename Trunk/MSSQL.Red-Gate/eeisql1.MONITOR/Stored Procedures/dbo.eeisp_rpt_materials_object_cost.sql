SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_rpt_materials_object_cost]
as
begin

Select	object.part,
		quantity,
		material_cum as TransferPrice,
		material_cum*quantity as Extended,
		last_date,
		(select min(last_date) from object o2 where o2.part = object.part) as Oldestdate,
		(select max(last_date) from object o2 where o2.part = object.part) as Newestdate
		
from		object
join		part_standard on object.part = part_standard.part
end
GO
