SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[eeisp_rpt_materials_POHistory_byPO] (@PONumber int)
as begin
--eeisp_rpt_materials_POHistory_byPO 24777
Select	ReleasePlanID,
		PONumber ,
		ft.releaseplanraw.Part,
		DueDT,
		StdqTY,
		PostAccum,
		AccumReceived,
		LastReceivedDT,
		GeneratedDT,
		(FabWeekNo-GeneratedWeekNo) as LeadTimeWeeks,
		Standard_pack
from		ft.releaseplanraw 
join		ft.releaseplans on ft.releaseplanraw.releaseplanid = ft.releaseplans.id
join		part_inventory on ft.releaseplanraw.part = part_inventory.part
where	POnumber = @PONumber and ReleasePlanID in ( Select max(ID) from ft.releaseplans group by GeneratedWeekNo)
order by releaseplanid asc
end
GO
