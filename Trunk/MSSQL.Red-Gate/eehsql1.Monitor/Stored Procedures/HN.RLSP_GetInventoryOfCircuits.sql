SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_GetInventoryOfCircuits](@FechaContenedor datetime,@FechaAuditTrail datetime)
AS 
BEGIN
		SELECT * FROM Monitor.dbo.Corte_InventarioProduccion WITH (READuncommitted)--WITH (nolock,READuncommitted, index(idx1_Corte_InventarioProduccion)) 
	WHERE TipoInventario='A'
	order by substring(Circuito,5,7), Circuito
END



GO
