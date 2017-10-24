SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Andre S. Boulanger
-- Create date: 2009-02-03
-- Description:	Returns expected ar starting balance, sales, expected sales, and expected cash receipts  for the expected sales and sales. Also returns running ar balance by date
-- =============================================
CREATE PROCEDURE [dbo].[eeisp_rpt_accounting_expected_cash_receipts_all]
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

create table #CustomerExpectedCashReceipts
(	Customer varchar(20),
	entrydate datetime,
	eeDueDateInd int,
	beg_balance decimal(15,2),
	projected_sales decimal(15,2),
	projected_collections decimal(15,2),
	total_balance decimal(15,2)
)
 
insert into #CustomerExpectedCashReceipts
select	CustomerL as Customer,
		entrydt,
		max(isnull(ee_sched_date,0)) as EEDueDateInd,
		ISNULL(c.openamount,0) as OpenAmount, 
		isNull(sum(ProjectedSalesShipDate.projected_Sales_eeiqty),0) as projected_sales, 
		isnull(sum(-1* projected_collections_eeiqty),0)+isnull(sum(-1* ProjectedSalesCollectionDate.projected_Sales_eeiqty),0) as projected_collections, 
		ISNULL(c.openamount,0)+ISNULL(sum(ProjectedSalesShipDate.projected_Sales_eeiqty),0)+(isnull(sum(-1* projected_collections_eeiqty),0)+isnull(sum(-1* ProjectedSalesCollectionDate.projected_Sales_eeiqty),0)) as TotalDue
from		(Select distinct customer  as CustomerL from order_header
			union	
		Select distinct bill_customer as CustomerL from ar_headers) CustomerList cross join (select * from dbo.fn_calendar_startCurrentDay('2009-09-01','dd',1,180)) Calendar 

left join 
		
		(select	order_header.customer as OHCustomer,
				(case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end) as 'order_ship_date',
				sum(quantity*order_detail.alternate_price) as projected_Sales_customerqty, 
				sum(eeiqty*order_detail.alternate_price) as projected_Sales_eeiqty
		from		order_detail 
		join		order_header on order_detail.order_no = order_header.order_no 
		where	order_detail.due_date > dateadd(d,-21,getdate())
		group by		order_header.customer,
					(case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end)) ProjectedSalesShipDate  on Calendar.EntryDT = ProjectedSalesShipDate.order_ship_date and ProjectedSalesShipDate.OHCustomer = CustomerL
left Join
	(select		order_header.customer as OHCustomer,
				[dbo].[fn_ReturnDueDate] ((case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end), order_header.term) as 'order_due_date',
				sum(quantity*order_detail.alternate_price) as projected_Sales_customerqty, 
				sum(eeiqty*order_detail.alternate_price) as projected_Sales_eeiqty
		from		order_detail 
		join		order_header on order_detail.order_no = order_header.order_no 
		where	order_detail.due_date > dateadd(d,-21,getdate())
		group by		order_header.customer,
					[dbo].[fn_ReturnDueDate] ((case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end), order_header.term)) ProjectedSalesDueDate  on Calendar.EntryDT = ProjectedSalesDueDate.order_due_date and ProjectedSalesDueDate.OHCustomer = CustomerL

left Join
	(select		order_header.customer as OHCustomer,
				[dbo].[fn_ReturnCustomerCheckReceiptDate]((case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end), order_header.term, order_header.customer) as 'order_expected_cashrecipt_date',
				sum(quantity*order_detail.alternate_price) as projected_Sales_customerqty, 
				sum(eeiqty*order_detail.alternate_price) as projected_Sales_eeiqty
		from		order_detail 
		join		order_header on order_detail.order_no = order_header.order_no 
		where	order_detail.due_date > dateadd(d,-21,getdate())
		group by		order_header.customer,
					[dbo].[fn_ReturnCustomerCheckReceiptDate]((case	when order_detail.due_date < getdate() 
					then ft.fn_truncdate('d',getdate()) 
					else ft.fn_truncdate('d',order_detail.due_date) 
					end), order_header.term, order_header.customer)) ProjectedSalesCollectionDate  on Calendar.EntryDT = ProjectedSalesCollectionDate.order_expected_cashrecipt_date and ProjectedSalesCollectionDate.OHCustomer = CustomerL

left join
		(select	bill_customer as BTCustomer,
				ft.fn_truncdate('day',COALESCE(ee_scheduled_date, due_date, getdate())) as 'ar_expected_cashrecipt_date',
				sum(amount-applied_amount) as projected_collections_custqty,
				sum(amount-applied_amount) as projected_collections_eeiqty,
				min((CASE WHEN ft.fn_truncdate('day',ee_scheduled_date) is Null then 0 ELSE 1 END)) as ee_sched_date
		from ar_headers 
		where (amount-applied_amount) <> 0 and
				bill_unit != '10' and
				bill_customer not in ( 'EEI', 'EEH')
		group by	bill_customer,
				ft.fn_truncdate('day',COALESCE(ee_scheduled_date, due_date, getdate()))
				
		) PriorSales  on  Calendar.EntryDT = PriorSales.ar_expected_cashrecipt_date and BTCustomer = CustomerL

left join 
 
		(select	bill_customer OBCustomer,
		ft.fn_truncdate('dd',getdate()) start_date , 
		isNull(sum(amount-applied_amount),0) as OpenAmount
		from		ar_headers 
		group by bill_customer 
		) c
 
on Calendar.EntryDT = c.start_date and obCustomer= customerL
 
group by CustomerL,entrydt, c.openamount
--having customerL != NULL
 
order by 1,4

Select	*, (Select sum(total_balance) from #CustomerExpectedCashReceipts CECR where CECR.Customer = #CustomerExpectedCashReceipts.Customer and  CECR.Entrydate<=#CustomerExpectedCashReceipts.Entrydate) as RunningTotal
from		#CustomerExpectedCashReceipts
where	customer is not null and
		customer in ( Select customer from #CustomerExpectedCashReceipts  group by customer having abs(max(beg_balance))>0 or abs(max(projected_sales))>0 or abs(max(projected_collections))>0)
order by 1,2
END
GO
