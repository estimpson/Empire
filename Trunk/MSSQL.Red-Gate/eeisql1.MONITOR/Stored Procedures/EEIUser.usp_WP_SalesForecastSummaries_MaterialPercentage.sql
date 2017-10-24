SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_MaterialPercentage]
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
			,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
			,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
			,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
			,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
			,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
			,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
			,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
			,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
			,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
			,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
			,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
			,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
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
		,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
		,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
		,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
		,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
		,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
		,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			product_line = @FilterValue
		group by 
			product_line

	end

end
GO
