SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[BF_rptScrapporMaquina]
AS
SELECT     TOP 100 PERCENT dbo.defect_codes.name AS Defect_Description, dbo.Defects.Machine, dbo.Defects.Part, dbo.Defects.DefectCode, 
                      dbo.WODetails.Part AS Circuit, dbo.Defects.Operator, dbo.Defects.QtyScrapped, dbo.part_standard.material_cum, 
                      dbo.Defects.QtyScrapped * dbo.part_standard.material_cum AS Totalcosto, dbo.defect_codes.code, dbo.Defects.Shift,
                          (SELECT     CONVERT(NVARCHAR(11), (dbo.Defects.TransactionDT), 101)) AS TransactionDT
FROM         dbo.WODetails INNER JOIN
                      dbo.Defects ON dbo.WODetails.WOID = dbo.Defects.WODID LEFT OUTER JOIN
                      dbo.part_standard ON dbo.Defects.Part = dbo.part_standard.part LEFT OUTER JOIN
                      dbo.defect_codes ON dbo.Defects.DefectCode = dbo.defect_codes.code
GROUP BY dbo.defect_codes.name, dbo.Defects.Machine, dbo.Defects.Part, dbo.Defects.DefectCode, dbo.WODetails.Part, dbo.Defects.Operator, 
                      dbo.Defects.QtyScrapped, dbo.part_standard.material_cum, dbo.Defects.QtyScrapped * dbo.part_standard.material_cum, dbo.defect_codes.code, 
                      dbo.Defects.Shift, dbo.Defects.TransactionDT
HAVING      (NOT (dbo.Defects.DefectCode LIKE 'Qty%')) AND (NOT (dbo.Defects.DefectCode LIKE 'Cantidad%')) AND
                          ((SELECT     CONVERT(NVARCHAR(11), (dbo.Defects.TransactionDT), 101)) >= '01/16/2008') AND
                          ((SELECT     CONVERT(NVARCHAR(11), (dbo.Defects.TransactionDT), 101)) <= '01/18/2008') AND (dbo.Defects.Machine = 'komax24')
ORDER BY dbo.Defects.QtyScrapped * dbo.part_standard.material_cum
GO
