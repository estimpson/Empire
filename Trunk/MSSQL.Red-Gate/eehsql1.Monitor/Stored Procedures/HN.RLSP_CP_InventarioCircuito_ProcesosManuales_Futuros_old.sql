SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_CP_InventarioCircuito_ProcesosManuales_Futuros_old](@FechaAuditTrail datetime, @FechaContenedor datetime )
as
------------ DECLARACION Y SETEO DE VARIABLES --------------------
------------------------------------------------------------------
--
DECLARE @Fecha datetime,
		@Contenedor int,
		@FechaContenedorAnterior datetime
		
/*
exec HN.RLSP_CP_InventarioCircuito_ProcesosManuales_Futuros '2008-07-07','2008-07-20'
*/

SET @fecha = getdate()
select	@Contenedor = ContenedorID
from sistema.dbo.cp_contenedores 
where datediff(d, @FechaContenedor, FechaEEH) = 0

set	@FechaContenedorAnterior = dateadd( d, -7, @FechaContenedor)


SELECT	Resumen.Circuito, 
		Resumen.Ubicacion, 
		Resumen.Color,
		Resumen.RelaseContenedor, 
		Resumen.Dia1, 
		Resumen.Dia2, 
		Resumen.Dia3,
		Resumen.Dia4, 
		Resumen.Dia5, 
		Resumen.Dia6, 
		Resumen.ReleaseDiario,
		isnull(Resumen.TotalEstacionProc,0) AS TotalEstacionProc, 
		isnull(Resumen.TotalEnsamble,0) AS TotalEnsamble, 
		isnull(Resumen.TotalFG,0) as TotalFG ,
		isnull(Resumen.TotalPotting ,0) as TotalPotting,
		coalesce(Resumen.InventarioInicial,(isnull(Resumen.TotalEnsamble,0)+isnull(Resumen.TotalFG,0)+isnull(Resumen.TotalPotting ,0)+isnull(Resumen.TotalEstacionProc,0)), 0) as InventarioInicial,
		(isnull(Resumen.TotalEnsamble,0)+isnull(Resumen.TotalFG,0)+isnull(Resumen.TotalPotting ,0)+isnull(Resumen.TotalEstacionProc,0)) AS TotalInventarioPlanta,
		((isnull(Resumen.TotalEnsamble,0)+isnull(Resumen.TotalFG,0)+isnull(Resumen.TotalPotting ,0)+isnull(Resumen.TotalEstacionProc,0))-Resumen.ReleaseDiario) AS TotalEntregado 
INTO #Inventario
FROM(
------------------------------------------------------------------------------
--OBTENGO LA PROGRAMACION DEL RELEASE Y DE PRODUCCION PARA SABER CUANDO CARGAR
------------------------------------------------------------------------------
SELECT	* FROM(
SELECT 	bom.part AS Circuito,		
		CASE location.group_no
			WHEN 'ENSAMBLE' THEN 'Linea'
			WHEN 'ENSAMBLE-depto' THEN 'Linea'
			WHEN 'POTTING' THEN 'Linea'
			WHEN 'Assembly' THEN 'Linea'
			WHEN 'Corte' THEN 'Komax'
			WHEN 'Corte-Komax' THEN 'Komax'
			WHEN 'Corte - Troquelado Manual' THEN 'Proc Man'
			WHEN 'Corte-Sonica' THEN 'Proc Man'
			WHEN 'Corte Autosplice' THEN 'Proc Man'			
			WHEN 'SOBREMOLD' THEN 'Linea'
			WHEN 'BOD POTTING' THEN 'Linea'
			WHEN 'Bodega-Moldeo' THEN 'Linea'
			WHEN 'MINIBODEGA' THEN 'Linea'
			WHEN 'MANUFACTURA' THEN 'Linea'
			WHEN 'MOLDEO' THEN 'Linea'
			WHEN 'SONICA' THEN 'Proc Man'
			when 'FS1' then 'Linea'
			when 'FS2' then 'Linea'
			when 'FS3' then 'Linea'
			WHEN 'Corte-Sonica-Kits' THEN 'Proc Man'
			WHEN 'Corte-Troqmanual-Kits'  THEN 'Proc Man'
		END AS Ubicacion,
		part.name AS Color,
		RelaseContenedor = ProgramacionLineas.RelaseContenedor * Bom.Quantity, Dia1 = ProgramacionLineas.Dia1 * Bom.Quantity,
		Dia2 = ProgramacionLineas.Dia2 * Bom.Quantity, Dia3 = ProgramacionLineas.Dia3 * Bom.Quantity, Dia4 = ProgramacionLineas.Dia4 * Bom.Quantity,
		Dia5 = ProgramacionLineas.Dia5 * Bom.Quantity, Dia6 = ProgramacionLineas.Dia6 * Bom.Quantity,
		CASE 
			WHEN isnull((SELECT count(*)
			FROM	eeh.HN.SA_BillMaterialData AS Data
			WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('ENSAMBLE','ENSAMBLE-depto','MANufactura'))
					AND type='W' 
					AND LEFT(part,3) IN ('MOL')			
					AND originalpart=bom.originalpart),0)>0 THEN
						
					CASE datepart(dw,@Fecha) + 1
							WHEN 1 THEN dia1
							WHEN 2 THEN dia2
							WHEN 3 THEN dia3
							WHEN 4 THEN dia4
							WHEN 5 THEN dia5
						ELSE
							dia6
					END				 
			WHEN LEFT(bom.parent_part,3)='PRE' OR LEFT(bom.parent_part,3)='POT' then
				CASE datepart(dw,@Fecha) +1
						WHEN 1 THEN dia1
						WHEN 2 THEN dia2
						WHEN 3 THEN dia3
						WHEN 4 THEN dia4
						WHEN 5 THEN dia5
					ELSE
						dia6
				END				 
					
			ELSE
				CASE datepart(dw,@Fecha) 
						WHEN 1 THEN dia1
						WHEN 2 THEN dia2
						WHEN 3 THEN dia3
						WHEN 4 THEN dia4
						WHEN 5 THEN dia5
					ELSE
						dia6
				END
		END	 * isnull(hcc.CantidadCircuito,1) AS ReleaseDiario
FROM 
	(SELECT CP.Part,
		  RelaseContenedor = CP.Revision,
		  Dia1= CP.ProgramadoDia1, 
		  Dia2= CP.ProgramadoDia1+CP.ProgramadoDia2, 
		  Dia3= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3,
		  Dia4= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4, 
		  Dia5= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5, 
		  Dia6= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5+CP.ProgramadoDia6      
	  FROM sistema.dbo.CP_Revisiones_Produccion_Asignacion CP
	WHERE CP.ContenedorID = @Contenedor
		  AND CP.Revision>0 AND part not in ( select toppart
		                                      from	ft.xrt
		                                      where	childpart like 'PRE-%')
--	Obtienen el Release de las partes que son PRE, ya que en el anterior se eliminan.
	union all
	SELECT Part= SUBSTRING(CP.Part, 5, 20),
		  RelaseContenedor = CP.Revision,
		  Dia1= CP.ProgramadoDia1, 
		  Dia2= CP.ProgramadoDia1+CP.ProgramadoDia2, 
		  Dia3= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3,
		  Dia4= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4, 
		  Dia5= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5, 
		  Dia6= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5+CP.ProgramadoDia6      
	  FROM sistema.dbo.CP_Revisiones_Produccion_Asignacion CP
	WHERE CP.ContenedorID = @Contenedor
		  AND CP.Revision>0 AND part LIKE 'PRE%'
	
	) AS ProgramacionLineas 
		INNER JOIN HN.SA_BillMaterialData AS BOM 		
		ON ProgramacionLineas.Part = bom.originalpart
		INNER JOIN location 
		ON location.code = bom.machine
		INNER JOIN part
		ON part.part = bom.part
		LEFT OUTER JOIN sistema.dbo.HC_Circuito_Componentes hcc 
		ON hcc.Part = bom.originalpart AND hcc.Circuito = bom.part
WHERE bom.type='W' AND bom.parent_part NOT LIKE 'DBL%' AND  LEFT(bom.part,3) IN ('TM-','SPL')) AS RELEASE

LEFT OUTER JOIN 

	(select	Circuito as CircuitInvIncial,
			InventarioInicial
	 from	hn.RLSP_CP_InventarioCircuito_PM_InvInicial( @FechaAuditTrail, @FechaContenedorAnterior )) as InventarioInicial
	on RELEASE.Circuito = InventarioInicial.CircuitInvIncial

LEFT OUTER JOIN 

------------------------------------------------------------------------------
--OBTENGO TODO LO QUE ESTE EN OBJECT EN LOCATION ENSAMBLE
------------------------------------------------------------------------------
(SELECT	object.part AS CircuitoE, 
		SUM(object.quantity) AS TotalEnsamble
FROM	Monitor.dbo.object AS Object
WHERE	object.location IN (SELECT code FROM location WHERE group_no IN ('Ensamble','ENSAMBLE-depto','Sobremold'))		
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
		AND (location not in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS','RETCORTE-P','RET-CORTE'))
		AND object.status not in ('R','H')
		AND LEFT(part,3) IN ('SPL','TM-')
GROUP BY object.part) AS Estacion_Procesos
		

ON Estacion_Procesos.CircuitoEP = RELEASE.Circuito


LEFT OUTER JOIN
------------------------------------------------------------------------------
--DESCOMPOSICION DE TODAS LAS PARTES QUE SON FG Y QUE TENGAN UN JOB COMPLETE
------------------------------------------------------------------------------
(SELECT	xrt.childpart AS CircuitoF, 
		--isnull(sum(quantity * xrt.xQty),0) AS TotalFG 		
		isnull(sum(total * xrt.xQty),0) AS TotalFG 		
FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				   --INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
				   INNER JOIN eeh.HN.fn_RL_GetInventoryJC_Part(@FechaAuditTrail,@Contenedor) audit_trail ON audit_trail.part = xrt.toppart
WHERE	LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-')
		AND part.type='F'
		--AND audit_trail.type='J' 
		--AND audit_trail.date_stamp>=@FechaAuditTrail AND audit_trail.date_stamp<=@FechaAuditTrail+7
		AND part.part IN (  SELECT	Part.PART	
							FROM	part 
							WHERE	part.type='F' 
									AND part.group_technology in ('Manufactura','Ensamble','Ensamble-depto'))
		--and audit_trail.operator not in ('CINES')
GROUP BY xrt.childpart) AS FinishGoods

--(SELECT	xrt.childpart AS CircuitoF, 
--		isnull(sum(quantity*xrt.xQty),0) AS TotalFG 		
--FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
--				   INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
--WHERE	LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-')
--		AND part.type='F'
--		AND audit_trail.type='J' 
--		AND audit_trail.date_stamp>=@FechaAuditTrail and audit_trail.date_stamp<=@FechaAuditTrail+7
--		AND part.part IN (  SELECT	Part.PART	
--							FROM	part 
--							WHERE	part.type='F' 
--									AND part.group_technology in ('Manufactura','Ensamble','ENSAMBLE-depto'))
--		and audit_trail.operator not in ('CINES')
--GROUP BY xrt.childpart) AS FinishGoods

ON FinishGoods.CircuitoF = RELEASE.Circuito

LEFT OUTER JOIN
------------------------------------------------------------------------------
--DESCOMPOSICION DE TODAS LAS PARTES QUE TIENEN POTTING
------------------------------------------------------------------------------



(SELECT	xrt.childpart AS CircuitoP, 
		sum(Potting.Cantidad) AS TotalPotting
FROM ft.xrt XRT INNER JOIN
					(SELECT object.part, isnull(Sum(object.quantity),0) AS Cantidad
					FROM Monitor.dbo.object object
					WHERE (object.part Like 'pre-%') 
					AND (object.location Not Like 'ret%')
					AND (object.location NOT LIKE 'recha%')
					AND (object.location NOT LIKE 'LOST%')
					AND (object.status ='A')  
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
									 WHERE location.group_no in ('BOD POTTING','Ensamble','ENSAMBLE-depto','Manufactura','Bodega-Moldeo','Moldeo-Kits','SOBREMOLD')
									 AND code=object.location))
					AND (object.status ='A')  							
					GROUP BY object.part) AS Potting 
				ON Potting.part = xrt.toppart
WHERE LEFT(xrt.toppart,3) IN ('PRE','POT','MOL') AND LEFT(xrt.childpart,3) IN ('SPL','TM-')
GROUP BY xrt.childpart) AS CircuitosPotting
ON CircuitosPotting.CircuitoP = RELEASE.Circuito) AS Resumen

SELECT DISTINCT part AS MOLDEO, 2 as Dias, 'Moldeo' as SiguienteProceso
INTO #MOLDEO
FROM eeh.HN.SA_BillMaterialData AS Data
WHERE originalpart in
	(	SELECT	DISTINCT parent_part
		FROM	eeh.HN.SA_BillMaterialData AS X
		WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('ENSAMBLE','ENSAMBLE-depto','MANufactura'))
				AND type='W' AND LEFT(part,3) IN ('MOL'))
	AND LEFT(part ,3) IN ('TM-','SPL')

SELECT DISTINCT part AS POTTING, 1 as Dias, 'Potting' as SiguienteProceso
INTO #POTTING 
FROM eeh.HN.SA_BillMaterialData AS Data
WHERE originalpart IN (
			SELECT	DISTINCT originalpart 
			FROM	eeh.HN.SA_BillMaterialData AS Data
			WHERE	machine IN ('POTTING')
					AND type='W' 
					AND LEFT(parent_part,3) IN ('Pot')	
					)
		AND LEFT(part,3) IN ('TM-','SPL')



SELECT  Circuito, 
		Ubicacion, 
		Color,
		Tipo = Max(coalesce( Moldeo.SiguienteProceso, Potting.SiguienteProceso, 'Linea')),
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
		avg(TotalInventarioPlanta) TotalSemanal,
		avg(TotalEntregado) TotalEntregado,
		avg(InventarioInicial) InventarioInicial,
		(sum(	case	 coalesce( Potting.SiguienteProceso, Moldeo.SiguienteProceso, 'Linea')
					when 'Linea' then
						case datepart(dw, getdate())
							when 1 then dia1
							when 7 then dia1
							when 5 then dia1
							when 6 then dia1
							else null
						end
					when 'Moldeo' then
						case datepart(dw, getdate())
							when 4 then dia1
							when 5 then dia2
							when 6 then dia2
							when 7 then dia2
							when 1 then dia2
							else null
						end
					when 'Potting' then
						case datepart(dw, getdate())
--							when 5 then dia1
--							when 6 then dia2
--							when 7 then dia2
							when 4 then dia1
							when 5 then dia2
							when 6 then dia2
							when 7 then dia2
							when 1 then dia2
							else null
						end 
				end ) - avg(InventarioInicial) ) * -1	TotalDiario
				--end ) - avg(coalesce(InventarioInicial,TotalInventarioPlanta,0)) ) * -1	TotalDiario
					
FROM #Inventario AS data
		left join #POTTING POTTING on POTTING.Potting = data.Circuito
		left join #MOLDEO MOLDEO on MOLDEO.MOLDEO = data.Circuito
GROUP BY Circuito, 
		Ubicacion, 
		Color
ORDER BY  substring(data.Circuito,
		charindex('-',data.Circuito)+1,
		charindex('-',data.Circuito,charindex('-',data.Circuito)+1)-(charindex('-',data.Circuito)+1)),
		data.Circuito --, Data.TotalEntregado
GO
