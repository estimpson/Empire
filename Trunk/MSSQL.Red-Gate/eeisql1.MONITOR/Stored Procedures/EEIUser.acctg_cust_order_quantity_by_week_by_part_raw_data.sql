SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  exec eeiuser.acctg_cust_order_quantity_by_week_by_part_raw_data

Create procedure [EEIUser].[acctg_cust_order_quantity_by_week_by_part_raw_data]
as

declare @week_due datetime
select @week_due = dateadd(d,7,ft.fn_Truncdate_monday('wk',getdate()))

declare @counter int
select @counter = 0

declare @list_of_weeks table (week_due datetime)

while @counter < 16
begin
insert @list_of_weeks
select @week_due

select @counter = @counter + 1
select @week_due = dateadd(d,7,@week_due)
end

drop table #a
create table #a ( part_number varchar(25), week_due datetime, wk_order_qty decimal(18,6), wk_eei_qty decimal(18,6), wk_po_qty decimal(18,6))

insert into #a (part_number, week_due)
select * from
(select	distinct(part_number) 
from	order_detail
where	ft.fn_TruncDate_monday('wk',due_date) <= DATEADD(d,118,ft.fn_Truncdate_monday('wk',getdate()))
	and ft.fn_TruncDate_monday('wk',due_date) >= DATEADD(d,007,ft.fn_Truncdate_monday('wk',getdate())))a
cross join
@list_of_weeks b

drop table #b
create table #b (part_number varchar(25), week_due datetime, wk_order_qty decimal(18,6), wk_eei_qty decimal(18,6), wk_po_qty decimal(18,6))
insert into #b
Select ISNULL(a.part_number, b.part_number), ISNULL(a.week_due, b.week_due), ISNULL(a.order_quantity,0), ISNULL(a.eei_quantity,0), ISNULL(b.po_quantity,0) from 
(select part_number, ft.fn_truncdate_monday('wk', due_date) as week_due, SUM(quantity) as order_quantity, SUM(eeiqty) as eei_quantity
from order_detail
group by part_number,
ft.fn_truncdate_monday('wk', due_date))a
full outer join
(select part_number, ft.fn_truncdate_monday('wk', date_due) as week_due, SUM(quantity) as po_quantity
from po_detail
group by part_number,
ft.fn_truncdate_monday('wk', date_due))b
on a.part_number = b.part_number and a.week_due = b.week_due
where ISNULL(a.order_quantity,0)+ISNULL(a.eei_quantity,0)+isnull(b.po_quantity,0) <> 0


update #a
set wk_order_qty = #b.wk_order_qty
,wk_eei_qty = #b.wk_eei_qty
,wk_po_qty = #b.wk_po_qty
from #a left join #b on #a.part_number = #b.part_number and #a.week_due = #b.week_due


Select * from #a

GO
