SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_MaterialPercentage]
	@Filter varchar(50)
as
set nocount on
set ansi_warnings on



--- <Body>
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


declare @materialPercentage table
(
	Customer varchar(50)
,	MaterialPercentage decimal(20, 6)
)

declare @shipped table
(
	Filter varchar(50)
,	Sales2016 decimal(20, 6) null
,	Sales2017 decimal(20, 6) null
)

declare @forecast table
(
	Filter varchar(50)
,	MaterialPercentage decimal(10, 2)
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



if (@Filter = 'Customer Actual') begin

	-- Group actuals by customer
	insert @shipped
	(
		Filter
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = bpa.customer
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


	-- Calculate material percentage using material cost and selling price
	insert @materialPercentage
	(
		Customer
	,	MaterialPercentage
	)
	select
		sf.customer as Customer
	,	convert(decimal(10,2), (avg(sf.MC_Dec_18) / avg(sf.SP_Dec_18) * 100)) as MaterialPercentage
	from
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where
		sf.MC_Dec_18 > 0
		and sf.SP_Dec_18 > 0
	group by 
		sf.customer


	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.customer
	,	MaterialPercentage = mp.MaterialPercentage
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
		left join @materialPercentage mp
			on mp.Customer = sf.customer
	group by 
		sf.customer
	,	mp.MaterialPercentage

	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
--	,	f.Sales_2016
--	,	s.Sales2016 as SalesActual_2016
--	,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	s.Sales2016 as Sales_2016
--	,	f.Sales_2017
--	,	s.Sales2017 as SalesActual_2017
--	,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	s.Sales2017 as Sales_2017
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
			on s.Filter = f.Filter
	order by
		f.Filter

end
else if (@Filter = 'Parent Customer Actual') begin

	-- Group actuals by parent customer
	insert @shipped
	(
		Filter
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = bpa.parent_customer
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
		bpa.parent_customer


	-- Calculate material percentage using material cost and selling price
	insert @materialPercentage
	(
		Customer
	,	MaterialPercentage
	)
	select
		sf.parent_customer as Customer
	,	convert(decimal(10,2), (avg(sf.MC_Dec_18) / avg(sf.SP_Dec_18) * 100)) as MaterialPercentage
	from
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where
		sf.MC_Dec_18 > 0
		and sf.SP_Dec_18 > 0
	group by 
		sf.parent_customer


	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.parent_customer
	,	MaterialPercentage = mp.MaterialPercentage
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
		left join @materialPercentage mp
			on mp.Customer = sf.parent_customer
	group by 
		sf.parent_customer
	,	mp.MaterialPercentage

	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
--	,	f.Sales_2016
--	,	s.Sales2016 as SalesActual_2016
--	,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	s.Sales2016 as Sales_2016
--	,	f.Sales_2017
--	,	s.Sales2017 as SalesActual_2017
--	,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	s.Sales2017 as Sales_2017
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
			on s.Filter = f.Filter
	order by
		f.Filter

end
else if (@Filter = 'Salesperson Actual') begin

	-- Group actuals by salesperson
	insert @shipped
	(
		Filter
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = bpa.Salesperson
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
		bpa.Salesperson

	-- Fix a data entry issue (salesperson's name entered twice, once incorrectly)
	update
		s
	set
		s.Sales2016 = (s.Sales2016 + a.Sales2016)
	,	s.Sales2017 = (s.Sales2017 + a.Sales2017)
	from
		@shipped s
		cross apply (
			select
				s2.Sales2016
			,	s2.Sales2017
			from
				@shipped s2
			where
				s2.Filter = 'Jeff Micheals' ) a
	where
		s.Filter = 'Jeff Michaels'
	
	delete from
		@shipped
	where
		Filter = 'Jeff Micheals'



	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.salesperson
	,	MaterialPercentage = 0
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
	group by 
		sf.salesperson	


	-- Fix a data entry issue (salesperson's name entered twice, once incorrectly)
	update
		f
	set
		f.Sales_2016 = (f.Sales_2016 + a.Sales_2016)
	,	f.Sales_2017 = (f.Sales_2017 + a.Sales_2017)
	,	f.Sales_2018 = (f.Sales_2018 + a.Sales_2018)
	,	f.Sales_2019 = (f.Sales_2019 + a.Sales_2019)
	,	f.Sales_2020 = (f.Sales_2020 + a.Sales_2020)
	,	f.Sales_2021 = (f.Sales_2021 + a.Sales_2021)
	,	f.Sales_2022 = (f.Sales_2022 + a.Sales_2022)
	,	f.Sales_2023 = (f.Sales_2023 + a.Sales_2023)
	,	f.Sales_2024 = (f.Sales_2024 + a.Sales_2024)
	,	f.Sales_2025 = (f.Sales_2025 + a.Sales_2025)
	from
		@forecast f
		cross apply (
			select
				f2.Sales_2016
			,	f2.Sales_2017
			,	f2.Sales_2018
			,	f2.Sales_2019
			,	f2.Sales_2020
			,	f2.Sales_2021
			,	f2.Sales_2022
			,	f2.Sales_2023
			,	f2.Sales_2024
			,	f2.Sales_2025
			from
				@forecast f2
			where
				f2.Filter = 'Jeff Micheals' ) a
	where
		f.Filter = 'Jeff Michaels'
	
	delete from
		@forecast
	where
		Filter = 'Jeff Micheals'



	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
--	,	f.Sales_2016
--	,	s.Sales2016 as SalesActual_2016
--	,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	s.Sales2016 as Sales_2016
--	,	f.Sales_2017
--	,	s.Sales2017 as SalesActual_2017
--	,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	s.Sales2017 as Sales_2017
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
		join @shipped s
			on s.Filter = f.Filter
	order by
		f.Filter

end
else if (@Filter = 'Segment Actual') begin

	-- Group actuals by empire market segment
	insert @shipped
	(
		Filter
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = bpa.empire_market_segment
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
		bpa.empire_market_segment

	-- Get forecast 
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.empire_market_segment
	,	MaterialPercentage = 0
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
		sf.empire_market_segment is not null
	group by 
		sf.empire_market_segment	
	order by
		sf.empire_market_segment

	-- Add in a row to make up the difference between customer and market segment totals (add in non-CSM, non-US segments)
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = 'Other'
	,	MaterialPercentage = 0
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
		sf.empire_market_segment is null



	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
--	,	f.Sales_2016
--	,	s.Sales2016 as SalesActual_2016
--	,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	s.Sales2016 as Sales_2016
--	,	f.Sales_2017
--	,	s.Sales2017 as SalesActual_2017
--	,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	s.Sales2017 as Sales_2017
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
			on s.Filter = f.Filter
	order by
		f.Filter

end
else if (@Filter = 'Product Line Actual') begin

	-- Group actuals by product line
	insert @shipped
	(
		Filter
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = bpa.product_line
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
		bpa.product_line

	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.product_line
	,	MaterialPercentage = 0
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
		sf.product_line is not null
	group by 
		sf.product_line
	order by 
		sf.product_line

	-- Add in a row to make up the difference between customer and product line totals (add in non-CSM, non-US segments)
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = 'Other'
	,	MaterialPercentage = 0
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
		sf.product_line is null



	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
--	,	f.Sales_2016
--	,	s.Sales2016 as SalesActual_2016
--	,	s.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	s.Sales2016 as Sales_2016
--	,	f.Sales_2017
--	,	s.Sales2017 as SalesActual_2017
--	,	s.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	s.Sales2017 as Sales_2017
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
			on s.Filter = f.Filter
	order by
		f.Filter

end
else if (@Filter = 'Program Forecast') begin

	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
	,	Sales_2016
	,	SalesActual_2016 
	,	Sales_2017
	,	SalesActual_2017
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
		Filter = sf.program
	,	MaterialPercentage = 0
	,	Sales_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	SalesActual_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	Sales_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
	,	SalesActual_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
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
		sf.program is not null
	group by 
		sf.program


	-- Add in a row to make up the difference between customer and program totals (add in non-CSM, non-US segments)
	insert @forecast
	(
		Filter
	,	MaterialPercentage
	,	Sales_2016
	,	SalesActual_2016 
	,	Sales_2017
	,	SalesActual_2017
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
		Filter = 'Other'
	,	MaterialPercentage = 0
	,	Sales_2016 = sum(coalesce(sf.Cal_16_Sales, 0)) -- will not be shown in the grid
	,	SalesActual_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	Sales_2017 = sum(coalesce(sf.Cal_17_Sales, 0)) -- will not be shown in the grid
	,	SalesActual_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
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
		sf.program is null



	select 
		f.Filter
	,	f.MaterialPercentage
	,	f.Sales_2016
	,	f.SalesActual_2016
	,	f.Sales_2016 - f.Sales_2016 as ActualForecastVar_2016
	,	f.Sales_2017
	,	f.SalesActual_2017
	,	f.Sales_2017 - f.Sales_2017 as ActualForecastVar_2017
	,	f.Sales_2018
	,	f.Sales_2019
	,	f.Sales_2020
	,	f.Sales_2021
	,	f.Sales_2022
	,	f.Sales_2023
	,	f.Sales_2024
	,	f.Sales_2025
	,	f.Sales_2017 - f.Sales_2016 as Change_2017
	,	f.Sales_2018 - f.Sales_2017 as Change_2018
	,	f.Sales_2019 - f.Sales_2018 as Change_2019
	,	f.Sales_2020 - f.Sales_2019 as Change_2020
	,	f.Sales_2021 - f.Sales_2020 as Change_2021
	,	f.Sales_2022 - f.Sales_2021 as Change_2022
	,	f.Sales_2023 - f.Sales_2022 as Change_2023
	,	f.Sales_2024 - f.Sales_2023 as Change_2024
	,	f.Sales_2025 - f.Sales_2024 as Change_2025
	from 
		@forecast f
	order by
		f.Filter



	/*
	-- Actuals

	-- Get allocation percentages based on sales per month by program
	declare @salesAllocation table
	(
		BasePart varchar(50)
--	,	Mnemonic int
	,	Program varchar(30)
	,	Sales2016Alloc decimal(10,6)
	,	Sales2017Alloc decimal(10,6)
	)
	insert @salesAllocation
	(
		BasePart
--	,	Mnemonic
	,	Program
	,	Sales2016Alloc
	,	Sales2017Alloc
	)
	select
		bpm.base_part
--	,	bpm.mnemonic
	,	bpm.program
--	,	bpm.badge + ' ' + nacsm.nameplate as vehicle
--	,	bp.Sales2016
	,	Sales2016Alloc = (bpm.Jan_16_Sales + bpm.Feb_16_Sales + bpm.Mar_16_Sales + bpm.Apr_16_Sales + bpm.May_16_Sales +
								bpm.Jun_16_Sales + bpm.Jul_16_Sales + bpm.Aug_16_Sales + bpm.Sep_16_Sales + bpm.Oct_16_Sales + 
								bpm.Nov_16_Sales + bpm.Dec_16_Sales) / nullif(a.Sales2016, 0)
--	,	bp.Sales2017
	,	Sales2017Alloc = (bpm.Jan_17_Sales + bpm.Feb_17_Sales + bpm.Mar_17_Sales + bpm.Apr_17_Sales + bpm.May_17_Sales +
								bpm.Jun_17_Sales + bpm.Jul_17_Sales + bpm.Aug_17_Sales + bpm.Sep_17_Sales + bpm.Oct_17_Sales + 
								bpm.Nov_17_Sales + bpm.Dec_17_Sales) / nullif(a.Sales2017, 0)
	from
		eeiuser.acctg_csm_vw_select_sales_forecast bpm
		join eeiuser.acctg_csm_NACSM nacsm
			on nacsm.MNEMONIC = bpm.mnemonic
			and nacsm.RELEASE_ID = (select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
		cross apply
			(	select
					bp.program
				,	Sales2016 = sum(bp.Jan_16_Sales + bp.Feb_16_Sales + bp.Mar_16_Sales + bp.Apr_16_Sales + bp.May_16_Sales +
								bp.Jun_16_Sales + bp.Jul_16_Sales + bp.Aug_16_Sales + bp.Sep_16_Sales + bp.Oct_16_Sales + 
								bp.Nov_16_Sales + bp.Dec_16_Sales)
				,	Sales2017 = sum(bp.Jan_17_Sales + bp.Feb_17_Sales + bp.Mar_17_Sales + bp.Apr_17_Sales + bp.May_17_Sales +
								bp.Jun_17_Sales + bp.Jul_17_Sales + bp.Aug_17_Sales + bp.Sep_17_Sales + bp.Oct_17_Sales + 
								bp.Nov_17_Sales + bp.Dec_17_Sales)
				from
					eeiuser.acctg_csm_vw_select_sales_forecast bp
				where
					bp.program = bpm.program
				group by
					bp.program		
			) a
	--where
	--	bpm.program = 'KL'



	-- Combine sales percentages where base part is the same for the same program
	declare @salesAllocationGrouped table
	(
		BasePart varchar(50)
	,	Program varchar(30)
	,	Sales2016Alloc decimal(10,6)
	,	Sales2017Alloc decimal(10,6)
	,	Processed int
	)
	insert @salesAllocationGrouped
	(
		BasePart
	,	Program
	,	Sales2016Alloc
	,	Sales2017Alloc
	,	Processed
	)
	select
		BasePart
	,	Program
	,	sum(Sales2016Alloc)
	,	sum(Sales2017Alloc)
	,	0
	from
		@salesAllocation sa
	group by
		BasePart
	,	Program

/*
	select * from @salesAllocationGrouped
	where
	BasePart in
	(
'ADC0072'
,'ALC0536'
,'VNA0297'
,'VNA0300'
,'VNA0301'
,'YAZ0017'
)
*/



	---- Group actuals by base part, program
	declare @shippedPartsPrograms table
	(
		Filter varchar(50)
	,	Program varchar(30) null
	,	Sales2016 decimal(20, 6) null
	,	Sales2017 decimal(20, 6) null
	)
	insert @shippedPartsPrograms
	(
		Filter
	,	Program
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = sbp.BasePart
	,	Program = sag.Program 
	,	Sales2016 = sum(sbp.Year2016 * sag.Sales2016Alloc)
	,	Sales2017 = sum(sbp.Year2017 * sag.Sales2017Alloc)
	from
		@shippedBasePart sbp
		join @salesAllocationGrouped sag
			on sag.BasePart = sbp.BasePart
	group by
		sbp.BasePart
	,	sag.Program


/*
	select * from @shipped
	where Filter in 
(
'ADC0072'
,'ALC0536'
,'VNA0297'
,'VNA0300'
,'VNA0301'
,'YAZ0017'
)
*/


	-- Total the base part actuals by grouping by program only
	declare @shippedPrograms table
	(
		Program varchar(30)
	,	Sales2016 decimal(20, 6)
	,	Sales2017 decimal(20, 6)
	)
	insert @shippedPrograms
	(
		Program
	,	Sales2016
	,	Sales2017
	)
	select
		sag.Program
	,	coalesce(sum(spp.Sales2016), 0)
	,	coalesce(sum(spp.Sales2017), 0)
	from
		@salesAllocationGrouped sag
		join @shippedPartsPrograms spp
			on spp.Filter = sag.BasePart
			and spp.Program = sag.Program
	group by
		sag.Program

--select * from @shippedPrograms order by Program
		



	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.program
	,	MaterialPercentage = 0
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
	--where
	--	program = 'KL'
	group by 
		sf.program


	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
	,	f.Sales_2016
	,	sp.Sales2016 as SalesActual_2016
	,	sp.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	f.Sales_2017
	,	sp.Sales2017 as SalesActual_2017
	,	sp.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	f.Sales_2018
	,	f.Sales_2019
	,	f.Sales_2020
	,	f.Sales_2021
	,	f.Sales_2022
	,	f.Sales_2023
	,	f.Sales_2024
	,	f.Sales_2025
	,	sp.Sales2017 - sp.Sales2016 as Change_2017
	,	f.Sales_2018 - sp.Sales2017 as Change_2018
	,	f.Sales_2019 - f.Sales_2018 as Change_2019
	,	f.Sales_2020 - f.Sales_2019 as Change_2020
	,	f.Sales_2021 - f.Sales_2020 as Change_2021
	,	f.Sales_2022 - f.Sales_2021 as Change_2022
	,	f.Sales_2023 - f.Sales_2022 as Change_2023
	,	f.Sales_2024 - f.Sales_2023 as Change_2024
	,	f.Sales_2025 - f.Sales_2024 as Change_2025
	from 
		@forecast f
		join @shippedPrograms sp
			on sp.Program = f.Filter
	order by
		f.Filter
	*/

end
else if (@Filter = 'Vehicle Forecast') begin

	
	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
	,	Sales_2016
	,	SalesActual_2016 
	,	Sales_2017
	,	SalesActual_2017
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
		Filter = sf.vehicle
	,	MaterialPercentage = 0
	,	Sales_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	SalesActual_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	Sales_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
	,	SalesActual_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
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
		sf.vehicle is not null
	group by 
		sf.vehicle


	-- Add in a row to make up the difference between customer and vehicle totals (add in non-CSM, non-US segments)
	insert @forecast
	(
		Filter
	,	MaterialPercentage
	,	Sales_2016
	,	SalesActual_2016 
	,	Sales_2017
	,	SalesActual_2017
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
		Filter = 'Other'
	,	MaterialPercentage = 0
	,	Sales_2016 = sum(coalesce(sf.Cal_16_Sales, 0)) -- will not be shown in the grid
	,	SalesActual_2016 = sum(coalesce(sf.Cal_16_Sales, 0))
	,	Sales_2017 = sum(coalesce(sf.Cal_17_Sales, 0)) -- will not be shown in the grid
	,	SalesActual_2017 = sum(coalesce(sf.Cal_17_Sales, 0))
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
		sf.vehicle is null



	select 
		f.Filter
	,	f.MaterialPercentage
	,	f.Sales_2016
	,	f.SalesActual_2016
	,	f.Sales_2016 - f.Sales_2016 as ActualForecastVar_2016
	,	f.Sales_2017
	,	f.SalesActual_2017
	,	f.Sales_2017 - f.Sales_2017 as ActualForecastVar_2017
	,	f.Sales_2018
	,	f.Sales_2019
	,	f.Sales_2020
	,	f.Sales_2021
	,	f.Sales_2022
	,	f.Sales_2023
	,	f.Sales_2024
	,	f.Sales_2025
	,	f.Sales_2017 - f.Sales_2016 as Change_2017
	,	f.Sales_2018 - f.Sales_2017 as Change_2018
	,	f.Sales_2019 - f.Sales_2018 as Change_2019
	,	f.Sales_2020 - f.Sales_2019 as Change_2020
	,	f.Sales_2021 - f.Sales_2020 as Change_2021
	,	f.Sales_2022 - f.Sales_2021 as Change_2022
	,	f.Sales_2023 - f.Sales_2022 as Change_2023
	,	f.Sales_2024 - f.Sales_2023 as Change_2024
	,	f.Sales_2025 - f.Sales_2024 as Change_2025
	from 
		@forecast f
	order by
		f.Filter



	/*
	-- Actuals

	-- Get allocation percentages based on sales per month by program
	declare @salesAllocationVehicle table
	(
		BasePart varchar(50)
--	,	Mnemonic int
	,	Vehicle varchar(50)
	,	Sales2016Alloc decimal(10,6)
	,	Sales2017Alloc decimal(10,6)
	)
	insert @salesAllocationVehicle
	(
		BasePart
--	,	Mnemonic
	,	Vehicle
	,	Sales2016Alloc
	,	Sales2017Alloc
	)
	select
		bpm.base_part
--	,	bpm.mnemonic
	,	bpm.vehicle
--	,	bpm.badge + ' ' + nacsm.nameplate as vehicle
--	,	bp.Sales2016
	,	Sales2016Alloc = (bpm.Jan_16_Sales + bpm.Feb_16_Sales + bpm.Mar_16_Sales + bpm.Apr_16_Sales + bpm.May_16_Sales +
								bpm.Jun_16_Sales + bpm.Jul_16_Sales + bpm.Aug_16_Sales + bpm.Sep_16_Sales + bpm.Oct_16_Sales + 
								bpm.Nov_16_Sales + bpm.Dec_16_Sales) / nullif(a.Sales2016, 0)
--	,	bp.Sales2017
	,	Sales2017Alloc = (bpm.Jan_17_Sales + bpm.Feb_17_Sales + bpm.Mar_17_Sales + bpm.Apr_17_Sales + bpm.May_17_Sales +
								bpm.Jun_17_Sales + bpm.Jul_17_Sales + bpm.Aug_17_Sales + bpm.Sep_17_Sales + bpm.Oct_17_Sales + 
								bpm.Nov_17_Sales + bpm.Dec_17_Sales) / nullif(a.Sales2017, 0)
	from
		eeiuser.acctg_csm_vw_select_sales_forecast bpm
		join eeiuser.acctg_csm_NACSM nacsm
			on nacsm.MNEMONIC = bpm.mnemonic
			and nacsm.RELEASE_ID = (select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 
		cross apply
			(	select
					bp.vehicle
				,	Sales2016 = sum(bp.Jan_16_Sales + bp.Feb_16_Sales + bp.Mar_16_Sales + bp.Apr_16_Sales + bp.May_16_Sales +
								bp.Jun_16_Sales + bp.Jul_16_Sales + bp.Aug_16_Sales + bp.Sep_16_Sales + bp.Oct_16_Sales + 
								bp.Nov_16_Sales + bp.Dec_16_Sales)
				,	Sales2017 = sum(bp.Jan_17_Sales + bp.Feb_17_Sales + bp.Mar_17_Sales + bp.Apr_17_Sales + bp.May_17_Sales +
								bp.Jun_17_Sales + bp.Jul_17_Sales + bp.Aug_17_Sales + bp.Sep_17_Sales + bp.Oct_17_Sales + 
								bp.Nov_17_Sales + bp.Dec_17_Sales)
				from
					eeiuser.acctg_csm_vw_select_sales_forecast bp
				where
					bp.vehicle = bpm.vehicle
				group by
					bp.vehicle		
			) a




	-- Combine sales percentages where base part is the same for the same vehicle
	declare @salesAllocationVehicleGrouped table
	(
		BasePart varchar(50)
	,	Vehicle varchar(50)
	,	Sales2016Alloc decimal(10,6)
	,	Sales2017Alloc decimal(10,6)
	,	Processed int
	)
	insert @salesAllocationVehicleGrouped
	(
		BasePart
	,	Vehicle
	,	Sales2016Alloc
	,	Sales2017Alloc
	,	Processed
	)
	select
		BasePart
	,	Vehicle
	,	sum(Sales2016Alloc)
	,	sum(Sales2017Alloc)
	,	0
	from
		@salesAllocationVehicle sa
	group by
		BasePart
	,	Vehicle



	---- Group actuals by base part, vehicle
	declare @shippedPartsVehicles table
	(
		Filter varchar(50)
	,	Vehicle varchar(30) null
	,	Sales2016 decimal(20, 6) null
	,	Sales2017 decimal(20, 6) null
	)
	insert @shippedPartsVehicles
	(
		Filter
	,	Vehicle
	,	Sales2016
	,	Sales2017
	)
	select
		Filter = sbp.BasePart
	,	Vehicle = sag.Vehicle 
	,	Sales2016 = sum(sbp.Year2016 * sag.Sales2016Alloc)
	,	Sales2017 = sum(sbp.Year2017 * sag.Sales2017Alloc)
	from
		@shippedBasePart sbp
		join @salesAllocationVehicleGrouped sag
			on sag.BasePart = sbp.BasePart
	group by
		sbp.BasePart
	,	sag.Vehicle





	-- Total the base part actuals by grouping by vehicle only
	declare @shippedVehicles table
	(
		Vehicle varchar(50)
	,	Sales2016 decimal(20, 6)
	,	Sales2017 decimal(20, 6)
	)
	insert @shippedVehicles
	(
		Vehicle
	,	Sales2016
	,	Sales2017
	)
	select
		sag.Vehicle
	,	coalesce(sum(spv.Sales2016), 0)
	,	coalesce(sum(spv.Sales2017), 0)
	from
		@salesAllocationVehicleGrouped sag
		join @shippedPartsVehicles spv
			on spv.Filter = sag.BasePart
			and spv.Vehicle = sag.Vehicle
	group by
		sag.Vehicle





	-- Get forecast
	insert @forecast
	(
		Filter
	,	MaterialPercentage
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
		Filter = sf.vehicle
	,	MaterialPercentage = 0
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
	group by 
		sf.vehicle


	-- Combine actuals and forecast, and return results
	select 
		f.Filter
	,	f.MaterialPercentage
	,	f.Sales_2016
	,	sv.Sales2016 as SalesActual_2016
	,	sv.Sales2016 - f.Sales_2016 as ActualForecastVar_2016
	,	f.Sales_2017
	,	sv.Sales2017 as SalesActual_2017
	,	sv.Sales2017 - f.Sales_2017 as ActualForecastVar_2017
	,	f.Sales_2018
	,	f.Sales_2019
	,	f.Sales_2020
	,	f.Sales_2021
	,	f.Sales_2022
	,	f.Sales_2023
	,	f.Sales_2024
	,	f.Sales_2025
	,	sv.Sales2017 - sv.Sales2016 as Change_2017
	,	f.Sales_2018 - sv.Sales2017 as Change_2018
	,	f.Sales_2019 - f.Sales_2018 as Change_2019
	,	f.Sales_2020 - f.Sales_2019 as Change_2020
	,	f.Sales_2021 - f.Sales_2020 as Change_2021
	,	f.Sales_2022 - f.Sales_2021 as Change_2022
	,	f.Sales_2023 - f.Sales_2022 as Change_2023
	,	f.Sales_2024 - f.Sales_2023 as Change_2024
	,	f.Sales_2025 - f.Sales_2024 as Change_2025
	from 
		@forecast f
		join @shippedVehicles sv
			on sv.Vehicle = f.Filter
	order by
		f.Filter
	*/

end






/*
	else begin -- specific customer

		insert @forecastActualCustomer
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
			EmpireApplication = sf.empire_application
		,	EmpireMarketSubsegment = sf.empire_market_subsegment
		,	BasePart = sf.base_part
		,	Program = sf.program
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
			sf.customer = @FilterValue
		group by 
			sf.base_part
		,	sf.empire_market_subsegment
		,	sf.empire_application
		,	sf.program
		order by
			sf.program
		,	sf.base_part
		,	sf.empire_market_subsegment
		,	sf.empire_application



		-- Filter / sum actual sales by customer
		insert @actualCustomer
		(
			Customer
		,	Sales2016
		,	Sales2017
		)
		select
			sa.Customer
		,	sum(sa.Sales2016)
		,	sum(sa.Sales2017)
		from
			@shippedAttributes sa
		group by
			sa.Customer

		update
			fac
		set
			fac.SalesActual_2016 = ac.Sales2016
		,	fac.SalesActual_2017 = ac.Sales2017
		from
			@forecastActualCustomer fac
			join @actualCustomer ac
				on ac.Customer = fac.Customer

	end

	-- Return customer results
	select 
		Customer
	,	MaterialPercentage
	,	Sales_2016
	,	SalesActual_2016
	,	(SalesActual_2016 - Sales_2016) as ActualForecastVar_2016
	,	Sales_2017
	,	SalesActual_2017
	,	(SalesActual_2017 - Sales_2017) as ActualForecastVar_2017
	,	Sales_2018
	,	Sales_2019
	,	Sales_2020
	,	Sales_2021
	,	Sales_2022
	,	Sales_2023
	,	Sales_2024
	,	Sales_2025
	,	(fac.Sales_2018 - fac.Sales_2017) as Change_2018
	,	(fac.Sales_2019 - fac.Sales_2018) as Change_2019
	,	(fac.Sales_2020 - fac.Sales_2019) as Change_2020
	,	(fac.Sales_2021 - fac.Sales_2020) as Change_2021
	,	(fac.Sales_2022 - fac.Sales_2021) as Change_2022
	,	(fac.Sales_2023 - fac.Sales_2022) as Change_2023
	,	(fac.Sales_2024 - fac.Sales_2023) as Change_2024
	,	(fac.Sales_2025 - fac.Sales_2024) as Change_2025	
	from 
		@forecastActualCustomer fac

end
else if (@Filter = 'Parent Customer') begin

	if (@FilterValue is null) begin

		declare @forecastDataParentCustomer table
		(	
			ParentCustomer varchar(50)
		,	MC_Dec_18 decimal (38,6)
		,	SP_Dec_18 decimal (38,6)
		,	Cal_16_Sales decimal (38,6)
		,	Cal_17_Sales decimal (38,6)
		,	Cal_18_Sales decimal (38,6)
		,	Cal_19_Sales decimal (38,6)
		,	Cal_20_Sales decimal (38,6)
		,	Cal_21_Sales decimal (38,6)
		,	Cal_22_Sales decimal (38,6)
		,	Cal_23_Sales decimal (38,6)
		,	Cal_24_Sales decimal (38,6)
		,	Cal_25_Sales decimal (38,6)
		)

		insert
			@forecastDataParentCustomer
		select 
			sf.parent_customer
		,	coalesce(sf.mc_Dec_18, 0)
		,	coalesce(sf.sp_Dec_18, 0)
		,	coalesce(sf.Cal_16_Sales, 0)
		,	coalesce(sf.Cal_17_Sales, 0)
		,	coalesce(sf.Cal_18_Sales, 0)
		,	coalesce(sf.Cal_19_Sales, 0)
		,	coalesce(sf.Cal_20_Sales, 0)
		,	coalesce(sf.Cal_21_Sales, 0)
		,	coalesce(sf.Cal_22_Sales, 0)
		,	coalesce(sf.Cal_23_Sales, 0)
		,	coalesce(sf.Cal_24_Sales, 0)
		,	coalesce(sf.Cal_25_Sales, 0)
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		;

		with cte_MP (ParentCustomer, MaterialPercentage)
		as
		(
			select
				fdpc.ParentCustomer as Customer
			,	convert(varchar, convert(decimal(10,2), (avg(fdpc.MC_Dec_18) / avg(fdpc.SP_Dec_18) * 100))) as MaterialPercentage
			from
				@forecastDataParentCustomer fdpc
			where
				fdpc.mc_Dec_18 > 0
				and fdpc.sp_Dec_18 > 0
			group by 
				fdpc.ParentCustomer
		)
		select 
			fdpc.ParentCustomer as Filter
		,	cte.MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			@forecastDataParentCustomer fdpc
			join cte_MP cte
				on cte.ParentCustomer = fdpc.ParentCustomer
		group by 
			fdpc.ParentCustomer
		,	cte.MaterialPercentage	
		order by
			fdpc.ParentCustomer

	end
	else begin

		select 
			parent_customer as Filter
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			parent_customer = @FilterValue
		group by 
			parent_customer

	end

end
else if (@Filter = 'Salesperson') begin

	if (@FilterValue is null) begin
	
		select 
			salesperson as Filter
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			salesperson not in ('Jeff Michaels', 'Jeff Micheals')
		group by 
			salesperson

		union all 

		select 
			'Jeff Michaels' as Filter
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			salesperson in ('Jeff Michaels', 'Jeff Micheals')
		order by
			salesperson
		
	end
	else begin

		if (@FilterValue = 'Jeff Michaels') begin

			select 
				'Jeff Michaels' as Filter
			,	sum(Cal_16_Sales) as Sales_2016
			,	sum(Cal_17_Sales) as Sales_2017
			,	sum(Cal_18_Sales) as Sales_2018
			,	sum(Cal_19_Sales) as Sales_2019
			,	sum(Cal_20_Sales) as Sales_2020
			,	sum(Cal_21_Sales) as Sales_2021
			,	sum(Cal_22_Sales) as Sales_2022
			,	sum(Cal_23_Sales) as Sales_2023
			,	sum(Cal_24_Sales) as Sales_2024
			,	sum(Cal_25_Sales) as Sales_2025
			,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
			,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
			,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
			,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
			,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
			,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
			,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
			,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
			,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where
				salesperson in ('Jeff Michaels', 'Jeff Micheals')

		end
		else begin

			select 
				salesperson as Filter
			,	sum(Cal_16_Sales) as Sales_2016
			,	sum(Cal_17_Sales) as Sales_2017
			,	sum(Cal_18_Sales) as Sales_2018
			,	sum(Cal_19_Sales) as Sales_2019
			,	sum(Cal_20_Sales) as Sales_2020
			,	sum(Cal_21_Sales) as Sales_2021
			,	sum(Cal_22_Sales) as Sales_2022
			,	sum(Cal_23_Sales) as Sales_2023
			,	sum(Cal_24_Sales) as Sales_2024
			,	sum(Cal_25_Sales) as Sales_2025
			,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
			,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
			,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
			,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
			,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
			,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
			,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
			,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
			,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where
				salesperson = @FilterValue
			group by 
				salesperson

		end

	end

end
else if (@Filter = 'Segment') begin

	if (@FilterValue is null) begin

		select 
			empire_market_segment as Filter
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			empire_market_segment is not null
		group by 
			empire_market_segment
		order by
			empire_market_segment

	end
	else begin

		select 
			empire_market_segment as Filter
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			empire_market_segment = @FilterValue
		group by 
			empire_market_segment

	end

end
else if (@Filter = 'Vehicle') begin

	if (@FilterValue is null) begin

		-- Get all vehicle totals, plus a row to make up the difference between customer and vehicle totals (add in non-CSM, non-US vehicles) 
		select 
			vehicle as Filter 
		,	'' as MaterialPercentage
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle is not null
		group by 
			vehicle
		
		union all

		select
			'Other' as Filter
		,	'' as MaterialPercentage
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle is null

		order by
			vehicle

	end
	else begin

		select 
			vehicle as Filter
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle = @FilterValue
		group by 
			vehicle

	end

end
else if (@Filter = 'Program') begin

	if (@FilterValue is null) begin

		select 
			program as Filter 
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program is not null
		group by 
			program

		union all

		select 
			'Other' as Filter 
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program is null

		order by
			program

	end
	else begin

		select 
			program as Filter
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program = @FilterValue
		group by 
			program

	end

end
else if (@Filter = 'Product Line') begin

	if (@FilterValue is null) begin

		select 
			product_line as Filter 
		,	'' as MaterialPercentage	
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			product_line is not null
		group by 
			product_line
		order by
			product_line

	end
	else begin

		select 
			product_line as Filter
		,	sum(Cal_16_Sales) as Sales_2016
		,	sum(Cal_17_Sales) as Sales_2017
		,	sum(Cal_18_Sales) as Sales_2018
		,	sum(Cal_19_Sales) as Sales_2019
		,	sum(Cal_20_Sales) as Sales_2020
		,	sum(Cal_21_Sales) as Sales_2021
		,	sum(Cal_22_Sales) as Sales_2022
		,	sum(Cal_23_Sales) as Sales_2023
		,	sum(Cal_24_Sales) as Sales_2024
		,	sum(Cal_25_Sales) as Sales_2025
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			product_line = @FilterValue
		group by 
			product_line

	end

end
*/
GO
