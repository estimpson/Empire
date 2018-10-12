SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_CP_InventarioCircuito_ProcesosManuales_old](@FechaAuditTrail datetime )
as

/*
Ejemplo:

declare	@FechaAuditTrail datetime

set	@FechaAuditTrail = '2009-05-04'

exec HN.RLSP_CP_InventarioCircuito_ProcesosManuales
		@FechaAuditTrail = @FechaAuditTrail

*/

------------ DECLARACION Y SETEO DE VARIABLES --------------------
------------------------------------------------------------------
--
DECLARE @Fecha datetime,
		@Contenedor int--,
		--@FechaAuditTrail datetime
--		@Piso char(13),
--		,
--		@fecha datetime
--	
--SET @FechaAuditTrail = '2008-07-07'
--SET @Piso = 'PISO06-15'
--SET @FechaContenedor = '2008-06-15'



/*
exec [HN].[RLSP_CP_InventarioCircuito_ProcesosManuales] '2008-07-14','2008-07-20'
*/

SET @fecha = getdate()
SELECT @Contenedor =	CASE 
							WHEN datepart(dw,getdate())  >6 
								THEN (SELECT contenedorid FROM sistema.dbo.CP_Contenedores cc WHERE cc.Activo=1) +1
							ELSE (SELECT contenedorid FROM sistema.dbo.CP_Contenedores cc WHERE cc.Activo=1)
						END



--select @Contenedor = (select contenedorid from sistema.dbo.CP_Contenedores where fechaeeh= @FechaContenedor)

/*******************************************
 * Debido a problemas con los arranques de las lineas que llevan PRE, se sacan los dias de arranque los POTs
 * mas los dias de los pres
 *******************************************/
SELECT * 
INTO #Release
FROM
(
SELECT substring(Part,5,len(part)) part, crpa.Revision, crpa.ProgramadoDia1, crpa.ProgramadoDia2, crpa.ProgramadoDia3,
	  crpa.ProgramadoDia4, crpa.ProgramadoDia5, crpa.ProgramadoDia6
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = @Contenedor
			  AND crpa.Revision>0 
			  AND crpa.Part like 'PRE-%' and crpa.Part not like '%-RW%'
UNION all
SELECT Part, crpa.Revision, crpa.ProgramadoDia1, crpa.ProgramadoDia2, crpa.ProgramadoDia3,
	  crpa.ProgramadoDia4, crpa.ProgramadoDia5, crpa.ProgramadoDia6
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = @Contenedor
			  AND crpa.Revision>0 
			  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%'
			  AND crpa.part NOT IN (SELECT substring(Part,5,len(part)) part
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = @Contenedor
			  AND crpa.Revision>0 
			  AND crpa.Part like 'PRE-%' and crpa.Part not like '%-RW%')) Data
ORDER BY part

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
		RelaseContenedor = ProgramacionLineas.RelaseContenedor * bom.Quantity, Dia1 =  ProgramacionLineas.Dia1 * bom.Quantity,
		Dia2 = ProgramacionLineas.Dia2 * bom.Quantity, Dia3 = ProgramacionLineas.Dia3 * bom.Quantity, Dia4 = ProgramacionLineas.Dia4 * bom.Quantity,
		Dia5 = ProgramacionLineas.Dia5 * bom.Quantity, Dia6 = ProgramacionLineas.Dia6* bom.Quantity,
		CASE 
			WHEN isnull((SELECT count(*)
			FROM	eeh.HN.SA_BillMaterialData AS Data
			WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('ENSAMBLE','Ensamble-depto','MANufactura'))
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
--	(SELECT CP.Part,
--		  RelaseContenedor = CP.Revision,
--		  Dia1= CP.ProgramadoDia1, 
--		  Dia2= CP.ProgramadoDia1+CP.ProgramadoDia2, 
--		  Dia3= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3,
--		  Dia4= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4, 
--		  Dia5= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5, 
--		  Dia6= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5+CP.ProgramadoDia6      
--	  FROM sistema.dbo.CP_Revisiones_Produccion_Asignacion CP
--	WHERE CP.ContenedorID = @Contenedor
--		  AND CP.Revision>0 AND part NOT like 'PRE%' and part not like '%-RW%'
--	) 
(SELECT CP.Part,
		  RelaseContenedor = CP.Revision,
		  Dia1= CP.ProgramadoDia1, 
		  Dia2= CP.ProgramadoDia1+CP.ProgramadoDia2, 
		  Dia3= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3,
		  Dia4= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4, 
		  Dia5= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5, 
		  Dia6= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5+CP.ProgramadoDia6      
	  FROM #Release CP	
	)  AS ProgramacionLineas 
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
------------------------------------------------------------------------------
--OBTENGO TODO LO QUE ESTE EN OBJECT EN LOCATION ENSAMBLE
------------------------------------------------------------------------------
(SELECT	object.part AS CircuitoE, 
		SUM(object.quantity) AS TotalEnsamble
FROM	Monitor.dbo.object AS Object
WHERE	object.location IN (SELECT code FROM location WHERE group_no IN ('Ensamble','Ensamble-depto','Sobremold'))		
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
	WHERE	LEFT(object.location,3) IN ('EST','TM-','SP-','MD-') 
			AND (location not in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS','RETCORTE-P','RET-CORTE'))
			AND object.status not in ('R','H')
			--AND location IN (SELECT code FROM monitor.dbo.location l WHERE l.group_no IN ('Moldeo-Kits','SOBREMOLD'))
			AND LEFT(part,3) IN ('SPL','TM-')
GROUP BY object.part) AS Estacion_Procesos

--								SELECT isnull(sum(quantity),0) AS Cantidad
--								FROM monitor.dbo.object
--								WHERE location IN (SELECT code FROM monitor.dbo.location l WHERE l.group_no IN ('Moldeo-Kits','SOBREMOLD'))
--									
--									AND Monitor.dbo.object.part = ObjectPrincipal.part						


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
					AND (object.status='A')  
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
									 WHERE location.group_no in ('BOD POTTING','Ensamble','Ensamble-depto','Manufactura','Bodega-Moldeo','Moldeo-Kits','SOBREMOLD')
									 AND code=object.location))
					AND (object.status ='A')  							
					GROUP BY object.part) AS Potting 
				ON Potting.part = xrt.toppart
WHERE LEFT(xrt.toppart,3) IN ('PRE','POT','MOL') AND LEFT(xrt.childpart,3) IN ('SPL','TM-')
GROUP BY xrt.childpart) AS CircuitosPotting

ON CircuitosPotting.CircuitoP = RELEASE.Circuito) AS Resumen


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
		avg(TotalEstacionProc) TotalEstacionProc,--
		avg(TotalEnsamble) TotalEnsamble, 
		avg(TotalFG ) TotalFG,
		avg(TotalPotting) TotalPotting,
		avg(TotalEntregado) TotalEntregado
into #Temporal		
FROM #Inventario AS data
GROUP BY Circuito, 
		Ubicacion, 
		Color
ORDER BY  substring(data.Circuito,
		charindex('-',data.Circuito)+1,
		charindex('-',data.Circuito,charindex('-',data.Circuito)+1)-(charindex('-',data.Circuito)+1))
		,data.Circuito 

update #Temporal
set TotalEntregado = (TotalEstacionProc + TotalEnsamble + TotalFG + TotalPotting) -ReleaseDiario


select * from #Temporal

DROP TABLE  #Temporal
DROP TABLE #Inventario
--DROP TABLE #Inventarios


GO
