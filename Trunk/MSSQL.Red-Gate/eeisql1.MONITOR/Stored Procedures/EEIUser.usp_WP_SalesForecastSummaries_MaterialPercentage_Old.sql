SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_SalesForecastSummaries_MaterialPercentage_Old]
	@Filter varchar(50)
,	@FilterValue varchar(250) = null
as
set nocount on
set ansi_warnings on



--- <Body>
if (@Filter = 'Customer') begin

	if (@FilterValue is null) begin

		declare @forecastDataCustomer table
		(	
			Customer varchar(50)
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
			@forecastDataCustomer
		select 
			sf.customer
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

		with cte_MP (Customer, MaterialPercentage)
		as
		(
			select
				fdc.Customer as Customer
			,	convert(varchar, convert(decimal(10,2), (avg(fdc.MC_Dec_18) / avg(fdc.SP_Dec_18) * 100))) as MaterialPercentage
			from
				@forecastDataCustomer fdc
			where
				fdc.MC_Dec_18 > 0
				and fdc.SP_Dec_18 > 0
			group by 
				fdc.Customer
		)
		select 
			fdc.Customer as Filter
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
			@forecastDataCustomer fdc
			join cte_MP cte
				on cte.Customer = fdc.Customer
		--where 
		--	customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')
		group by 
			fdc.Customer
		,	cte.MaterialPercentage	
		order by
			fdc.Customer
	

	end
	else begin

		select 
			customer as Filter
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
			customer = @FilterValue
		group by 
			customer

	end

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

		declare @forecast table
		(
			Filter varchar(50)
		,	MaterialPercentage varchar(20)
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
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		group by 
			salesperson

		--,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		--,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		--,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		--,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		--,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		--,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		--,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
		--,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
		--,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
		--from 
		--	eeiuser.acctg_csm_vw_select_sales_forecast sf
		----where
		----	salesperson not in ('Jeff Michaels', 'Jeff Micheals')
		--group by 
		--	salesperson

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


		select 
			Filter
		,	'' as MaterialPercentage	
		,	f.Sales_2016
		,	f.Sales_2017
		,	f.Sales_2018
		,	f.Sales_2019
		,	f.Sales_2020
		,	f.Sales_2021
		,	f.Sales_2022
		,	f.Sales_2023
		,	f.Sales_2024
		,	f.Sales_2025
		,	f.Sales_2017- f.Sales_2016 as Change_2017
		,	f.Sales_2018- f.Sales_2017 as Change_2018
		,	f.Sales_2019- f.Sales_2018 as Change_2019
		,	f.Sales_2020- f.Sales_2019 as Change_2020
		,	f.Sales_2021- f.Sales_2020 as Change_2021
		,	f.Sales_2022- f.Sales_2021 as Change_2022
		,	f.Sales_2023- f.Sales_2022 as Change_2023
		,	f.Sales_2024- f.Sales_2023 as Change_2024
		,	f.Sales_2025- f.Sales_2024 as Change_2025
		from 
			@forecast f
		order by
			f.Filter
		
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

		-- Get all market segment totals, plus a row to make up the difference between customer and market segment totals (add in non-CSM, non-US market segments) 
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
			empire_market_segment is null
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

		-- Get all program totals, plus a row to make up the difference between customer and program totals (add in non-CSM, non-US programs) 
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

		-- Get all product line totals, plus a row to make up the difference between customer and product line totals (add in non-CSM, non-US product lines) 
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
			product_line is null
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
GO
