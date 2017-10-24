SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE view [dbo].[vw_eeiMaterialCostBasePart]
as
Select	BasePart,PartUsedforCost, material_cum
from		vw_eei_baseFinishedPart
join		part_standard on vw_eei_baseFinishedPart.PartUsedforCost=part_standard.part
GO
