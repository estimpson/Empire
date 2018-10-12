SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[VW_ATM_DatosPULL_JC] as
SELECT   p.*, a.date_stamp, t.Lote  
FROM            sistema.dbo.ATM_Resultados_PullTest p inner join audit_trail a on p.serial = a.serial 
				inner join (Select rawserial, Lote from EEH.dbo.TRW_LOG group by rawserial, Lote) t on t.rawserial = p.serial 
and type IN ('J','A')
GO
