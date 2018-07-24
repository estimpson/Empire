SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_TransInventory]
as
select
	Part = o.part
,	InTransDT = dateadd(day, 10, FT.fn_TruncDate('day', o.last_date))
,	InTransQty = sum(o.quantity)
from
	dbo.object o
	join dbo.part p
		on o.part = p.part
	left join dbo.location l
		on o.location = l.code
where
	upper(o.location) like '%TRAN%'
	and p.type = 'F'
	and isnull(o.field2, 'XXX') <> 'ASB'
	and coalesce(l.secured_location, 'N') != 'Y'
group by
	o.part
,	dateadd(day, 10, FT.fn_TruncDate('day', o.last_date))
GO
