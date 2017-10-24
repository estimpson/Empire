SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- select distinct(forecast_name), time_stamp from eeiuser.sales_1 where time_stamp >= '2015-10-01' order by time_stamp

-- delete from eeiuser.sales_1 where forecast_name = '2016/09/30 OSF' and time_stamp = '2016-09-30 18:00:00.000'

-- exec eeiuser.acctg_sales_sp_insert_official_forecast '2016/09/30 OSF', '2016-09-30 18:00:00'


CREATE procedure [EEIUser].[acctg_sales_sp_insert_official_forecast]
  @forecast_name varchar(50),
  @time_stamp datetime
as

insert into sales_1

select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','1', sum(Jan_14_TOTALdemand), case sum(Jan_14_Sales) when 0 then 0 else Sum(Jan_14_Sales)/sum(Jan_14_TOTALdemand) end, Sum(Jan_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','2', sum(Feb_14_TOTALdemand), case sum(Feb_14_Sales) when 0 then 0 else Sum(Feb_14_Sales)/sum(Feb_14_TOTALdemand) end, Sum(Feb_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','3', sum(Mar_14_TOTALdemand), case sum(Mar_14_Sales) when 0 then 0 else Sum(Mar_14_Sales)/sum(Mar_14_TOTALdemand) end, Sum(Mar_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','4', sum(Apr_14_TOTALdemand), case sum(Apr_14_Sales) when 0 then 0 else Sum(Apr_14_Sales)/sum(Apr_14_TOTALdemand) end, Sum(Apr_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','5', sum(May_14_TOTALdemand), case sum(May_14_Sales) when 0 then 0 else Sum(May_14_Sales)/sum(May_14_TOTALdemand) end, Sum(May_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','6', sum(Jun_14_TOTALdemand), case sum(Jun_14_Sales) when 0 then 0 else Sum(Jun_14_Sales)/sum(Jun_14_TOTALdemand) end, Sum(Jun_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','7', sum(Jul_14_TOTALdemand), case sum(Jul_14_Sales) when 0 then 0 else Sum(Jul_14_Sales)/sum(Jul_14_TOTALdemand) end, Sum(Jul_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','8', sum(Aug_14_TOTALdemand), case sum(Aug_14_Sales) when 0 then 0 else Sum(Aug_14_Sales)/sum(Aug_14_TOTALdemand) end, Sum(Aug_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','9', sum(Sep_14_TOTALdemand), case sum(Sep_14_Sales) when 0 then 0 else Sum(Sep_14_Sales)/sum(Sep_14_TOTALdemand) end, Sum(Sep_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','10', sum(Oct_14_TOTALdemand), case sum(Oct_14_Sales) when 0 then 0 else Sum(Oct_14_Sales)/sum(Oct_14_TOTALdemand) end, Sum(Oct_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','11', sum(Nov_14_TOTALdemand), case sum(Nov_14_Sales) when 0 then 0 else Sum(Nov_14_Sales)/sum(Nov_14_TOTALdemand) end, Sum(Nov_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2014','12', sum(Dec_14_TOTALdemand), case sum(Dec_14_Sales) when 0 then 0 else Sum(Dec_14_Sales)/sum(Dec_14_TOTALdemand) end, Sum(Dec_14_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','1', sum(Jan_15_TOTALdemand), case sum(Jan_15_Sales) when 0 then 0 else Sum(Jan_15_Sales)/sum(Jan_15_TOTALdemand) end, Sum(Jan_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','2', sum(Feb_15_TOTALdemand), case sum(Feb_15_Sales) when 0 then 0 else Sum(Feb_15_Sales)/sum(Feb_15_TOTALdemand) end, Sum(Feb_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','3', sum(Mar_15_TOTALdemand), case sum(Mar_15_Sales) when 0 then 0 else Sum(Mar_15_Sales)/sum(Mar_15_TOTALdemand) end, Sum(Mar_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','4', sum(Apr_15_TOTALdemand), case sum(Apr_15_Sales) when 0 then 0 else Sum(Apr_15_Sales)/sum(Apr_15_TOTALdemand) end, Sum(Apr_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','5', sum(May_15_TOTALdemand), case sum(May_15_Sales) when 0 then 0 else Sum(May_15_Sales)/sum(May_15_TOTALdemand) end, Sum(May_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','6', sum(Jun_15_TOTALdemand), case sum(Jun_15_Sales) when 0 then 0 else Sum(Jun_15_Sales)/sum(Jun_15_TOTALdemand) end, Sum(Jun_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','7', sum(Jul_15_TOTALdemand), case sum(Jul_15_Sales) when 0 then 0 else Sum(Jul_15_Sales)/sum(Jul_15_TOTALdemand) end, Sum(Jul_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','8', sum(Aug_15_TOTALdemand), case sum(Aug_15_Sales) when 0 then 0 else Sum(Aug_15_Sales)/sum(Aug_15_TOTALdemand) end, Sum(Aug_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','9', sum(Sep_15_TOTALdemand), case sum(Sep_15_Sales) when 0 then 0 else Sum(Sep_15_Sales)/sum(Sep_15_TOTALdemand) end, Sum(Sep_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','10', sum(Oct_15_TOTALdemand), case sum(Oct_15_Sales) when 0 then 0 else Sum(Oct_15_Sales)/sum(Oct_15_TOTALdemand) end, Sum(Oct_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','11', sum(Nov_15_TOTALdemand), case sum(Nov_15_Sales) when 0 then 0 else Sum(Nov_15_Sales)/sum(Nov_15_TOTALdemand) end, Sum(Nov_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2015','12', sum(Dec_15_TOTALdemand), case sum(Dec_15_Sales) when 0 then 0 else Sum(Dec_15_Sales)/sum(Dec_15_TOTALdemand) end, Sum(Dec_15_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','1', sum(Jan_16_TOTALdemand), case sum(Jan_16_Sales) when 0 then 0 else Sum(Jan_16_Sales)/sum(Jan_16_TOTALdemand) end, Sum(Jan_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','2', sum(Feb_16_TOTALdemand), case sum(Feb_16_Sales) when 0 then 0 else Sum(Feb_16_Sales)/sum(Feb_16_TOTALdemand) end, Sum(Feb_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','3', sum(Mar_16_TOTALdemand), case sum(Mar_16_Sales) when 0 then 0 else Sum(Mar_16_Sales)/sum(Mar_16_TOTALdemand) end, Sum(Mar_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','4', sum(Apr_16_TOTALdemand), case sum(Apr_16_Sales) when 0 then 0 else Sum(Apr_16_Sales)/sum(Apr_16_TOTALdemand) end, Sum(Apr_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','5', sum(May_16_TOTALdemand), case sum(May_16_Sales) when 0 then 0 else Sum(May_16_Sales)/sum(May_16_TOTALdemand) end, Sum(May_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','6', sum(Jun_16_TOTALdemand), case sum(Jun_16_Sales) when 0 then 0 else Sum(Jun_16_Sales)/sum(Jun_16_TOTALdemand) end, Sum(Jun_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','7', sum(Jul_16_TOTALdemand), case sum(Jul_16_Sales) when 0 then 0 else Sum(Jul_16_Sales)/sum(Jul_16_TOTALdemand) end, Sum(Jul_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','8', sum(Aug_16_TOTALdemand), case sum(Aug_16_Sales) when 0 then 0 else Sum(Aug_16_Sales)/sum(Aug_16_TOTALdemand) end, Sum(Aug_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','9', sum(Sep_16_TOTALdemand), case sum(Sep_16_Sales) when 0 then 0 else Sum(Sep_16_Sales)/sum(Sep_16_TOTALdemand) end, Sum(Sep_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','10', sum(Oct_16_TOTALdemand), case sum(Oct_16_Sales) when 0 then 0 else Sum(Oct_16_Sales)/sum(Oct_16_TOTALdemand) end, Sum(Oct_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','11', sum(Nov_16_TOTALdemand), case sum(Nov_16_Sales) when 0 then 0 else Sum(Nov_16_Sales)/sum(Nov_16_TOTALdemand) end, Sum(Nov_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2016','12', sum(Dec_16_TOTALdemand), case sum(Dec_16_Sales) when 0 then 0 else Sum(Dec_16_Sales)/sum(Dec_16_TOTALdemand) end, Sum(Dec_16_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','1', sum(Jan_17_TOTALdemand), case sum(Jan_17_Sales) when 0 then 0 else Sum(Jan_17_Sales)/sum(Jan_17_TOTALdemand) end, Sum(Jan_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','2', sum(Feb_17_TOTALdemand), case sum(Feb_17_Sales) when 0 then 0 else Sum(Feb_17_Sales)/sum(Feb_17_TOTALdemand) end, Sum(Feb_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','3', sum(Mar_17_TOTALdemand), case sum(Mar_17_Sales) when 0 then 0 else Sum(Mar_17_Sales)/sum(Mar_17_TOTALdemand) end, Sum(Mar_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','4', sum(Apr_17_TOTALdemand), case sum(Apr_17_Sales) when 0 then 0 else Sum(Apr_17_Sales)/sum(Apr_17_TOTALdemand) end, Sum(Apr_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','5', sum(May_17_TOTALdemand), case sum(May_17_Sales) when 0 then 0 else Sum(May_17_Sales)/sum(May_17_TOTALdemand) end, Sum(May_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','6', sum(Jun_17_TOTALdemand), case sum(Jun_17_Sales) when 0 then 0 else Sum(Jun_17_Sales)/sum(Jun_17_TOTALdemand) end, Sum(Jun_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','7', sum(Jul_17_TOTALdemand), case sum(Jul_17_Sales) when 0 then 0 else Sum(Jul_17_Sales)/sum(Jul_17_TOTALdemand) end, Sum(Jul_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','8', sum(Aug_17_TOTALdemand), case sum(Aug_17_Sales) when 0 then 0 else Sum(Aug_17_Sales)/sum(Aug_17_TOTALdemand) end, Sum(Aug_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','9', sum(Sep_17_TOTALdemand), case sum(Sep_17_Sales) when 0 then 0 else Sum(Sep_17_Sales)/sum(Sep_17_TOTALdemand) end, Sum(Sep_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','10', sum(Oct_17_TOTALdemand), case sum(Oct_17_Sales) when 0 then 0 else Sum(Oct_17_Sales)/sum(Oct_17_TOTALdemand) end, Sum(Oct_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','11', sum(Nov_17_TOTALdemand), case sum(Nov_17_Sales) when 0 then 0 else Sum(Nov_17_Sales)/sum(Nov_17_TOTALdemand) end, Sum(Nov_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2017','12', sum(Dec_17_TOTALdemand), case sum(Dec_17_Sales) when 0 then 0 else Sum(Dec_17_Sales)/sum(Dec_17_TOTALdemand) end, Sum(Dec_17_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','1', sum(Jan_18_TOTALdemand), case sum(Jan_18_Sales) when 0 then 0 else Sum(Jan_18_Sales)/sum(Jan_18_TOTALdemand) end, Sum(Jan_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','2', sum(Feb_18_TOTALdemand), case sum(Feb_18_Sales) when 0 then 0 else Sum(Feb_18_Sales)/sum(Feb_18_TOTALdemand) end, Sum(Feb_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','3', sum(Mar_18_TOTALdemand), case sum(Mar_18_Sales) when 0 then 0 else Sum(Mar_18_Sales)/sum(Mar_18_TOTALdemand) end, Sum(Mar_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','4', sum(Apr_18_TOTALdemand), case sum(Apr_18_Sales) when 0 then 0 else Sum(Apr_18_Sales)/sum(Apr_18_TOTALdemand) end, Sum(Apr_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','5', sum(May_18_TOTALdemand), case sum(May_18_Sales) when 0 then 0 else Sum(May_18_Sales)/sum(May_18_TOTALdemand) end, Sum(May_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','6', sum(Jun_18_TOTALdemand), case sum(Jun_18_Sales) when 0 then 0 else Sum(Jun_18_Sales)/sum(Jun_18_TOTALdemand) end, Sum(Jun_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','7', sum(Jul_18_TOTALdemand), case sum(Jul_18_Sales) when 0 then 0 else Sum(Jul_18_Sales)/sum(Jul_18_TOTALdemand) end, Sum(Jul_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','8', sum(Aug_18_TOTALdemand), case sum(Aug_18_Sales) when 0 then 0 else Sum(Aug_18_Sales)/sum(Aug_18_TOTALdemand) end, Sum(Aug_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','9', sum(Sep_18_TOTALdemand), case sum(Sep_18_Sales) when 0 then 0 else Sum(Sep_18_Sales)/sum(Sep_18_TOTALdemand) end, Sum(Sep_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','10', sum(Oct_18_TOTALdemand), case sum(Oct_18_Sales) when 0 then 0 else Sum(Oct_18_Sales)/sum(Oct_18_TOTALdemand) end, Sum(Oct_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','11', sum(Nov_18_TOTALdemand), case sum(Nov_18_Sales) when 0 then 0 else Sum(Nov_18_Sales)/sum(Nov_18_TOTALdemand) end, Sum(Nov_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','12', sum(Dec_18_TOTALdemand), case sum(Dec_18_Sales) when 0 then 0 else Sum(Dec_18_Sales)/sum(Dec_18_TOTALdemand) end, Sum(Dec_18_Sales) from eeiuser.acctg_csm_vw_select_sales_forecast group by customer, base_part




order by 5,6





GO
