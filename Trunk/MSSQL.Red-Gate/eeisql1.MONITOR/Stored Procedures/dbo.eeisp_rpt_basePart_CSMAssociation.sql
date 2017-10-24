SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_basePart_CSMAssociation]
as
Begin							
Select * from flatCSM Where OEM not like '%General Motors%' and OEM not like '%Ford%' and OEM not like '%Chrysler%' 
UNION
Select left(Part_number,7),'','',''
from		order_detail
where due_date > '2009-02-01' and left(part_number,7) not in (Select BASEPart from flatCSM Where OEM  like '%General Motors%' or OEM  like '%Ford%' or OEM  like '%Chrysler%' )

order by 1
End
GO
