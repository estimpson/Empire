SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [EEIUser].[acctg_cust_order_quantity_by_week_by_customer]
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



select	LEFT(part_number,3) as customer,
		min(st_min_date) as st_min_date,
		max(st_max_date) as st_max_date,
		avg(st_average_order) as st_average_order,
		avg(st_std_deviation) as st_average_std_deviation,
		avg(st_std_dev_as_percentage) as st_average_std_dev_as_percentage,
		min(lt_min_date) as lt_min_date,
		max(lt_max_date) as lt_max_date,
		avg(lt_average_order) as lt_average_order,
		avg(lt_std_deviation) as lt_average_std_deviation,
		avg(lt_std_dev_as_percentage) as lt_average_std_dev_as_percentage
from
(
select	ISNULL(a.part_number, b.part_number) as part_number
		, a.min_date as st_min_date
		, a.max_date as st_max_date
		, a.average_order as st_average_order
		, a.std_deviation as st_std_deviation
		, a.std_dev_as_percentage as st_std_dev_as_percentage
		, b.min_date as lt_min_date
		, b.max_date as lt_max_date
		, b.average_order as lt_average_order
		, b.std_deviation as lt_std_deviation
		, b.std_dev_as_percentage  as lt_std_dev_as_percentage
from
		(	select	part_number
					,DATEADD(d,07,ft.fn_truncdate_monday('wk',getdate())) as min_date
					,DATEADD(d,90,ft.fn_truncdate_monday('wk',getdate())) as max_date
					,AVG(wk_order_qty) average_order
					,STDEV(wk_order_qty) as std_deviation
					,STDEV(wk_order_qty)/NULLIF(AVG(wk_order_qty),0) as std_dev_as_percentage
			from	#a
			where	week_due >= DATEADD(d,07,ft.fn_Truncdate_monday('wk',getdate()))
				and week_due <= DATEADD(d,90,ft.fn_Truncdate_monday('wk',getdate()))
			group by part_number
		) a
full outer join
		(	select	part_number
					,DATEADD(d,091,ft.fn_truncdate_monday('wk',getdate())) as min_date
					,DATEADD(d,118,ft.fn_truncdate_monday('wk',getdate())) as max_date
					,AVG(wk_order_qty) average_order
					,STDEV(wk_order_qty) as std_deviation
					,STDEV(wk_order_qty)/NULLIF(AVG(wk_order_qty),0) as std_dev_as_percentage
			from	#a
			where	week_due >= DATEADD(d,091,ft.fn_Truncdate_monday('wk',getdate()))
				and week_due <= DATEADD(d,118,ft.fn_Truncdate_monday('wk',getdate()))
			group by part_number
		)b
	on a.part_number = b.part_number) aa
	group by LEFT(part_number, 3)


GO
