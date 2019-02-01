SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_LifeCycle_GetParentCustomers]
	@LifeCycleStage varchar(50)
as
set nocount on
set ansi_warnings on


--- <Body>
select
	'' as ParentCustomer

union all

select 
	case
		when sf.parent_customer like '%UTAS%' then 'UTAS-NOVA Automotive Lighting Systems' -- remove tab from this parent cust
		else sf.parent_customer
	end as ParentCustomer
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where
	( @LifeCycleStage = 'Pre-production' 
		and coalesce(year(sf.sop_display), 2018) >= 2019 )
	or ( @LifeCycleStage = 'Launch 2017' 
		and coalesce(year(sf.sop_display), 2016) = 2017 )
	or ( @LifeCycleStage = 'Launch 2018' 
		and coalesce(year(sf.sop_display), 2017) = 2018 )
	or ( @LifeCycleStage = 'Production' 
		and coalesce(year(sf.sop_display), 2018) < 2017 
		and coalesce(year(sf.eop_display), 2016) > 2018 )
	or ( @LifeCycleStage = 'Closeouts 2018'
		and coalesce(year(sf.eop_display), 2017) = 2018 )
	or ( @LifeCycleStage = 'Closeouts 2019'
		and coalesce(year(sf.eop_display), 2018) = 2019 )
	or ( @LifeCycleStage = 'Service'
		and coalesce(year(sf.eop_display), 2016) <= 2017 )
	or ( @LifeCycleStage = 'Summary' )
group by
	sf.parent_customer
order by
	ParentCustomer
--- </Body>
GO
