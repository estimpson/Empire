SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[BF_QtyProducida]
AS
SELECT DISTINCT TOP 100 PERCENT dbo.WOHeaders.Machine, SUM(dbo.BackFlushHeaders.QtyProduced) AS JCQty,
                          (SELECT     CONVERT(NVARCHAR(11), (WOShift.ShiftDate), 101)) AS [Date], dbo.WOShift.Shift, dbo.WODetails.Part
FROM         dbo.BackFlushHeaders LEFT OUTER JOIN
                      dbo.WOHeaders RIGHT OUTER JOIN
                      dbo.WOShift RIGHT OUTER JOIN
                      dbo.WODetails ON dbo.WOShift.WOID = dbo.WODetails.WOID ON dbo.WOHeaders.ID = dbo.WODetails.WOID ON 
                      dbo.BackFlushHeaders.WODID = dbo.WODetails.ID
WHERE     (dbo.BackFlushHeaders.SerialProduced NOT IN
                          (SELECT     DefectSerial
                            FROM          Defects))
GROUP BY dbo.WOHeaders.Machine, dbo.WOShift.ShiftDate, dbo.WOShift.Shift, dbo.WODetails.Part
ORDER BY dbo.WOHeaders.Machine
GO
