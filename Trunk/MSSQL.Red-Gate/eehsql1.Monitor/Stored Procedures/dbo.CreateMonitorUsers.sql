SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[CreateMonitorUsers]( @EmpleadoID varchar(10), @Password varchar(15), @CoWorkerEmpleadoID varchar(15) )as
/*
	USE [Monitor]
	exec CreateMonitorUsers
		@EmpleadoID= '22922',
		@Password = 'ferrera2016',
		@CoWorkerEmpleadoID = '20767'
*/
declare @smallPassword  varchar(5)

set	@smallPassword = Left(@Password,5)


if	not exists( select	1 
				from	eeh.dbo.employee 
				where	operator_code = left(@EmpleadoID,5) ) begin
	print 'User create on Employee for Monitor'
	insert into eeh.dbo.employee(name, operator_code, password, npassword,EmployeeID  )
	select	LEFT( desplegar, 40), LEFT(EmpleadoID,5), @smallPassword, convert(varbinary(255), pwdencrypt (@Password)),EmpleadoId 
	from	sistema.dbo.RH_Empleados
	where	EmpleadoID = @EmpleadoID
end
else begin 
	print 'User already exists in Employee for Monitor'
end

update	Sistema.dbo.PP_Usuarios
set		Operator_Code = @EmpleadoID
where	EmpleadoID = @EmpleadoID

IF NOT EXISTS (SELECT 1 FROM eeh.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID) BEGIN
	print 'User create on adm_usr_usuarios for WEB Access'
	INSERT INTO eeh.dbo.adm_usr_usuarios(usr_codigo,usr_usuario, usr_password, usr_nombre,
				usr_codemp, usr_tipo_autentificacion, usr_operator_code,usr_Codigo_Empleado)
	SELECT (SELECT max(usr_codigo)+1 FROM eeh.dbo.adm_usr_usuarios	), pu.EmpleadoID, EEH.dbo.dkrpt(@Password,'E'), pu.Desplegar, usr_codemp='','P',pu.EmpleadoID,pu.EmpleadoID
	FROM	sistema.dbo.RH_Empleados pu 
	WHERE	pu.EmpleadoID=@EmpleadoID
			and not exists(	select	1
							from	eeh.dbo.adm_usr_usuarios
							where	usr_usuario = @EmpleadoID)

end
else begin
	print 'User already has WEB Access'
end

IF  EXISTS (SELECT 1 FROM eeh.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID) BEGIN
	if	isnull(@CoWorkerEmpleadoID, '')  <> '' begin
		print 'Give the employee the same roles as a coworker.'
		delete	
		from eeh.dbo.adm_rus_role_usuarios 
		where	rus_codusr = (SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID)
				and rus_role<>2
		
		INSERT INTO eeh.dbo.adm_rus_role_usuarios( rus_role, rus_codusr )
		select	rus_role,
				(SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID)
		from	eeh.dbo.adm_rus_role_usuarios
		where	rus_codusr = (SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@CoWorkerEmpleadoID)
				and rus_role<>2
	end
end

--Si es Auditor
If (Select PuestoID from Sistema.dbo.RH_Empleados where EmpleadoId=@EmpleadoID)=225 begin

	print 'Insert in SA_Usuarios the new user for audit validation.'
	Insert into Sistema.dbo.SA_Usuarios(UsuarioID, Nombre, Clave, Estado)

Select @EmpleadoID,Nombre1 + ' ' + Apellido1,@Password,1
from Sistema.dbo.RH_Empleados where EmpleadoId=@EmpleadoID

Insert into Sistema.dbo.SA_Modulo_Usuario(Modulo_ID,UsuarioID)
Select Modulo_ID, @EmpleadoID from Sistema.dbo.SA_Modulo_Usuario where UsuarioID='mestrada'

Insert into Sistema.dbo.SA_Permisos_Usuarios(UsuarioID, PermisoId)
Select @EmpleadoID, PermisoId from Sistema.dbo.SA_Permisos_Usuarios where UsuarioID='mestrada'
end

GO
