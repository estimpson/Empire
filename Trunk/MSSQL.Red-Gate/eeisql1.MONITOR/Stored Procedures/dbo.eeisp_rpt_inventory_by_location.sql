SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_inventory_by_location] (@location varchar(25)) as
begin
Select	serial,
		parent_serial,
		object.part,
		location,
		last_date,
		quantity,
		material_cum
from		object
join		part_standard on object.part = part_standard.part
where	object.location = @location and object.part <> 'PALLET'
end
GO
