SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [HN].[RLSP_CP_InventarioCircuito_PM_InvInicial]
			(@FechaAuditTrail datetime,
			 @FechaContenedor datetime )
returns @Reporte table
	(	Circuito	varchar(25),
		TotalEntregado numeric(20,6),
		ReleaseContenedor	numeric(20,6),
		InventarioInicial	decimal(18,6))
as
begin
------------ DECLARACION Y SETEO DE VARIABLES --------------------
------------------------------------------------------------------
--
declare @Fecha datetime,
		@Contenedor int
/*
	select	*
	from	hn.RLSP_CP_InventarioCircuito_PM_InvInicial( '2008-07-7', '2008-07-13' )
	where	circuito like 'TM-AUT0003/0004-01'
*/

select @Fecha = SystemDate from HN.SystemDate

select	@Contenedor = ContenedorID
from sistema.dbo.cp_contenedores 
where datediff(d, @FechaContenedor, FechaEEH) = 0


declare	@ResumenInventario table
	(	Circuito varchar(25),
		TotalEntregado numeric(20,6),
		ReleaseContenedor numeric(20,6)
		)

insert @ResumenInventario( Circuito, TotalEntregado, ReleaseContenedor )
SELECT	Resumen.Circuito, 
		TotalEntregado = avg((isnull(TotalEnsamble,0)+isnull(TotalFG,0)+isnull(TotalPotting ,0)+isnull(TotalEstacionProc,0))),
		ReleaseContenedor = sum(RelaseContenedor)
FROM(
------------------------------------------------------------------------------
--OBTENGO LA PROGRAMACION DEL RELEASE Y DE PRODUCCION PARA SABER CUANDO CARGAR
------------------------------------------------------------------------------
SELECT	* from (
SELECT 	bom.part AS Circuito,
		RelaseContenedor = ProgramacionLineas.RelaseContenedor * BOM.Quantity
FROM 
	(	SELECT	CP.Part,
				RelaseContenedor = CP.Revision
		FROM	sistema.dbo.CP_Revisiones_Produccion_Asignacion CP
		WHERE	CP.ContenedorID = @Contenedor
				AND CP.Revision>0 AND part NOT LIKE 'PRE%'
	) AS ProgramacionLineas 
	JOIN HN.SA_BillMaterialData AS BOM ON ProgramacionLineas.Part = bom.originalpart
	LEFT JOIN sistema.dbo.HC_Circuito_Componentes hcc ON hcc.Part = bom.originalpart AND hcc.Circuito = bom.part
WHERE bom.type='W' AND bom.parent_part NOT LIKE 'DBL%' AND LEFT(bom.part,3) IN ('TM-','SPL')) AS RELEASE

LEFT OUTER JOIN 
------------------------------------------------------------------------------
--OBTENGO TODO LO QUE ESTE EN OBJECT EN LOCATION ENSAMBLE
------------------------------------------------------------------------------
(SELECT	object.part AS CircuitoE, 
		SUM(object.quantity) AS TotalEnsamble
FROM	Monitor.dbo.object AS Object
WHERE	object.location IN (SELECT code FROM location WHERE group_no='Ensamble')		
		AND object.status !='R'
		and object.location != 'MANUFACTUR'
		AND object.location NOT LIKE 'LOST%'
		AND object.part IN (SELECt part FROM part where type = 'W')
GROUP BY object.part) AS ENSAMBLE

ON ENSAMBLE.CircuitoE = RELEASE.Circuito

LEFT OUTER JOIN 
------------------------------------------------------------------------------
--OBTENGO TODO LO QUE ESTE EN OBJECT EN LOCATION ESTACION, TM, SPL
------------------------------------------------------------------------------
(SELECT part AS CircuitoEP,	
	SUM(quantity) AS TotalEstacionProc	
FROM  eeh.dbo.object object
WHERE	LEFT(object.location,3) IN ('EST','TM-','SP-') 
		AND (location <> 'ESTCUT-6' and location <> 'ESTCUT-12' and location <> 'BOD-CKTOBS')					  
		AND object.status !='R'
		AND LEFT(part,3) IN ('SPL','TM-')
GROUP BY object.part) AS Estacion_Procesos
ON Estacion_Procesos.CircuitoEP = RELEASE.Circuito


LEFT OUTER JOIN
------------------------------------------------------------------------------
--DESCOMPOSICION DE TODAS LAS PARTES QUE SON FG Y QUE TENGAN UN JOB COMPLETE
------------------------------------------------------------------------------
(SELECT	xrt.childpart AS CircuitoF, 
		isnull(sum(quantity * xrt.xQty),0) AS TotalFG 		
FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				   INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
WHERE	LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-')
		AND part.type='F'
		AND audit_trail.type='J' 
		AND audit_trail.date_stamp>=@FechaAuditTrail
		AND part.part IN (  SELECT	Part.PART	
							FROM	part 
							WHERE	part.type='F' 
									AND part.group_technology in ('Manufactura','Ensamble'))
GROUP BY xrt.childpart) AS FinishGoods

ON FinishGoods.CircuitoF = RELEASE.Circuito

LEFT OUTER JOIN
------------------------------------------------------------------------------
--DESCOMPOSICION DE TODAS LAS PARTES QUE TIENEN POTTING
------------------------------------------------------------------------------



(SELECT	xrt.childpart AS CircuitoP, 
		sum(Potting.Cantidad * xrt.xQty) AS TotalPotting
FROM ft.xrt XRT INNER JOIN
					(SELECT object.part, isnull(Sum(object.quantity),0) AS Cantidad
					FROM Monitor.dbo.object object
					WHERE (object.part Like 'pre-%') 
					AND (object.location Not Like 'ret%')
					AND (object.location NOT LIKE 'recha%')
					AND (object.location NOT LIKE 'LOST%')
					AND (object.status !='R')  
					GROUP BY object.part
					UNION ALL
					SELECT object.part, isnull(Sum(object.quantity),0) AS Cantidad
					FROM Monitor.dbo.object object
					WHERE (object.part Like 'mold-%') 
					AND (object.location Not Like 'ret%')
					AND (object.location NOT LIKE 'recha%')
					AND (object.status ='A')  
					GROUP BY object.part
					UNION ALL
					SELECT object.part, isnull(Sum(object.quantity),0) AS Cantidad
					FROM Monitor.dbo.object object
					WHERE (object.part Like 'pot-%') 
					AND (object.location Not Like 'ret%') 
					AND (object.location Not Like 'pt%') 
					AND (object.location NOT LIKE 'LOST%')
					AND (object.location NOT LIKE 'recha%')
					AND (exists (SELECT 1 FROM location  
									 WHERE location.group_no in ('Ensamble','Manufactura','Bodega-Moldeo')
									 AND code=object.location))
					AND (object.status !='R')  							
					GROUP BY object.part) AS Potting 
				ON Potting.part = xrt.toppart
WHERE LEFT(xrt.toppart,3) IN ('PRE','POT','MOL') AND LEFT(xrt.childpart,3) IN ('SPL','TM-')
GROUP BY xrt.childpart) AS CircuitosPotting

ON CircuitosPotting.CircuitoP = RELEASE.Circuito) AS Resumen
group by Resumen.Circuito

/*
SELECT  Circuito, 
		Ubicacion, 
		Color,
		sum(RelaseContenedor) RelaseContenedor, 
		sum(Dia1) Dia1, 
		sum(Dia2) Dia2, 
		sum(Dia3) Dia3,
		sum(Dia4) Dia4, 
		sum(Dia5) Dia5, 
		sum(Dia6) Dia6, 
		sum(ReleaseDiario) ReleaseDiario,
		avg(TotalEstacionProc) TotalEstacionProc,
		avg(TotalEnsamble) TotalEnsamble, 
		avg(TotalFG ) TotalFG,
		avg(TotalPotting) TotalPotting,
		avg(TotalEntregado) TotalEntregado		
FROM #Inventario AS data
GROUP BY Circuito, 
		Ubicacion, 
		Color
ORDER BY  substring(data.Circuito,
		charindex('-',data.Circuito)+1,
		charindex('-',data.Circuito,charindex('-',data.Circuito)+1)-(charindex('-',data.Circuito)+1))
		,data.Circuito , Data.TotalEntregado

DROP TABLE #Inventario
*/

insert @Reporte( Circuito,  TotalEntregado, ReleaseContenedor,InventarioInicial )
select	Circuito, TotalEntregado, ReleaseContenedor, (ReleaseContenedor - TotalEntregado) * -1
from	@ResumenInventario

return
end


GO
