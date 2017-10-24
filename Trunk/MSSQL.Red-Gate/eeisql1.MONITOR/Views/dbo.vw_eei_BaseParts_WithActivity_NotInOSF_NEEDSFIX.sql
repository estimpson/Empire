SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_eei_BaseParts_WithActivity_NotInOSF_NEEDSFIX]

as
(Select	left(part.part,7) BasePart
from   part where left(part,7) in (Select	left(part.part,7)
from		  part_eecustom
join		 part on part_eecustom.part = part.part and part.type = 'F' and part.class !='O'
where	part.part in (Select part_number from   order_detail where quantity>100 and due_date > dateadd(dd, -30, getdate()) union select part_original from   shipper_detail where isNull(date_shipped, '1999-01-01') >= dateadd(dd, -30, getdate())) and
left(part.part,7) not in (Select base_part from  [EEIUser].[acctg_csm_vw_select_total_demand])
group by left(part.part,7)
having    max(isNull(currentrevlevel,'N'))= 'N')

group by left(part,7)

UNION
Select	left(part.part,7)
from		  part_eecustom
join		 part on part_eecustom.part = part.part and part.type = 'F' and part.class != 'O'
where	isNull(currentrevlevel,'N')= 'Y' and left(part.part,7) not in (Select base_part from  [EEIUser].[acctg_csm_vw_select_total_demand]))
GO
