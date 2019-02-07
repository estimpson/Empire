SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- select * from eeiuser.sales_1 where forecast_name like '%Actual%' and forecast_name like '%2018%' order by 2

-- select * from eeiuser.sales_1 where forecast_name = '2019/01/13 ACTUAL'

-- delete from eeiuser.sales_1 where forecast_name like '%Actual%' and forecast_name like '%2019%' 

-- exec eeiuser.acctg_sales_sp_insert_historical_sales '2019/01/31 ACTUAL', '2019-01-31 12:00:00.000', '2019-01-01','2019-01-31'


CREATE procedure [EEIUser].[acctg_sales_sp_insert_historical_sales] (@forecast_name varchar(100),@time_stamp datetime,@FromDate datetime , @throughDate datetime)
as

--declare @forecast_name varchar(100) = '2019/01/13 Actual'
--declare @time_stamp datetime = '2019-01-13 12:00:00.000'
--declare @fromdate datetime = '2019-01-01'
--declare @throughdate datetime = '2019-01-13'


declare 
@TruncatedFromDT datetime,
@TruncatedThroughDT datetime


Set @TruncatedFromDT =  FT.fn_TruncDate ('dd', @FromDate)
Set @TruncatedThroughDT =  FT.fn_TruncDate ('dd', @throughDate) +1 

insert into sales_1
select	@forecast_name,
		@time_stamp, 
		team as ProgramManager,
		left(basepart,3) as Customer,
		basepart as Base_part, 
		datepart(YEAR, date_shipped) as salesYear,		
		datepart(MONTH, date_shipped) as SalesPeriod,
		sum(qty_shipped) as Units,
		case sum(qty_shipped) when 0 then 0 else SUM(extended)/SUM(qty_shipped) end as selling_price,
		sum(extended) as Extended
from		vw_eei_sales_history
join		destination on  vw_eei_sales_history.destination = destination.destination
where	date_shipped >= @TruncatedFromDT and date_shipped < @TruncatedThroughDT
group by	team,
		left(basepart,3),
		basepart, 
		datepart(MONTH, date_shipped),
		datepart(YEAR, date_shipped)











GO
