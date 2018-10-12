SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [HN].[RLSP_CP_Corte_InventarioCircuito_Renew](
		@FechaAuditTrail datetime, 
		@FechaContenedor datetime)
returns	@Reporte table(
	[Circuito] [varchar](25) not NULL,
	[Revision] [int] NULL,
	[TotalSemanal] [numeric](18, 6) null)
as
begin

/*

DECLARE @FechaAuditTrail datetime,
		@FechaContenedor datetime
		
SET @FechaAuditTrail = '2008-10-20'
SET @FechaContenedor = '2008-10-26'

select	*
from	[HN].[RLSP_CP_Corte_InventarioCircuito_Renew](@FechaAuditTrail,@FechaContenedor)

*/

--set transaction isolation level read uncommitted

declare @Fecha datetime
select	@Fecha = Systemdate from HN.SystemDate 



/*******************************************
 * Debido a problemas con los arranques de las lineas que llevan PRE, se sacan los dias de arranque los POTs
 * mas los dias de los pres
 *******************************************/

declare @Release table(
	[Part] [varchar](25) not null,
	[Revision] [int] NULL,
	[ProgramadoDia1] [int] NOT NULL,
	[ProgramadoDia2] [int] NOT NULL,
	[ProgramadoDia3] [int] NOT NULL,
	[ProgramadoDia4] [int] NOT NULL,
	[ProgramadoDia5] [int] NOT NULL,
	[ProgramadoDia6] [int] NOT NULL
)

insert @Release
SELECT * 
FROM
(
SELECT substring(Part,5,len(part)) part, crpa.Revision, crpa.ProgramadoDia1, crpa.ProgramadoDia2, crpa.ProgramadoDia3,
	  crpa.ProgramadoDia4, crpa.ProgramadoDia5, crpa.ProgramadoDia6
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = (SELECT ContenedorID 
			   FROM sistema.dbo.CP_Contenedores cc 
                           WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
			  AND crpa.Revision>0 
			  AND crpa.Part like 'PRE-%' and crpa.Part not like '%-RW%'
UNION all
SELECT Part, crpa.Revision, crpa.ProgramadoDia1, crpa.ProgramadoDia2, crpa.ProgramadoDia3,
	  crpa.ProgramadoDia4, crpa.ProgramadoDia5, crpa.ProgramadoDia6
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = (SELECT ContenedorID 
			   FROM sistema.dbo.CP_Contenedores cc 
                           WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
			  AND crpa.Revision>0 
			  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%'
			  AND crpa.part NOT IN (SELECT substring(Part,5,len(part)) part
FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
WHERE crpa.ContenedorID = (SELECT ContenedorID 
			   FROM sistema.dbo.CP_Contenedores cc 
                           WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
			  AND crpa.Revision>0 
			  AND crpa.Part like 'PRE-%' and crpa.Part not like '%-RW%')) Data
ORDER BY part






declare @CircuitosRevision table(
	[Circuito] [varchar](25) not null,
	[Ubicacion] [varchar](8) NULL,
	[Revision] [int] NULL,
	[CantidadCircuito] [int] NOT NULL
)

insert @CircuitosRevision
SELECT 	Circuito = Circuitos.Part,		
		Ubicacion = CASE location.group_no
			WHEN 'ENSAMBLE' THEN 'Linea'
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
		END,
		Revision = (sum(Release.Revision)*isnull(HC.CantidadCircuito,1)),
		CantidadCircuito = isnull(HC.CantidadCircuito,1)
FROM hn.sa_billMaterialdata Circuitos with (readuncommitted)
    left JOIN location with (readuncommitted) ON Circuitos.machine = location.code 
	 JOIN part with (readuncommitted) ON circuitos.part = part.part
	 JOIN part_standard with (readuncommitted) ON circuitos.part = part_standard.part
	 JOIN @Release Release ON Circuitos.originalpart=Release.part
	JOIN (SELECT hcc.Part, hcc.Circuito, hcc.CantidadCircuito
	      FROM Sistema.dbo.HC_Circuito_Componentes hcc with (readuncommitted)) HC ON Circuitos.originalpart=HC.part AND Circuitos.part=HC.Circuito
WHERE Circuitos.machine IN (SELECT code
						FROM location  
						WHERE group_no IN ('Corte-Sonica-Kits','Corte-Troqmanual-Kits','SONICA','Manufactura','MOLDEO','BOD POTTING','Bodega-Moldeo','MINIBODEGA','SOBREMOLD','Ensamble','Corte-Komax','Corte - Troquelado Manual','POTTING','Corte Autosplice','Corte-Sonica','Assembly','CORTE'))
						 AND part.type='W' AND LEFT(part.part,3) IN ('DBL','CKT') AND parent_part not LIKE 'DBL%'
GROUP BY  CASE location.group_no
			WHEN 'ENSAMBLE' THEN 'Linea'
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
		END,
		Circuitos.Part, part_standard.material_cum,HC.CantidadCircuito


					
--CREATE INDEX IDX_Circuito ON @CircuitosRevision(Circuito)

declare @CircuitosFGoods_J table (
	[Circuito] [varchar](25) NOT NULL,
	[TotalJ] [numeric](18, 6) NOT NULL
) 


insert @CircuitosFGoods_J
SELECT JobComplete.Circuito,(JobComplete.TotalJ)
FROM
(	SELECT	xrt.childpart AS Circuito, isnull(sum(quantity*xQty),0) AS TotalJ 		
	FROM	FT.XRT XRT with (readuncommitted)
			JOIN part with (readuncommitted) ON part.part = xrt.toppart
			JOIN audit_trail with (readuncommitted) ON audit_trail.part = xrt.toppart
			JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion a with (readuncommitted) ON a.part = part.part
			JOIN Sistema.dbo.CP_Contenedores b with (readuncommitted) ON b.ContenedorID = a.ContenedorID
													and a.Revision>0 AND b.Activo=1
	WHERE   LEFT(xrt.childpart,3) IN ('DBL','CKT') AND part.type='F' AND 
			audit_trail.type='J' AND audit_trail.date_stamp>=@FechaAuditTrail	
	GROUP BY xrt.childpart) AS JobComplete

declare @CircuitosFGoods_M table (
	[Circuito] [varchar](25) NOT NULL,
	[TotalM] [numeric](18, 6) NOT NULL
)

insert @CircuitosFGoods_M
select MatIssue.Circuito,(isnull(MatIssue.TotalM,0)) AS TotalM
from
(	SELECT	xrt.childpart AS Circuito, isnull(sum(quantity*xQty),0) AS TotalM 	
 	from	FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
			JOIN audit_trail with (readuncommitted) ON audit_trail.part = xrt.toppart
			JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
			JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
	WHERE	LEFT(xrt.childpart,3) IN ('DBL','CKT') AND part.type='F' AND 
		audit_trail.type='M' AND audit_trail.date_stamp>=@FechaAuditTrail
		AND audit_trail.to_loc = 'DELETE'
	GROUP BY xrt.childpart
	UNION all
		SELECT	xrt.childpart AS Circuito, isnull(sum(quantity*xQty),0) AS TotalJ 		
		FROM	FT.XRT XRT with (readuncommitted) INNER JOIN part with (readuncommitted) ON part.part = xrt.toppart
				JOIN audit_trail with (readuncommitted) ON audit_trail.part = xrt.toppart
				JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion a with (readuncommitted) ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b with (readuncommitted) ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
		WHERE    LEFT(xrt.childpart,3) IN ('DBL','CKT') AND part.type='F' AND 
				audit_trail.type='T' AND audit_trail.date_stamp>=@FechaAuditTrail and audit_trail.notes = 'cajas left behind'
				GROUP BY xrt.childpart) AS MatIssue


declare @CircuitosFGoods table (
	[Circuito] [varchar](25) NOT NULL,
	[TotalFG] [numeric](18, 6) NULL
) 
	
insert	@CircuitosFGoods
select	CircuitosFGoods_J.Circuito,
		TotalFG = (CircuitosFGoods_J.TotalJ - isnull(CircuitosFGoods_M.TotalM,0))  
from	@CircuitosFGoods_J CircuitosFGoods_J LEFT OUTER JOIN @CircuitosFGoods_M CircuitosFGoods_M on CircuitosFGoods_J.Circuito = CircuitosFGoods_M.Circuito


--
--CREATE INDEX IDX_Circuito ON @CircuitosFGoods(Circuito)
--
declare @JobCompleteProcesos table(
	[Circuito] [varchar](25) NOT NULL,
	[Cantidad] [numeric](18, 6) NULL
) 

insert @JobCompleteProcesos
--select jp1.Circuito, jp1.cantidad-isnull(jp2.cantidad,0) Cantidad
----INTO #JobCompleteProcesos 
--from 
--(SELECT xrt.childpart AS Circuito, sum(quantity * xrt.xQty) AS Cantidad
--FROM object 
--	INNER JOIN ft.xrt xrt ON object.part = xrt.toppart
--	INNER JOIN ft.xrt xrt2 ON xrt.toppart = xrt2.childpart
--WHERE LEFT(part,3) IN ('SUB','SPL','TM-') AND LEFT(xrt.childpart,3) IN ('CKT','DBL')
--		AND (object.location NOT in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS','RETCORTE-P','RET-CORTE','SCRAP_CHIN'))
--		and status not in ('H','R')
--		and xrt2.toppart in (SELECT Part
--							FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
--							WHERE crpa.ContenedorID = (SELECT ContenedorID 
--													   FROM sistema.dbo.CP_Contenedores cc 
--													   WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
--									  AND crpa.Revision>0 
--									  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%')
--GROUP BY xrt.childpart) JP1 left outer join
--(SELECT xrt.childpart AS Circuito, sum(quantity * xrt.xQty) AS Cantidad
--FROM object 
--	INNER JOIN ft.xrt xrt ON object.part = xrt.toppart
--WHERE LEFT(part,3) IN ('SUB','SPL','TM-') AND LEFT(xrt.childpart,3) IN ('CKT','DBL')
--		AND (object.location NOT in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS','RETCORTE-P','RET-CORTE','SCRAP_CHIN'))
--		and status not in ('H','R')		
--GROUP BY xrt.childpart) JP2 on JP2.Circuito =JP1.Circuito
--order by 1
SELECT xrt.childpart AS Circuito, round(sum(quantity * xrt.xQty)/Division.Cantidad,0)  AS Cantidad
--INTO #JobCompleteProcesos 
FROM object 
	INNER JOIN ft.xrt xrt ON object.part = xrt.toppart
	INNER JOIN ft.xrt xrt2 ON xrt.toppart = xrt2.childpart
	inner join (SELECT xrt.childpart AS Circuito, sum(xrt.xqty) AS Cantidad
				FROM ft.xrt xrt INNER JOIN ft.xrt xrt2 ON xrt.toppart = xrt2.childpart
				WHERE LEFT(xrt2.childpart,3) IN ('SUB','SPL','TM-') AND LEFT(xrt.childpart,3) IN ('CKT','DBL')
						and xrt2.toppart in (SELECT Part
											FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
											WHERE crpa.ContenedorID = (SELECT ContenedorID 
																	   FROM sistema.dbo.CP_Contenedores cc 
																	   WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
													  AND crpa.Revision>0 
													  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%')
				GROUP BY xrt.childpart,xrt.xQty) Division on Division.Circuito = xrt.childpart
WHERE LEFT(object.part,3) IN ('SUB','SPL','TM-') AND LEFT(xrt.childpart,3) IN ('CKT','DBL')
		AND (object.location NOT in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS','RETCORTE-P','RET-CORTE','SCRAP_CHIN'))
		and status not in ('H','R')
		and xrt2.toppart in (SELECT Part
							FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
							WHERE crpa.ContenedorID = (SELECT ContenedorID 
													   FROM sistema.dbo.CP_Contenedores cc 
													   WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
									  AND crpa.Revision>0 
									  AND crpa.Part not like 'PRE-%' and crpa.Part not like '%-RW%')
GROUP BY xrt.childpart,Division.Cantidad


--
--CREATE INDEX IDX_Circuito ON @JobCompleteProcesos(Circuito)
--
declare @CircuitosPotting TABLE (
	[Circuito] [varchar](25) NOT NULL,
	[TotalPotting] [numeric](18, 6) NULL
) 

insert @CircuitosPotting
select xrt.childpart AS Circuito, sum(Potting.Cantidad*xQty) AS TotalPotting
from ft.xrt XRT INNER JOIN
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
																 WHERE location.group_no in ('Ensamble', 'Manufactura','Bodega-Moldeo','BOD POTTING')
																 AND code=object.location))
								AND (object.status ='A')  							
					GROUP BY object.part) AS Potting 
				ON Potting.part = xrt.toppart
WHERE LEFT(xrt.toppart,3) IN ('PRE','POT','MOL') AND LEFT(xrt.childpart,3) IN ('DBL','CKT')
GROUP BY xrt.childpart

--
--CREATE INDEX IDX_Circuito ON @CircuitosPotting(Circuito)
--
--
--
declare	@InventarioFisico table(
	[Circuito] [varchar](25) NULL,
	[Estacion] [numeric](18, 6) NOT NULL,
	[Piso] [numeric](18, 6) NOT NULL,
	[Corte] [numeric](18, 6) NOT NULL,
	[Ensamble] [numeric](18, 6) NOT NULL,
	[RebajadoPiso_TransferProcesos] [numeric](18, 6) NOT NULL,
	[InventarioFisico] [numeric](18, 6) NULL
)

insert @InventarioFisico
SELECT Circuito, Estacion,  Piso, Corte,Ensamble,RebajadoPiso_TransferProcesos, (Estacion+ Piso+Corte+Ensamble+RebajadoPiso_TransferProcesos) AS InventarioFisico
FROM
(SELECT	ObjectPrincipal.part AS Circuito,	
		Estacion = isnull((SELECT Sum(cantidad) 
		                FROM (
								SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
								FROM   Monitor.dbo.object 
								WHERE  (LEFT(Monitor.dbo.object.location,3) IN ('EST','SP-','TM-'))
								AND (Monitor.dbo.object.location NOT IN ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS')) 
								AND Monitor.dbo.object.part = ObjectPrincipal.part
								AND (Monitor.dbo.object.status ='A') 
							) AS ProcAutomatico),0) ,		
		Piso = isnull((SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
					FROM   Monitor.dbo.object 
					WHERE  (Monitor.dbo.object.location LIKE 'PISO%') 
						AND Monitor.dbo.object.part = ObjectPrincipal.part
						AND (Monitor.dbo.object.status ='A')),0) ,
		Corte = isnull((SELECT Sum(cantidad) 
		                FROM (
							SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
							FROM   Monitor.dbo.object 
							WHERE  (LEFT(Monitor.dbo.object.location,5) IN ('KOMAX','ARTOS')) 						
							AND Monitor.dbo.object.part = ObjectPrincipal.part	
							AND (Monitor.dbo.object.status ='A')						
							) AS ProcAutomatico) ,0) ,
		Ensamble = 	isnull((SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
					FROM   Monitor.dbo.object 
					WHERE  (Monitor.dbo.object.location IN (SELECT code FROM location WHERE group_no='Ensamble')) 
							AND Monitor.dbo.object.part = ObjectPrincipal.part
							and Monitor.dbo.object.location != 'MANUFACTUR'
							AND (Monitor.dbo.object.status ='A')   
							AND Monitor.dbo.object.location NOT LIKE 'LOST%'),0),
		RebajadoPiso_TransferProcesos = isnull((SELECT sum(cantidad) AS Cantidad FROM(
     							(SELECT sum(quantity) AS Cantidad  
		                        FROM audit_trail INNER JOIN part ON part.part = audit_trail.part
		                        JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
								WHERE	audit_trail.type = 'T' 
										AND LEFT(to_loc,2) IN ('TM','SP')
     									AND part.type='W' AND audit_trail.date_stamp>=@FechaAuditTrail     									
     									AND audit_trail.part = ObjectPrincipal.part
     								UNION ALL
								SELECT isnull(sum(quantity),0) AS Cantidad
								FROM monitor.dbo.object
								WHERE location IN (SELECT code FROM monitor.dbo.location l WHERE l.group_no IN ('Moldeo-Kits','SOBREMOLD'))
									
									AND Monitor.dbo.object.part = ObjectPrincipal.part						)
									) AS X),0)   	
FROM    HN.SA_BillMaterialData  ObjectPrincipal			 		 
WHERE    ( type = 'W') AND LEFT(ObjectPrincipal.part,3) IN ('DBL','CKT')
GROUP BY ObjectPrincipal.part) AS InvCKTs
GROUP BY Circuito, Estacion, Piso,Corte,Ensamble,RebajadoPiso_TransferProcesos


--
--CREATE INDEX IDX_Circuito ON @InventarioFisico(Circuito)
--

/*declare @Resumen table(
	[Circuito] [varchar](25) NULL,
	[Revision] [int] NULL,
	Total [numeric](20, 6) null
)*/


insert @Reporte
SELECT	Circuito = CircuitosRevision.Circuito,
		Revision = Sum(CircuitosRevision.Revision),
		Total = Sum(((isnull(InventarioFisico.InventarioFisico,0)+isnull(JobCompleteProcesos.Cantidad,0) +(isnull(CircuitosFGoods.TotalFG,0)*isnull(CircuitosRevision.CantidadCircuito,1))+isnull(circuitospotting.TotalPotting,0))-CircuitosRevision.Revision))
FROM	@CircuitosRevision CircuitosRevision 
		LEFT OUTER JOIN	@CircuitosFGoods CircuitosFGoods	ON CircuitosFGoods.Circuito = CircuitosRevision.Circuito
		LEFT OUTER JOIN	@JobCompleteProcesos JobCompleteProcesos	ON JobCompleteProcesos.Circuito =  CircuitosRevision.Circuito
		LEFT OUTER JOIN	@CircuitosPotting CircuitosPotting	 ON CircuitosPotting.Circuito = CircuitosRevision.circuito
		LEFT OUTER JOIN	@InventarioFisico InventarioFisico	ON InventarioFisico.circuito = CircuitosRevision.Circuito 
group by CircuitosRevision.Circuito

return
end
GO
