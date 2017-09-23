SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_GetProgramList]
	@Region varchar(50) = null
as
set nocount on
set ansi_warnings off

--- <Body>
if (@Region is null) begin

	select
		hl.Program
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	group by
		hl.Program
	order by
		hl.Program asc

end
else begin

	select
		hl.Program
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	where
		hl.Region = @Region
	group by
		hl.Program
	order by
		hl.Program asc

end
--- </Body>
GO
