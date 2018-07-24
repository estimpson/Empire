declare
	@po int = 18296
,	@part varchar(25) = '1393366-1'

select
	[*part] = ew.part
,	[*engineering_level] = ew.engineering_level
,	[*po_number_str] = convert(varchar(10), ew.po_number)
,	[*unit_of_measure] = ew.unit_of_measure
,	[*price_string] =
		case
			when ew.Price < 0 then '('
			else ''
		end
		+ convert (varchar(4), floor(abs(ew.Price)))
		+ substring(convert(varchar(10), round(convert(numeric(20,7), abs(ew.Price) - floor(abs(ew.Price))), 4) + 0.0000001), 2, 5)
		+ case
			when ew.Price < 0 then ')'
			else ''
		end
,	[*vendor_part] = ew.vendor_part
,	[*description] = ew.description
,	[*dock_code] = ew.dock_code
,	[*buyer_name] = ew.buyer_name
,	[*buyer_phone_cond] = case when rtrim(ew.buyer_name) > '' then ew.buyer_phone else '' end
,	[*buyer_email] = ew.buyer_email
,	[*scheduler_name] = ew.scheduler_name
,	[*scheduler_phone_cond] = case when rtrim(ew.scheduler_name) > '' then ew.scheduler_phone else '' end
,	[*scheduler_email] = ew.scheduler_email
,	[*raw_auth_qty] = convert(varchar(20), ew.raw_auth_qty)
,	[*cum_start_date] = convert(varchar(6), dg.Value, 12)
,	[*raw_auth_end_date] = ew.raw_auth_end_date
,	[*fab_auth_qty] = convert(varchar(20), ew.fab_auth_qty)
,	[*fab_auth_end_date] = convert(varchar(6), ew.firm_end_date, 12)
,	[*cum_expected] = convert(varchar(20), ew.cum_expected)
,	[*cum_end_date] = convert(varchar(6), getdate(), 12)
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