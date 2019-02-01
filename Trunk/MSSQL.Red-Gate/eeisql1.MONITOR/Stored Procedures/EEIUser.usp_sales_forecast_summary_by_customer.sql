SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_sales_forecast_summary_by_customer]
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

/*
declare @forecast table
(
	Customer varchar(50)
,	Sales_2016 decimal(38, 6)
,	SalesActual_2016 decimal(38, 6) null
,	Sales_2017 decimal(38, 6)
,	SalesActual_2017 decimal(38, 6) null
,	Sales_2018 decimal(38, 6)
,	Sales_2019 decimal(38, 6)
,	Sales_2020 decimal(38, 6)
,	Sales_2021 decimal(38, 6)
,	Sales_2022 decimal(38, 6)
,	Sales_2023 decimal(38, 6)
,	Sales_2024 decimal(38, 6)
,	Sales_2025 decimal(38, 6)
)
*/


declare @shipped table
(
	Customer varchar(50)
,	Sales2016 decimal(20, 6) null
,	Sales2017 decimal(20, 6) null
)

-- Group actuals by empire market segment
insert @shipped
(
	Customer
,	Sales2016
,	Sales2017
)
select
	Customer = bpa.customer
,	Sales2016 = coalesce(sum(sbp.Year2016), 0)
,	Sales2017 = coalesce(sum(sbp.Year2017), 0)
from
	@shippedBasePart sbp
	left join eeiuser.acctg_csm_base_part_attributes bpa
		on bpa.base_part = sbp.BasePart
where
	bpa.include_in_forecast = 1
	and bpa.release_id = (select [dbo].[fn_ReturnLatestCSMRelease] ('CSM') )
group by
	bpa.customer


/*
-- Get forecast 
insert @forecast
(
	Customer
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
,	Sales_2021
,	Sales_2022
,	Sales_2023
,	Sales_2024
,	Sales_2025
)
select
	Customer = sf.customer
,	Sales_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
,	Sales_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
,	Sales_2018 = sum(coalesce(sf.Cal_18_Sales, 0))
,	Sales_2019 = sum(coalesce(sf.Cal_19_Sales, 0))
,	Sales_2020 = sum(coalesce(sf.Cal_20_Sales, 0))
,	Sales_2021 = sum(coalesce(sf.Cal_21_Sales, 0))
,	Sales_2022 = sum(coalesce(sf.Cal_22_Sales, 0))
,	Sales_2023 = sum(coalesce(sf.Cal_23_Sales, 0))
,	Sales_2024 = sum(coalesce(sf.Cal_24_Sales, 0))
,	Sales_2025 = sum(coalesce(sf.Cal_25_Sales, 0))
from
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where
	sf.customer is not null
group by 
	sf.customer	
order by
	sf.customer




-- Combine actuals and forecast, and return results
select 
	f.Customer
,	f.Sales_2016
,	s.Sales2016 as SalesActual_2016
,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
,	f.Sales_2017
,	s.Sales2017 as SalesActual_2017
,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
,	f.Sales_2018
,	f.Sales_2019
,	f.Sales_2020
,	f.Sales_2021
,	f.Sales_2022
,	f.Sales_2023
,	f.Sales_2024
,	f.Sales_2025
,	s.Sales2017 - s.Sales2016 as Change_2017
,	f.Sales_2018 - s.Sales2017 as Change_2018
,	f.Sales_2019 - f.Sales_2018 as Change_2019
,	f.Sales_2020 - f.Sales_2019 as Change_2020
,	f.Sales_2021 - f.Sales_2020 as Change_2021
,	f.Sales_2022 - f.Sales_2021 as Change_2022
,	f.Sales_2023 - f.Sales_2022 as Change_2023
,	f.Sales_2024 - f.Sales_2023 as Change_2024
,	f.Sales_2025 - f.Sales_2024 as Change_2025
from 
	@forecast f
	left join @shipped s
		on s.Customer = f.Customer
order by
	f.Customer
*/












-- Combine STE and STK
declare @tempSteSales table
(
	Customer varchar(50)
,	Sales_2016 decimal(20,6)
,	Sales_2017 decimal(20,6)
,	Sales_2018 decimal(20,6)
,	Sales_2019 decimal(20,6)
,	Sales_2020 decimal(20,6)
)

insert into @tempSteSales
(
	Customer
--,	Sales_2016
--,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	sf.customer
--,	sum(Cal_16_Sales)
--,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	sf.customer = 'STE'
group by 
	sf.customer

-- Update with actuals
update
	t
set
	t.Sales_2016 = s.Sales2016
,	t.Sales_2017 = s.Sales2017
from
	@tempSteSales t
	join @shipped s
		on s.Customer = t.Customer
where
	t.Customer = 'STE'
	

-- Combine
declare
	@StkSales2016 decimal(20,6)
,	@StkSales2017 decimal(20,6)
,	@StkSales2018 decimal(20,6)
,	@StkSales2019 decimal(20,6)
,	@StkSales2020 decimal(20,6)	

select
	@StkSales2016 = s.Sales2016
,	@StkSales2017 = s.Sales2017
from
	@shipped s
where
	s.Customer = 'STK'

select 
	@StkSales2018 = sum(Cal_18_Sales)
,	@StkSales2019 = sum(Cal_19_Sales)
,	@StkSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = 'STK'
group by 
	customer 
	
update
	@tempSteSales	
set
	Sales_2016 = Sales_2016 + @StkSales2016
,	Sales_2017 = Sales_2017 + @StkSales2017
,	Sales_2018 = Sales_2018 + @StkSales2018
,	Sales_2019 = Sales_2019 + @StkSales2019
,	Sales_2020 = Sales_2020 + @StkSales2020
	



-- Combine AUT and DFN
declare @tempAutSales table
(
	Customer varchar(50)
,	Sales_2016 decimal(20,6)
,	Sales_2017 decimal(20,6)
,	Sales_2018 decimal(20,6)
,	Sales_2019 decimal(20,6)
,	Sales_2020 decimal(20,6)
)

insert into @tempAutSales
(
	Customer
--,	Sales_2016
--,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
--,	sum(Cal_16_Sales)
--,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = 'AUT'
group by 
	customer 

-- Update with actuals
update
	t
set
	t.Sales_2016 = s.Sales2016
,	t.Sales_2017 = s.Sales2017
from
	@tempAutSales t
	join @shipped s
		on s.Customer = t.Customer
where
	t.Customer = 'AUT'

-- Combine
declare
	@DfnSales2016 decimal(20,6)
,	@DfnSales2017 decimal(20,6)
,	@DfnSales2018 decimal(20,6)
,	@DfnSales2019 decimal(20,6)
,	@DfnSales2020 decimal(20,6)	

select
	@DfnSales2016 = s.Sales2016
,	@DfnSales2017 = s.Sales2017
from
	@shipped s
where
	s.Customer = 'DFN'

select 
	@DfnSales2018 = sum(Cal_18_Sales)
,	@DfnSales2019 = sum(Cal_19_Sales)
,	@DfnSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = 'DFN'
group by 
	customer 
	
update
	@tempAutSales	
set
	Sales_2016 = Sales_2016 + @DfnSales2016
,	Sales_2017 = Sales_2017 + @DfnSales2017
,	Sales_2018 = Sales_2018 + @DfnSales2018
,	Sales_2019 = Sales_2019 + @DfnSales2019
,	Sales_2020 = Sales_2020 + @DfnSales2020





-- Combine VNA and MER
declare @tempVnaSales table
(
	Customer varchar(50)
,	Sales_2016 decimal(20,6)
,	Sales_2017 decimal(20,6)
,	Sales_2018 decimal(20,6)
,	Sales_2019 decimal(20,6)
,	Sales_2020 decimal(20,6)
)

insert into @tempVnaSales
(
	Customer
--,	Sales_2016
--,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
--,	sum(Cal_16_Sales)
--,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = 'VNA'
group by 
	customer 

-- Update with actuals
update
	t
set
	t.Sales_2016 = s.Sales2016
,	t.Sales_2017 = s.Sales2017
from
	@tempVnaSales t
	join @shipped s
		on s.Customer = t.Customer
where
	t.Customer = 'VNA'

-- Combine
declare
	@MerSales2016 decimal(20,6)
,	@MerSales2017 decimal(20,6)
,	@MerSales2018 decimal(20,6)
,	@MerSales2019 decimal(20,6)
,	@MerSales2020 decimal(20,6)	

select
	@MerSales2016 = s.Sales2016
,	@MerSales2017 = s.Sales2017
from
	@shipped s
where
	s.Customer = 'MER'

select 
	@MerSales2018 = sum(Cal_18_Sales)
,	@MerSales2019 = sum(Cal_19_Sales)
,	@MerSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = 'MER'
group by 
	customer 
	
update
	@tempVnaSales	
set
	Sales_2016 = Sales_2016 + @MerSales2016
,	Sales_2017 = Sales_2017 + @MerSales2017
,	Sales_2018 = Sales_2018 + @MerSales2018
,	Sales_2019 = Sales_2019 + @MerSales2019
,	Sales_2020 = Sales_2020 + @MerSales2020






-- Return results	
declare @forecast table
(
	Customer varchar(50)
,	Sales_2016 decimal(38, 6) null
,	Sales_2017 decimal(38, 6) null
,	Sales_2018 decimal(38, 6)
,	Sales_2019 decimal(38, 6)
,	Sales_2020 decimal(38, 6)
,	Sales_2021 decimal(38, 6)
,	Sales_2022 decimal(38, 6)
,	Sales_2023 decimal(38, 6)
,	Sales_2024 decimal(38, 6)
,	Sales_2025 decimal(38, 6)
)

insert @forecast
(
	Customer
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
,	Sales_2016 = null
,	Sales_2017 = null
--,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	sum(Cal_18_Sales) as Sales_2018
--,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	sum(Cal_19_Sales) as Sales_2019
--,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	sum(Cal_20_Sales) as Sales_2020
--,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')
group by 
	customer


update
	f
set
	f.Sales_2016 = s.Sales2016
,	f.Sales_2017 = s.Sales2017
from
	@forecast f
	join @shipped s
		on s.Customer = f.Customer
where
	f.Customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')






select 
	customer
,	Sales_2016
,	Sales_2017
,	(Sales_2017 - Sales_2016) as Change_2017
,	Sales_2018
,	(Sales_2018 - Sales_2017) as Change_2018
,	Sales_2019
,	(Sales_2019 - Sales_2018) as Change_2019
,	Sales_2020
,	(Sales_2020 - Sales_2019) as Change_2020
from 
	@forecast
where 
	customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')
--group by 
--	customer

union all	

select
	customer = 'STE/STK'
,	Sales_2016
,	Sales_2017
,	(Sales_2017 - Sales_2016) as Change_2017
,	Sales_2018
,	(Sales_2018 - Sales_2017) as Change_2018
,	Sales_2019
,	(Sales_2019 - Sales_2018) as Change_2019
,	Sales_2020
,	(Sales_2020 - Sales_2019) as Change_2020
from
	@tempSteSales t

union all	

select
	customer = 'AUT/DFN'
,	Sales_2016
,	Sales_2017
,	(Sales_2017 - Sales_2016) as Change_2017
,	Sales_2018
,	(Sales_2018 - Sales_2017) as Change_2018
,	Sales_2019
,	(Sales_2019 - Sales_2018) as Change_2019
,	Sales_2020
,	(Sales_2020 - Sales_2019) as Change_2020
from
	@tempAutSales t

union all	

select
	customer = 'VNA/MER'
,	Sales_2016
,	Sales_2017
,	(Sales_2017 - Sales_2016) as Change_2017
,	Sales_2018
,	(Sales_2018 - Sales_2017) as Change_2018
,	Sales_2019
,	(Sales_2019 - Sales_2018) as Change_2019
,	Sales_2020
,	(Sales_2020 - Sales_2019) as Change_2020
from
	@tempVnaSales t
order by
	customer
GO
