--PO NO DEMAND - $A$1:$C$843

select
	po_detail.vendor_code
,	po_detail.part_number
,	po_detail.po_number
,	po_detail.balance
from
	MONITOR.dbo.po_detail po_detail
where
	(po_detail.vendor_code = 'EEH')
	and (po_detail.balance <> 0)
	and (isnull(truck_number, 'XXX') <> 'ASB')
order by
	po_detail.part_number
,	po_detail.po_number;