SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VW_PCB_UltimasLiberaciones_Maestros] as 

SELECT		Liberaciones.PE_Estacion
		,	Liberaciones.Part
		,   Fecha_UltimaLiberacion = Fecha 
		,	DiasLiberacion = DATEDIFF(DAY,Fecha,GETDATE())
		,	Status = CASE WHEN DATEDIFF(DAY,Fecha,GETDATE()) > 3 THEN 'Vencido' else 'Validada' END
FROM Sistema.dbo.Cal_Liberaciones Liberaciones INNER JOIN 
		( Select	 UltimaLiberacion = MAX(LiberacionID)
					,PE_Estacion
			from Sistema.dbo.cal_liberaciones
			WHERE PE_Estacion is not null 
			GROUP BY PE_Estacion 
		) xLiberacion  ON Liberaciones.LiberacionID = xLiberacion.UltimaLiberacion 



GO
