SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[SP_PCB_Produccion_GetHorario] 
	@ContenedorID  INT  = NULL  
AS
BEGIN
			EXEC eeh.hn.SP_PCB_Produccion_GetHorario @ContenedorID  
		--,@Planta,@ModoPlanilla
END
GO
