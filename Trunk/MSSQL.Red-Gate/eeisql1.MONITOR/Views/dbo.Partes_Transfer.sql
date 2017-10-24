SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Partes_Transfer]
AS
SELECT     dbo.KB_BillMaterialData_Transfer.Parte, dbo.KB_Revisiones_Produccion.DiasProgramados, dbo.KB_BillMaterialData_Transfer.materialista, 
                      ISNULL(dbo.KB_BillMaterialData_Transfer.entregado / (dbo.KB_BillMaterialData_Transfer.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados),
                       0) AS diaEntregado, dbo.KB_Revisiones_Produccion.DiaArranque, dbo.KB_BillMaterialData_Transfer.Linea, 
                      dbo.KB_BillMaterialData_Transfer.Requerimiento
FROM         dbo.KB_BillMaterialData_Transfer INNER JOIN
                      dbo.KB_Revisiones_Produccion ON dbo.KB_BillMaterialData_Transfer.Linea = dbo.KB_Revisiones_Produccion.part LEFT OUTER JOIN
                      dbo.object ON dbo.KB_BillMaterialData_Transfer.Parte = dbo.object.part LEFT OUTER JOIN
                      dbo.dbo_Fifo_Partes_No_Usuar_BOM ON dbo.KB_BillMaterialData_Transfer.Parte = dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte
WHERE     (NOT (dbo.KB_BillMaterialData_Transfer.Parte LIKE N'ckt%')) AND (NOT (dbo.KB_BillMaterialData_Transfer.Parte LIKE N'tm%')) AND 
                      (NOT (dbo.KB_BillMaterialData_Transfer.Parte LIKE N'spl%')) AND (NOT (dbo.KB_BillMaterialData_Transfer.Parte LIKE N'dbl-%')) AND 
                      (NOT (dbo.KB_BillMaterialData_Transfer.Parte LIKE N'pot%')) AND (dbo.dbo_Fifo_Partes_No_Usuar_BOM.Parte IS NULL) AND 
                      (dbo.KB_Revisiones_Produccion.contenedorId = 164) AND (dbo.KB_BillMaterialData_Transfer.[Requerimiento Total] <> 0) AND 
                      (dbo.KB_Revisiones_Produccion.DiasProgramados <> 0)
GROUP BY dbo.KB_BillMaterialData_Transfer.Linea, dbo.KB_Revisiones_Produccion.DiasProgramados, dbo.KB_BillMaterialData_Transfer.materialista, 
                      dbo.KB_BillMaterialData_Transfer.Parte, 
                      ISNULL(dbo.KB_BillMaterialData_Transfer.entregado / (dbo.KB_BillMaterialData_Transfer.[Requerimiento Total] / dbo.KB_Revisiones_Produccion.DiasProgramados),
                       0), dbo.object.location, dbo.KB_Revisiones_Produccion.DiaArranque, dbo.KB_BillMaterialData_Transfer.[Requerimiento Total], 
                      dbo.KB_BillMaterialData_Transfer.Requerimiento
HAVING      (dbo.object.location = 'piso11-05 ')
GO
