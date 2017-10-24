SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_cashreceipt_forecast] 
	(	
	orderid,
	team,
	basepart,
	destination,
	qty_projected,
	orderdetailtype,
	price,
    sell_date,
	projectedcashreceipt,
	extended)
as
SELECT	
	order_detail.order_no,
	isNULL((Select max(sales_manager_code.description) from sales_manager_code where  part_eecustom.team_no = sales_manager_code.code), 'No team Assigned'),   
	(case when patindex('%-%', order_detail.part_number)=8 THEN Substring(order_detail.part_number,1, (patindex('%-%', order_detail.part_number)-1)) else order_detail.part_number end),   
	order_header.destination,   
	isNULL(order_detail.eeiqty, order_detail.quantity),   
	order_detail.type,   
	order_detail.alternate_price,
    order_detail.due_date,
	dateadd(dd,( CASE WHEN term.type in ('COD', 'IMMEDIATE') THEN 0 ELSE isNULL(due_day,30) END), order_detail.due_date) as projectedcashreceipt,
	isNULL(order_detail.eeiqty, order_detail.quantity)*order_detail.alternate_price
FROM	order_header
JOIN		order_detail on order_header.order_no = order_detail.order_no
JOIN		part_eecustom on order_detail.part_number = part_eecustom.part
LEFT OUTER JOIN term on order_header.term = term.description 
Where	order_detail.due_date > '1999-01-01'
GO
