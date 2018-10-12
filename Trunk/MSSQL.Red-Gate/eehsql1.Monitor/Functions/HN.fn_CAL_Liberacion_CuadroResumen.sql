SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [HN].[fn_CAL_Liberacion_CuadroResumen] (
	@FechaContenedor_ALiberar date  )
returns @Liberaciones table (
	Contenedor date,
	Part varchar(25),
	machine varchar(10),
	Revision int,
	Comentario varchar(25),
	Total_LM_Asociados int,
	Total_LM_Liberados int,
	LiberacionID_SemanaAnteriorContenedor int,
	HF_Liberacion_SemanaAnteriorContenedor datetime,
	EstadoLiberacion varchar(25), 
	Coordinador VARCHAR(35) 
	)
AS
BEGIN

Insert into @Liberaciones
Select *
from	sistema.HN.fn_CAL_Liberacion_CuadroResumen(@FechaContenedor_ALiberar)

return
end
GO
