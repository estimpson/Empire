SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[usp_PCB_CumplimientoPlantaEnsamble_Ventas] (@valor  int) as begin

set transaction isolation level read uncommitted
SET XACT_ABORT ON 

SET nocount ON

DECLARE	@TranCount smallint,@Error integer,@ProcName sysname
set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName

delete  from PCB_DataGraficas
Declare @ventasTotal decimal(18,4), @porcentajeScrap decimal(18,4), @porcentajeOT decimal(18,4)

select   @ventasTotal  = convert (decimal(18,4), sum ((precios.Price  * CPR.Revision3)))  from 
				CP_Revisiones_Produccion cpr
						inner join  CP_Contenedores cp  on  cpr.ContenedorID =cp.ContenedorID 
						inner join part p on p.part =cpr.Part 
						left JOIN 
						( select  Part = blanket_part, PONumber = MAX( order_no ), Price = MAX(ISNULL(Price, Alternate_price))
                                  from   eeh.dbo.order_header_eei
                                  group by blanket_part ) precios on cpr.Part =precios.Part  
	where p.product_line ='PCB' AND CP.Activo =1 AND CPR.Part  NOT LIKE '%-PT%' and Revision3 >0

	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end

	set @porcentajeScrap =(@ventasTotal *0.25)/100
	set @porcentajeOT =(@ventasTotal *0.5)/100

	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end

	Insert PCB_DataGraficas(Concepto,Valor  )
	Values ('VentasTotales',@ventasTotal )
	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end

	Insert PCB_DataGraficas(Concepto,Valor  )
	Values ('MetaScrap',@porcentajeScrap )
	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end

	Insert PCB_DataGraficas(Concepto,Valor  )
	Values ('MetaOT',@porcentajeOT )
	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end


Declare @DatosGenerales table(ID INT Identity (1,1),								
								Dia date,
								Acumulado decimal(18,4)
								)


Insert INTO @DatosGenerales
select  Dia=Convert(date,TranDT ), Acumulado=sum (venta)  from 
				(select  cpr.Part ,precios.Price  ,CPR.Revision3 ,bh.qtyproduced,bh.trandt ,Venta =(precios.Price  * bh.qtyproduced)  from 
								CP_Revisiones_Produccion cpr
										inner join  CP_Contenedores cp  on  cpr.ContenedorID =cp.ContenedorID 
										inner join part p on p.part =cpr.Part 
										inner JOIN 
										( select  Part = blanket_part, PONumber = MAX( order_no ), Price = MAX(ISNULL(Price, Alternate_price))
												  from   eeh.dbo.order_header_eei
												  group by blanket_part ) precios on cpr.Part =precios.Part  
										inner join BackFlushHeaders bh on bh.partproduced=cpr.Part and TranDt >(cp.FechaEEH-6) and (bH.operationSource='J' OR bH.QTYPRODUCED<0)
					where p.product_line ='PCB' AND CP.Activo =1 AND CPR.Part  NOT LIKE '%-PT%' and Revision3 >0 ) datos
					group by Convert(date,TranDT )

	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end

	Insert PCB_DataGraficas(Concepto,DiaSemana,Porcentaje,Meta   )

			SELECT Concepto='GraficaVentas', 
								Dia= DATENAME(DW  ,Dia ), 
										Porcentaje= convert (decimal (18,4), ((sum (SUM(Acumulado  )) OVER (ORDER BY Dia  ASC))/@ventasTotal)*100 ),
										Meta=100
					
											FROM @DatosGenerales  
											group by dia
						

	select @Error = @@Error
	if	@Error != 0 begin
			rollback tran @ProcName
			return
	end					

if	@TranCount = 0 begin
	commit tran @ProcName
end


end
GO
