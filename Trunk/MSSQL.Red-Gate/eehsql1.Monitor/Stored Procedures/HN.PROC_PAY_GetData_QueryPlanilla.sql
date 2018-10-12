SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [HN].[PROC_PAY_GetData_QueryPlanilla] 
	@DisplayPlanilla  VARCHAR(25) 
AS
BEGIN
		Exec EEH.HN.PROC_PAY_GetData_QueryPlanilla @DisplayPlanilla
		--,@Planta,@ModoPlanilla
END
GO
