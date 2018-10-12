SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE View [dbo].[VW_DatosAuditoria_TRW_HxH] as
SELECT       SA_HistorialPreguntas_Respuestas.TipoPreguntaID, SA_PreguntasLog.Descripcion, SA_PreguntasLog.Min, SA_PreguntasLog.Max, SA_HistorialPreguntas_Respuestas.Respuesta, 
                         SA_HistorialPreguntas_Respuestas.Operator_Code, SA_HistorialPreguntas_Respuestas.Fecha, SA_HistorialPreguntas_Respuestas.Parte, 
                         SA_HistorialPreguntas_Respuestas.Comentario, SA_HistorialPreguntas_Respuestas.Serie AS WO, SA_HistorialPreguntas_Respuestas.RegDT
FROM           sistema.dbo.SA_HistorialPreguntas_Respuestas SA_HistorialPreguntas_Respuestas INNER JOIN
sistema.dbo.SA_PreguntasLog                         SA_PreguntasLog ON SA_HistorialPreguntas_Respuestas.PreguntaID = SA_PreguntasLog.PreguntaID
WHERE        (SA_HistorialPreguntas_Respuestas.TipoPreguntaID in (103, 104))
GO
