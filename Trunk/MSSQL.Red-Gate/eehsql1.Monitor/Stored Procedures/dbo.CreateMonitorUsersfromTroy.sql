SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CreateMonitorUsersfromTroy](@Name varchar(50),
		@OperatorCode varchar(50),
		@CoworkerUser varchar(50),
		@Password varchar(25)) 
as
/*
Set	@Name='Scott Dickson'
Set	@OperatorCode='SDM'
Set	@Password='4173'
set	@CoworkerUser='bmoore'
*/

--Insert into eeh.dbo.employee(name, operator_code, password, npassword)
--Select	@Name,@OperatorCode,left(@Password,5), convert(varbinary(255), pwdencrypt (@Password))

INSERT INTO eeh.dbo.adm_usr_usuarios(usr_codigo,usr_usuario, usr_password, usr_nombre,
				usr_codemp, usr_tipo_autentificacion, usr_operator_code,usr_Codigo_Empleado)
SELECT distinct (SELECT max(usr_codigo)+1 FROM eeh.dbo.adm_usr_usuarios	), @OperatorCode, 
				EEH.dbo.dkrpt(@Password,'E'), @Name, '','P',@OperatorCode,1000
			from	eeh.dbo.adm_usr_usuarios
			where	not exists(	select	1
							from	eeh.dbo.adm_usr_usuarios
							where	usr_usuario = @OperatorCode)


IF  EXISTS (SELECT 1 FROM eeh.dbo.adm_usr_usuarios WHERE usr_usuario=@OperatorCode) BEGIN
	if	isnull(@CoworkerUser, '')  <> '' begin
		print 'Give the employee the same roles as a coworker.'
		delete	
		from eeh.dbo.adm_rus_role_usuarios 
		where	rus_codusr = (SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_usuario=@OperatorCode)
		
		INSERT INTO eeh.dbo.adm_rus_role_usuarios( rus_role, rus_codusr )
		select	rus_role,
				(SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_usuario=@OperatorCode)
		from	eeh.dbo.adm_rus_role_usuarios
		where	rus_codusr = (SELECT usr_codigo  FROM eeh.dbo.adm_usr_usuarios WHERE usr_usuario=@CoworkerUser)
		and rus_role<>2
	end
end
GO
