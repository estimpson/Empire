SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROC [HN].[RLSP_CP_EstCircuito_CargadoLinea1_NoUSAR](@FechaAuditTrail datetime)
as

/*
Ejemplo:

declare	@FechaAuditTrail datetime

set	@FechaAuditTrail = '2009-02-23'

Exec [HN].[RLSP_CP_EstCircuito_CargadoLinea1]
		@FechaAuditTrail = @FechaAuditTrail


*/

------------ DECLARACION Y SETEO DE VARIABLES --------------------
------------------------------------------------------------------
--
DECLARE @Fecha datetime,
		@Contenedor int
--	@FechaAuditTrail datetime
--		@Piso char(13),
--		,
--		@fecha datetime
--	
--SET @FechaAuditTrail = '2008-07-14'
--SET @Piso = 'PISO06-15'
--SET @FechaContenedor = '2008-06-15'

SET @fecha = getdate()
--SELECT @Contenedor =	CASE 
--				WHEN datepart(dw,getdate())  >6
--					THEN (SELECT contenedorid FROM sistema.dbo.CP_Contenedores cc WHERE cc.Activo=1) +1
--				ELSE (SELECT contenedorid FROM sistema.dbo.CP_Contenedores cc WHERE cc.Activo=1)
--			END
			
select	@Contenedor = contenedorid FROM sistema.dbo.CP_Contenedores cc WHERE cc.Activo=1


SELECT JobComplete.Circuito,(JobComplete.TotalJ)
INTO #CircuitosFGoods_J
from
	(	SELECT	xrt.childpart AS Circuito, isnull(sum(quantity),0) AS TotalJ 		
		FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				JOIN audit_trail ON audit_trail.part = xrt.toppart
				JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
		WHERE    LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-','DBL','CKT') AND part.type='F' AND 
				audit_trail.type='J' AND audit_trail.date_stamp>=@FechaAuditTrail AND audit_trail.date_stamp<=@FechaAuditTrail+7
				GROUP BY xrt.childpart) AS JobComplete

SELECT MatIssue.Circuito,(isnull(MatIssue.TotalM,0)) AS TotalM
INTO #CircuitosFGoods_M
FROM
	(	SELECT	xrt.childpart AS Circuito, isnull(sum(quantity),0) AS TotalM
		FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				JOIN audit_trail ON audit_trail.part = xrt.toppart
				JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
		WHERE   LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-','DBL','CKT') AND part.type='F' AND 
				audit_trail.type='M' AND audit_trail.date_stamp>=@FechaAuditTrail AND audit_trail.date_stamp<=@FechaAuditTrail+7
				AND audit_trail.to_loc = 'DELETE'
		GROUP BY xrt.childpart
		UNION all
		SELECT	xrt.childpart AS Circuito, isnull(sum(quantity),0) AS TotalJ 		
		FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				JOIN audit_trail ON audit_trail.part = xrt.toppart
				JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
		WHERE    LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-','DBL','CKT') AND part.type='F' AND 
				audit_trail.type='T' AND audit_trail.date_stamp>=@FechaAuditTrail and audit_trail.notes = 'cajas left behind'
				GROUP BY xrt.childpart) AS MatIssue




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
		isnull(Resumen.TotalEnsamble,0) AS TotalEnsamble, 
		isnull(Resumen.TotalFG,0) as TotalFG ,
		isnull(Resumen.TotalPotting ,0) as TotalPotting,
		((isnull(Resumen.TotalEnsamble,0)+isnull(Resumen.TotalFG,0)+isnull(Resumen.TotalPotting ,0))-Resumen.ReleaseDiario) AS TotalEntregado,Resumen.CantidadCircuito 
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
			WHEN 'Corte-Sonica-Kits' THEN 'Proc Man'
			WHEN 'Corte-Troqmanual-Kits'  THEN 'Proc Man'
			WHEN 'INVENTARIO' THEN 'INVENTARIO'
		END AS Ubicacion,
		part.name AS Color,
		ProgramacionLineas.RelaseContenedor, ProgramacionLineas.Dia1,
		ProgramacionLineas.Dia2, ProgramacionLineas.Dia3, ProgramacionLineas.Dia4,
		ProgramacionLineas.Dia5, ProgramacionLineas.Dia6,
		CASE 
			WHEN isnull((SELECT count(*)
			FROM	eeh.HN.SA_BillMaterialData AS Data
			WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('Ensamble','Ensamble-depto','MANufactura'))
					AND type='W' 
					AND LEFT(part,3) IN ('MOL')			
					AND originalpart=bom.originalpart),0)>0 THEN
						
					CASE datepart(dw,@Fecha) +2
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
		END	 * isnull(hcc.CantidadCircuito,1) AS ReleaseDiario, isnull(hcc.CantidadCircuito,1) as CantidadCircuito
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
		  AND CP.Revision>0 AND part not IN	(select	Toppart
		                               	 from	FT.XRt
		                               	 where	childpart like 'PRE-%')
--	Query para recuperar los productos que inidcan PRE
	union All
		SELECT Part = SUBSTRING( CP.Part, 5, 20),
			  RelaseContenedor = CP.Revision,
			  Dia1= CP.ProgramadoDia1, 
			  Dia2= CP.ProgramadoDia1+CP.ProgramadoDia2, 
			  Dia3= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3,
			  Dia4= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4, 
			  Dia5= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5, 
			  Dia6= CP.ProgramadoDia1+CP.ProgramadoDia2+CP.ProgramadoDia3+CP.ProgramadoDia4+CP.ProgramadoDia5+CP.ProgramadoDia6      
		  FROM sistema.dbo.CP_Revisiones_Produccion_Asignacion CP
		WHERE CP.ContenedorID = @Contenedor
			  AND CP.Revision>0 AND part LIKE 'PRE-%'
	) AS ProgramacionLineas 
		INNER JOIN HN.SA_BillMaterialData AS BOM 		
		ON ProgramacionLineas.Part = bom.originalpart
		INNER JOIN location 
		ON location.code = bom.machine
		INNER JOIN part
		ON part.part = bom.part
		LEFT OUTER JOIN sistema.dbo.HC_Circuito_Componentes hcc 
		ON hcc.Part = bom.originalpart AND hcc.Circuito = bom.part
WHERE bom.type='W' AND bom.parent_part NOT LIKE 'DBL%' AND  LEFT(bom.part,3) IN ('CKT','DBL','TM-','SPL')) AS RELEASE

LEFT OUTER JOIN 
------------------------------------------------------------------------------
--OBTENGO TODO LO QUE ESTE EN OBJECT EN LOCATION ENSAMBLE
------------------------------------------------------------------------------
(SELECT	object.part AS CircuitoE, 
		SUM(object.quantity) AS TotalEnsamble
FROM	Monitor.dbo.object AS Object
WHERE	object.location IN (SELECT code FROM location WHERE group_no IN ('Ensamble','Ensamble-depto'))
		AND object.status !='R'
		AND object.location NOT LIKE 'LOST%'
		AND object.part IN (SELECt part FROM part where type = 'W')
GROUP BY object.part) AS ENSAMBLE

ON ENSAMBLE.CircuitoE = RELEASE.Circuito

LEFT OUTER JOIN
------------------------------------------------------------------------------
--DESCOMPOSICION DE TODAS LAS PARTES QUE SON FG Y QUE TENGAN UN JOB COMPLETE
------------------------------------------------------------------------------
		
(SELECT #CircuitosFGoods_J.Circuito as CircuitoF,(#CircuitosFGoods_j.TotalJ- isnull(#CircuitosFGoods_M.TotalM,0)) AS TotalFG 
FROM #CircuitosFGoods_J LEFT OUTER JOIN #CircuitosFGoods_M on #CircuitosFGoods_J.Circuito = #CircuitosFGoods_M.Circuito) as FinishGoods
ON FinishGoods.CircuitoF = RELEASE.Circuito

--(SELECT	xrt.childpart AS CircuitoF, 
--		isnull(sum(quantity),0) AS TotalFG 		
--FROM	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
--				   INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
--WHERE	LEFT(xrt.childpart,3) IN ('MOL','SUB','POT','PRE','SPL','TM-','DBL','CKT')
--		AND part.type='F'
--		AND audit_trail.type='J' 
--		AND audit_trail.date_stamp>=@FechaAuditTrail
--		AND part.part IN (  SELECT	Part.PART	
--							FROM	part 
--							WHERE	part.type='F' 
--									AND part.group_technology in ('Manufactura','Ensamble'))
--		and audit_trail.operator not in ('CINES')
--GROUP BY xrt.childpart) AS FinishGoods
--
--ON FinishGoods.CircuitoF = RELEASE.Circuito

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
					WHERE (object.part Like 'TM-%') 
					AND (object.location Not Like 'ret%')
					AND (object.location NOT LIKE 'recha%')
					AND (object.status ='A')  
					AND (exists (SELECT 1 FROM location  
									 WHERE location.group_no in ('Moldeo-Kits','SOBREMOLD')
									 AND code=object.location))
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
									 WHERE location.group_no in ('Ensamble','Ensamble-depto','Manufactura','Bodega-Moldeo','BOD POTTING','Moldeo-Kits','SOBREMOLD')
									 AND code=object.location))
					AND (object.status !='R')  							
					GROUP BY object.part) AS Potting 
				ON Potting.part = xrt.toppart
				INNER JOIN ft.xrt xrt2 ON xrt2.childpart=xrt.toppart AND xrt2.toppart in (SELECT Part
											FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
											WHERE crpa.ContenedorID = @Contenedor
													  AND crpa.Revision>0 
													  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%')
WHERE LEFT(xrt.toppart,3) IN ('PRE','POT','MOL','TM-') AND LEFT(xrt.childpart,3) IN ('SPL','TM-','CKT','DBL')
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
		avg(TotalEnsamble) as TotalEnsamble, 
		avg(TotalFG*CantidadCircuito ) TotalFG,
		avg(TotalPotting) TotalPotting,
		avg(TotalEntregado) TotalEntregado		
INTO #Inventarios			
FROM #Inventario
GROUP BY Circuito, 
		Ubicacion, 
		Color


update #Inventarios
set TotalEntregado = ((TotalEnsamble+TotalFG+TotalPotting)-ReleaseDiario)

DROP TABLE #Inventario


SELECT  *, Operator = (select Max(Location.OperatorCode )
						from EEH.dbo.MaterialHandlerDeliveryLocations Location
								join EEH.dbo.MaterialHandlerPickupWarehouse Warehouse on Location.OperatorCode = Warehouse.OperatorCode
						where LocationCode = Data.Familia and WareHouseCode = 'Bodega - Corte')
 FROM( 
SELECT  Circuito, 
		Ubicacion, 
		Color,
		RelaseContenedor, 
		Dia1 , 
		Dia2 , 
		Dia3 ,
		Dia4 , 
		Dia5 , 
		Dia6 , 
		ReleaseDiario ,
		TotalEnsamble , 
		TotalFG  ,
		TotalPotting ,
		TotalEntregado ,
		0 AS serial, 
		0 AS quantity, 
		''  AS location,
		Dia = ReleaseDiario - TotalEnsamble,
		Familia = substring(Circuito, charindex('-',Circuito)+1,
			case when isnull(charindex('-',Circuito, charindex('-',Circuito)+1 ),0) = 0 then LEN(Circuito)
				else charindex('-',Circuito, charindex('-',Circuito)+1 ) end - (charindex('-',Circuito )+1))		
FROM #iNVENTARIOs
WHERE  #iNVENTARIOs.TotalEntregado>=0 

UNION ALL

SELECT  Circuito, 
		Ubicacion, 
		Color,
		RelaseContenedor, 
		Dia1, 
		Dia2, 
		Dia3,
		Dia4, 
		Dia5, 
		Dia6, 
		ReleaseDiario,
		TotalEnsamble, 
		TotalFG ,
		TotalPotting,
		TotalEntregado,
		OBJECT.serial, 
		OBJECT.quantity, 
		OBJECT.location,
		Dia = ReleaseDiario - TotalEnsamble,
		Familia = substring(Circuito, charindex('-',Circuito)+1,
			case when isnull(charindex('-',Circuito, charindex('-',Circuito)+1 ),0) = 0 then LEN(Circuito)
				else charindex('-',Circuito, charindex('-',Circuito)+1 ) end - (charindex('-',Circuito )+1))		
FROM #iNVENTARIOs

LEFT OUTER JOIN 
------------------------------------------------------------------------------
--OBTENGO TODAS LAS SERIES QUE ESTAN EN OBJECT
------------------------------------------------------------------------------
(SELECT part AS CircuitoI,
	serial,
	quantity,
	location
FROM  eeh.dbo.object object
WHERE LEFT(object.location,3) IN ('EST','KOM','ART','TM-','SP-') AND (location <> 'ESTCUT-6' and location <> 'ESTCUT-12' and location <> 'BOD-CKTOBS')					  
	AND LEFT(part,3) IN ('SPL','TM-','CKT','DBL')
) AS OBJECT
ON #iNVENTARIOs.Circuito =OBJECT.CircuitoI
WHERE  #iNVENTARIOs.TotalEntregado<0 AND (-1*#iNVENTARIOs.TotalEntregado) - isnull((select sum( quantity )
										from eeh.dbo.object obj
										WHERE LEFT(obj.location,3) IN ('EST','KOM','ART','TM-','SP-') AND (location <> 'ESTCUT-6' and location <> 'ESTCUT-12' and location <> 'BOD-CKTOBS')											
												AND LEFT(part,3) IN ('SPL','TM-','CKT','DBL') AND part = #iNVENTARIOs.Circuito
										and obj.serial < OBJECT.Serial ),0) > 0 ) AS Data
ORDER BY  substring(data.Circuito,5,7)
--		substring(data.Circuito,
--		charindex('-',data.Circuito)+1,
--		charindex('-',data.Circuito,charindex('-',data.Circuito)+1)-(charindex('-',data.Circuito)+1))
		,data.Circuito , Data.TotalEntregado,Data.serial

DROP TABLE #Inventarios



GO
