SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_GruposFocales_RespuestasporParticipante]
AS


SELECT        ID, GrupoFocalID, participante, PreguntaID, Puntuacion
FROM            Sistema.dbo.RRHH_GruposFocales_RespuestasporParticipante





GO
