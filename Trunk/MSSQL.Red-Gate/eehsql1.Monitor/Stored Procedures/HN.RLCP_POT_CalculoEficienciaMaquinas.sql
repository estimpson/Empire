SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLCP_POT_CalculoEficienciaMaquinas](@FechaInicio datetime, @Fechafinal datetime,@HorasProgramadas decimal(9,3))
AS
BEGIN
	EXEC eeh.HN.RLCP_POT_CalculoEficienciaMaquinas @FechaInicio , @Fechafinal ,@HorasProgramadas
END
GO
