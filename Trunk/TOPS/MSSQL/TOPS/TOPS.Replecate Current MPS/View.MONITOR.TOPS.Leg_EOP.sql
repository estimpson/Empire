
/*
Create View.MONITOR.TOPS.Leg_EOP.sql
*/

use MONITOR
go

--drop table TOPS.Leg_EOP
if	objectproperty(object_id('TOPS.Leg_EOP'), 'IsView') = 1 begin
	drop view TOPS.Leg_EOP
end
go

create view TOPS.Leg_EOP
as
select
	BasePart = acvssf.base_part
,	SOP = min(acvssf.sop)
,	EOP = max(acvssf.eop)
,	CSM_SOP = min(acvssf.CSM_sop)
,	CSM_EOP = max(acvssf.CSM_eop)
from
	eeiuser.acctg_csm_vw_select_sales_forecast acvssf
group by
	acvssf.base_part
go

select
	*
from
	TOPS.Leg_EOP le
where
	le.BasePart = 'AUT0221'
order by
	le.BasePart
