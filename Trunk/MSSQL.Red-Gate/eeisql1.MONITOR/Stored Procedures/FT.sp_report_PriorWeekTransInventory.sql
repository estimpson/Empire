SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [FT].[sp_report_PriorWeekTransInventory]
as
select	
			dateadd(dd,-1, ft.fn_TruncDate_monday('wk',getdate())) CurrentWeek,
			dateadd(wk, -2, dateadd(dd,-1, ft.fn_TruncDate_monday('wk',getdate()))) LastWeek,
			last_date LastDate,
			Serial,
			operator,
			location,
			part,
			quantity
from		dbo.object
where	last_date>= dateadd(wk, -2, dateadd(dd,-1, ft.fn_TruncDate_monday('wk',getdate()))) and  
			last_date< dateadd(wk, -1, dateadd(dd,-1, ft.fn_TruncDate_monday('wk',getdate()))) and
			location like '%TRAN%' and
			part != 'PALLET'


GO
