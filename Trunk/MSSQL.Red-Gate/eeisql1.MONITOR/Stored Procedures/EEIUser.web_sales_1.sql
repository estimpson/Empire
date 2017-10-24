SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[web_sales_1] (@FY1 char(4), @FP1 char(2),@FN1 varchar(50), @FY2 char(4), @FP2 char(2), @FN2 varchar(50))
as
declare 
@SD datetime
,@ED datetime

Select 
@SD = @FY1+'-'+@FP1+'-'+'01'
,@ED = (case when @FP1 = 12 then str(@FY1+1)+'-'+'01'+'-'+'01' else @FY1+'-'+str(@FP1+1)+'-'+'01' end)

--delete from sales_2

----populate with distinct parts from actual and forecast
--insert into sales_2 (base_part, forecast_year, forecast_period)
--select base_part, forecast_year, forecast_period from sales_1 where forecast_year=@FY and forecast_period=@FP and forecast_name=@FN

--insert into sales_2 (base_part, forecast_year, forecast_period)
--select distinct(basepart), @FY, @FP from vw_eei_sales_history where date_shipped > @SD and date_shipped < @ED
--and basepart not in (select distinct(base_part) from sales_2)

--update sales_2
--set customer = left(base_part,3),
--forecast_name = @FN,
--forecast_name_2 = 'ACTUAL'

----populate forecast columns
--update sales_2
--set forecast_time_stamp = time_stamp,
--sales_2.forecast_units = ISNULL(sales_1.forecast_units,0),
--sales_2.forecast_sales = ISNULL(sales_1.forecast_sales,0)
--from sales_1, sales_2
--where sales_1.base_part = sales_2.base_part
--and sales_1.forecast_year = @FY
--and sales_1.forecast_period = @FP
--and sales_1.forecast_name = @FN

----populate actual columns
--update sales_2 
--set
--forecast_time_stamp_2=getdate(),
--actual_units = ISNULL((select sum(qty_shipped) from vw_eei_sales_history where sales_2.base_part = vw_eei_sales_history.basepart and vw_eei_sales_history.date_shipped >= @SD and date_shipped < @ED),0),
--actual_sales = ISNULL((select sum(extended) from vw_eei_sales_history where sales_2.base_part = vw_eei_sales_history.basepart and vw_eei_sales_history.date_shipped >= @SD and date_shipped < @ED),0)
--from sales_2


----compute variances
--update sales_2
--set variance_units = ISNULL(actual_units,0) - ISNULL(forecast_units,0),
--variance_sales = ISNULL(actual_sales,0) - ISNULL(forecast_sales,0),
--variance_percentage = case forecast_sales when NULL then 0 else case forecast_sales when 0 then 0 else ((actual_sales - forecast_sales)/forecast_sales)*100 end end


----return result set
--select * from sales_2




--NEW VERSION

delete from eeiuser.sales_2

--populate with distinct parts from actual and forecast
insert into sales_2 (	base_part, 
						forecast_name,
						forecast_year, 
						forecast_period, 
						forecast_units, 
						forecast_sales,
						forecast_name_2,
						forecast_year_2,
						forecast_period_2,
						actual_units,
						actual_sales)
select		isnull(a.base_part, b.base_part) as base_part,
			@FN1,
			a.forecast_year, 
			a.forecast_period, 
			a.forecast_units, 
			a.forecast_sales,
			@FN2,
			b.forecast_year,
			b.forecast_period,
			b.forecast_units, 
			b.forecast_sales
FROM
	(select base_part, forecast_year, forecast_period, forecast_units, forecast_sales from eeiuser.sales_1 where forecast_year=@FY1 and forecast_period=@FP1 and forecast_name=@FN1)a
		full outer join
	(select base_part, forecast_year, forecast_period, forecast_units, forecast_sales from eeiuser.sales_1 where forecast_year=@FY2 and forecast_period=@FP2 and forecast_name=@FN2)b
		on a.base_part = b.base_part 

update sales_2
set customer = left(base_part,3)

--compute variances
update sales_2
set variance_units = ISNULL(actual_units,0) - ISNULL(forecast_units,0),
variance_sales = ISNULL(actual_sales,0) - ISNULL(forecast_sales,0),
variance_percentage = case forecast_sales when NULL then 0 else case forecast_sales when 0 then 0 else ((actual_sales - forecast_sales)/forecast_sales)*100 end end


--return result set
select * from eeiuser.sales_2



GO
