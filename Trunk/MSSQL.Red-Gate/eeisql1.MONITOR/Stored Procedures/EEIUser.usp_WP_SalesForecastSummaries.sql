SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries]
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
		group by 
			parent_customer
		order by
			parent_customer

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
			vehicle is not null
		group by 
			vehicle
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




/*
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
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
,	sum(Cal_16_Sales)
,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('STE') 
group by 
	customer 


declare
	@StkSales2016 decimal(20,6)
,	@StkSales2017 decimal(20,6)
,	@StkSales2018 decimal(20,6)
,	@StkSales2019 decimal(20,6)
,	@StkSales2020 decimal(20,6)	

select 
	@StkSales2016 = sum(Cal_16_Sales)
,	@StkSales2017 = sum(Cal_17_Sales)
,	@StkSales2018 = sum(Cal_18_Sales)
,	@StkSales2019 = sum(Cal_19_Sales)
,	@StkSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('STK') 
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
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
,	sum(Cal_16_Sales)
,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('AUT') 
group by 
	customer 


declare
	@DfnSales2016 decimal(20,6)
,	@DfnSales2017 decimal(20,6)
,	@DfnSales2018 decimal(20,6)
,	@DfnSales2019 decimal(20,6)
,	@DfnSales2020 decimal(20,6)	

select 
	@DfnSales2016 = sum(Cal_16_Sales)
,	@DfnSales2017 = sum(Cal_17_Sales)
,	@DfnSales2018 = sum(Cal_18_Sales)
,	@DfnSales2019 = sum(Cal_19_Sales)
,	@DfnSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('DFN') 
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
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
)
select 
	customer
,	sum(Cal_16_Sales)
,	sum(Cal_17_Sales)
,	sum(Cal_18_Sales)
,	sum(Cal_19_Sales)
,	sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('VNA') 
group by 
	customer 


declare
	@MerSales2016 decimal(20,6)
,	@MerSales2017 decimal(20,6)
,	@MerSales2018 decimal(20,6)
,	@MerSales2019 decimal(20,6)
,	@MerSales2020 decimal(20,6)	

select 
	@MerSales2016 = sum(Cal_16_Sales)
,	@MerSales2017 = sum(Cal_17_Sales)
,	@MerSales2018 = sum(Cal_18_Sales)
,	@MerSales2019 = sum(Cal_19_Sales)
,	@MerSales2020 = sum(Cal_20_Sales)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where 
	customer = ('MER') 
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






	
	
select 
	customer, 
	sum(Cal_16_Sales) as Sales_2016,
	sum(Cal_17_Sales) as Sales_2017,
	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017,
	sum(Cal_18_Sales) as Sales_2018,
	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018,
	sum(Cal_19_Sales) as Sales_2019,
	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019,
	sum(Cal_20_Sales) as Sales_2020,
	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
from 
	eeiuser.acctg_csm_vw_select_sales_forecast 
where customer in ('NAL','TRW','VAL','ALI','SLA','FNG','ADC','NOR','ALC','KSI','HEL','VAR','IIS','MAG')
group by customer
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
*/

--- </Body>
GO
