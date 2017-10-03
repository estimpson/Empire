SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Volumes]
	@Filter varchar(50)
,	@FilterValue varchar(250) = null
as
set nocount on
set ansi_warnings on



--- <Body>
if (@Filter = 'Customer') begin

	if (@FilterValue is null) begin

		select 
			customer as Filter
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		--where 
		--	customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')
		group by 
			customer
		order by
			customer
	end
	else begin

			select 
				customer as Filter
			,	sum(Total_2016_TotalDemand) as TotalDemand_2016
			,	sum(Total_2017_TotalDemand) as TotalDemand_2017
			,	sum(Total_2018_TotalDemand) as TotalDemand_2018
			,	sum(Total_2019_TotalDemand) as TotalDemand_2019
			,	sum(Cal20_TotalDemand) as TotalDemand_2020
			,	sum(Cal21_TotalDemand) as TotalDemand_2021
			,	sum(Cal22_TotalDemand) as TotalDemand_2022
			,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
			,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
			,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
			,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
			,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
			,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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

		select 
			parent_customer as Filter
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		group by 
			parent_customer
		order by
			parent_customer

	end
	else begin

		select 
			parent_customer as Filter
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			salesperson not in ('Jeff Michaels', 'Jeff Micheals')
		group by 
			salesperson

		union all 

		select 
			'Jeff Michaels' as Filter
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
			,	sum(Total_2016_TotalDemand) as TotalDemand_2016
			,	sum(Total_2017_TotalDemand) as TotalDemand_2017
			,	sum(Total_2018_TotalDemand) as TotalDemand_2018
			,	sum(Total_2019_TotalDemand) as TotalDemand_2019
			,	sum(Cal20_TotalDemand) as TotalDemand_2020
			,	sum(Cal21_TotalDemand) as TotalDemand_2021
			,	sum(Cal22_TotalDemand) as TotalDemand_2022
			,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
			,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
			,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
			,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
			,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
			,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where
				salesperson in ('Jeff Michaels', 'Jeff Micheals')

		end
		else begin

			select 
				salesperson as Filter
			,	sum(Total_2016_TotalDemand) as TotalDemand_2016
			,	sum(Total_2017_TotalDemand) as TotalDemand_2017
			,	sum(Total_2018_TotalDemand) as TotalDemand_2018
			,	sum(Total_2019_TotalDemand) as TotalDemand_2019
			,	sum(Cal20_TotalDemand) as TotalDemand_2020
			,	sum(Cal21_TotalDemand) as TotalDemand_2021
			,	sum(Cal22_TotalDemand) as TotalDemand_2022
			,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
			,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
			,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
			,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
			,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
			,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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

		select 
			vehicle as Filter 
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle is not null
		group by 
			vehicle

		union all

		select 
			'Other' as Filter 
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program is not null
		group by 
			program

		union all

		select 
			'Other' as Filter 
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		,	sum(Total_2016_TotalDemand) as TotalDemand_2016
		,	sum(Total_2017_TotalDemand) as TotalDemand_2017
		,	sum(Total_2018_TotalDemand) as TotalDemand_2018
		,	sum(Total_2019_TotalDemand) as TotalDemand_2019
		,	sum(Cal20_TotalDemand) as TotalDemand_2020
		,	sum(Cal21_TotalDemand) as TotalDemand_2021
		,	sum(Cal22_TotalDemand) as TotalDemand_2022
		,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
		,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
		,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
		,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
		,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
		,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			product_line = @FilterValue
		group by 
			product_line

	end

end
GO
