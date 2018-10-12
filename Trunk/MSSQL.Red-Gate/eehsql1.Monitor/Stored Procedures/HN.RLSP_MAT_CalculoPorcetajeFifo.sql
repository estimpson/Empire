SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_MAT_CalculoPorcetajeFifo](@FechaInicio datetime, @FechaFinal datetime)
AS
begin
	EXEC EEH.HN.RLSP_MAT_CalculoPorcetajeFifo @FechaInicio,@FechaFinal
end
GO
