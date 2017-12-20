--EOP - $A$1:$C$1222

select
	base_part
,	sop
,	eop
from
	[eeiuser].[acctg_csm_vw_select_sales_forecast]
order by
	base_part;