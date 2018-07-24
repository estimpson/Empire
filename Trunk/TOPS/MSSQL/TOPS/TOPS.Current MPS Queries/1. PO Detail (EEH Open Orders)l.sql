--EEH OPEN ORDERS - $A$1:$E$89421

select
	po_detail.part_number
,	po_detail.po_number
,	po_detail.vendor_code
,	po_detail.balance
,	po_detail.date_due
from
	MONITOR.dbo.po_detail po_detail
where
	(po_detail.vendor_code = 'eeh')
	and (isnull(truck_number, 'XXX') <> 'ASB')
order by
	po_detail.part_number;