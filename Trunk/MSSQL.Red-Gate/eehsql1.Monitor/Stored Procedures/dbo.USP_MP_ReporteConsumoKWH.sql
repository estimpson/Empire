SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


/*

EXEC USP_MP_ReporteConsumoKWH '2018-07-01','2018-07-18'

*/
CREATE PROCEDURE [dbo].[USP_MP_ReporteConsumoKWH] (@fechaI date,@FechaF date)

AS
BEGIN


select FECHACONSUMO=convert(date,FECHACONSUMO),nombreplanta,CONSUMOKWH=SUM(CONSUMOKWH),ConsumoDolares=(SUM(CONSUMOKWH)*(select top 1 PrecioKWH from sistema.dbo.MP_ConsumoEnergia_Header)) from SISTEMA.DBO.MP_ConsumoEnergia_Header header
inner join SISTEMA.DBO.MP_ConsumoEnergia_LecturaDiario_Detalle detalle on header.Contador=detalle.Contador
where convert(datetime,FechaConsumo)>= @fechaI and convert(datetime,FechaConsumo)<=@FechaF
GROUP BY nombreplanta,FECHACONSUMO
ORDER BY FECHACONSUMO


END
GO
GRANT EXECUTE ON  [dbo].[USP_MP_ReporteConsumoKWH] TO [public]
GO
GRANT ALTER ON  [dbo].[USP_MP_ReporteConsumoKWH] TO [public]
GO
GRANT CONTROL ON  [dbo].[USP_MP_ReporteConsumoKWH] TO [public]
GO
GRANT TAKE OWNERSHIP ON  [dbo].[USP_MP_ReporteConsumoKWH] TO [public]
GO
GRANT VIEW DEFINITION ON  [dbo].[USP_MP_ReporteConsumoKWH] TO [public]
GO
