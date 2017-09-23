SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- DW - 2012-06-22  removed es3_bk union because es3 activity is now all in monitor db


CREATE view [dbo].[vw_eei_sales_history] 
	(
	company,
	shipperid,
	team,
	part,
	basepart,
	destination,
	qty_shipped,
	shippertype,
	price,
	date_shipped,
	extended,
	eeiMaterialCumExt
	)
as

SELECT
	'EEI'	,
	shipper.id, 
	isNULL((Select max(sales_manager_code.description) from sales_manager_code where  part_eecustom.team_no = sales_manager_code.code), 'No team Assigned'),
	part_original,  
	(case when patindex('%-%', shipper_detail.part_original)=8 THEN Substring(shipper_detail.part_original,1, (patindex('%-%', shipper_detail.part_original)-1)) else shipper_detail.part_original end),   
	shipper.destination,   
	qty_packed,   
	shipper.type,   
	shipper_detail.alternate_price,
	shipper.date_shipped,
	qty_packed*alternate_price,
	qty_packed*material_cum
FROM	Shipper
JOIN		customer on dbo.shipper.customer = dbo.customer.customer
JOIN		shipper_detail on shipper.id = shipper_detail.shipper
left JOIN		part_eecustom on shipper_detail.part_original = part_eecustom.part
left JOIN		part_standard on part_eecustom.part = part_standard.part
Where	isNULL(shipper.date_shipped, convert (datetime,'1999-01-01') ) > (select dateadd(yy, -3, getdate())) 
	and	isNULL (shipper.type, 'Y') <> 'V' 
	and isNULL (shipper.type, 'Y') <> 'T' 
	and	shipper_detail.qty_packed is not null 
	and shipper_detail.part_original not in (select part from eeiVW_MG) 
	and isNull(customer.region_code,'') != 'Internal'

/*UNION ALL
SELECT
	'ES3',	
	shipper.id, 
	isNULL((Select max(sales_manager_code.description) from sales_manager_code where  part_eecustom.team_no = sales_manager_code.code), 'No team Assigned'), 
	part_original, 
	(case when patindex('%-%', shipper_detail.part_original)=8 THEN Substring(shipper_detail.part_original,1, (patindex('%-%', shipper_detail.part_original)-1)) else shipper_detail.part_original end),   
	shipper.destination,   
	qty_packed,   
	shipper.type,   
	shipper_detail.alternate_price,
	shipper.date_shipped,
	qty_packed*alternate_price,
	qty_packed*material_cum
FROM		ES3_BK.[dbo].Shipper shipper
JOIN		ES3_BK.[dbo].customer customer on shipper.customer = customer.customer
JOIN		ES3_BK.[dbo].shipper_detail shipper_detail on shipper.id = shipper_detail.shipper
JOIN		ES3_BK.[dbo].part_eecustom part_eecustom on shipper_detail.part_original = part_eecustom.part
JOIN		ES3_BK.[dbo].part_standard part_standard on shipper_detail.part_original = part_standard.part
Where	isNULL(shipper.date_shipped, convert (datetime,'1999-01-01') ) > (select dateadd(yy, -1, getdate())) and
	isNULL (shipper.type, 'Y') <> 'V' and isNULL (shipper.type, 'Y') <> 'T' and
	shipper_detail.qty_packed is not null and isNull(customer.region_code,'') != 'Internal'*/







GO
