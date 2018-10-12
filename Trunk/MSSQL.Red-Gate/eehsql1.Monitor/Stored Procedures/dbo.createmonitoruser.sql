SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[createmonitoruser] (
	@empleadoIDNuevo int,
	@contraseña varchar(25),
	@empleadoconpermisos int
	)
AS
BEGIN	


	select	*
	into #empleado
	from	rh_empleados
	where	empleadoiD=@empleadoconpermisos
	
		

	insert into #empleado (EmpleadoId,Estado,Sexo,CobranHorasExtras)
	values (@empleadoIDNuevo,'A','M','')

	select *
	from	#empleado

	
END
GO
