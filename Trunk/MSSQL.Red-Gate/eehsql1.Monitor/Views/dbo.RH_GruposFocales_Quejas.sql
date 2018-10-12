SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_GruposFocales_Quejas]
AS


SELECT        ID, Queja, IDTema
FROM            Sistema.dbo.RRHH_GruposFocales_Quejas





GO
