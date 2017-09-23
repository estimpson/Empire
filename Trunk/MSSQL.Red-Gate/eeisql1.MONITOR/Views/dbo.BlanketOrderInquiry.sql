SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[BlanketOrderInquiry]
as
select
	Scheduler = d.scheduler
,	CustomerCode = oh.customer
,	CustomerName = c.name
,	DestinationCode = oh.destination
,	DestinationName = d.name
,	CustomerPart = oh.customer_part
,	NewCustomerPart = oh.new_customer_part
,	SalesOrderNo = oh.order_no
,	BlanketPart = oh.blanket_part
,	PartName = p.name
,	PartType = p.type
,	PartClass = p.class
,	AvailableQty = (select sum (std_quantity) from object where part = oh.blanket_part and coalesce((select secured_location from location where code = location), 'N') != 'Y')
,	DemandQty = (select sum (std_qty) from order_detail where order_no = oh.order_no)
,	ActiveFlag = convert(int, case when oh.status = 'A' then 1 else 0 end)
,	OrderStatus = oh.status
,	OrderNotes = oh.notes
from
	dbo.order_header oh
	join dbo.destination d on
		oh.destination = d.destination
	join dbo.customer c on
		oh.customer = c.customer
	join dbo.part p on
		oh.blanket_part = p.part
	and
		p.class != 'O'
where
--	oh.status != 'C'
--and
	oh.order_type = 'B'
	and oh.blanket_part not like '%-PT%'
--union all
--select
--	d.scheduler
--,	c.customer
--,	c.name
--,	d.destination
--,	d.name
--,	CustomerPart = pc.customer_part
--,	NewCustomerPart = null
--,	order_no = null
--,	blanket_part = pc.part
--,	PartName = p.name
--,	PartType = p.type
--,	PartClass = p.class
--,	inventory = (select sum (std_quantity) from object where part = pc.part and coalesce((select secured_location from location where code = location), 'N') != 'Y')
--,	demand = null
--,	current_rev = ''
--,	status = null
--,	notes = null
--from
--	dbo.part_customer pc
--	join dbo.customer c on
--		pc.customer = c.customer
--	join dbo.destination d on
--		pc.customer = d.customer
--	join dbo.part p on 
--		pc.part = p.part
--	and
--		p.class != 'O'
--where
--	not exists
--	(	select
--			*
--		from
--			dbo.order_header oh
--		where
--			pc.part = oh.blanket_part
--		and
--			d.destination = oh.destination)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_BlanketOrderInquiry_u] on [dbo].[BlanketOrderInquiry] instead of update
as
update
	dbo.order_header
set
	new_customer_part = inserted.NewCustomerPart
from
	dbo.order_header oh
	join inserted on
		oh.order_no = inserted.SalesOrderNo
	join deleted on
		oh.order_no = deleted.SalesOrderNo
where
	coalesce (inserted.NewCustomerPart, '') != coalesce(deleted.NewCustomerPart, '')
GO
