SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[RLSP_MAT_MaterialPerdido]
		(@Parte varchar(25) =  null,
		@FechaInicio datetime = null,
		@FechaFinal datetime = null ) as
	

	select	@FechaInicio = isnull(@FechaInicio, dateadd(minute, 2, MAX( time_stamp)))
	from	EEH.HN.Inventario_Used_by_ARS	
	
	set	@FechaFinal = isnull(@FechaFinal, GETDATE())
	
	select	*
	from	EEH.HN.fn_MaterialPerdido(@FechaInicio, @FechaFinal, @Parte)
GO
