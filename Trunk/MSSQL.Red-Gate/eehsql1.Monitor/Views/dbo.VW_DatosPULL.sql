SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VW_DatosPULL] as
select dato=avg(value),  RawSerial, lote 
from sistema.dbo.ATM_Resultados_PullTest 
right join TRW_LOG on trw_log.RawSerial = ATM_Resultados_PullTest.serial 
where lote is not null
group by  RawSerial , lote
GO
