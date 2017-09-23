SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--- exec sub_ValidarUsuario 'rlarios','klarios'

CREATE  PROCEDURE [dbo].[sub_ValidarUsuario] (
	@userName varchar(50),
	@password varchar(255))
AS

declare @fecha datetime, @hayRegistros int

set @fecha = getdate()

SELECT @hayRegistros= isnull(sum(hayRegistros) ,0)
  from (
		select 1 hayRegistros from adm_usr_usuarios
		 where upper(usr_usuario) = upper(@userName)
		 and usr_password = dbo.dkrpt(@password,'E')
		union all
		select 0 hayRegistros
	 ) v1


SELECT hayRegistros =@hayRegistros
exec sub_auditoria_del_sistema 'adm_usr_usuarios','S',@userName,@fecha,''


RETURN @hayRegistros


GO
GRANT EXECUTE ON  [dbo].[sub_ValidarUsuario] TO [APPUser]
GO
