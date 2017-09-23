SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[web_sales_2] (@FY char(4),@FP char(2), @FN1 varchar(50), @FN2 varchar(50))
as
delete from sales_2

--populate with distinct parts from actual and forecast
insert into sales_2 (base_part, forecast_year, forecast_period)
select distinct(base_part),@FY, @FP from sales_1 where forecast_year=@FY and forecast_period >= @FP and forecast_period < @FP+2 and forecast_name=@FN1

insert into sales_2 (base_part, forecast_year, forecast_period)
select distinct(base_part), @FY, @FP from sales_1 where forecast_year=@FY and forecast_period >= @FP and forecast_period < @FP+2 and forecast_name=@FN2
and base_part not in (select distinct(base_part) from sales_2)

update sales_2
set forecast_time_stamp = (select distinct(time_stamp) from sales_1 where forecast_name = @FN1), forecast_name = @FN1

update sales_2
set forecast_time_stamp_2 = (select distinct(time_stamp) from sales_1 where forecast_name = @FN2), forecast_name_2 = @FN2

update sales_2
set customer = left(base_part,3), forecast_year_2 = forecast_year, forecast_period_2 = forecast_period+1

update sales_2
set program_manager = (select max(team) from eeiuser.teamtobasepart where sales_2.base_part = teamtobasepart.basepart)

update sales_2
set program_manager = (select description from sales_manager_code where sales_2.program_manager = sales_manager_code.code)


--populate forecast columns
update sales_2
set 
sales_2.forecast_units = ISNULL(sales_1.forecast_units,0),
sales_2.forecast_sales = ISNULL(sales_1.forecast_sales,0)
from sales_1, sales_2
where sales_1.base_part = sales_2.base_part
and sales_1.forecast_year = @FY
and sales_1.forecast_period = @FP
and sales_1.forecast_name = @FN1

--populate actual columns
update sales_2 
set 
actual_units = ISNULL(sales_1.forecast_units,0),
actual_sales = ISNULL(sales_1.forecast_sales,0)
from sales_1, sales_2
where sales_1.base_part = sales_2.base_part
and sales_1.forecast_year = @FY
and sales_1.forecast_period = @FP
and sales_1.forecast_name = @FN2

--compute variances
update sales_2
set variance_units = ISNULL(actual_units,0) - ISNULL(forecast_units,0),
variance_sales = ISNULL(actual_sales,0) - ISNULL(forecast_sales,0),
variance_percentage = case forecast_sales when NULL then 0 else case forecast_sales when 0 then 0 else ((actual_sales - forecast_sales)/forecast_sales)*100 end end

--populate forecast columns
update sales_2
set 
sales_2.forecast_units_2 = ISNULL(sales_1.forecast_units,0),
sales_2.forecast_sales_2 = ISNULL(sales_1.forecast_sales,0)
from sales_1, sales_2
where sales_1.base_part = sales_2.base_part
and sales_1.forecast_year = @FY
and sales_1.forecast_period = @FP+1
and sales_1.forecast_name = @FN1

--populate actual columns
update sales_2 
set 
actual_units_2 = ISNULL(sales_1.forecast_units,0),
actual_sales_2 = ISNULL(sales_1.forecast_sales,0)
from sales_1, sales_2
where sales_1.base_part = sales_2.base_part
and sales_1.forecast_year = @FY
and sales_1.forecast_period = @FP+1
and sales_1.forecast_name = @FN2


--compute variances
update sales_2
set variance_units_2 = ISNULL(actual_units_2,0) - ISNULL(forecast_units_2,0),
variance_sales_2 = ISNULL(actual_sales_2,0) - ISNULL(forecast_sales_2,0),
variance_percentage_2 = case forecast_sales_2 when NULL then 0 else case forecast_sales_2 when 0 then 0 else ((actual_sales_2 - forecast_sales_2)/forecast_sales_2)*100 end end





select * from sales_2
GO
