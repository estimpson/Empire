SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [HN].[VW_YEAR] AS 

	SELECT DT_Year = 2017	UNION ALL 
	SELECT DT_Year = 2018	UNION ALL 
	SELECT DT_Year = 2019	UNION ALL 
	SELECT DT_Year = 2020	

GO
