SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_GetInventoryOfCircuits_Future](@FechaContenedor datetime,@FechaAuditTrail datetime)
AS 
BEGIN
	exec eeh.HN.RLSP_GetInventoryOfCircuits_Future @FechaContenedor,@FechaAuditTrail
END

GO
