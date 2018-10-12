SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [HN].[RLSP_CP_Corte_InventarioCircuito_Renew_old](
		@FechaAuditTrail datetime, 
		@Piso char(13), 
		@FechaContenedor datetime)
returns	@Reporte table(
	[Circuito] [varchar](25) NULL,
	[Ubicacion] [varchar](8) NULL,
	[CantidadCircuito] [int] NULL,
	[Tipo] [varchar](7) NULL,
	[Cost] [numeric](18, 6) NULL,
	[Revision] [int] NULL,
	[TotalFG] [numeric](18, 6) NULL,
	[TotalPotting] [numeric](18, 6) NULL,
	[Estacion] [numeric](18, 6) NULL,
	[Piso] [numeric](18, 6) NULL,
	[Corte] [numeric](18, 6) NULL,
	[Ensamble] [numeric](18, 6) NULL,
	[RebajadoPiso_TransferProcesos] [numeric](18, 6) NULL,
	[JobCompleteProcesos] [numeric](18, 6) NULL,
	[TotalInventarioFisico] [numeric](18, 6) NULL,
	[SubTotal] [numeric](18, 6) NULL,
	[TotalSemanal] [numeric](18, 6) NULL,
	[Dia1] [int] NULL,
	[Dia2] [int] NULL,
	[Dia3] [int] NULL,
	[Dia4] [int] NULL,
	[Dia5] [int] NULL,
	[Dia6] [int] NULL,
	[ReleaseDiario] [int] NULL,
	[TotalDiario] [numeric](18, 6) NULL) 
as
begin

/*

DECLARE @FechaAuditTrail datetime,
	@FechaContenedor datetime,
		@Piso char(13)
SET @FechaAuditTrail = '2008-07-07'
SET @Piso = 'PISO07-20'
SET @FechaContenedor = '2008-07-13'
exec [HN].[RLSP_CP_Corte_InventarioCircuito_Renew1] @FechaAuditTrail,@Piso,@FechaContenedor

*/

--set transaction isolation level read uncommitted

declare @Fecha datetime
select	@Fecha = Systemdate from HN.SystemDate 

declare @CircuitosRevision table(
	[Circuito] [varchar](25) NULL,
	[Ubicacion] [varchar](8) NULL,
	[Revision] [int] NULL,
	[cost] [numeric](20, 6) NULL,
	[CantidadCircuito] [int] NOT NULL,
	[Dia1] [int] NULL,
	[Dia2] [int] NULL,
	[Dia3] [int] NULL,
	[Dia4] [int] NULL,
	[Dia5] [int] NULL,
	[Dia6] [int] NULL
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
		cost = part_standard.material_cum ,
		CantidadCircuito = isnull(HC.CantidadCircuito,1),
		Dia1 = (sum(isnull(Release.ProgramadoDia1,0))*isnull(HC.CantidadCircuito,1)),
		Dia2 = (sum(isnull(Release.ProgramadoDia1,0)+isnull(Release.ProgramadoDia2,0))*isnull(HC.CantidadCircuito,1)),
		Dia3 = (sum(isnull(Release.ProgramadoDia1,0)+isnull(Release.ProgramadoDia2,0)+isnull(Release.ProgramadoDia3,0))*isnull(HC.CantidadCircuito,1)),
		Dia4 = (sum(isnull(Release.ProgramadoDia1,0)+isnull(Release.ProgramadoDia2,0)+isnull(Release.ProgramadoDia3,0)+isnull(Release.ProgramadoDia4,0))*isnull(HC.CantidadCircuito,1)),
		Dia5 = (sum(isnull(Release.ProgramadoDia1,0)+isnull(Release.ProgramadoDia2,0)+isnull(Release.ProgramadoDia3,0)+isnull(Release.ProgramadoDia4,0)+isnull(Release.ProgramadoDia5,0))*isnull(HC.CantidadCircuito,1)),
		Dia6 = (sum(isnull(Release.ProgramadoDia1,0)+isnull(Release.ProgramadoDia2,0)+isnull(Release.ProgramadoDia3,0)+isnull(Release.ProgramadoDia4,0)+isnull(Release.ProgramadoDia5,0)+isnull(Release.ProgramadoDia6,0))*isnull(HC.CantidadCircuito,1))	
FROM hn.sa_billMaterialdata Circuitos
left JOIN location  ON Circuitos.machine = location.code
	 JOIN part  ON circuitos.part = part.part
	 JOIN part_standard ON circuitos.part = part_standard.part
	 JOIN (SELECT Part, crpa.Revision, crpa.ProgramadoDia1, crpa.ProgramadoDia2, crpa.ProgramadoDia3,
				  crpa.ProgramadoDia4, crpa.ProgramadoDia5, crpa.ProgramadoDia6
			      FROM Sistema.dbo.CP_Revisiones_Produccion_Asignacion crpa
					WHERE crpa.ContenedorID = (SELECT ContenedorID 
											   FROM sistema.dbo.CP_Contenedores cc 
					                           WHERE datediff(d, cc.FechaEEH, @FechaContenedor) = 0 )
						  AND crpa.Revision>0 
						  AND crpa.Part NOT LIKE 'PRE%') Release ON Circuitos.originalpart=Release.part
	JOIN (SELECT hcc.Part, hcc.Circuito, hcc.CantidadCircuito
	      FROM Sistema.dbo.HC_Circuito_Componentes hcc) HC ON Circuitos.originalpart=HC.part AND Circuitos.part=HC.Circuito
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


					
----CREATE INDEX IDX_Circuito ON @CircuitosRevision(Circuito)

declare @CircuitosFGoods_J table (
	[Circuito] [varchar](25) NOT NULL,
	[TotalJ] [numeric](18, 6) NOT NULL
) 


insert @CircuitosFGoods_J
SELECT JobComplete.Circuito,(JobComplete.TotalJ)
FROM
(SELECT	xrt.childpart AS Circuito, isnull(sum(quantity),0) AS TotalJ 		
FROM   FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				  INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
				   JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
WHERE    LEFT(xrt.childpart,3) IN ('DBL','CKT') AND part.type='F' AND 
		audit_trail.type='J' AND audit_trail.date_stamp>=@FechaAuditTrail	
GROUP BY xrt.childpart) AS JobComplete

declare @CircuitosFGoods_M table (
	[Circuito] [varchar](25) NOT NULL,
	[TotalM] [numeric](18, 6) NOT NULL
)

insert @CircuitosFGoods_M
select MatIssue.Circuito,(isnull(MatIssue.TotalM,0)) AS TotalM
from
(	SELECT	xrt.childpart AS Circuito, isnull(sum(quantity),0) AS TotalM 	
	FROM   FT.XRT XRT INNER JOIN part  ON part.part = xrt.toppart
				  INNER JOIN audit_trail ON audit_trail.part = xrt.toppart
				   JOIN Sistema.dbo.CP_Revisiones_Produccion_Asignacion  a ON a.part = part.part
															INNER JOIN Sistema.dbo.CP_Contenedores b ON b.ContenedorID = a.ContenedorID
															and a.Revision>0 AND b.Activo=1
	WHERE    LEFT(xrt.childpart,3) IN ('DBL','CKT') AND part.type='F' AND 
		audit_trail.type='M' AND audit_trail.date_stamp>=@FechaAuditTrail
		AND audit_trail.to_loc = 'DELETE'
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
SELECT childpart AS Circuito, sum(quantity) AS Cantidad
FROM object INNER JOIN ft.xrt xrt ON object.part = xrt.toppart
WHERE LEFT(part,3) IN ('SUB','SPL','TM-') AND LEFT(xrt.childpart,3) IN ('CKT','DBL')
		AND (object.location NOT in ('ESTCUT-6','ESTCUT-12','Cert-corte','BOD-CKTOBS'))
GROUP BY childpart

--
--CREATE INDEX IDX_Circuito ON @JobCompleteProcesos(Circuito)
--
declare @CircuitosPotting TABLE (
	[Circuito] [varchar](25) NOT NULL,
	[TotalPotting] [numeric](18, 6) NULL
) 

insert @CircuitosPotting
select xrt.childpart AS Circuito, sum(Potting.Cantidad) AS TotalPotting
from ft.xrt XRT INNER JOIN
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
																 WHERE location.group_no in ('Ensamble', 'Manufactura')
																 AND code=object.location))
								AND (object.status !='R')  							
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

							) AS ProcAutomatico),0) ,		
		Piso = isnull((SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
					FROM   Monitor.dbo.object 
					WHERE  (Monitor.dbo.object.location LIKE 'PISO%') 
						AND Monitor.dbo.object.part = ObjectPrincipal.part),0) ,
		Corte = isnull((SELECT Sum(cantidad) 
		                FROM (
							SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
							FROM   Monitor.dbo.object 
							WHERE  (LEFT(Monitor.dbo.object.location,5) IN ('KOMAX','ARTOS')) 						
							AND Monitor.dbo.object.part = ObjectPrincipal.part							
							) AS ProcAutomatico) ,0) ,
		Ensamble = 	isnull((SELECT SUM(Monitor.dbo.object.quantity) AS Cantidad
					FROM   Monitor.dbo.object 
					WHERE  (Monitor.dbo.object.location IN (SELECT code FROM location WHERE group_no='Ensamble')) 
							AND Monitor.dbo.object.part = ObjectPrincipal.part
							AND (Monitor.dbo.object.status !='R')   
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
     									AND audit_trail.part = ObjectPrincipal.part)
									) AS X),0)   	
FROM    HN.SA_BillMaterialData  ObjectPrincipal			 		 
WHERE    ( type = 'W') AND LEFT(ObjectPrincipal.part,3) IN ('DBL','CKT')
GROUP BY ObjectPrincipal.part) AS InvCKTs
GROUP BY Circuito, Estacion, Piso,Corte,Ensamble,RebajadoPiso_TransferProcesos


--
--CREATE INDEX IDX_Circuito ON @InventarioFisico(Circuito)
--

declare @Resumen table(
	[Circuito] [varchar](25) NULL,
	[Ubicacion] [varchar](8) NULL,
	[Revision] [int] NULL,
	[cost] [numeric](20, 6) NULL,
	[CantidadCircuito] [int] NOT NULL,
	[Dia1] [int] NULL,
	[Dia2] [int] NULL,
	[Dia3] [int] NULL,
	[Dia4] [int] NULL,
	[Dia5] [int] NULL,
	[Dia6] [int] null,
	TotalFG	[numeric](20, 6) null,
	TotalPotting [numeric](20, 6) null,
	Estacion  [numeric](20, 6) null,
	Piso  [numeric](20, 6) null,
	Corte [numeric](20, 6) null,
	Ensamble [numeric](20, 6) null,
	RebajadoPiso_TransferProcesos [numeric](20, 6) null,
	JobCompleteProcesos  [numeric](20, 6) null,
	TotalInventarioFisico [numeric](20, 6) null,
	SubTotal [numeric](20, 6) null,
	Total [numeric](20, 6) null
)


insert	@Resumen     
SELECT	CircuitosRevision.*,
		TotalFG = isnull(CircuitosFGoods.TotalFG,0),
		TotalPotting = isnull(circuitospotting.TotalPotting,0),
		Estacion = isnull(InventarioFisico.Estacion,0) , 
		Piso = isnull(InventarioFisico.Piso,0), 
		Corte = isnull(InventarioFisico.Corte,0),
		Ensamble = isnull(InventarioFisico.Ensamble,0), 
		RebajadoPiso_TransferProcesos  = isnull(InventarioFisico.RebajadoPiso_TransferProcesos,0),
		JobCompleteProcesos = isnull(JobCompleteProcesos.Cantidad,0),
		TotalInventarioFisico = (isnull(InventarioFisico.InventarioFisico,0)+isnull(JobCompleteProcesos.Cantidad,0)),
		SubTotal = (isnull(InventarioFisico.InventarioFisico,0)+isnull(JobCompleteProcesos.Cantidad,0) +isnull(CircuitosFGoods.TotalFG,0)+isnull(circuitospotting.TotalPotting,0)),
		Total = ((isnull(InventarioFisico.InventarioFisico,0)+isnull(JobCompleteProcesos.Cantidad,0) +isnull(CircuitosFGoods.TotalFG,0)+isnull(circuitospotting.TotalPotting,0))-CircuitosRevision.Revision)
FROM	@CircuitosRevision CircuitosRevision 
		LEFT OUTER JOIN	@CircuitosFGoods CircuitosFGoods	ON CircuitosFGoods.Circuito = CircuitosRevision.Circuito
		LEFT OUTER JOIN	@JobCompleteProcesos JobCompleteProcesos	ON JobCompleteProcesos.Circuito =  CircuitosRevision.Circuito
		LEFT OUTER JOIN	@CircuitosPotting CircuitosPotting	 ON CircuitosPotting.Circuito = CircuitosRevision.circuito
		LEFT OUTER JOIN	@InventarioFisico InventarioFisico	ON InventarioFisico.circuito = CircuitosRevision.Circuito 
 

--SELECT	DISTINCT Part AS  Moldeo
----INTO @Moldeo
--FROM	eeh.HN.SA_BillMaterialData AS Data
--WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('ENSAMBLE','MANufactura'))
--		AND type='W' 
--		AND LEFT(parent_part,3) IN ('MOL')			
--		AND LEFT(part,3) IN ('CKT','DBL')

declare @MOLDEO table (
	[MOLDEO] [varchar](25) NULL,
	[Dias] [int] NOT NULL,
	[SiguienteProceso] [varchar](6) NOT NULL
)

insert @MOLDEO
SELECT DISTINCT part AS MOLDEO, 2 as Dias, 'Moldeo' as SiguienteProceso
FROM eeh.HN.SA_BillMaterialData AS Data
WHERE originalpart in
	(SELECT	DISTINCT parent_part
	--INTO @Moldeo
	FROM	eeh.HN.SA_BillMaterialData AS X
	WHERE	machine IN (SELECT code FROM location WHERE location.group_no IN ('ENSAMBLE','MANufactura'))
	AND type='W' 
	AND LEFT(part,3) IN ('MOL'))
AND LEFT(part ,3) IN ('CKt','DBL')

--SELECT	DISTINCT Part AS Potting, machine
--INTO @Potting 
--FROM	eeh.HN.SA_BillMaterialData AS Data
--WHERE	machine IN ('POTTING')
--		AND type='W' 
--		AND LEFT(parent_part,3) IN ('Pot')	
--		AND LEFT(part,3) IN ('CKT','DBL')

declare  @POTTING table(
	[POTTING] [varchar](25) NULL,
	[Dias] [int] NOT NULL,
	[SiguienteProceso] [varchar](7) NOT NULL
)

insert @POTTING 
SELECT DISTINCT part AS POTTING, 1 as Dias, 'Potting' as SiguienteProceso
FROM eeh.HN.SA_BillMaterialData AS Data
WHERE originalpart IN (
			SELECT	DISTINCT originalpart 
			FROM	eeh.HN.SA_BillMaterialData AS Data
			WHERE	machine IN ('POTTING')
					AND type='W' 
					AND LEFT(parent_part,3) IN ('Pot')	
					)
		AND LEFT(part,3) IN ('CKT','DBL')



insert @Reporte
SELECT	Resumen.Circuito,
		Resumen.Ubicacion,
		Resumen.CantidadCircuito,
		Tipo = coalesce( Moldeo.SiguienteProceso, Potting.SiguienteProceso, 'Linea' ),
		sum(Resumen.Cost) AS Cost,
		sum(Resumen.Revision) AS Revision,
		sum(Resumen.TotalFG) AS TotalFG,
		sum(Resumen.TotalPotting) AS TotalPotting,
		sum(Resumen.Estacion) AS Estacion,
		sum(Resumen.Piso) AS Piso,
		sum(Resumen.Corte) AS Corte,
		sum(Resumen.Ensamble) AS Ensamble,
		sum(Resumen.RebajadoPiso_TransferProcesos) AS RebajadoPiso_TransferProcesos,
		sum(Resumen.JobCompleteProcesos) AS JobCompleteProcesos,
		sum(Resumen.TotalInventarioFisico) AS TotalInventarioFisico,
		sum(Resumen.SubTotal) AS SubTotal,
		sum(Resumen.Total) AS TotalSemanal,
		Dia1 = Sum(dia1),	
		Dia2 = Sum(dia2),
		Dia3 = Sum(dia3),
		Dia4 = Sum(dia4),
		Dia5 = Sum(dia5),
		Dia6 = Sum(dia6),
		ReleaseDiario = sum(case datepart(dw,@Fecha) + coalesce( Moldeo.Dias, Potting.Dias, 0 )
							when 1 then dia1
							when 2 then dia2
							when 3 then dia3
							when 4 then dia4
							when 5 then dia5
							else
								dia6
							end),
		TotalDiario = sum(Resumen.SubTotal) - sum(case datepart(dw,@Fecha) + coalesce( Moldeo.Dias, Potting.Dias, 0 )
							when 1 then dia1
							when 2 then dia2
							when 3 then dia3
							when 4 then dia4
							when 5 then dia5
							else
								dia6
							end) 
FROM	@Resumen Resumen  LEFT JOIN @MOLDEO MOLDEO
					ON moldeo.Moldeo = Resumen.Circuito
				   left JOIN @POTTING POTTING
					ON POTTING.POTTING = Resumen.Circuito
GROUP BY	Circuito,
			Ubicacion,
			Resumen.CantidadCircuito,
		   coalesce( Moldeo.SiguienteProceso, Potting.SiguienteProceso, 'Linea' )
ORDER BY	substring(circuito,5,7)

return
end
GO
