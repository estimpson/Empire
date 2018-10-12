SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [HN].[VW_Cursos_PCB] 
as
	Select  Cursos.EmpleadoID,Cursos.NombreCompleto,Cursos.NombrePuesto,Certificacion=Cursos.Descripcion,Empleados.Planta
		,Centro_De_Costo=Empleados.CenterCost,Tipo = 'Curso'
	from  sistema.dbo.RLSP_Entrenamiento_CursosEmpleado_All() Cursos INNER JOIN 
				(
					Select EmpleadoID,Desplegar,Planta,CenterCost
					from sistema.hn.vw_pay_empleados 
					where Planta = 'PCB' 
						  AND ModoPlanilla = 'Semanal'
						  AND Estado = 'A'
				) Empleados  on Convert(VARCHAR(10),Empleados.EmpleadoID) = Cursos.EmpleadoID
	UNION ALL 
		Select	 EmpleadoID=Empleados.EmpleadoID
		,NombreCompleto = Empleados.Desplegar
		,NombrePuesto = ''
		,Certificacion=Habilidades.Descripcion
		,Empleados.Planta 
		,Centro_De_Costo=Empleados.CenterCost
		,Tipo = 'Habilidad'
	from Sistema.dbo.Entrenamiento_Habilidades Habilidades INNER JOIN 
			Sistema.dbo.Entrenamiento_Habilidades_Empleados Habilidades_Empleados on Habilidades.HabilidadID = Habilidades_Empleados.HabilidadID  INNER JOIN 
			(
					Select EmpleadoID,Desplegar,Planta,CenterCost
					from sistema.hn.vw_pay_empleados 
					where Planta = 'PCB' 
							AND ModoPlanilla = 'Semanal'
							AND Estado = 'A'
				) Empleados  on Convert(VARCHAR(10),Empleados.EmpleadoID) = Habilidades_Empleados.EmpleadoID
	WHERE Habilidades.Estado = 1




GO
