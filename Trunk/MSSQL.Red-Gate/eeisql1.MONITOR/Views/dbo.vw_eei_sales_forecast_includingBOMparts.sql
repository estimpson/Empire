SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--select * from [dbo].[vw_eei_sales_forecast_includingBOMparts] where qty_projected != eeiQty


/*
Object:			View [dbo].[vw_eei_sales_forecast]    
Script Date:	10/02/2006 16:47:59
Authors:		Andre Boulanger

Use:			

Dependencies:	StoredProcedure [dbo].[eeisp_rpt_sales_forecast_5Months]

Change Log:		2012-06-22 2:00 PM; Dan West
				Temporarily removed the union to ES3_BK db because ES3_BK db deleted and dependent reports won't run
				(will distort the YTD and Prior Year Sales for ES3 sales pre- Oct 1, 2011!)
				After Jan 1, 2013, we may remove the ES3_BK references because effective Oct 1, 2011 all ES3 activity is running through the Monitor db

				2014-05-12 12:30 PM; Andre S. Boulanger
				1. Modified where clause to select only those rows from order detail that are due within the next 14 days.
				2. Added case statement for due date so that anything past due will be due on current date

				2016-10-19 12:23 PM; Andre S. Boulanger
				1. Per request from German , qty_projected is now customer quantity, was eeiqty; all affects extended and materialcumExt			

*/

-- select * from dbo.vw_eei_sales_forecast


CREATE VIEW [dbo].[vw_eei_sales_forecast_includingBOMparts] 
	(	
	company,
	orderid,
	team,
	basepart,
	destination,
	qty_projected,
	orderdetailtype,
	price,
	date_due,
	extended,
	part_number,
	customerqty,
	eeiQty,
	term,
	customer,
	customer_name,
	net_days,
	disc_percent,
	disc_days,
	eom_flag,
	eom_cutoff,
	eeiMaterialCum,
	eeiMaterialCumExt)
AS
SELECT
	'EEI',	
	order_detail.order_no,
	ISNULL((SELECT MAX(sales_manager_code.description) FROM sales_manager_code WHERE  part_eecustom.team_no = sales_manager_code.code), 'No team Assigned'),   
	(CASE WHEN PATINDEX('%-%', order_detail.part_number)=8 THEN SUBSTRING(order_detail.part_number,1, (PATINDEX('%-%', order_detail.part_number)-1)) ELSE order_detail.part_number END),   
	order_header.destination,   
	--ISNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity), 
	COALESCE(order_detail.quantity, 0),  
	order_detail.type,   
	order_detail.alternate_price,
	[due_date] = CASE WHEN ft.fn_TruncDate('d',order_detail.due_date) < ft.fn_TruncDate('d',GETDATE()) THEN ft.fn_TruncDate('d',GETDATE()) ELSE ft.fn_TruncDate('d',order_detail.due_date) END ,
	--ISNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity)*order_detail.alternate_price,
	COALESCE(order_detail.quantity, 0)*order_detail.alternate_price,
	part_number,
	order_detail.quantity,
	order_detail.eeiqty,
	order_header.term,
	customer.customer,
	customer.name,
	terms.net_days,
	terms.discount_percent as disc_percent,
	terms.discount_days as disc_days,
	terms.end_of_month as eom_flag,
	terms.end_of_month_cutoff as eom_cutoff,
	part_standard.material_cum,
	--ISNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity)*part_standard.material_cum
	COALESCE(order_detail.quantity,0)*part_standard.material_cum


FROM		order_header
LEFT JOIN	empower..Payment_terms terms ON order_header.term = terms.payment_term
JOIN		customer ON order_header.customer= customer.customer 
JOIN		order_detail ON order_header.order_no = order_detail.order_no
JOIN		part_eecustom ON order_detail.part_number = part_eecustom.part
JOIN		part_standard ON part_eecustom.part = part_standard.part
WHERE		order_detail.due_date >= DATEADD(dd,-14, GETDATE())
		--AND ISNULL(customer.region_code,'') != 'Internal' 
--		and order_detail.part_number not in (select part from eeiVW_MG)

/*UNION ALL
SELECT
	'ES3',	
	order_detail.order_no,
	isNULL((Select max(sales_manager_code.description) from sales_manager_code where  part_eecustom.team_no = sales_manager_code.code), 'No team Assigned'),   
	(case when patindex('%-%', order_detail.part_number)=8 THEN Substring(order_detail.part_number,1, (patindex('%-%', order_detail.part_number)-1)) else order_detail.part_number end),   
	order_header.destination,   
	isNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity),   
	order_detail.type,   
	order_detail.alternate_price,
	order_detail.due_date,
	isNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity)*order_detail.alternate_price,
	part_number,
	order_detail.quantity,
	order_detail.eeiqty,
	order_header.term,
	customer.customer,
	customer.name,
	net_days,
	disc_percent,
	disc_days,
	eom_flag,
	eom_cutoff,
	part_standard.material_cum,
	isNULL(dbo.fn_GreaterOf(0,order_detail.eeiqty), order_detail.quantity)*part_standard.material_cum
	
FROM		[es3_bk].[dbo].order_header order_header
LEFT JOIN		[es3_bk].[dbo].terms terms on order_header.term = terms.terms
JOIN		[es3_bk].[dbo].customer customer on order_header.customer= customer.customer
JOIN		[es3_bk].[dbo].order_detail  order_detail on order_header.order_no = order_detail.order_no
JOIN		[es3_bk].[dbo].part_eecustom part_eecustom on order_detail.part_number = part_eecustom.part
JOIN		[es3_bk].[dbo].part_standard part_standard on order_detail.part_number = part_standard.part
Where		order_detail.due_date > '1999-01-01' and isNull(customer.region_code,'') != 'Internal'*/







GO