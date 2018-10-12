SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_CP_Orden_Corte](
			@ContainerDT datetime)
as
exec  EEH.HN.SP_CP_Orden_Corte
			@ContainerDT = @ContainerDT
		
GO
