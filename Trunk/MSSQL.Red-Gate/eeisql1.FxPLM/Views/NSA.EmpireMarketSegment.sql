SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [NSA].[EmpireMarketSegment]
as
select
	ems.EmpireMarketSegment
,	RowID = isnull(row_number() over (order by ems.EmpireMarketSegment), 0)
from
	MONITOR.EEIUser.QT_EmpireMarketSegment ems


GO
