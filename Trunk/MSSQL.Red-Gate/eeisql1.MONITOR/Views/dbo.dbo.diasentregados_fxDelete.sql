SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[dbo.diasentregados_fxDelete]
AS
SELECT     dbo.KB_BillMaterialData_Issue.Parte, dbo.KB_BillMaterialData_Issue.Quantity, dbo.KB_BillMaterialData_Issue.Requerimiento, 
                      dbo.KB_BillMaterialData_Issue.[Requerimiento Total], dbo.KB_BillMaterialData_Issue.entregado, dbo.KB_BillMaterialData_Issue.manualadd, 
                      dbo.KB_Revisiones_Produccion.DiasProgramados, dbo.KB_BillMaterialData_Issue.materialista, 
                      dbo.KB_BillMaterialData_Issue.entregado / (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados)
                       AS diaEntregado
FROM         dbo.Material_Issue_To_Floor INNER JOIN
                      dbo.KB_BillMaterialData_Issue INNER JOIN
                      dbo.KB_Revisiones_Produccion ON dbo.KB_BillMaterialData_Issue.Linea = dbo.KB_Revisiones_Produccion.part ON 
                      dbo.Material_Issue_To_Floor.Part = dbo.KB_BillMaterialData_Issue.Parte LEFT OUTER JOIN
                      dbo.dbo_Fifo_Partes_No_Usuar_BOM ON dbo.KB_BillMaterialData_Issue.Parte = dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte
WHERE     (dbo.KB_BillMaterialData_Issue.Linea = N'AUT0001-HD02') AND (dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte IS NULL)
GROUP BY dbo.KB_BillMaterialData_Issue.Linea, dbo.KB_BillMaterialData_Issue.Requerimiento, dbo.KB_Revisiones_Produccion.DiasProgramados, 
                      dbo.KB_BillMaterialData_Issue.Quantity, dbo.KB_BillMaterialData_Issue.[Requerimiento Total], dbo.KB_BillMaterialData_Issue.materialista, 
                      dbo.KB_BillMaterialData_Issue.manualadd, dbo.KB_BillMaterialData_Issue.entregado, dbo.KB_BillMaterialData_Issue.Parte, 
                      dbo.KB_BillMaterialData_Issue.entregado / (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados)
GO
