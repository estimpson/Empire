SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_CausaInactivacion]
AS


SELECT        CausaInactivacionID, CausaInactivacion, DescripcionInactivacion, Categoria, Estado, CreateBy, CreateDT, LastModifyBy, LastModifyDT, DeleteBy, DeleteDT
FROM            Sistema.dbo.RH_CausaInactivacion


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
