SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwKomaxReporte]
AS
SELECT DISTINCT 
                      TOP 100 PERCENT HN.BF_rptProducedSerial.JCPart, HN.BF_rptProducedSerial.Machine, HN.BF_rptProducedSerial.JCSerial, 
                      HN.BF_rptProducedSerial.Operator, dbo.part_standard.material_cum, HN.BF_rptProducedSerial.Date_stamp AS Date_Stamp, 
                      HN.BF_rptProducedSerial.JCQty, HN.BF_rptProducedSerial.ProducedDate, HN.BF_rptProducedSerial.TransferDate, HN.BF_rptProducedSerial.Shift, 
                      Sistema.dbo.HC_Circuito_Componentes.Alambre, ISNULL(Sistema.dbo.HC_Circuito_Componentes.Terminal1, 0) AS Terminal1, 
                      ISNULL(Sistema.dbo.HC_Circuito_Componentes.Terminal2, 0) AS Terminal2,
                          (SELECT     CASE WHEN len(Sistema.dbo.TP_TerminalCFG.GrommetParte) <= 3 THEN NULL ELSE (Sistema.dbo.TP_TerminalCFG.GrommetParte) 
                                                   END) AS GrommetParte1,
                          (SELECT     CASE WHEN len(TP_TerminalCFG_1.GrommetParte) <= 3 THEN NULL ELSE (TP_TerminalCFG_1.GrommetParte) END) 
                      AS GrommetParte2
FROM         dbo.part_standard RIGHT OUTER JOIN
                      Sistema.dbo.TP_TerminalCFG RIGHT OUTER JOIN
                      Sistema.dbo.TP_TerminalCFG TP_TerminalCFG_1 RIGHT OUTER JOIN
                      Sistema.dbo.HC_Circuito_Componentes ON TP_TerminalCFG_1.TCFGID = Sistema.dbo.HC_Circuito_Componentes.Terminal1 ON 
                      Sistema.dbo.TP_TerminalCFG.TCFGID = Sistema.dbo.HC_Circuito_Componentes.Terminal2 RIGHT OUTER JOIN
                      HN.BF_rptProducedSerial ON Sistema.dbo.HC_Circuito_Componentes.Circuito = HN.BF_rptProducedSerial.JCPart ON 
                      dbo.part_standard.part = HN.BF_rptProducedSerial.JCPart
ORDER BY HN.BF_rptProducedSerial.Date_stamp
GO
