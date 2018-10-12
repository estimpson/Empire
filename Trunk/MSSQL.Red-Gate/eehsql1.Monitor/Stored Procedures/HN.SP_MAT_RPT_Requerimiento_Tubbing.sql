SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [HN].[SP_MAT_RPT_Requerimiento_Tubbing](	
			@ContainerDT datetime )
as

exec EEH.HN.SP_MAT_RPT_Requerimiento_Tubbing
		@ContainerDT = @ContainerDT
GO
