SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Entregado]
AS
SELECT     TOP 100 PERCENT dbo.KB_BillMaterialData_Transfer.Parte, SUM(dbo.object.quantity) AS cantidad, dbo.object.note
FROM         dbo.object INNER JOIN
                      dbo.KB_BillMaterialData_Transfer ON dbo.object.part = dbo.KB_BillMaterialData_Transfer.Parte
WHERE     (dbo.object.note = 'PST0001-HB00')
GROUP BY dbo.KB_BillMaterialData_Transfer.Parte, dbo.object.note
ORDER BY dbo.KB_BillMaterialData_Transfer.Parte
GO
