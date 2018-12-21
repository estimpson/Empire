SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_sales_forecast_summary_by_customer_totalsales]
as
set nocount on
set ansi_warnings on


-- Get actual sales per base part for 2016, 2017
declare @shippedBasePart table
(
	BasePart varchar(25)
,	Year2016 decimal(20, 6) null
,	Year2017 decimal(20, 6) null
)
insert @shippedBasePart
(
	BasePart
,	Year2016
,	Year2017
)
select
	BasePart = left(sd.part_original, 7)
,	Year2016 = sum((case when year(s.date_shipped) = 2016 then sd.qty_packed * sd.alternate_price else 0 end))
,	Year2017 = sum((case when year(s.date_shipped) = 2017 then sd.qty_packed * sd.alternate_price else 0 end))
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on s.id = sd.shipper
where
	year(s.date_shipped) in (2016, 2017)
	and isnull(s.type, 'S') not in ('V', 'T')
	and sd.alternate_price is not null
group by
	left(sd.part_original, 7)


declare @sales table
(
	Sales_2016 decimal(38, 6) null
,	Sales_2017 decimal(38, 6) null
,	Sales_2018 decimal(38, 6)
,	Sales_2019 decimal(38, 6)
,	Sales_2020 decimal(38, 6)
)

declare @shipped table
(
	Sales2016 decimal(20, 6) null
,	Sales2017 decimal(20, 6) null
)

insert @shipped
(
	Sales2016
,	Sales2017
)
select
	Sales2016 = coalesce(sum(sbp.Year2016), 0)
,	Sales2017 = coalesce(sum(sbp.Year2017), 0)
from
	@shippedBasePart sbp
	left join eeiuser.acctg_csm_base_part_attributes bpa
		on bpa.base_part = sbp.BasePart
where
	bpa.include_in_forecast = 1
	and bpa.release_id = (select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )



-- Get forecast sales
insert @sales
(
	Sales_2018
,	Sales_2019
,	Sales_2020
)
select
	Sales_2018 = sum(coalesce(sf.Cal_18_Sales, 0))
,	Sales_2019 = sum(coalesce(sf.Cal_19_Sales, 0))
,	Sales_2020 = sum(coalesce(sf.Cal_20_Sales, 0))
from
	eeiuser.acctg_csm_vw_select_sales_forecast sf

-- Include actual sales
update
	s
set
	s.Sales_2016 = sh.Sales2016
,	s.Sales_2017 = sh.Sales2017
from
	@sales s
	cross join @shipped sh


select
	Sales_2016
,	Sales_2017
,	(Sales_2017 - Sales_2016) as Change_2017
,	Sales_2018
,	(Sales_2018 - Sales_2017) as Change_2018
,	Sales_2019
,	(Sales_2019 - Sales_2018) as Change_2019
,	Sales_2020
,	(Sales_2020 - Sales_2019) as Change_2020
from
	@sales s

GO
