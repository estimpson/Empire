SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[PROC_PAY_OvertimeReports_HorasExtras]
	@FechaInicial		Date,
	@fechaFinal			Date
	--@Planta				VARCHAR(15)=NULL,			-- Opciones: EEH, PCB
	--@ModoPlanilla		VARCHAR(15)=NULL			-- Opciones: Semanal, Quincenal, 4*4
AS
BEGIN
		exec sistema.hn.PROC_PAY_OvertimeReports_HorasExtras @FechaInicial, @fechaFinal
		--,@Planta,@ModoPlanilla
END
GO
