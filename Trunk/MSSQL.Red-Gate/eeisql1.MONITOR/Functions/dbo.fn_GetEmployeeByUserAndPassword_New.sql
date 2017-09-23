SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fn_GetEmployeeByUserAndPassword_New]
(	@UserName varchar(25),
	@Password varchar(25),
	@Type varchar(3)=null,
	@OptionMenuID int=null)
returns	@Info TABLE (
	Name varchar(35),
	OperatorCode varchar(5),
	EmployeeID varchar(15),
	Punish bit,
	Pin varchar(6),
	AllowOption bit)


AS
BEGIN

	Select @Type=isnull(@Type,'WEB')
	
	DECLARE @UserValid int
	
	if @Type='WEB' begin
		SELECT @UserValid= isnull(sum(hayRegistros) ,0)
			from (
				select 1 hayRegistros 
				from	adm_usr_usuarios  Users 
				where	upper(usr_usuario) = upper(@userName)
						and usr_password = dbo.dkrpt(@password,'E')

				union all
				select 0 hayRegistros
			 ) v1

			IF @UserValid>0 
				BEGIN
					INSERT INTO @Info
					SELECT substring(auu.usr_nombre,1,35), usr_operator_code=isnull(auu.usr_operator_code,''), auu.usr_Codigo_Empleado,
					Castigado=case when DATEDIFF(HH,isnull(usr_FechaFinCastigo,getdate()) ,getdate())<0 then 1 else 0 end,
					Pin= isnull(usr_pin,'NOPIN'),
					Allow=(Select case when count(1)>=1 then 1 else 0 end 
							from adm_opu_opciones_role AS aoor 
							INNER JOIN adm_rus_role_usuarios AS arru ON aoor.opu_role = arru.rus_role 
							INNER JOIN adm_usr_usuarios AS auu1 ON auu1.usr_codigo = arru.rus_codusr 
							INNER JOIN adm_opm_opciones_menu AS aoom ON aoom.opm_codigo = aoor.opu_codopm
							where auu1.usr_usuario=auu.usr_usuario AND aoom.opm_codigo=@OptionMenuID)
					FROM adm_usr_usuarios auu 
					WHERE auu.usr_usuario=@UserName
				END	
	end else begin
		INSERT INTO @Info
		select	name,
				operator_code,employeeid,0,null,0
		from	monitor.dbo.employee with (readuncommitted)
		where	pwdcompare (@Password, npassword, 0) = 1 and operator_code=@UserName
	end
	
	RETURN

END



GO
GRANT SELECT ON  [dbo].[fn_GetEmployeeByUserAndPassword_New] TO [APPUser]
GO
