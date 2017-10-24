SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE 	procedure [dbo].[eeisp_get_currentRevLevels]

as 

begin

truncate table Part_CurrentRevLevel

declare	@EEHPartStandard  table (
			part varchar(25),
			material_cum numeric (20,6),
			primary key (part))
insert	@EEHpartStandard

Select	part.part,
		material_cum
from		[EEHSQL1].[EEH].[dbo].part part
join		[EEHSQL1].[EEH].[dbo].part_standard  part_standard on part.part = part_standard.part and part.class = 'M' and part.type = 'F'


insert	 Part_CurrentRevLevel


Select	Left(part_eecustom.part,7) as BasePart,
		part_eecustom.part,
		CurrentRevLevel,
		frozen_material_cum
		 
from		part_eecustom 
join		part_standard on part_eecustom.part = part_standard.part
where	currentRevLevel = 'Y'
order by 1 asc

Select	Part_CurrentRevLevel.part EEIpart,
		Part_CurrentRevLevel.BasePart BasePart,
		CurrentRevLevel,
		Part_CurrentRevLevel.material_cum EEIFrozenMaterialCum,
		 EEHPartStandard.Part EEHPart,
		EEHPartStandard.Material_cum EEHMaterialCum,
		Release_id,
		 costtabular.base_Part,
		version,
		partUsedForCost,
		JAN_08,
		JAN_09,
		JAN_10,
		JAN_11,
		JAN_12
		
from		Part_CurrentRevLevel
left join		@EEHpartStandard EEHPartStandard on Part_CurrentRevLevel.Part = EEHPartStandard.Part
full	join	[MONITOR].[EEIUser].[acctg_csm_material_cost_tabular] costtabular on Part_CurrentRevLevel.basePart = costtabular.base_Part

end
GO
