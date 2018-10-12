SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_CP_FIFO_CalculoPorcentaje]( @FechaInicio AS datetime, @FechaFinal AS datetime) 

AS

SET DATEFORMAT ymd
SET @FechaFinal = @FechaFinal +1
--set transaction isolation level read uncommitted

			
SELECT	fifo.Serie, max(audit_trail.part) AS Part, fifo.FechaRegistro, fifo.Comentario,fifo.autoriza,@FechaInicio AS FechaIni, (@FechaFinal-1) AS FechaFin,
		Porcentaje = (1-(
((SELECT count(Serie)
		FROM	sistema.dbo.Fifo_Registro_Series_OK  
		WHERE	fecharegistro >= @FechaInicio AND fecharegistro <=@FechaFinal AND Autoriza IS NOT NULL AND Fifo.Autoriza <>'WREYE')*1.0)/
((SELECT count(Serie)
		FROM	sistema.dbo.Fifo_Registro_Series_OK  
		WHERE	fecharegistro >= @FechaInicio AND fecharegistro <=@FechaFinal)*1.0)))*100
FROM	sistema.dbo.Fifo_Registro_Series_OK AS Fifo INNER JOIN audit_trail
		ON fifo.Serie = audit_trail.serial
WHERE	FIFO.FechaRegistro >= @FechaInicio AND FIFO.FechaRegistro <=@FechaFinal
		AND Fifo.Autoriza IS NOT NULL AND Fifo.Autoriza <>'WREYE'
GROUP BY fifo.Serie, fifo.FechaRegistro, fifo.Comentario, fifo.autoriza
GO
