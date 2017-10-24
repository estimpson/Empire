SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	procedure [dbo].[eeisp_rpt_materials_CallARSReportExceptions]

as

Begin


begin transaction
execute ft.csp_autopogen
commit
SELECT     'P',Part, Description
FROM         FT.vweHoldInventory
UNION ALL
SELECT     'P',Part, Description
FROM         FT.vweStandardPack
UNION ALL
SELECT     'P',Part, Description
FROM         FT.vweLeadDemand
UNION ALL
SELECT     'P',Part, Description
FROM         FT.vweTotalDemand
UNION ALL
SELECT     'P',Part, Description
FROM         FT.vweMinOnHand
UNION ALL
SELECT     'P',Part, Description
FROM         FT.vweRoundDown
UNION ALL
Select 'S', part, description from "FT".vweSetupData

End
GO
