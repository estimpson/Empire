SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [HN].[VW_PCB_GetAditorias_MoldesParametros] as 

SELECT wos.Part,wos.Machine,Parametros.Nombre,Moldes.TipoMaterial,Moldes.Cavidad,Historial.Parametro,Historial.Operador,Historial.Fecha
	  ,Historial.ParametroMin,Historial.ParametroMax,Historial.WOID 
FROM Sistema.dbo.TP_Parametros  Parametros  INNER JOIN 
		 Sistema.dbo.TP_Parametros_Moldes Moldes ON Parametros.EspecificacionID = Moldes.EspecificacionID INNER JOIN 
			Sistema.dbo.TP_Parametros_Operador Historial ON Historial.ParametrosMoldes = Moldes.ParametrosMoldes INNER JOIN 
				eeh.dbo.wos wos ON wos.ID = Historial.WOID	INNER JOIN 
					eeh.dbo.part part ON		part.part = wos.Part 
										AND		part.product_line = 'PCB'
WHERE Historial.Fecha > '2017-05-01'



GO
