SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [HN].[SP_MAT_RPT_LostMaterialByPart] ( 
		@Part varchar(25),
		@StartDT datetime,
		@EndDT datetime ) as

	Exec EEH.HN.SP_MAT_RPT_LostMaterialByPart
			@Part = @Part,
			@StartDT = @StartDT,
			@EndDT = @EndDT
GO
