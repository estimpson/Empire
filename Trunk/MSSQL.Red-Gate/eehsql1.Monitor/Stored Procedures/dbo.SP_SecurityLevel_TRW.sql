SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_SecurityLevel_TRW] -- Add the parameters for the stored procedure here
@fecha_inicial datetime,
@fecha_final datetime,
@partlike varchar(3) AS BEGIN
SET NOCOUNT ON;
/*
	exec SP_SecurityLevel_TRW '01/20/2014','01/25/2014','TRW'

*/
DECLARE @PrevMan TABLE ( partf varchar(50))
INSERT INTO @PrevMan EXEC sistema.dbo.SP_GetPreventiveMaintenance @partlike --CHECK LINEAS Y PARTES REVISAR FORMATO CORRECTO

SELECT DISTINCT REPLACE(A.part,' ','') AS PART,
                substring(REPLACE(A.part,' ',''),1,7) AS FAMILIA,
                ISNULL(AA.Status,'Line Down') AS STATUS,
                0 AS POKE_YOKE,
                isnull(F.PREV_MANT,0) AS PREV_MANT,
                isnull(E.PERSONNEL,0) AS PERSONNEL,
                0 AS DEFECT_TEND,
                0 AS SUPERVISOR_AUDIT,
                0 AS APQP_ECN,
                0 AS RPN,
                isnull(G.IPM,0) AS IPM,
                isnull(B.DOCK_AUDIT,0) AS DOCK_AUDIT,
                0 AS MFG_LINE_FRC,
                isnull(C.OT,0) AS OT,
                0 AS SCRAP,
                0 AS HK,
                ISNULL(D.PRODUCTION_COMPLIANCE,0) AS PRODUCTION_COMPLIANCE
FROM OBJECT A --A part obtenerla de origen de reporte de Vania para saber lines down etc...
--contenedor previo al current
LEFT JOIN
  (SELECT B.Part,
          'Programmed' AS Status
   FROM
     (SELECT TOP 1 ContenedorID
      FROM
        ( SELECT DISTINCT TOP 2 ContenedorID
         FROM CP_Revisiones_Produccion_asignacion
         ORDER BY ContenedorID DESC ) z
      ORDER BY ContenedorID ASC ) A
   LEFT JOIN
     (SELECT *
      FROM CP_Revisiones_Produccion_asignacion ) B ON A.ContenedorID=B.ContenedorID
   WHERE B.Part LIKE 'TRW%' ) AA ON REPLACE(A.part,' ','')=substring(REPLACE(AA.part,' ',''),1,12)
LEFT JOIN
  (SELECT substring(REPLACE(Defects.Part,' ',''),1,12) AS partb,
          cast(-40 AS int) AS DOCK_AUDIT
   FROM Monitor.dbo.Defects Defects
   WHERE (Defects.Machine='PRECONTENC')
     AND (Defects.TransactionDT>=@fecha_inicial
          AND Defects.TransactionDT<=@fecha_final) ) B ON REPLACE(A.part,' ','')=substring(Replace(B.partb,' ',''),1,12)
LEFT JOIN
  (SELECT substring(replace(part,' ',''),1,12) AS partc,
          cast(-20 AS int) AS OT
   FROM
     (SELECT PL_Transacciones.Fecha,
             PL_Transacciones.Part,
             Count(PL_Transacciones.EmpleadoID) AS 'Count of EmpleadoID'
      FROM sistema.dbo.PL_Transacciones PL_Transacciones
      GROUP BY PL_Transacciones.Fecha,
               PL_Transacciones.Part,
               PL_Transacciones.TipoTransaccion,
               PL_Transacciones.Turnoid HAVING (PL_Transacciones.TipoTransaccion=7)
      AND (PL_Transacciones.Turnoid=0)
      AND (PL_Transacciones.Part LIKE @partlike+'%')
      AND (PL_Transacciones.Fecha>=@fecha_inicial
           AND PL_Transacciones.Fecha<=@fecha_final)) Tmp) C ON REPLACE(A.part,' ','')=substring(replace(C.partc,' ',''),1,12)
LEFT JOIN
  (SELECT substring(replace(part,' ',''),1,12) AS partd,
          cast(-15 AS int) AS PRODUCTION_COMPLIANCE
   FROM
     (SELECT wos.Part,
             sum(wos.QtyRequired) AS QtyRequired,
             sum(wos.QtyCompleted) AS QtyCompleted,
             sum(wos.QtyRequired)-sum(wos.QtyCompleted) AS Pending,
             IIF((sum(wos.QtyRequired)-sum(wos.QtyCompleted))>=0,'Not Ok','Ok') AS Status
      FROM Monitor.dbo.wos wos --check this date if inicial o final? cual usar

      WHERE (wos.ShiftDate=@fecha_inicial)
        AND (wos.Type=7)
        AND (wos.Part LIKE @partlike+'%')
        AND (wos.QtyRequired>QtyCompleted)
      GROUP BY wos.Part HAVING (sum(wos.QtyRequired)-sum(wos.QtyCompleted)>=0)) Tmp) D ON REPLACE(A.part,' ','')=substring(replace(D.partd,' ',''),1,12)
LEFT JOIN
  (SELECT REPLACE(Tmp.Part,' ','') AS parte,
          cast(15 AS int) AS PERSONNEL
   FROM 
 (---usar query de liberaciones  ATENCION
--select A.Part, LessThan3Month = sum(case when isnull(B.wks,0)<13 then 1 else 0 end), --ifnull(wks) =0
--  MoreThan3Month = sum(case when isnull(B.wks,0)>=13 then 1 else 0 end) from
--(select distinct
--substring(Cl.Part,1,7) as Part,CLE.EmpleadoID from sistema.dbo.Cal_Liberacion_Empleados CLE,sistema.dbo.Cal_Liberaciones Cl
--where CLE.LiberacionID=CL.LiberacionID
--and CL.Part like 'trw%' and CL.Tipo='CC' and CL.transDT<=getdate()
--and CL.transDT >= dateadd(day,-92,getdate())) A
--left join
--(select
--CLE.EmpleadoID,count(distinct datepart(wk,CL.transdt)) as wks from sistema.dbo.Cal_Liberacion_Empleados CLE,sistema.dbo.Cal_Liberaciones Cl
--where CLE.LiberacionID=CL.LiberacionID
--and CL.Part like 'trw%' and CL.Tipo='CC' and CL.transDT<=getdate()
--and CL.transDT >= dateadd(day,-92,getdate())  --feriado de navidad por ejemplo fueron varios dias...
--group by CLE.EmpleadoID ) B
--on A.EmpleadoID=B.EmpleadoID
--group by A.Part

         SELECT Part,
                LessThan3Month = sum(CASE WHEN datediff(DAY, FechaIngreso, getdate()) < 91 THEN 1 ELSE 0 END),
                                 MoreThan3Month = sum(CASE WHEN datediff(DAY, FechaIngreso, getdate()) >= 91 THEN 1 ELSE 0 END)
         FROM sistema.dbo.PL_Transacciones Transactions
         JOIN RH_Empleados Empleados ON Empleados.EmpleadoId = Transactions.EmpleadoID
         WHERE TipoTransaccion = 1
           AND Turnoid = 0
           AND part LIKE @partlike+'%'
           AND Fecha >= @fecha_inicial
           AND Fecha <= @fecha_final
         GROUP BY Part) Tmp
   WHERE (Tmp.MoreThan3Month/(Tmp.MoreThan3Month+Tmp.LessThan3Month)>0.5)) E ON REPLACE(A.part,' ','')=replace(E.parte,' ','')
LEFT JOIN
  (SELECT P.partf,
          cast(5 AS int) AS PREV_MANT
   FROM @PrevMan P) F ON substring(REPLACE(A.part,' ',''),1,7)=replace(F.partf,' ','')
LEFT JOIN
  (SELECT SQCLH.Part_Number_EEH AS partg,
          cast(-40 AS int) AS IPM,
          SQCLH.Date_Reported_Customer,
          iSNULL(NULLIF(SQCLH.Harness_Date,''),'TBD') AS Harness_Date
   FROM Sistema.dbo.SQC_Log_header SQCLH
   WHERE SQCLH.Part_Number_EEH LIKE @partlike+'%'
     AND SQCLH.OFFICIAL=1 -- date? what other validations Date Reported or Harness Date?
) G ON REPLACE(A.part,' ','')=substring(replace(G.partg,' ',''),1,12)
WHERE A.part LIKE @partlike+'%' 
--declare @ReporteFinal table
--(
--      TipoReporte int,
--      Descripcion varchar(50),
--      Valor decimal(18,2)
--     )
--Select * from @ReporteFinal
END


GO
