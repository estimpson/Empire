SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [NSA].[EmpireMarketSubsegment]
as
select
	emss.EmpireMarketSubsegment
,	RowID = isnull(row_number() over (order by emss.EmpireMarketSubsegment), 0)
from
	MONITOR.EEIUser.QT_EmpireMarketSubsegment emss


GO
