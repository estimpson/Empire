SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  view [dbo].[vwft_ActivePartMaterialAccum] as

select		
	max(left(peec.part,7)) as MCBasePart,
	ps.part as CurrentRevPart,
	ps.material_cum as CurrentRevMaterialAccum,
	0 as CurrentRevFrozenMaterialCost,
	'EEH' as PartDataBase,
	0 as BOMFlag
from		
	part_eecustom peec
join		
	EEH_part_standard ps on peec.part = ps.part
where		
	peec.CurrentRevLevel = 'Y'
group by	
	ps.part,
	ps.material_cum
union
select		
	max(left(peec.part,7)) as MCBasePart,
	ps.part as CurrentRevPart,
	0 as CurrentRevMaterialAccum,
	ps.Frozen_Material_cum as CurrentRevFrozenMaterialCost,
	'EEI' as PartDatabase,	
	case when exists (select 1 from FT.vwBOM where parentPart = ps.part) then 1 else 0 end as BOMFlag
from		
	part_eecustom peec
join		
	monitor.dbo.part_standard ps on peec.part = ps.part
where		
	peec.CurrentRevLevel = 'Y' 
group by	
	ps.part,
	ps.Frozen_Material_cum
	
	/*
	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevMaterialAccum ,0) as MaterialCUM,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNUll(BOMFlag,0) = 0 and 
				MCBASEPart not in (Select MCBasePart from vwft_ActivePartMaterialAccum where BOMFlag = 1) and
				PartDataBase = 'EEH'
	Union
	Select	MCBasePart,
				CurrentRevPart,
				COALESCE(CurrentRevFrozenMaterialCost ,0) as MaterialCUM,
				BOMFlag,
				PartDataBase
	From	vwft_ActivePartMaterialAccum
	where	isNull(BOMFlag,0) = 1 and 
				PartDataBase = 'EEI'
	
	*/
	

GO
