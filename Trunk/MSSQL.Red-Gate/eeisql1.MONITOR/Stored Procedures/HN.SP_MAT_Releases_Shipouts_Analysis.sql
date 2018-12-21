SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Hector Joel Chavez>
-- Create date: <9/26/2016>
-- Description:	<Generate Analysis of ship outs and releases>
-- =============================================

-- exec [HN].[SP_MAT_Releases_Shipouts_Analysis] @fechainicial = '2018-01-01', @fechafinal = '2018-05-04', @parte = 'SLA0346?', @dia = 5



CREATE PROCEDURE [HN].[SP_MAT_Releases_Shipouts_Analysis]

		@FechaInicial	datetime,
		@FechaFinal		Datetime,
		@Parte			Varchar(50),
		@Dia			Int
AS
BEGIN
	create table #Datos(
	id int identity(1,1) primary key,
	DueDT Date,
	StdQty Numeric(18, 6),
	Generateddt Date,
	ident varchar(1)
)


select @parte = replace(@parte,';','')


INSERT INTO #Datos(DueDT, StdQty, Generateddt, ident)
SELECT DueDT= DueDT, StdQty=Sum(StdQty), Generateddt = convert(date,generateddt), ident FROM
		(
		SELECT			ident = 'x', Generateddt = convert(date, b.generateddt),Semana = datepart(week, DueDT), 
						DueDT= Convert(Date,CASE  when DATEPART(dw, a.DueDT) = 1 then dateadd(day, 1, a.DueDT) when DATEPART(dw, a.DueDT) = 3 then dateadd(day, -1, a.DueDT) 
						when DATEPART(dw, a.DueDT) = 4 then dateadd(day, -2, a.DueDT) when DATEPART(dw, a.DueDT) = 5 then dateadd(day, -3, a.DueDT) when DATEPART(dw, a.DueDT) = 6 then dateadd(day, -4, a.DueDT) 
						when DATEPART(dw, a.DueDT) = 7 then dateadd(day, -5, a.DueDT) else DueDT end), 								
						a.StdQty,a.Part

		FROM			MONITOR.dbo.CustomerReleasePlanRaw a join MONITOR.dbo.customerreleaseplans b on a.releaseplanid = b.id
		WHERE	Part Like'%'+@Parte+'%'  -- like @Parte+'%' 
			and Generateddt >= @FechaInicial and generateddt < @FechaFinal 
			And Datepart(dw, convert(date, Generateddt)) = @Dia
		) Datos
Group by Semana, Part,  DueDT, convert(date,generateddt), ident

INSERT INTO #Datos(DueDT, StdQty, Generateddt, ident)
SELECT DueDt, Total = Sum(Total), generateddt, ident 
FROM (
	SELECT Ident = 'y', Semana=Datepart(week, date_stamp), Dia=datepart(dw, date_stamp), Data.part, 
				DueDT=CASE  when DATEPART(dw, date_stamp) = 1 then dateadd(day, 1, date_stamp) when DATEPART(dw, date_stamp) = 3 then dateadd(day, -1, date_stamp) 
						when DATEPART(dw, date_stamp) = 4 then dateadd(day, -2, date_stamp) when DATEPART(dw, date_stamp) = 5 then dateadd(day, -3, date_stamp) when DATEPART(dw, date_stamp) = 6 then dateadd(day, -4, date_stamp) 
						when DATEPART(dw, date_stamp) = 7 then dateadd(day, -5, date_stamp) else date_stamp end, 
				
				Total = SUM(quantity) , generateddt = Fechas.Generateddt FROM 
				(
				SELECT date_stamp=Convert(Date, audit_trail.date_stamp), audit_trail.type, audit_trail.part, audit_trail.quantity
				FROM MONITOR.dbo.audit_trail audit_trail
				WHERE (audit_trail.date_stamp>{ts '2016-05-20 00:00:00'}) AND (audit_trail.type='S')  
				AND date_stamp >=@FechaInicial
				and date_stamp < @fechaFinal
				AND ( audit_trail.part Like'%'+@Parte+'%' )
				) Data
					cross Join	(	SELECT		Distinct Generateddt = convert(date, b.generateddt)
									FROM		#Datos b
								) fechas
	group by date_stamp, type, Data.part, fechas.generateddt
	)Data1
Group By DueDt, generateddt, Ident   

UPDATE #Datos
set stdqty=NULL
FROM #Datos Datos
left join (SELECT * FROM #Datos Where Ident='X') Release on  Release.duedt = Datos.duedt and Release.Generateddt = Datos.Generateddt
join (
select max(Generateddt) as fcontenedor,duedt from  #Datos where Ident='x' group by duedt
)FirstRelease on FirstRelease.duedt = Datos.duedt
where Datos.ident='Y' and Datos.Generateddt <  FirstRelease.fcontenedor

Delete from #Datos
from #Datos d1
	inner join (
				select MAX(id) as id, DueDt, Generateddt 
				from #Datos
				group by DueDT, Generateddt
				having count(1)>1
				) D2
		on d1.duedt = d2.duedt and d1.Generateddt = d2.Generateddt
where ident = 'y'

UPDATE #Datos set StdQty = StdQty+0.000001
where Ident='x'

select month(DueDT) as Due_Month, year(DueDT) as Due_Year, DueDT, StdQty=ISNULL(StdQty,0), Generateddt, Ident from #Datos

drop table #Datos
END


GO
