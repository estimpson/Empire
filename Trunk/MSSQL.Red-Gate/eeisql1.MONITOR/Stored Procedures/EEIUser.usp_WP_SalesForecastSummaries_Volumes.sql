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
if (@Filter = 'Customer' or @Filter = 'Customer Actual') begin

	if (@FilterValue is null) begin

		select 
			customer as Filter
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
			,	sum(Cal_16_TotalDemand) as TotalDemand_2016
			,	sum(Cal_17_TotalDemand) as TotalDemand_2017
			,	sum(Cal_18_TotalDemand) as TotalDemand_2018
			,	sum(Cal_19_TotalDemand) as TotalDemand_2019
			,	sum(Cal_20_TotalDemand) as TotalDemand_2020
			,	sum(Cal_21_TotalDemand) as TotalDemand_2021
			,	sum(Cal_22_TotalDemand) as TotalDemand_2022
			,	sum(Cal_23_TotalDemand) as TotalDemand_2023
			,	sum(Cal_24_TotalDemand) as TotalDemand_2024
			,	sum(Cal_25_TotalDemand) as TotalDemand_2025
			,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
			,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
			,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
			,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
			,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
			,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
			,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
			,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
			,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where 
				customer = @FilterValue
			group by 
				customer

	end

end
else if (@Filter = 'Parent Customer' or @Filter = 'Parent Customer Actual') begin

	if (@FilterValue is null) begin

		select 
			parent_customer as Filter
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			parent_customer = @FilterValue
		group by 
			parent_customer

	end

end
else if (@Filter = 'Salesperson' or @Filter = 'Salesperson Actual') begin

	if (@FilterValue is null) begin
	
		select 
			salesperson as Filter
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			salesperson not in ('Jeff Michaels', 'Jeff Micheals')
		group by 
			salesperson

		union all 

		select 
			'Jeff Michaels' as Filter
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
			,	sum(Cal_16_TotalDemand) as TotalDemand_2016
			,	sum(Cal_17_TotalDemand) as TotalDemand_2017
			,	sum(Cal_18_TotalDemand) as TotalDemand_2018
			,	sum(Cal_19_TotalDemand) as TotalDemand_2019
			,	sum(Cal_20_TotalDemand) as TotalDemand_2020
			,	sum(Cal_21_TotalDemand) as TotalDemand_2021
			,	sum(Cal_22_TotalDemand) as TotalDemand_2022
			,	sum(Cal_23_TotalDemand) as TotalDemand_2023
			,	sum(Cal_24_TotalDemand) as TotalDemand_2024
			,	sum(Cal_25_TotalDemand) as TotalDemand_2025
			,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
			,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
			,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
			,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
			,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
			,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
			,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
			,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
			,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where
				salesperson in ('Jeff Michaels', 'Jeff Micheals')

		end
		else begin

			select 
				salesperson as Filter
			,	sum(Cal_16_TotalDemand) as TotalDemand_2016
			,	sum(Cal_17_TotalDemand) as TotalDemand_2017
			,	sum(Cal_18_TotalDemand) as TotalDemand_2018
			,	sum(Cal_19_TotalDemand) as TotalDemand_2019
			,	sum(Cal_20_TotalDemand) as TotalDemand_2020
			,	sum(Cal_21_TotalDemand) as TotalDemand_2021
			,	sum(Cal_22_TotalDemand) as TotalDemand_2022
			,	sum(Cal_23_TotalDemand) as TotalDemand_2023
			,	sum(Cal_24_TotalDemand) as TotalDemand_2024
			,	sum(Cal_25_TotalDemand) as TotalDemand_2025
			,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
			,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
			,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
			,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
			,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
			,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
			,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
			,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
			,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where
				salesperson = @FilterValue
			group by 
				salesperson

		end

	end

end
else if (@Filter = 'Segment' or @Filter = 'Segment Actual') begin

	if (@FilterValue is null) begin

		select 
			empire_market_segment as Filter
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			empire_market_segment = @FilterValue
		group by 
			empire_market_segment

	end

end
else if (@Filter = 'Vehicle' or @Filter = 'Vehicle Forecast') begin

	if (@FilterValue is null) begin

		select 
			vehicle as Filter 
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle is not null
		group by 
			vehicle

		union all

		select 
			'Other' as Filter 
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			vehicle = @FilterValue
		group by 
			vehicle

	end

end
else if (@Filter = 'Program' or @Filter = 'Program Forecast') begin

	if (@FilterValue is null) begin

		select 
			program as Filter 
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program is not null
		group by 
			program

		union all

		select 
			'Other' as Filter 
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			program = @FilterValue
		group by 
			program

	end

end
else if (@Filter = 'Product Line' or @Filter = 'Product Line Actual') begin

	if (@FilterValue is null) begin

		select 
			product_line as Filter 
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
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
		,	sum(Cal_16_TotalDemand) as TotalDemand_2016
		,	sum(Cal_17_TotalDemand) as TotalDemand_2017
		,	sum(Cal_18_TotalDemand) as TotalDemand_2018
		,	sum(Cal_19_TotalDemand) as TotalDemand_2019
		,	sum(Cal_20_TotalDemand) as TotalDemand_2020
		,	sum(Cal_21_TotalDemand) as TotalDemand_2021
		,	sum(Cal_22_TotalDemand) as TotalDemand_2022
		,	sum(Cal_23_TotalDemand) as TotalDemand_2023
		,	sum(Cal_24_TotalDemand) as TotalDemand_2024
		,	sum(Cal_25_TotalDemand) as TotalDemand_2025
		,	(sum(Cal_17_TotalDemand) - sum(Cal_16_TotalDemand)) as Change_2017
		,	(sum(Cal_18_TotalDemand) - sum(Cal_17_TotalDemand)) as Change_2018
		,	(sum(Cal_19_TotalDemand) - sum(Cal_18_TotalDemand)) as Change_2019
		,	(sum(Cal_20_TotalDemand) - sum(Cal_19_TotalDemand)) as Change_2020
		,	(sum(Cal_21_TotalDemand) - sum(Cal_20_TotalDemand)) as Change_2021
		,	(sum(Cal_22_TotalDemand) - sum(Cal_21_TotalDemand)) as Change_2022
		,	(sum(Cal_23_TotalDemand) - sum(Cal_22_TotalDemand)) as Change_2023
		,	(sum(Cal_24_TotalDemand) - sum(Cal_23_TotalDemand)) as Change_2024
		,	(sum(Cal_25_TotalDemand) - sum(Cal_24_TotalDemand)) as Change_2025
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where
			product_line = @FilterValue
		group by 
			product_line

	end

end
GO
