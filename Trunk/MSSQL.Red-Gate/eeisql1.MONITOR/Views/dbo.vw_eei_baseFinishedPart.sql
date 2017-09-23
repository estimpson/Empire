SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE view [dbo].[vw_eei_baseFinishedPart] as
Select	distinct substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1) as  BasePart,
		(Select max(COALESCE(part_eecustom.part, shipper_detail.part_original, part_standard.part)) 					
			from		part p2
		left outer join		part_eecustom on p2.part = part_eecustom.part and part_eecustom.CurrentRevLevel = 'Y'
		left outer join		shipper_detail on p2.part = shipper_detail.part_original
		left outer join		part_standard on p2.part = part_standard.part and part_standard.material_cum is not NULL
where	p2.class not in ('O', 'M') and
		p2.type = 'F' and 
		p2.part like '%[-]%'  and 
		p2.part not like '%PT%' and
		p2.part not like  '%[-]SP%' and
		p2.part not like  '%[-]RW%' and
		substring(p2.part, 1,(PATINDEX( '%[-]%',part.part))-1) = substring(part.part, 1,(PATINDEX( '%[-]%',part.part))-1)) as PartUsedForCost
from		part

where	part.class not in( 'O' , 'M')and
		part.type = 'F' and 
		part.part like '%[-]%'  and 
		part.part not like '%PT%' and
		part.part not like  '%[-]SP%' and
		part.part not like  '%[-]RW%'
GO
