SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VWParetoScrap]
AS
SELECT     TOP 5 JCPart, SUM(QtyScrapped * material_cum) AS scrap, Date_stamp
FROM         dbo.vwKomaxReporte
WHERE     (QtyScrapped * material_cum IS NOT NULL)
GROUP BY JCPart, Date_stamp
ORDER BY SUM(QtyScrapped * material_cum) DESC
GO
