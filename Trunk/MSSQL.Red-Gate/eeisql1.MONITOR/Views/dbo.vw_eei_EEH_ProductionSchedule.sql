SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view	[dbo].[vw_eei_EEH_ProductionSchedule]

as
Select	EEHProdSched.Part,
		Container,
		isNull(QtySchedule,0) ScheduledQty,
		isNull(ShipQtyForCurrentWeek,0) ShippedQty,
		isNull(QtySchedule,0) - isNull(ShipQtyForCurrentWeek,0) as RemainingEEHQty
   
from  [EEHSQL1].[Monitor].[dbo].[EEH_Schedule_Production] EEHProdSched left join
	(select sum(std_quantity) ShipQtyForCurrentWeek,
	part,
	dateadd(wk,1,ft.fn_TruncDate('wk', date_stamp)) as ForContainerDT
from  [EEHSQL1].[Monitor].[dbo].audit_trail 
where type = 'S' and date_stamp> '2009-04-26'
Group By part,
  dateadd(wk,1,ft.fn_TruncDate('wk', date_stamp))) ShipmentsforWeek on EEHProdSched.Part = ShipmentsforWeek.part and EEHProdSched.Container = ShipmentsforWeek.ForContainerDT


 


GO
