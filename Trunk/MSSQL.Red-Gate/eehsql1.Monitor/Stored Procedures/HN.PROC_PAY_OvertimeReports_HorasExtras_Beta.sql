SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[PROC_PAY_OvertimeReports_HorasExtras_Beta]
	@FechaInicial		Date,
	@fechaFinal			Date,
	@Planta				VARCHAR(30)=NULL,			-- Opciones: EEH, PCB
	@ModoPlanilla		VARCHAR(30)=NULL			-- Opciones: Semanal, Quincenal, 4*4
AS
BEGIN
		exec sistema.hn.PROC_PAY_OvertimeReports_HorasExtras_Beta @FechaInicial, @fechaFinal,@Planta,@ModoPlanilla
		--,@Planta,@ModoPlanilla
END
GO
