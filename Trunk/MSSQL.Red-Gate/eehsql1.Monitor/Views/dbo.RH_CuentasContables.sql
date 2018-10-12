SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_CuentasContables]
AS

SELECT CuentaContable = DES_CORTA,
DescripcionCuentaContable = CASE WHEN DES_CORTA = '506012' THEN 'Directos Empire'
								 WHEN DES_CORTA = '556012' THEN 'Indirecto Empire'
								 WHEN DES_CORTA = '506008' THEN 'Directos PCB'
								 WHEN DES_CORTA = '556008' THEN 'Indirectos PCB'
							END 
FROM iTPayroll.dbo.MAE_TABLA_DET WHERE (TIP_TABLA IN ('CNT_CONTA'))


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
