SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Test3]
AS
	SELECT 
		* 
		FROM EDICHRY.CurrentShipSchedules()
GO