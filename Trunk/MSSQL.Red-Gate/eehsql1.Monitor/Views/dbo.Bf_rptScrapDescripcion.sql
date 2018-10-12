SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Bf_rptScrapDescripcion]
AS
SELECT     dbo.BackFlushHeaders.PartProduced, CONVERT(DateTime, CAST(dbo.Defects.TransactionDT AS int), 101) AS Date_Stamp, 
                      SUM(dbo.BackFlushHeaders.QtyProduced * dbo.part_standard.material_cum) AS Extend, dbo.Defects.DefectCode, dbo.Defects.Machine,
                          (SELECT     CONVERT(NVARCHAR(11), (dbo.Defects.TransactionDT), 101)) AS [Date], dbo.Defects.TransactionDT
FROM         dbo.BackFlushHeaders INNER JOIN
                      dbo.Defects ON dbo.BackFlushHeaders.SerialProduced = dbo.Defects.DefectSerial INNER JOIN
                      dbo.part_standard ON dbo.BackFlushHeaders.PartProduced = dbo.part_standard.part
GROUP BY CONVERT(DateTime, CAST(dbo.Defects.TransactionDT AS int), 101), dbo.BackFlushHeaders.PartProduced, dbo.Defects.DefectCode, 
                      dbo.Defects.Machine, dbo.Defects.TransactionDT
GO
