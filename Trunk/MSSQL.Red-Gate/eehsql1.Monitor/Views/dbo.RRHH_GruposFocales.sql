SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RRHH_GruposFocales]
AS


SELECT        ID, Titulo, FechaGrupo, CantidadParticipantes, CreateDT, CreateUser
FROM            Sistema.dbo.RRHH_GruposFocales



GO
