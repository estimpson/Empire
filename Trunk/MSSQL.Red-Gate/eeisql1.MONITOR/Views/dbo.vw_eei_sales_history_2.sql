SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_sales_history_2] 
	(
	shipperid,
	basepart,
	qty_shipped,
	shippertype,
	price,
	date_shipped,
	extended)
as
--To be used only for Ken's Sales Report - His report only pulls last Months History
SELECT	
	shipper.id, 
	(case when patindex('%-%', shipper_detail.part_original)=8 THEN Substring(shipper_detail.part_original,1, (patindex('%-%', shipper_detail.part_original)-1)) else shipper_detail.part_original end),   
	qty_packed,   
	shipper.type,   
	shipper_detail.alternate_price,
	shipper.date_shipped,
	qty_packed*alternate_price
FROM	Shipper
JOIN		shipper_detail on shipper.id = shipper_detail.shipper
Where	isNULL(shipper.date_shipped, convert (datetime,'1999-01-01') ) > (select dateadd(yy, -2, getdate())) and
	isNULL (shipper.type, 'Y') <> 'T' and
	shipper_detail.qty_packed is not null and shipper_detail.part_original not in (select part from eeiVW_MG)
GO
