SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Programar Cargado]
AS
SELECT     dbo.KB_BillMaterialData_Issue.Linea, dbo.KB_BillMaterialData_Issue.Parte, ISNULL(dbo.KB_BillMaterialData_Issue.entregado, 0) 
                      / (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados) AS minimo, 
                      dbo.KB_BillMaterialData_Issue.diasacargar, dbo.KB_Revisiones_Produccion.DiaArranque
FROM         dbo.KB_BillMaterialData_Issue INNER JOIN
                      dbo.KB_Revisiones_Produccion ON dbo.KB_BillMaterialData_Issue.Linea = dbo.KB_Revisiones_Produccion.part LEFT OUTER JOIN
                      dbo.dbo_Fifo_Partes_No_Usuar_BOM ON dbo.KB_BillMaterialData_Issue.Parte = dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte
WHERE     (dbo.KB_Revisiones_Produccion.contenedorId = 163) AND (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] <> 0) AND 
                      (dbo.KB_Revisiones_Produccion.DiasProgramados <> 0) AND (dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte IS NULL) AND 
                      (NOT (dbo.KB_BillMaterialData_Issue.Parte LIKE N'ckt%')) AND (NOT (dbo.KB_BillMaterialData_Issue.Parte LIKE N'tm%')) AND 
                      (NOT (dbo.KB_BillMaterialData_Issue.Parte LIKE N'spl%')) AND (NOT (dbo.KB_BillMaterialData_Issue.Parte LIKE N'dbl-%')) AND 
                      (NOT (dbo.KB_BillMaterialData_Issue.Parte LIKE N'pot%'))
GROUP BY dbo.KB_BillMaterialData_Issue.Linea, dbo.KB_Revisiones_Produccion.DiaArranque, dbo.KB_BillMaterialData_Issue.Parte, 
                      dbo.KB_BillMaterialData_Issue.diasacargar, ISNULL(dbo.KB_BillMaterialData_Issue.entregado, 0) 
                      / (dbo.KB_BillMaterialData_Issue.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados)
GO
