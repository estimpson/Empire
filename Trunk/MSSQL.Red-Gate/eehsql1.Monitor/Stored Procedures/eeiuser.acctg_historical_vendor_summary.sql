SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [eeiuser].[acctg_historical_vendor_summary] 
as

Select 			convert(varchar,oh.fiscal_year)+'-'+convert(varchar,oh.period) as date_stamp,
po.default_vendor,
			Oh.part,
			ph.name,
			Sum(Oh.quantity*psh.material_cum) as ext_amount
From 			object_historical oh
left join 	part_online po 
on 	oh.part = po.part
	left join 	part_standard_historical psh
		on 	oh.part  = psh.part
		and 	oh.fiscal_year = psh.fiscal_year
		and 	oh.period = psh.period
		and	oh.reason = psh.reason
	left join	part_historical ph
		on	oh.part = ph.part
		and 	oh.fiscal_year = ph.fiscal_year
		and 	oh.period = ph.period
		and 	oh.reason = ph.reason
where			oh.reason = 'MONTH END'
		and 	oh.fiscal_year >= (DATEPART(yyyy,getdate())-1)
		and		ph.type = 'R'
group by		convert(varchar,oh.fiscal_year)+'-'+convert(varchar,oh.period),
				po.default_vendor,
				oh.part,
				ph.name
GO
