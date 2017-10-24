SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[EEH_Objects_Kanban_fxDelete] AS
SELECT SUM(dbo.object.quantity) AS Total, dbo.object.part, dbo.KB_BillMaterialData_Transfer.Linea
FROM dbo.object INNER JOIN dbo.KB_BillMaterialData_Transfer ON dbo.object.part = dbo.KB_BillMaterialData_Transfer.Parte AND (dbo.object.note = dbo.KB_BillMaterialData_Transfer.Linea or dbo.object.custom2 = dbo.KB_BillMaterialData_Transfer.Linea)
GROUP BY dbo.object.part, dbo.KB_BillMaterialData_Transfer.Linea
GO
