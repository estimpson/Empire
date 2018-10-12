SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [HN].[BF_SeriesDetalle]
AS
SELECT     CONVERT(varchar(10), X.Date_stamp, 101) AS Date_stamp, X.Operator, X.JCQty, X.JCSerial, X.ProducedDate, X.TransferDate, X.Machine, X.Shift, 
                      X.JCPart
FROM         (SELECT     JCLocation, Date_stamp, Machine, JCPart, Shift, Operator, JCSerial, JCQty, ProducedDate, TransferDate
                       FROM          HN.BF_rptProducedSerial
                       GROUP BY JCLocation, Date_stamp, Machine, JCPart, Shift, Operator, TransferDate, ProducedDate, JCSerial, JCQty) X LEFT OUTER JOIN
                          (SELECT     Part, Fecha, Machine, Operator
                            FROM          HN.BF_rptScrap
                            GROUP BY Fecha, Machine, Part, Operator) Y ON X.Date_stamp = Y.Fecha AND X.Machine = Y.Machine AND X.JCPart = Y.Part AND 
                      X.Operator = Y.Operator
GO
