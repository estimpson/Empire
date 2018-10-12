SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Elvis Alas>
-- Create date: <Create Date,,1/18/2018>
-- Description:	<Description,,Procedimiento para calcular el scap, produccion y tiempo muerto en reporte de cristian.>
-- =============================================
CREATE PROCEDURE [dbo].[USP_PCB_PE_ReporteSPTM](@Fecha1 date,
										@Fecha2 date,
										@Area varchar(40),
										@Machine varchar(40),
										@Meta int,
										@Tipo int,
										@ContenedorID int,
										@Part  Varchar(25)
										)

AS
BEGIN
	
	Declare @Search varchar(40)=''
	set @Fecha2=DATEADD(day,1,@Fecha2)


	
--- Inicio del Scrap
Select	@Search= Value
from	eeh.HN.vw_PCB_LocationValidToConsolidateReport
where	area=@area
	and machine=@Machine

	create table  #info ( dia date, TotalScrap numeric(18,2),MetaAcumulada int,Tipo varchar(15))

if @Tipo=1
begin

insert into #info
	SELECT		Dia = convert(date,defects.transactionDT),
				ToltalScrap=CONVERT(DECIMAL(10, 2), SUM(Defects.QtyScrapped * part_standard.cost_cum)),
				Meta=@META,
				'Scrap'
	FROM    MONITOR.DBO.defect_codes AS defect_codes 
		INNER JOIN MONITOR.DBO.Defects AS Defects 
				ON defect_codes.code = Defects.DefectCode 
		INNER JOIN (Select	code
					from	MONITOR.DBO.location
					where	code like '' + @search + ''
						or group_no like '' + @search + ''
					union all
					Select	code
					from	MONITOR.DBO.location
					where	code in (
						Select	parte
						from	sistema.dbo.pcb_pe_familias
						where	familia = @Search)) AS setups_location 
				ON Defects.Machine = setups_location.code		
		INNER JOIN MONITOR.DBO.part_standard AS part_standard 
				ON Defects.Part = part_standard.part
	WHERE        (defect_codes.code_group <> 'backflush') 
		AND Defects.TransactionDT>=@Fecha1
		and Defects.TransactionDT<=@FEcha2
		AND (Defects.QtyScrapped <> 0) 
		AND (Defects.DefectCode <> 'otros') 
		AND (Defects.DefectCode <> 'scrap nj') 			
		AND (ISNULL(defect_codes.Account, 'W3') <> 'Y')		
	GROUP BY convert(date,defects.transactionDT)
	
end

declare @columnas varchar(max)

set @columnas = ''

select @columnas = coalesce(@columnas + '[' + cast(dia as varchar(150)) + '],', '')
FROM (select Dia from #info  ) as DTM
order by dia

set @columnas= LEFT(@columnas,len(@columnas)-1)

declare @ListaColumnas nvarchar(max)
	set @ListaColumnas=NULL
	select @ListaColumnas= Coalesce(@ListaColumnas + ' ,' + campo,campo)
	from(
	Select campo=concat(convert(varchar,dia),tipo)

	from   #info )  Data
	order by campo

DECLARE @SQLString nvarchar(max)

	set @SQLString = N'
		SELECT *
			into TempScrap
		FROM 
		(
			Select Tipo,Dia,totalscrap,MetaAcumulada
			from	#info 
			) AS SourceTable
			
		PIVOT
		(
		avg(totalscrap)
		FOR Dia IN (' + @columnas + ')
		) AS PivotTable	
		'
		EXECUTE sp_executesql @SQLString  

--- Fin del Scrap
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--- Inicio del produccion

create table  #Produccion ( Dia date, TotalProduccion int,MetaAcumulada int,Tipo varchar(15))
insert into #Produccion ( Dia ,TotalProduccion ,MetaAcumulada)
Exec eeh.[HN].[USP_PCB_TendeciaProduccionDiaria] @Fecha1,@Fecha2,@Part

update #Produccion set Tipo='Produccion'

declare @columnasP varchar(max)

set @columnasP = ''

select @columnasP = coalesce(@columnasP + '[' + cast(dia as varchar(150)) + '],', '')
FROM (select Dia from #Produccion  ) as DTM
order by dia

set @columnasP= LEFT(@columnasP,len(@columnasP)-1)

declare @ListaColumnasPorducion nvarchar(max)
	set @ListaColumnasPorducion=NULL
	select @ListaColumnasPorducion= Coalesce(@ListaColumnasPorducion + ' ,' + campo,campo)
	from(
	Select campo=convert(varchar,dia)

	from   #Produccion )  Data
	order by campo

DECLARE @SQLStringProduccion nvarchar(max)

--IF EXISTS( SELECT *  FROM monitor.dbo.TempProduccion)
--PRINT 'La tabla existe'
--else
--PRINT 'La tabla no existe'

	set @SQLStringProduccion = N'
		SELECT * 
		into TempProduccion
		FROM 
		(
			Select Tipo,dia,TotalProduccion,metaacumulada
			from	#Produccion 
			) AS SourceTable
			
		PIVOT
		(
		avg(TotalProduccion)
		FOR dia IN (' + @columnas + ')
		) AS PivotTable	
		'

			EXECUTE sp_executesql @SQLStringProduccion  
			--select * from monitor.dbo.TempProduccion
--- Fin del produccion
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--- Inicio del Tiempo Muerto

		create table  #TM ( Dia date, TiempoMuertoHours int,MetaAcumulada int,Tipo varchar(15))
		insert into #TM ( Dia , TiempoMuertoHours ,MetaAcumulada )
		Exec eeh.HN.USP_PCB_TendeciaProduccionDiariascrap_New  @Fecha1,@Fecha2,@Area,@Machine,@Meta,1
		update #TM set Tipo='Tiempo Muerto' 

			declare @columnasTM varchar(max)

			set @columnasTM = ''

			select @columnasTM = coalesce(@columnasTM + '[' + cast(dia as varchar(150)) + '],', '')
			FROM (select dia=concat(convert(varchar(150),Dia),tipo) from #TM  ) as DTM
			order by dia
			
			set @columnasTM= LEFT(@columnasTM,len(@columnasTM)-1)
			
			declare @ListaColumnasTM nvarchar(max)

				set @ListaColumnasTM=NULL
				select @ListaColumnasTM=Coalesce(@ListaColumnasTM + ' ,' + campo,campo)
				from(
				Select campo=concat(convert(varchar,dia),tipo)

				from   #TM )  Data
				order by campo

				print @ListaColumnasTM


			DECLARE @SQLStringTM nvarchar(max)

				set @SQLStringTM = N'
					SELECT *
					into TempTM
					FROM 
					(
						Select Tipo,dia,TiempoMuertoHours,MetaAcumulada
						from	#TM 
						) AS SourceTable
			
					PIVOT
					(
					avg(TiempoMuertoHours)
					FOR dia IN (' + @columnas + ')
					) AS PivotTable	
					'
						EXECUTE sp_executesql @SQLStringTM  



select * from Monitor.dbo.TempProduccion 
			cross join  Monitor.dbo.TempTM 
			cross join Monitor.dbo.TempScrap
			Cross join (select Producline='PCB')xdata1


Drop table #info
Drop table #Produccion
Drop table #TM
Drop table Monitor.dbo.TempProduccion
Drop table Monitor.dbo.TempTM
Drop table Monitor.dbo.TempScrap


END
GO
