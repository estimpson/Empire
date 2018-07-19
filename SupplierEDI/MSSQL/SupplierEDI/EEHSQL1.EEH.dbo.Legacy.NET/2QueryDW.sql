declare
	@vendor varchar(10) = 'TE'

select
	[*po_number] = ew.po_number
,	[*part] = ew.part
from
	dbo.edi_830_work ew
where
	ew.vendor = @vendor
order by
	ew.po_number
,	ew.part