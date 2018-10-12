SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[usp_RH_RotacionPersonal](
	@dFechaFinal date)
AS
BEGIN

DECLARE	@return_value int

EXEC	@return_value = EEH.[HN].[usp_RH_RotacionPersonal]
		@FechaFinal = @dFechaFinal,
		@FiltroAno = NULL

SELECT	'Return Value' = @return_value

END
GO
