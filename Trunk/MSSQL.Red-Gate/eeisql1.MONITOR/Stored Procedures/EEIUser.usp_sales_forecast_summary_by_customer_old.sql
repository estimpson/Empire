SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_sales_forecast_summary_by_customer_old]
as
set nocount on
set ansi_warnings on


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
GO
