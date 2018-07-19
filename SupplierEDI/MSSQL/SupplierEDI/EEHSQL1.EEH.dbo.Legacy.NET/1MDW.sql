
/*
select
	*
from
	dbo.edi_830_work ew

select
	*
from
	dbo.edi_vendor ev
*/

declare
	@vendor varchar(10) = 'TE'

select distinct
	ew.vendor
,	[*today_str] = convert(varchar(6), getdate(), 12)
,	[*horizon_start] = convert(varchar(6), dateadd(day, 1, getdate()), 12)
,	[*horizon_end] = convert(varchar(6), ew.horizon_end_date, 12)
,	[*trading_partner_code] = ev.trading_partner_code
,	[*c_vendor_supplier_code] = coalesce(nullif(edi_setups.supplier_code, ''), ew.vendor)
,	[*c_vendor_id_code_type] = coalesce(nullif(edi_setups.id_code_type, ''),'92')
,	[*vendor_material_issuer] = isnull(edi_setups.material_issuer, '')
,	[*material_issuer_id_type] = (case when edi_setups.destination = 'DIXIEHON' then '92' else '1' end)
,	[*doc_num] = ew.vendor + '-' + convert(varchar(6), getdate(), 12) --[vendor]-yymmdd
from
	dbo.edi_830_work ew
	join dbo.edi_vendor ev
		on ev.vendor = ew.vendor
	left outer join edi_setups
		on ew.vendor = edi_setups.destination
where
	ew.vendor = @vendor
order by
	ew.vendor
