SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwCustomerScheduler]
as
select	CustomerCode = customer.customer,
	Scheduler = SchedulerCustomer.OperatorCode,
	Orders = isnull (Orders.Orders, 0),
	ActiveReleases = isnull (Orders.ActiveReleases, 0)
from	customer
	left join FT.SchedulerCustomer SchedulerCustomer on SchedulerCustomer.CustomerCode = customer.customer
	left join
	(	select	CustomerCode = order_header.customer,
			Orders = count (distinct order_header.order_no),
			ActiveReleases = count (1)
		from	order_detail
			join order_header on order_detail.order_no = order_header.order_no
		group by
			order_header.customer) Orders on customer.customer = Orders.CustomerCode
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FT].[vwCustomerScheduler_u] on [FT].[vwCustomerScheduler] instead of update
as
set nocount on

delete	FT.SchedulerCustomer
from	FT.SchedulerCustomer SchedulerCustomer
	join inserted on SchedulerCustomer.CustomerCode = inserted.CustomerCode
where	inserted.Scheduler is null

insert	FT.SchedulerCustomer
(	CustomerCode,
	OperatorCode)
select	inserted.CustomerCode,
	inserted.Scheduler
from	inserted
	left join FT.SchedulerCustomer SchedulerCustomer on inserted.CustomerCode = SchedulerCustomer.CustomerCode
where	inserted.Scheduler is not null and
	SchedulerCustomer.OperatorCode is null
GO
