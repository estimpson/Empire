SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_CentrosCostos]
AS

SELECT CenterCost = organization, CenterCostName = organization_description, 
CenterCostComplete = organization + ' ' + organization_description
FROM monitor.dbo.ledger_organizations
WHERE LEN(organization) = 3


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
