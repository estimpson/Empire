SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [HN].[PROC_PAY_GetData_AFP]
		@Month  int,
		@Year	int 
AS

/*
EXEC HN.PROC_PAY_GetData_AFP 6,2017
*/
BEGIN
	declare @Planillas table
	(	 PlanillaID			INT,
		 PlanillaDisplay	VARCHAR(100)
	)

	INSERT INTO @Planillas
	SELECT PlanillaID,coalesce(PlanillaIDToDisplay,convert(varchar(20),PlanillaID))
	FROM Sistema.dbo.PL_Planillas Planillas inner join 
			Sistema.dbo.PL_TipoPlanilla Tipo on Planillas.TipoPlanilla = Tipo.TIpoID
	WHERE	   DATEPART(MONTH,COALESCE(Hasta_Calculo,Desde)) = @Month
		   AND DATEPART(YEAR,COALESCE(Hasta_Calculo,Desde)) = @YEAR	
		   AND  TipoPlanilla in (2,3,22,26,27,18)	
		   AND Planillas.Estado = 0		   
	GROUP BY  PlanillaID,PlanillaIDToDisplay


	SELECT 	      DetallePlanilla.EmpleadoID,Nombre = empleados.Desplegar,DetallePlanilla.PlanillaIDToDisplay
			, AporteAFP_Total =   SUM(ISNULL(DetallePlanilla.AporteAFP_Total,0)) 
			FROM Sistema.dbo.PL_PAY_DetallePlanilla DetallePlanilla 
				INNER JOIN 
					@Planillas planillas on DetallePlanilla.PlanillaID = Planillas.PlanillaID 
				INNER JOIN
					Sistema.dbo.RH_Empleados empleados on DetallePlanilla.empleadoID = Empleados.EmpleadoId
			GROUP BY DetallePlanilla.EmpleadoID,empleados.Desplegar,DetallePlanilla.PlanillaIDToDisplay
			HAVING SUM(ISNULL(DetallePlanilla.AporteAFP_Total,0)) >0

END
GO
