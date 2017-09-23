SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwEmployeeScheduler]
as
select	OperatorCode = employee.operator_code,
	Name = employee.name,
	SchedulerFlag = case when Schedulers.OperatorCode is null then 0 else 1 end
from	employee
	left join FT.Schedulers Schedulers on employee.operator_code = Schedulers.OperatorCode
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FT].[vwEmployeeScheduler_u] on [FT].[vwEmployeeScheduler] instead of update
as
set nocount on

delete	FT.Schedulers
from	FT.Schedulers Schedulers
	join inserted on Schedulers.OperatorCode = inserted.OperatorCode
where	inserted.SchedulerFlag = 0

insert	FT.Schedulers
(	OperatorCode)
select	inserted.OperatorCode
from	inserted
	left join FT.Schedulers Schedulers on inserted.OperatorCode = Schedulers.OperatorCode
where	inserted.SchedulerFlag = 1 and
	Schedulers.OperatorCode is null
GO
