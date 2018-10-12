SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_NivelEducativo]
AS


SELECT        NivelEducID, Descripcion_Nivel
FROM           Sistema.dbo.RH_NivelEducativo


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
