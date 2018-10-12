SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [HN].[InsertOTHoraconHora](@EmpleadoId varchar(15),@FechaFinal datetime,@FechaInicial datetime
              ,@contendorid int, @part nvarchar(50))

as begin
declare @FechaIncio datetime
--Set @EmpleadoId = '22545'
--Set @FechaFinal = '2015-10-03'

--Set @FechaInicial = '9/18/2015 15:30:00 PM'
Set @FechaIncio = @FechaInicial

Declare @HorarioDiario table (
       Id int identity(1,1),
       Hora int not null,
       HoraInicio time,                             
       HoraFinal time)

Insert into @HorarioDiario 
Select 7,'7:00:00 AM','7:59:00 AM' union all
Select 8,'8:00:00 AM','8:59:00 AM' union all
Select 9,'9:00:00 AM','9:59:00 AM' union all
Select 10,'10:00:00 AM','10:59:00 AM' union all
Select 11,'11:00:00 AM','11:59:00 AM' union all
Select 12,'12:00:00 PM','12:59:00 PM' union all
Select 13,'13:00:00 PM','13:59:00 PM' union all
Select 14,'14:00:00 PM','14:59:00 PM' union all
Select 15,'15:00:00 PM','15:59:00 PM' 

Declare @HorarioDias table (
       Id int identity(1,1),
       Fecha date)

While datediff(day,@FechaInicial,@FechaFinal)>=0
begin
       if DATEPART(WEEKDAY,@FechaInicial) not in (1,7)
       begin
       Insert into @HorarioDias (Fecha)
       Select @FechaInicial
       end
       Set @FechaInicial = DATEADD(day,1,@FechaInicial)
end

Declare @HorarioEmpleado table (
       EmpleadoID varchar(15),
       FechaInicio datetime,
       FechaFinal datetime)

Insert into @HorarioEmpleado
Select @EmpleadoId,
              FInicio = convert(datetime,convert(varchar,Dia.FEcha) + ' ' + replace(convert(varchar, hora.horainicio),'.0000000','')),
              FFInal = convert(datetime,convert(varchar,Dia.FEcha) + ' ' + replace(convert(varchar, hora.HoraFinal),'.0000000',''))
from   @HorarioDias Dia
       cross join
       (Select       HoraInicio, HoraFinal, Hora
       from   @HorarioDiario) Hora

Delete
from   @HorarioEmpleado
where  FechaInicio <=@FechaIncio


---insert into sistema.dbo.CP_IngresoHoraconHora (Contenedor,Part,EmpleadoID,HoraInicial,HoraFinal,Qty)
Select @contendorid ,@part ,EmpleadoID ,FechaInicio,FechaFinal ,null 
from   @HorarioEmpleado
order by 2,3

end 
GO
