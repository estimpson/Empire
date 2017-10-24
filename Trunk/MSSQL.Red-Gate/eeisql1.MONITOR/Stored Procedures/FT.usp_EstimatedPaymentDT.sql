SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_EstimatedPaymentDT]
as
set nocount on

select	CustomerFlag = convert (bit, 0),
	Customer = (select customer from order_header where order_no = order_detail.order_no),
	Terms = (select term from order_header where order_no = order_detail.order_no),
	Amount = price * quantity,
	ShipDT = due_date,
	InvoiceDueDT = convert (datetime, null),
	EstimatedPaymentDT = convert (datetime, null)
into	#EstimatedReceipts
from	order_detail
where	due_date > '2008-01-01'

update	#EstimatedReceipts
set	InvoiceDueDT = dateadd (day, 60, ShipDT)
where	Terms = 'NET 60'

update	#EstimatedReceipts
set	InvoiceDueDT = dateadd (day, 45, ShipDT)
where	Terms in ('NET 45', 'NET 45 WITH VMI', '1% NET 45')

update	#EstimatedReceipts
set	InvoiceDueDT = dateadd (day, 30, ShipDT)
where	Terms = 'NET 30'

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 1, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, ShipDT))))
where	Terms = '2D 2M'

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 9, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, ShipDT))))
where	Terms in ('30D EOM + 10', '30D EOM +10')

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 29, FT.fn_TruncDate('Month', dateadd (day, 2, ShipDT)))
where	Terms = '30TH PROX'

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 24, FT.fn_TruncDate('Month', dateadd (day, 7, ShipDT)))
where	Terms = 'PROX 25'

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 14, FT.fn_TruncDate('Month', dateadd (day, 17, ShipDT)))
where	Terms = 'PROX 15'

update	#EstimatedReceipts
set	InvoiceDueDT = dateadd (day, 55, ShipDT)
where	Terms = '55D'

update	#EstimatedReceipts
set	InvoiceDueDT = DateAdd (day, 1, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 60, ShipDT))))
where	Terms in ('60D EOM + 2', '60D EOM +2')

update	#EstimatedReceipts
set	InvoiceDueDT = dateadd (day, 15, ShipDT)
where	Terms = 'NET 15'

update	#EstimatedReceipts
set	InvoiceDueDT = ShipDT
where	Terms is null

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (week, 2 * (DateDiff (week, '2008-01-07', InvoiceDueDT) / 2) + 2, '2008-01-07'),
	CustomerFlag = 1
where	Customer = 'AUTOSYSTEM'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 2, FT.fn_TruncDate ('Month', DateAdd (day, 15, InvoiceDueDT))),
	CustomerFlag = 1
where	Customer = 'TRW-AUTO'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 12, FT.fn_TruncDate ('Week', InvoiceDueDT)),
	CustomerFlag = 1
where	Customer = 'GUIDEMEX'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 6, FT.fn_TruncDate ('Week', InvoiceDueDT)),
	CustomerFlag = 1
where	Customer = 'ALC'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 5, FT.fn_TruncDate ('Week', InvoiceDueDT)),
	CustomerFlag = 1
where	Customer = 'NALFLORA'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 1, FT.fn_TruncDate ('Week', InvoiceDueDT)),
	CustomerFlag = 1
where	Customer = 'GMP'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, 4, FT.fn_TruncDate ('Week', InvoiceDueDT)),
	CustomerFlag = 1
where	Customer = 'TRW-2'

update	#EstimatedReceipts
set	EstimatedPaymentDT = DateAdd (day, -1, dateadd (month, 1, FT.fn_TruncDate ('Month', DateAdd (day, 10, InvoiceDueDT)))),
	CustomerFlag = 1
where	Customer = 'ALCQRO'

update	#EstimatedReceipts
set	EstimatedPaymentDT = InvoiceDueDT
where	CustomerFlag = 0

declare	@Today datetime; set @Today = FT.fn_TruncDate('day', getdate ())
declare	@Day datetime; set @Day = @Today
while	@Day < DateAdd (day, 90, @Today) begin
	insert	#EstimatedReceipts
	(	CustomerFlag,
		Customer,
		Terms,
		EstimatedPaymentDT)
	select	CustomerFlag,
		Customer,
		Terms,
		EstimatedPaymentDT = @Day
	from	#EstimatedReceipts
	where	not exists
		(	select	1
			from	#EstimatedReceipts ER1
			where	Customer = #EstimatedReceipts.Customer and
				Terms = #EstimatedReceipts.Terms and
				EstimatedPaymentDT = @Day)
	group by
		CustomerFlag,
		Customer,
		Terms
	
	set	@Day = dateadd (day, 1, @Day)
end

select	*
from	#EstimatedReceipts
where estimatedpaymentdt >= dateadd(d,-30,getdate())
order by
	Customer,
	Terms,
	ShipDT,
	EstimatedPaymentDT

drop table
	#EstimatedReceipts

GO
