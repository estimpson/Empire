SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_Departamentos]
AS


SELECT DepartamentoNombre,DepartamentoId 
FROM Sistema.dbo.RH_Departamentos


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
