SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [HN].[HCSP_Mat_WhereUseList](
	@Weeks int = null )
as
exec EEH.HN.HCSP_Mat_WhereUseList
	@Weeks = @Weeks 
GO
