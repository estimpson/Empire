SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VW_RH_Empleados_RotacionHorarios] as
select	Employee.EmpIdAlternative, 
		PersonName = PersonNatural.PersonName + ' ' + PersonLastName1,
		Schedule = Schedule.ScheName, RotaScheDateIn, RotaScheDateOut,
		case RotationScheduleByPerson.RotaScheState
			when 0 then 'Eliminado'
			when 1 then 'Pendiente'
			when 2 then 'Activa/En Proceso'
			when 3 then 'Concluida'
			when 4 then 'Parcial/En Proceso'
			when 5 then 'Ejecutada'
			else 'Estado NO Controlado'
		end RotaScheStateName
from	ITSmartClock.dbo.RotationScheduleByPerson RotationScheduleByPerson
		join ITSmartClock.dbo.Employee Employee on RotationScheduleByPerson.RotaPersonId = Employee.PersonId
		join ITSmartClock.dbo.Schedule Schedule on Schedule.ScheId = RotationScheduleByPerson.ScheId
		join ITSmartClock.dbo.PersonNatural PersonNatural on PersonNatural.personID = RotationScheduleByPerson.RotaPersonId
GO
