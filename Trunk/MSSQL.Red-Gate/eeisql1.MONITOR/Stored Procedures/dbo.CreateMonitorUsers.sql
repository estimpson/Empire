SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[CreateMonitorUsers]( @Name varchar(40), @EmpleadoID varchar(10), @Password varchar(15), @CoWorkerEmpleadoID varchar(15) )as
/*
	exec CreateMonitorUsers
		@EmpleadoID= '17162',
		@Password = 'do25z',
		@CoWorkerEmpleadoID = '15124'
*/
declare @smallPassword  varchar(5)

set	@smallPassword = Left(@Password,5)


if	not exists( select	* 
				from	monitor.dbo.employee 
				where	operator_code = left(@EmpleadoID,5) ) begin
	print 'User created on Employee for Monitor'
	insert into monitor.dbo.employee(name, operator_code, password, npassword,EmployeeID  )
	select	LEFT( @Name, 40), LEFT(@EmpleadoID,5),  LEFT(@EmpleadoID,5), convert(varbinary(255), pwdencrypt (@Password)),@EmpleadoID 
end
else begin 
	print 'User exists in Employee for Monitor'
end



IF NOT EXISTS (SELECT 1 FROM monitor.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID) BEGIN
	print 'User created on adm_usr_usuarios for WEB Access'
	INSERT INTO monitor.dbo.adm_usr_usuarios(usr_codigo,usr_usuario, usr_password, usr_nombre,
				usr_codemp, usr_tipo_autentificacion, usr_operator_code,usr_Codigo_Empleado)
SELECT (SELECT max(usr_codigo)+1 FROM monitor.dbo.adm_usr_usuarios	), @EmpleadoID, monitor.dbo.dkrpt(@Password,'E'), @Name, usr_codemp='','P',@EmpleadoID,@EmpleadoID
	

end
else begin
	print 'User already has WEB Access'
end

IF  EXISTS (SELECT 1 FROM monitor.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID) BEGIN
	if	isnull(@CoWorkerEmpleadoID, '')  <> '' begin
		print 'Give the employee the same roles as a coworker.'
		delete	
		from monitor.dbo.adm_rus_role_usuarios 
		where	rus_codusr = (SELECT usr_codigo  FROM monitor.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID)
		
		INSERT INTO monitor.dbo.adm_rus_role_usuarios( rus_role, rus_codusr )
		select	rus_role,
				(SELECT usr_codigo  FROM monitor.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@EmpleadoID)
		from	monitor.dbo.adm_rus_role_usuarios
		where	rus_codusr = (SELECT usr_codigo  FROM monitor.dbo.adm_usr_usuarios WHERE usr_Codigo_Empleado=@CoWorkerEmpleadoID)
		and rus_role<>2
	end
end

GO
