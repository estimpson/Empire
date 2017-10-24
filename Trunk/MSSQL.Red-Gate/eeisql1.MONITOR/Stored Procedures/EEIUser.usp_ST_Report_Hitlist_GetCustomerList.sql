SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_GetCustomerList]
	@Region varchar(50) = null
as
set nocount on
set ansi_warnings off

--- <Body>
if (@Region is null) begin

	select
		hl.Customer
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	group by
		hl.Customer
	order by
		hl.Customer asc

end
else begin

	select
		hl.Customer
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
	where
		hl.Region = @Region
	group by
		hl.Customer
	order by
		hl.Customer asc

end
--- </Body>
GO
