SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [EEIUser].[vw_QT_EmpireMarketSegment]
as
select
	ems.EmpireMarketSegment
,	row_number() over(order by ems.EmpireMarketSegment) as RowId
from 
	eeiuser.QT_EmpireMarketSegment ems


GO
