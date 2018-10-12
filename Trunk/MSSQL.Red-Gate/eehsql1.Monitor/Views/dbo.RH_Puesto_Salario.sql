SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_Puesto_Salario]
AS



SELECT ID, PuestoID, Tipo_Puesto, Descripcion_PuestoRH 
FROM Sistema.dbo.RH_Puesto_Salario



GO
