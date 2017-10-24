SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[eeisp_rpt_sales_comapre_eei_customer]  (@FromDate datetime, @ThroughDate datetime)

as

Begin


Select	left(basepart,3) as CustomerID,
		Customer.name,
		team,
		basepart,
		destination.destination,
		orderdetailtype,
		price,
		date_due,
		part_number,
		customerqty,
		eeiQty,
		eeiQty*price as EEIExtended,
		customerQty*price as CustomerExtended

From	vw_eei_sales_forecast
join		destination	on	vw_eei_sales_forecast.destination = destination.destination
left join	customer on destination.customer = customer.customer
where	date_due >= @FromDate and date_due< dateadd(d, 1, FT.fn_TruncDate('dd',@ThroughDate))


End
GO
