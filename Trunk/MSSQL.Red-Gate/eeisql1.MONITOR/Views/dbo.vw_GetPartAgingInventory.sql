SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_GetPartAgingInventory] AS

SELECT * FROM [dbo].[udf_GetPartAgingInventory]()
GO
