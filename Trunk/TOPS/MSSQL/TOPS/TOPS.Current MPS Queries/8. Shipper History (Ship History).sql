--Ship History - $A$1:$E$21103

select
	shipper_detail.part
,	shipper_detail.qty_packed
,	shipper_detail.date_shipped
,	shipper_detail.shipper
,	shipper_detail.accum_shipped
from
	MONITOR.dbo.shipper_detail shipper_detail
where
	(shipper_detail.date_shipped >= dateadd(d, -180, getdate()))
	and (shipper_detail.qty_required > 0)
order by
	shipper_detail.part
,	shipper_detail.date_shipped desc;