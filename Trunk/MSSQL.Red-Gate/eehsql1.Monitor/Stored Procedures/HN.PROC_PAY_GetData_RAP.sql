SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	exe Monitor.hn.PROC_PAY_GetData_RAP 4,2017
*/
CREATE PROCEDURE [HN].[PROC_PAY_GetData_RAP] 
	@Month  int,
	@Year	int 

AS
BEGIN
		SELECT 	      DetallePlanilla.EmpleadoID
			, Devengado =   SUM(ISNULL(DetallePlanilla.TotalHorasNormales_Lps,0)) + SUM(ISNULL(DetallePlanilla.TotalHorasRecargoJornadaNocturna_Lps,0)) +  SUM(ISNULL(DetallePlanilla.TotalFeriado_Lps,0))
						+ SUM(ISNULL(DetallePlanilla.TotalVacaciones_Lps,0)) 
			, RAPAcumulado = SUM(DetallePlanilla.RAP_Cuentas_Individuales)
			FROM Sistema.dbo.PL_PAY_DetallePlanilla DetallePlanilla INNER JOIN 
						Sistema.HN.fn_PAY_RAP_GetPayroll_ByMonth(@Month,@Year) Planillas on DetallePlanilla.PlanillaID = Planillas.PlanillaID 
			GROUP BY DetallePlanilla.EmpleadoID
END
GO
