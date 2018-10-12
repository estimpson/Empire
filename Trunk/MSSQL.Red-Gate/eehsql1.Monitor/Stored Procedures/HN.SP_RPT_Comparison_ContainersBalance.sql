SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [HN].[SP_RPT_Comparison_ContainersBalance](
		@OldContainer datetime,
		@NewContainer datetime ) 
as
	exec EEH.HN.SP_RPT_Comparison_ContainersBalance @OldContainer,  @NewContainer 
GO
