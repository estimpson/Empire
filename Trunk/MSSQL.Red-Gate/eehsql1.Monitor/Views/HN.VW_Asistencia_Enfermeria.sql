SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE View [HN].[VW_Asistencia_Enfermeria]
as
Select [Codigo Empleado]=Enfermeria.EmpleadoID, [Nombre del Empleado]=Empleados.Desplegar, [Fecha de Enfermeria]=Fecha, enfermeria.status
from Sistema.dbo.RH_ControlAsistenciaEnfermeria Enfermeria
	join Sistema.dbo.RH_Empleados Empleados
		on enfermeria.empleadoid=empleados.empleadoid

GO
