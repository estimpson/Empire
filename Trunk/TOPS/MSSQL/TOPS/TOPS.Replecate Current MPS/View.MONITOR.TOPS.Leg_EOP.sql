
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
	BasePart = base_part
,	SOP = sop
,	EOP = eop
from
	[eeiuser].[acctg_csm_vw_select_sales_forecast]
go

select
	*
from
	TOPS.Leg_EOP le
order by
	le.BasePart
