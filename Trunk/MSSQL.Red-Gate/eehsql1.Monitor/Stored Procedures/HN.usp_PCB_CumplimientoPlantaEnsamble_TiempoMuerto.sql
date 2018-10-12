SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[usp_PCB_CumplimientoPlantaEnsamble_TiempoMuerto] (
	@FechaInicio datetime,
	@FechaFinal datetime)
AS
BEGIN

Declare @search varchar(25)
set @search='PCB-Ensamble%'


	Declare @DatosGenerales table(ID INT Identity (1,1),
								Machine varchar(50), 
								Dia date,
								TotaTiempoMuerto decimal(18,2) 
								)


Insert INTO @DatosGenerales 

select	
			Machine = DownTime.log_machine,
			Dia = convert(date,log_date_begin),
			TotalTiempoMuerto=sum(DATEDIFF(MINUTE,log_date_begin,log_date_end)/60.0)
			
		from hn.General_Log_DownTime DownTime
		join  Sistema.dbo.SA_Areas Areas on DownTime.log_areaID = Areas.AreaId 
		INNER JOIN (					
					Select	code
					from	location
					where	code like '' + @search + ''
						or group_no like '' + @search + ''
					union 
					Select	code
					from	location
					where	code in (
						Select	parte
						from	sistema.dbo.pcb_pe_familias
						where	familia = @Search)) AS setups_location 
				ON DownTime.LinePCB like '' + setups_location.code + '' or DownTime.log_machine like '' + setups_location.code + '' 
		where log_date_begin >= @FechaInicio and log_date_end <=@FechaFinal
		and log_AssignedArea = 27 
		group by 
			DownTime.log_machine,
			 convert(date,log_date_begin)


			 Insert PCB_DataGraficas(Concepto,DiaSemana,Porcentaje,Meta   )
				SELECT Concepto='GraficasTiempo',DiaSemana=DATENAME(DW  ,Dia ), 
						--DIA=SUM(TotalScrap ) ,
						--Acumulado=(sum (SUM(TotalScrap )) OVER (ORDER BY DATENAME(DW  ,Dia ) ASC)) , 
						Porcentaje= convert (decimal (18,4), ((sum (SUM(TotaTiempoMuerto )) OVER (ORDER BY Dia  ASC))) ), 
						--Meta=480.84   
							Meta =58
					FROM @DatosGenerales 
					
				group by dia
END
GO
