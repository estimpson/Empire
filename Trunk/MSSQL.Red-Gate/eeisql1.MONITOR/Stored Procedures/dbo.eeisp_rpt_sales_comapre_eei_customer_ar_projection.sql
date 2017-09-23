SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[eeisp_rpt_sales_comapre_eei_customer_ar_projection] (@FromDate datetime, @ThroughDate datetime)

as

Begin

-- eeisp_rpt_sales_comapre_eei_customer  '2009-01-01', '2009-01-31'
Select	left(basepart,3) as CustomerID,
		Customer.name,
		team,
		basepart,
		destination.destination,
		orderdetailtype,
		vw_eei_sales_forecast.price,
		date_due,
		part_number,
		customerqty,
		eeiQty,
		eeiQty*vw_eei_sales_forecast.price as EEIExtended,
		customerQty*vw_eei_sales_forecast.price as CustomerExtended,
		order_header.term
		

From	vw_eei_sales_forecast
join		destination	on	vw_eei_sales_forecast.destination = destination.destination
left join	customer on destination.customer = customer.customer
join		order_header on vw_eei_sales_forecast.orderid = order_header.order_no
where	date_due >= @FromDate and date_due< dateadd(d, 1, FT.fn_TruncDate('dd',@ThroughDate))


End
GO
