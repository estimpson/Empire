SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[usp_PCB_CumplimientoPlantaEnsamble_Scrap] (
	@FechaInicio datetime,
	@FechaFinal datetime)
AS
BEGIN

Declare @MetaScrap decimal(18,2)

Select @MetaScrap=Valor  from PCB_DataGraficas where Concepto ='VentasTotales'

Declare @DatosGenerales table(ID INT Identity (1,1),
								Machine varchar(50), 
								Dia date,
								TotalScrap decimal(18,2), 
								TipoScrap varchar(50),
								AreaScrap varchar(50)  )


Insert INTO @DatosGenerales 
SELECT	--Familia = isnull(familia,'Otros'),
		Defects.Machine,	
		Dia = convert(date,defects.transactionDT),	
		ToltalScrap=CONVERT(DECIMAL(10, 2), SUM(Defects.QtyScrapped * part_standard.cost_cum)),
		TipoScrap = case when ISNULL(defect_codes.Account, 'W3')='W3' then 'Operativo' 
						 when ISNULL(defect_codes.Account, 'W3')='W1' then 'Natural'
							else 'ND' end,
		AreaScrap = setups_location.area
	FROM    MONITOR.DBO.defect_codes AS defect_codes 
		INNER JOIN MONITOR.DBO.Defects AS Defects 
				ON defect_codes.code = Defects.DefectCode 
		INNER JOIN (
		
					--Select	code, area='Ensamble'
					--from	MONITOR.DBO.location
					--where	code like '' + @search + ''
					--	or group_no like '' + @search + ''
					--union all
					--Select	code, area='Ensamble'
					--from	MONITOR.DBO.location
					--where	code in (
					--	Select	parte
					--	from	sistema.dbo.pcb_pe_familias
					--	where	familia = @Search)

					Select code,area='Ensamble' from location  where group_no in (
							select Grupo='PCB-SUB-ENSAMBLE' union 
							select Grupo='PCB-ENSAMBLE-KT' union 
							select Grupo='PCB-ENSWIP' union 
							select Grupo='PCB-ENSRAW' union 
							select Grupo='PCB-ENSAMBLE-MC' union 
							select Grupo='PCB-ENSAMBLE' union 
							select Grupo='PCB-PACKAGING' union 
							select Grupo='RETPCB-ENS' union 
							select Grupo='RECHA-PCB' union 
							select Grupo='RETCARRIER')
					union all

					select code='RETPCB-ENS',area='Ensamble' union all
					select code='RECHA-PCB',area='Ensamble' union  all
					select code='RETCARRIER',area='Ensamble'

					--Select	code, area='Reteneciones/otros'
					--from	MONITOR.DBO.location
					--where	group_no in (--'PCB-ENSWIP',
					--					'PCB-PANEL+ID','PCB-RET'
					--					--,'PCB-ENSRAW'
						--				)
					) AS setups_location 
				ON Defects.Machine = setups_location.code		
		INNER JOIN MONITOR.DBO.part_standard AS part_standard 
				ON Defects.Part = part_standard.part
		--LEFT JOIN sistema.dbo.pcb_pe_familias Familias
		--		ON Familias.Parte = Defects.Machine
	WHERE        (defect_codes.code_group <> 'backflush') 
		AND Defects.TransactionDT>=@FechaInicio
		and Defects.TransactionDT<=@FechaFinal
		AND (Defects.QtyScrapped <> 0) 
		AND (Defects.DefectCode <> 'otros') 
		--AND (Defects.DefectCode <> 'scrap nj') 			
		AND (Defects.DefectCode <> 'PCB-Empaqu') 			
		AND (ISNULL(defect_codes.Account, 'W3') <> 'Y')		
	GROUP BY --isnull(familia,'Otros'),
				convert(date,defects.transactionDT), 
				Defects.Machine,
				case when ISNULL(defect_codes.Account, 'W3')='W3' then 'Operativo' 
					 when ISNULL(defect_codes.Account, 'W3')='W1' then 'Natural'
						else 'ND' end,
				setups_location.area


			
	Insert PCB_DataGraficas(Concepto,DiaSemana,Porcentaje,Meta   )

SELECT Concepto='GraficaScrap',DiaSemana=DATENAME(DW  ,Dia ), 
						--DIA=SUM(TotalScrap ) ,
						--Acumulado=(sum (SUM(TotalScrap )) OVER (ORDER BY DATENAME(DW  ,Dia ) ASC)) , 
						Porcentaje= convert (decimal (18,4), ((sum (SUM(TotalScrap )) OVER (ORDER BY Dia  ASC))/@MetaScrap)*100 ), 
						--Porcentaje= convert (decimal (18,4), ((sum (SUM(TotalScrap )) OVER (ORDER BY Dia  ASC)))), 
						--Meta=480.84   
							Meta =0.25
					FROM @DatosGenerales 
					WHERE TipoScrap IN ('Natural','Operativo') AND AreaScrap ='Ensamble'
				group by dia 
				
END
GO
