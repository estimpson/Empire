use EEH
go

declare
	@po int = 18296
,	@part varchar(25) = '1393366-1'


select
	ew.po_number
,	ew.vendor
,	ew.part
,	[*last_rcv_qty] = convert(varchar(20), ew.last_rcv_qty)
,	[*last_rcv_date] = convert(varchar(6), ew.last_rcv_date, 12)
,	[*last_rcv_id] = ew.last_rcv_id
,	[*cum_received] = convert(varchar(20), ew.cum_received)
,	[*cum_start_date] = convert(varchar(6), dg.Value, 12)
from
	dbo.edi_830_work ew
	cross apply
		(	select
				*
			from
				FT.DTGlobals dg
			where
				dg.Name = 'BaseWeek'
		) dg
--where
	--ew.po_number = @po
	--and ew.part = @part