SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create PROCEDURE [dbo].[SP_RH_CalculoPrestaciones_Beta](@FechaCalculo datetime = null, @Tipo tinyint, @EmpleadoID int = null, @Observacion varchar(200)=null, @SoloActivos varchar(1) = 'N', @FechaUltimaCesantia datetime = null ) 
AS
/*
declare coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) datetime, @Tipo tinyint

--Tipo:
--    1: Despido
--    2: Cesantia
--    3: Renuncia
--- 4: Despido Justificado

set @Tipo=2

set coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)='01/10/2014'

exec SP_RH_CalculoPrestaciones 
            coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) = coalesce(@FechaCalculo,RH_Empleados.FechaEgreso),
            @Tipo = @Tipo,
            @SoloActivos = 'N'

*/

create table #Calculo 
            (     EmpleadoID varchar(10),
                  Nombre varchar(60),
                  Puesto  varchar(60),
                  FechaIngreso datetime,
                  FechaCesantia datetime,
                  FechaEgreso datetime,
                  Anos int, Meses int,Dias int,
                  SalarioBaseDiario numeric(14,2),
                  SalarioPromedioDiario numeric(14,2),
                  SalarioOrdinarioDiario numeric(14,2),
                  SalarioBase numeric(14,2),
                  SalarioPromedio numeric(14,2),
                  SalarioOrdinario numeric(14,2),
                  VacacionesGozadas numeric(14,2),
				  Vacaciones numeric(14,2),
                  VacacionesProporcionales numeric(14,2),
                  Treceavo numeric(14,2),
                  Catorceavo numeric(14,2),
                  Preaviso numeric(14,2),
                  Cesantia  numeric(14,2),
                  CesantiaProporcial numeric(14,2),
                  CooperativaAhorro numeric(14,2),
                  CooperativaPrestamo numeric(14,2), 
                  VacacionesLps numeric(14,2),
                  VacacionesProporcionalesLps numeric(14,2),
                  TreceavoLps numeric(14,2),
                  CatorceavoLps numeric(14,2),
                  PreavisoLps numeric(14,2),
                  CesantiaLps  numeric(14,2),
                  CesantiaProporcialLps numeric(14,2),
                  Total numeric(14,2),
				  SubTotal numeric (14,2),
                  Estado varchar(1),
                  OtrosIngresos numeric(14,2),
                  OtrasDeducciones numeric(14,2),
                  ProgramaCesantia varchar(1),
				  TarjetaIdentidad varchar(16),
				  Direccion varchar(150),
				  Telefono varchar(13),
				  TotalCesantia numeric (14,2)
                  )

--set   @FechaCalculo = Convert(date, @FechaCalculo)

--Declare coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) datetime

create table #DetallePlanilla (
      EmpleadoId varchar(15) primary key,
      SalarioPromedioSemanal numeric (18,2)
      )


insert #DetallePlanilla
select  EmpleadoID,SalarioPromedioSemanal = avg(Round(Devengado, 2))
from  PL_DetallePlanilla_Historico Historico 
where Salario <> 0 
            and PlanillaID > coalesce((select   Inicio26Planilla 
                                          from  RH_q_Empleados_Planilla_26Semanas Planillas 
                                          where Planillas.EmpleadoID = Historico.EmpleadoID), 
                                          (select min(PlanillaID) 
                                          from PL_DetallePlanilla_Historico
                                          where PL_DetallePlanilla_Historico.EmpleadoID = Historico.EmpleadoID),0)
group by EmpleadoID


/*
Select coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)=convert(date,RH_Empleados.FechaEgreso)
from sistema.dbo.rh_empleados RH_Empleados
	join  #DetallePlanilla SalarioPromedio on SalarioPromedio.EmpleadoID = RH_Empleados.EmpleadoId
	*/


insert into #Calculo(
                  EmpleadoID, Nombre,     Puesto,     FechaIngreso ,FechaCesantia,
                  FechaEgreso, Anos, Meses ,Dias,
                  SalarioBaseDiario, SalarioPromedioDiario,
                  SalarioOrdinarioDiario, SalarioBase,
                  SalarioPromedio,SalarioOrdinario,
                  Vacaciones, VacacionesProporcionales,
                  Treceavo,Catorceavo,
                  Preaviso, Cesantia , CesantiaProporcial,
                  CooperativaAhorro, CooperativaPrestamo, Estado, OtrosIngresos, OtrasDeducciones, ProgramaCesantia,
				  TarjetaIdentidad, Direccion, Telefono, TotalCesantia)
select      RH_Empleados.EmpleadoID, Nombre = Desplegar, Puest0 = RH_Puestos.Nombre_Puesto,
            RH_Empleados.FechaIngreso, FechaCesantia= coalesce(@FechaUltimaCesantia, FechaCesantia),RH_Empleados.fechaEgreso Salida,
            Anos, Meses, Dias,
            SalarioBaseDiario = Salario*8, 
            SalarioPromedioDiario = case  when isnull(SalarioPromedioSemanal,0)*4.3*14/12 < Salario*56*4.3 * 14/12 
                                                            then round(Salario*56*4.3 * 14/12 / 30.00,2)
                                                            else round(isnull(SalarioPromedioSemanal,0)*4.3*14/12/30.00,2) end,
            SalarioOrdinarioDiario = round(Salario*56*4.3*14/12/30.00,2),
            SalarioBase = round(Salario*56*4.3,2),
            SalarioPromedio = case when isnull(SalarioPromedioSemanal,0)*4.3*14/12 < Salario*56*4.3 * 14/12 
                                                then round(Salario*56*4.3 * 14/12,2)
                                                else round(isnull(SalarioPromedioSemanal,0)*4.3*14/12,2) end,
            SalarioOrdinario = round(Salario*56*4.3*14/12,2),
           	Vacaciones = ((case when Anos = 0 then 0.00 
                                          when Anos = 1 then 10.00 
                                          when Anos = 2 then 22.00 
                                          when Anos = 3 then 37.00 
                                          else 37.00 + 20.00 *(Anos - 3)  end) + (Meses * 30 + Dias) / case when Anos = 0 then 36.00
																								when Anos = 1 then 34.00
																								when Anos = 2 then 32.00
																								else 24.00 end)-(coalesce(VacacionesGozadas,0)),

										  --((  case when Anos = 0 then 0.00 
            --                          when Anos = 1 then 10.00 
            --                          when Anos = 2 then 22.00 
            --                          when Anos = 3 then 37.00 
            --                          else 37.00 + 20.00 *(Anos - 3)  end)+(Meses * 30 + Dias) / case when Anos = 0 then 36.00
												--												when Anos = 1 then 34.00
												--												when Anos = 2 then 32.00
												--												else 24.00 end)-(coalesce(VacacionesGozadas,0))
            VacacionesProporcionales = (Meses * 30 + Dias) / case when Anos = 0 then 36.00
																	when Anos = 1 then 34.00
																	when Anos = 2 then 32.00
																	else 24.00 end,
            Treceavo = (dbo.fn_Days360( dbo.ReturnMaxDate(RH_Empleados.FechaIngreso, CONVERT(datetime, '1/1/' + CONVERT(varchar, YEAR(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))))), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))+1)/360.00*30.00,
            Catorceavo = (Case      when coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) > CONVERT( datetime, '7/1/'+convert(varchar,year(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))))
                                          then dbo.fn_Days360( dbo.ReturnMaxDate(RH_Empleados.FechaIngreso, CONVERT(datetime, '7/1/' + CONVERT(varchar, YEAR(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))))), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) 
                                          else dbo.fn_Days360( dbo.ReturnMaxDate(RH_Empleados.FechaIngreso, CONVERT(datetime, '7/1/' + CONVERT(varchar, YEAR(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))-1))), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) end + 1) / 360.00 * 30.00,
            Preaviso = case when AnosPreaviso = 0 then 
                                          case  when MesesPreaviso < 3 then 1.00
                                                      when MesesPreaviso >= 3 and MesesPreaviso <6 then 7.00
                                                      when MesesPreaviso >=6 then 14.00
                                                      else 0.00 end
                                    when AnosPreaviso = 1 then 30.00
                                    else 60.00 end,                     
            Cesantia = case when Anos = 0 then 
                                          case when (Meses*30+Dias) > 91 and (Meses * 30+Dias) < 180 then 10
                                                when (Meses * 30+Dias) >= 180 then 20.00
                                                else 0 end
                                    when Anos <= 25 then 30.00*Anos
                                    else 25*30.00 end,
            CesantiaProporcial = case when Anos > 0 and Anos < 25 then 30 * ((Meses * 30 + Dias)/360.00) else 0.0 end,
            CooperativaAhorro = isnull(SaldoAhorro,0),
            CooperativaPrestamo = case when @Tipo = 2 then 0 else isnull(SaldoPrestamo,0) end,
            RH_Empleados.Estado,
            OtrosIngresos= ISNULL(OtrosIngresos.TotalIngresos ,0),
            OtrasDeduccicones= case when @Tipo = 2 then 0 else ISNULL(OtrasDeducciones.TotalDeducciones ,0) end,
            RH_Empleados.ProgramaCesantia, RH_Empleados.Cedula, RH_Empleados.Direccion, RH_Empleados.telefono1, case when @Tipo in (3,4) then 0 else isnull(TotalCesantia.Cesantia,0) end  
from  RH_Empleados with (readuncommitted)
            join RH_Puestos on RH_Empleados.PuestoID = RH_Puestos.PuestoID
            join  #DetallePlanilla SalarioPromedio on SalarioPromedio.EmpleadoID = RH_Empleados.EmpleadoId
            join  (
                              select      EmpleadoID,
                                          Anos = dbo.fn_Days360 (RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360,
                                          --Meses =  case when DATEDIFF( mm, coalesce(@FechaUltimaCesantia,FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DATEDIFF( yy, coalesce(@FechaUltimaCesantia, FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) * 12 < 0 
                                          --                              then 12 + (DATEDIFF( mm, coalesce(@FechaUltimaCesantia,FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DATEDIFF( yy, coalesce(@FechaUltimaCesantia, FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) * 12 )
                                          --                              else dbo.fn_Days360( coalesce(@FechaUltimaCesantia,FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/30 -
                                          --                                    (dbo.fn_Days360( coalesce(@FechaUltimaCesantia,FechaCesantia, RH_Empleados.FechaIngreso), coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360)*12 end,
										  Meses =  case when dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/30 -
													(dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360)*12  < 0 
												then 12 + (dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/30 -
													(dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360)*12 )
												else dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/30 -
													(dbo.fn_Days360(RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360)*12 end,
                                          Dias = case when case when day(RH_Empleados.FechaIngreso) <= DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))
                                                                  then DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DAY( RH_Empleados.FechaIngreso)
                                                                  else  30-(DAY(RH_Empleados.FechaIngreso) - DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))) end >= 30 
														then 0
														else case when day(RH_Empleados.FechaIngreso) <= DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))
                                                                  then DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DAY( RH_Empleados.FechaIngreso)
                                                                  else  30-(DAY(RH_Empleados.FechaIngreso) - DAY(coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))) end end
                              from  RH_Empleados  with (readuncommitted)
                        ) Antiguedad on Antiguedad.EmpleadoId = RH_Empleados.EmpleadoId
			left join (select Cesantia=sum(Cantidad), EmpleadoID 
								from	sistema.dbo.RH_HistorialCesantiasEntregadas 
								where	[Year] <= datepart(YEAR, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) )
								group by EmpleadoID ) TotalCesantia
						on TotalCesantia.EmpleadoID = RH_Empleados.EmpleadoId 
            join  (
                              select      EmpleadoID,
                                          AnosPreaviso = dbo.fn_Days360 (RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360,
                                          MesesPreaviso =  case when DATEDIFF( mm, RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DATEDIFF( yy, RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) * 12 < 0 
                                                                        then 12 + (DATEDIFF( mm, RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) - DATEDIFF( yy, RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso)) * 12 )
                                                                        else dbo.fn_Days360( RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/30 -
                                                                              (dbo.fn_Days360( RH_Empleados.FechaIngreso, coalesce(@FechaCalculo,RH_Empleados.FechaEgreso))/360)*12 end                                      
                              from  RH_Empleados  with (readuncommitted)
                        ) AntiguedadPreaviso on AntiguedadPreaviso.EmpleadoId = RH_Empleados.EmpleadoId
            left join (                                                                   
                              select      Vacaciones.EmpleadoID, VacacionesGozadas = SUM( Cant_dias)
                              from  RH_Empleados_HistoVacaciones Vacaciones
                                          join RH_Empleados with (readuncommitted) on Vacaciones.EmpleadoId = RH_Empleados.EmpleadoId 
                                                                        and Vacaciones.Fecha >= RH_Empleados.FechaIngreso
                              group by Vacaciones.EmpleadoID
                              ) Vacaciones on Vacaciones.EmpleadoId = RH_Empleados.EmpleadoId
            left join CO_EmpleadosCooperativa on CO_EmpleadosCooperativa.EmpleadoID = RH_Empleados.EmpleadoID
            left join (Select EmpleadoID, SUM(Ingreso) as TotalIngresos
                           From RH_Prestaciones_OtrasDeducciones 
                           Group by EmpleadoID) OtrosIngresos on OtrosIngresos.EmpleadoID = RH_Empleados.EmpleadoId   
			left join (SELECT  EmpleadoID, SUM(Saldo) AS TotalDeducciones
						   FROM         RH_Empleados_OtrasDeducciones
						   Where saldo>0
						   GROUP BY Empleadoid) OtrasDeducciones  on OtrasDeducciones.EmpleadoID = RH_Empleados.EmpleadoId  
Where RH_Empleados.Empleadoid = isnull(@EmpleadoID,RH_Empleados.EmpleadoID)
order by RH_Empleados.EmpleadoId                            

 

--Tipo:
--    1: Despido
--    2: Cesantia
--    3: Renuncia
----4: Despido Justificado


update      #Calculo
set         
			--*Vacaciones
			Vacaciones = Vacaciones,
			VacacionesLps = Vacaciones * case when @Tipo = 2 then 0 
												when Vacaciones < 0 then SalarioBaseDiario
												else  SalarioOrdinarioDiario  end,--Vacaciones * case when @Tipo = 2 then SalarioBaseDiario else SalarioOrdinarioDiario  end, ---
			--*VacacionesProporcionales
			VacacionesProporcionales= VacacionesProporcionales, 
			VacacionesProporcionalesLps = VacacionesProporcionales * case  when @Tipo = 2 then 0 else SalarioOrdinarioDiario end, --VacacionesProporcionales * case  when @Tipo = 2 then SalarioBaseDiario else SalarioOrdinarioDiario end,
             --*Treceavo
            Treceavo=Treceavo, 
             TreceavoLps = case  when @Tipo = 2 then 0 else Treceavo * SalarioBaseDiario end,
            --*Catorceavo
            Catorceavo= Catorceavo ,
            CatorceavoLps = case  when @Tipo = 2 then 0 else Catorceavo * SalarioBaseDiario end,
			PreavisoLps = case when FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else 1 end * case  when @Tipo = 2 then 0 else  Preaviso * case when @Tipo in (3,4) then 0 else SalarioPromedioDiario end end,
            CesantiaLps  = case when FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else 1 end * Cesantia * case  when @Tipo in (3,4) then 0 else SalarioPromedioDiario end,
            CesantiaProporcialLps = case when FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else 1 end * CesantiaProporcial * case when @Tipo in(3,4) then 0 else SalarioPromedioDiario end,
            Preaviso = case when @Tipo in (2,3) or FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else Preaviso end,
            Cesantia = case when @Tipo in (3,4) or FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else Cesantia end,
            CesantiaProporcial = case when @Tipo  in(3,4) or FechaIngreso > coalesce(@FechaCalculo,RH_Empleados.FechaEgreso) then 0 else CesantiaProporcial end

 

update      #Calculo
set         Total = (VacacionesLps  + TreceavoLps +
                        CatorceavoLps + PreavisoLps + CesantiaLps + CesantiaProporcialLps + OtrosIngresos)
                       - (OtrasDeducciones + case when @Tipo in (3,4) then 0 else isnull(TotalCesantia,0) end),
			subtotal= VacacionesLps + TreceavoLps +
                        CatorceavoLps + PreavisoLps + CesantiaLps + CesantiaProporcialLps
                       

declare @Estado varchar(1)

select      @Estado = case @SoloActivos when  'S' then 'I' else 'J' end

Select Calculos.*, 
            (Select case @Tipo      when 1 then 'Despido' 
                                          when 2 then 'Cesantia' 
                                          when 3 then 'Renuncia'
                                          when 4 then 'Despido Justificado' end) as Tipo, 
            @Observacion as Observacion
from  #Calculo Calculos
where EmpleadoID = ISNULL(@EmpleadoID, EmpleadoID)
            and Estado != @Estado
GO
