SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[transfer]
AS
SELECT DISTINCT 
                      TOP 100 PERCENT dbo.KB_BillMaterialData_Transfer.Linea, dbo.KB_BillMaterialData_Transfer.Requerimiento, 
                      dbo.KB_Revisiones_Produccion.DiasProgramados, dbo.KB_Revisiones_Produccion.DiaArranque, 
                      MIN(ISNULL(dbo.KB_BillMaterialData_Transfer.entregado, 0) 
                      / (dbo.KB_BillMaterialData_Transfer.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados)) AS [min], 
                      dbo.KB_BillMaterialData_Transfer.materialista
FROM         dbo.KB_BillMaterialData_Transfer INNER JOIN
                      dbo.KB_Revisiones_Produccion ON dbo.KB_BillMaterialData_Transfer.Linea = dbo.KB_Revisiones_Produccion.part INNER JOIN
                      dbo.object ON dbo.KB_BillMaterialData_Transfer.Parte = dbo.object.part LEFT OUTER JOIN
                      dbo.dbo_Fifo_Partes_No_Usuar_BOM ON dbo.KB_BillMaterialData_Transfer.Parte = dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte
WHERE     (dbo.KB_BillMaterialData_Transfer.Requerimiento <> 0) AND (dbo.KB_Revisiones_Produccion.contenedorId = 163) AND 
                      (dbo.KB_Revisiones_Produccion.DiasProgramados <> 0) AND (dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte IS NULL) AND 
                      (dbo.object.location = 'piso11-05')
GROUP BY dbo.KB_BillMaterialData_Transfer.Requerimiento, dbo.KB_Revisiones_Produccion.DiasProgramados, dbo.KB_Revisiones_Produccion.DiaArranque, 
                      dbo.KB_BillMaterialData_Transfer.Linea, dbo.KB_BillMaterialData_Transfer.materialista
ORDER BY dbo.KB_BillMaterialData_Transfer.Linea
GO
