SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[PCB_AuditoriaProceso]
as
select Operator_code, liberacion.TransDT, Responsable, Part, PruebaElectNo, Pregunta, respuesta=respuestas.Estado
from Sistema.dbo.Cal_Liberaciones liberacion
	inner join Sistema.dbo.Cal_Liberacion_Preguntas respuestas on liberacion.LiberacionID=respuestas.LiberacionID
	inner join (SELECT DISTINCT x.ID AS PreguntaIDs, x.Pregunta, LineasPreguntas.Linea
				FROM         Sistema.dbo.sa_preguntas AS x RIGHT OUTER JOIN
                Sistema.dbo.CAL_Asoc_LineasPreguntas AS LineasPreguntas ON x.ID = LineasPreguntas.PreguntaID WHERE [tipo] = 'CC') Preguntas on Preguntas.PreguntaIDs = respuestas.PreguntaID and Preguntas.Linea=LEFT(part,7)
GO
