SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[SP_PCB_RPT_Eficiency_SMT](
		@Eficiencia numeric(8,2) = 1.2,
		@TiempoCambioSetup numeric(8,2) = 1,
		@OperationSource varchar(3) = 'SMT' )
as
	exec	eeh.[HN].[SP_PCB_RPT_Eficiency_SMT]
				@Eficiencia = @Eficiencia,
				@TiempoCambioSetup = @TiempoCambioSetup,
				@OperationSource = @OperationSource
GO
