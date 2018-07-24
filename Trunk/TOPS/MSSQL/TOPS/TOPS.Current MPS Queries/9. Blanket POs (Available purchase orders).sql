--Available purchase orders - $A$1:$C$13117

select
	po_header.po_number
,	po_header.vendor_code
,	po_header.blanket_part
from
	MONITOR.dbo.po_header po_header
where
	(po_header.vendor_code = 'EEH')
	and (po_header.blanket_part is not null)
	and (isnull(blanket_vendor_part, 'XXX') <> 'ASB')
order by
	po_header.po_number;