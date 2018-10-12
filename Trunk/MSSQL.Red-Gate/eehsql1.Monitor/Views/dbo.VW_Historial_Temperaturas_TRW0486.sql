SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[VW_Historial_Temperaturas_TRW0486] as
SELECT       SA_HistorialPreguntas_Respuestas.Parte, SA_PreguntasLog.Descripcion, SA_HistorialPreguntas_Respuestas.Respuesta, 
                         SA_HistorialPreguntas_Respuestas.Comentario, SA_HistorialPreguntas_Respuestas.Operator_Code, SA_HistorialPreguntas_Respuestas.Serie AS WO, 
                         SA_HistorialPreguntas_Respuestas.RegDT, SA_PreguntasLog.Min, SA_PreguntasLog.Max
FROM            sistema.dbo.SA_HistorialPreguntas_Respuestas INNER JOIN
                         sistema.dbo.SA_PreguntasLog ON SA_HistorialPreguntas_Respuestas.PreguntaID = SA_PreguntasLog.PreguntaID
WHERE        (SA_PreguntasLog.GrupoID = 105)
GO
