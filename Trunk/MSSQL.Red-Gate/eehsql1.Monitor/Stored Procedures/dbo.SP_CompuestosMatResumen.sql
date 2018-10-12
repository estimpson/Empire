SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[SP_CompuestosMatResumen]
AS
BEGIN


Declare @Datos1 table
(
	compuesto varchar(35),
	total decimal(12,6)
)

Declare @Datos2 table
(
	compuesto varchar(35),
	tipo1 varchar(35),
	total decimal(12,6)
)

Insert into @Datos1( compuesto, total )

SELECT compuesto, MAX(total) FROM 
(
SELECT        wpart.Part AS compuesto, (CASE WHEN wpart.part IS NULL THEN 'Virgin excess BOM' WHEN (wpart.part IS NOT NULL AND colorantes.part IS NOT NULL) 
                         THEN 'Regrind' WHEN wpart.part LIKE '%MIX%' THEN 'Mixed' ELSE 'Virgin With Colorant' END) AS tipo1, SUM(compuesto.Qty * mps.qnty) AS total
FROM            master_prod_sched AS mps INNER JOIN
                         part_machine AS pm ON pm.part = mps.part INNER JOIN
                         CP_Contenedores AS cp ON cp.FechaEEH = mps.rel_date INNER JOIN
                             (SELECT        bom.TopPart, bom.Part, bom.Qty
                               FROM            HN.BOM_Query AS bom INNER JOIN
                                                         part AS p ON p.part = bom.Part
                               WHERE        (p.commodity = 'compound')) AS compuesto ON compuesto.TopPart = mps.part LEFT OUTER JOIN
                             (SELECT        bom.TopPart, bom.Part, x.ChildPart
                               FROM            HN.BOM_Query AS bom INNER JOIN
                                                         part AS p ON p.part = bom.Part INNER JOIN
                                                         FT.XRt AS x ON x.TopPart = bom.Part
                               WHERE        (p.commodity = 'regrind')) AS wpart ON wpart.TopPart = mps.part AND wpart.ChildPart = compuesto.Part INNER JOIN
                         part AS p2 ON p2.part = mps.part LEFT OUTER JOIN
                             (SELECT        bom1.TopPart, bom1.Part
                               FROM            HN.BOM_Query AS bom1 INNER JOIN
                                                         part AS p2 ON p2.part = bom1.Part
                               WHERE        (p2.commodity = 'colorante')) AS colorantes ON colorantes.TopPart = wpart.TopPart
WHERE        (cp.Activo = 1) AND (pm.machine IN ('moldeo', 'sobremold')) AND (compuesto.Part NOT LIKE '%8621%') AND (p2.commodity <> 'regrind')
GROUP BY wpart.Part, CASE WHEN wpart.part IS NULL THEN 'Virgin excess BOM' WHEN (wpart.part IS NOT NULL AND colorantes.part IS NOT NULL) 
                         THEN 'Regrind' WHEN wpart.part LIKE '%MIX%' THEN 'Mixed' ELSE 'Virgin With Colorant' END
) AS Datos
GROUP BY compuesto



Insert into @Datos2( compuesto, tipo1, total )

SELECT        wpart.Part AS compuesto, (CASE WHEN wpart.part IS NULL THEN 'Virgin excess BOM' WHEN (wpart.part IS NOT NULL AND colorantes.part IS NOT NULL) 
                         THEN 'Regrind' WHEN wpart.part LIKE '%MIX%' THEN 'Mixed' ELSE 'Virgin With Colorant' END) AS tipo1, SUM(compuesto.Qty * mps.qnty) AS total
FROM            master_prod_sched AS mps INNER JOIN
                         part_machine AS pm ON pm.part = mps.part INNER JOIN
                         CP_Contenedores AS cp ON cp.FechaEEH = mps.rel_date INNER JOIN
                             (SELECT        bom.TopPart, bom.Part, bom.Qty
                               FROM            HN.BOM_Query AS bom INNER JOIN
                                                         part AS p ON p.part = bom.Part
                               WHERE        (p.commodity = 'compound')) AS compuesto ON compuesto.TopPart = mps.part LEFT OUTER JOIN
                             (SELECT        bom.TopPart, bom.Part, x.ChildPart
                               FROM            HN.BOM_Query AS bom INNER JOIN
                                                         part AS p ON p.part = bom.Part INNER JOIN
                                                         FT.XRt AS x ON x.TopPart = bom.Part
                               WHERE        (p.commodity = 'regrind')) AS wpart ON wpart.TopPart = mps.part AND wpart.ChildPart = compuesto.Part INNER JOIN
                         part AS p2 ON p2.part = mps.part LEFT OUTER JOIN
                             (SELECT        bom1.TopPart, bom1.Part
                               FROM            HN.BOM_Query AS bom1 INNER JOIN
                                                         part AS p2 ON p2.part = bom1.Part
                               WHERE        (p2.commodity = 'colorante')) AS colorantes ON colorantes.TopPart = wpart.TopPart
WHERE        (cp.Activo = 1) AND (pm.machine IN ('moldeo', 'sobremold')) AND (compuesto.Part NOT LIKE '%8621%') AND (p2.commodity <> 'regrind')
GROUP BY wpart.Part, CASE WHEN wpart.part IS NULL THEN 'Virgin excess BOM' WHEN (wpart.part IS NOT NULL AND colorantes.part IS NOT NULL) 
                         THEN 'Regrind' WHEN wpart.part LIKE '%MIX%' THEN 'Mixed' ELSE 'Virgin With Colorant' END



SELECT Datos1.compuesto, Datos2.tipo1, Datos2.total 
FROM @Datos1 AS Datos1
	INNER JOIN @Datos2 AS Datos2
		ON Datos1.compuesto = Datos2.compuesto
			AND CONVERT( DECIMAL, Datos1.total) = CONVERT( DECIMAL, Datos2.total) 

end
GO
