SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[usp_PCB_CumplimientoPlantaEnsamble_Piezas] (@valor  int) as begin



Declare @PiezasTotales decimal(18,4)
select   @PiezasTotales  = convert (decimal(18,4), sum ( CPR.Revision3))  from 
				CP_Revisiones_Produccion cpr
						inner join  CP_Contenedores cp  on  cpr.ContenedorID =cp.ContenedorID 
						inner join part p on p.part =cpr.Part 
						left JOIN 
						( select  Part = blanket_part, PONumber = MAX( order_no ), Price = MAX(ISNULL(Price, Alternate_price))
                                  from   order_header_eei
                                  group by blanket_part ) precios on cpr.Part =precios.Part  
	where p.product_line ='PCB' AND CP.Activo =1 AND CPR.Part  NOT LIKE '%-PT%' and Revision3 >0


	



Declare @DatosGenerales table(ID INT Identity (1,1),								
								Dia date,
								Acumulado decimal(18,4)
								)


Insert INTO @DatosGenerales
select  Dia=Convert(date,TranDT ), Acumulado=sum (QtyProduced )  from 
				(select  cpr.Part   ,CPR.Revision3 ,bh.qtyproduced,bh.trandt   from 
								CP_Revisiones_Produccion cpr
										inner join  CP_Contenedores cp  on  cpr.ContenedorID =cp.ContenedorID 
										inner join part p on p.part =cpr.Part 
										inner JOIN  BackFlushHeaders bh on bh.partproduced=cpr.Part and TranDt >(cp.FechaEEH-6) and (bH.operationSource='J' OR bH.QTYPRODUCED<0)
					where p.product_line ='PCB' AND CP.Activo =1 AND CPR.Part  NOT LIKE '%-PT%' and Revision3 >0 ) datos
					group by Convert(date,TranDT )


	Insert PCB_DataGraficas(Concepto,DiaSemana,Porcentaje,Meta   )

			SELECT Concepto='GraficaPiezas', 
								Dia= DATENAME(DW  ,Dia ), 
										Porcentaje= convert (decimal (18,4), ((sum (SUM(Acumulado  )) OVER (ORDER BY Dia  ASC))/@PiezasTotales)*100 ),
										Meta=100
					
											FROM @DatosGenerales  
											group by dia
						

					
		end
GO
