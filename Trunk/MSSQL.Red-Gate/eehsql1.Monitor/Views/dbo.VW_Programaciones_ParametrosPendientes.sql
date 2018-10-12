SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[VW_Programaciones_ParametrosPendientes] as
SELECT         MD_Programacion_Parte_Molde.Parte, MD_Moldes.Nombre, SA_Maquinas.Nombre AS Maquina
FROM            sistema.dbo.MD_Programacion_PMM INNER JOIN
                         sistema.dbo.MD_Programacion_Parte_Molde ON MD_Programacion_PMM.Programacion_ID = MD_Programacion_Parte_Molde.ProgramacionID INNER JOIN
                         sistema.dbo.MD_Moldes ON MD_Programacion_Parte_Molde.MoldeID = MD_Moldes.MoldeID INNER JOIN
                         sistema.dbo.SA_Maquinas ON MD_Programacion_PMM.MaquinaID = SA_Maquinas.MaquinaID LEFT OUTER JOIN
                         sistema.dbo.MD_Parametros_Programacion ON MD_Programacion_PMM.PMM_ID = MD_Parametros_Programacion.PMM_ID
WHERE        (MD_Programacion_PMM.Estado = 1) AND (MD_Parametros_Programacion.PMM_ID IS NULL)
GO
