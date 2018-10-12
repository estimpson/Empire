SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [HN].[BF_DatosMaquina]
AS
SELECT     TOP 100 PERCENT JCPart, Shift, Operator, COUNT(JCSerial) AS Bandos, SUM(JCQty) AS QtyProduced, Machine, CONVERT(VARCHAR(10), Date_stamp, 
                      101) AS Date_Stamp
FROM         HN.BF_rptProducedSerial
GROUP BY JCPart, Shift, Operator, Machine, CONVERT(VARCHAR(10), Date_stamp, 101)
ORDER BY JCPart
GO
