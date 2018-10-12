SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view	[dbo].[VW_Moldeo_Asociaciones_ParteMaquinaMolde] as
select	ToolID = pmm.PMM_ID, Parte, Molde = Moldes.Nombre, Maquina = Maquina.Nombre, CavidadesReales, CavidadesIdeales
from	Sistema.dbo.MD_Programacion_PMM PMM
		join Sistema.dbo.MD_Programacion_Parte_Molde PM on PMM.Programacion_ID = pm.ProgramacionID
		join Sistema.dbo.MD_Moldes Moldes on Moldes.MoldeID = PM.MoldeID
		join Sistema.dbo.SA_Maquinas Maquina on Maquina.MaquinaID = PMM.MaquinaID
		
		
GO
