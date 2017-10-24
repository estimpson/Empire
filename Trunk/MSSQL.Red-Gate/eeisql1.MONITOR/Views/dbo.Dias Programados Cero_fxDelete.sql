SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Dias Programados Cero_fxDelete]
AS
SELECT     dbo.KB_BillMaterialData_Issue.Linea, dbo.KB_BillMaterialData_Issue.Parte, dbo.KB_BillMaterialData_Issue.[Requerimiento Total], 
                      dbo.KB_Revisiones_Produccion.DiasProgramados
FROM         dbo.KB_BillMaterialData_Issue INNER JOIN
                      dbo.KB_Revisiones_Produccion ON dbo.KB_BillMaterialData_Issue.Linea = dbo.KB_Revisiones_Produccion.part INNER JOIN
                      dbo.Material_Issue_To_Floor ON dbo.KB_BillMaterialData_Issue.Parte = dbo.Material_Issue_To_Floor.Part
WHERE     (dbo.KB_Revisiones_Produccion.DiasProgramados = 0) AND (dbo.KB_Revisiones_Produccion.contenedorId = 163) AND 
                      (dbo.Material_Issue_To_Floor.LOCATION = 'PISO10-29') OR
                      (dbo.KB_Revisiones_Produccion.contenedorId = 163) AND (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] = 0) AND 
                      (dbo.Material_Issue_To_Floor.LOCATION = 'PISO10-29')
GROUP BY dbo.KB_BillMaterialData_Issue.Linea, dbo.KB_BillMaterialData_Issue.[Requerimiento Total], dbo.KB_Revisiones_Produccion.DiasProgramados, 
                      dbo.KB_BillMaterialData_Issue.Parte
GO
