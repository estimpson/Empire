SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_GetSopList]
	@Customer varchar(50) = null
as
set nocount on
set ansi_warnings off

--- <Body>
if (@Customer is null) begin

	select
		hl.SOPYear
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	group by
		hl.SOPYear
	order by
		hl.SOPYear asc

end
else begin

	select
		hl.SOPYear
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	where
		hl.Customer = @Customer
	group by
		hl.SOPYear
	order by
		hl.SOPYear asc

end
--- </Body>
GO
