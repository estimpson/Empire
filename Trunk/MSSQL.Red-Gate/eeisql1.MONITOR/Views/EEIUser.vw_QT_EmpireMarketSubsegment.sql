SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [EEIUser].[vw_QT_EmpireMarketSubsegment]
as
select
	ems.EmpireMarketSubsegment
,	row_number() over(order by ems.EmpireMarketSubsegment) as RowId
from 
	eeiuser.QT_EmpireMarketSubsegment ems


GO
