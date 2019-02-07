SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- select distinct(forecast_name), time_stamp from eeiuser.sales_1 where time_stamp >= '2015-10-01' order by time_stamp

-- delete from eeiuser.sales_1 where forecast_name = '2018/08 OSF' and time_stamp = '2018-10-28 18:00:00'

-- exec eeiuser.acctg_sales_sp_insert_official_forecast '2018/12 OSF', '2019-02-07 18:00:00'


CREATE procedure [EEIUser].[acctg_sales_sp_insert_official_forecast]
  @forecast_name varchar(50),
  @time_stamp datetime
as


select @time_stamp = ft.fn_truncdate('ss',getdate())

declare @b table 
	(customer varchar(15), 
	 base_part varchar(15), 
	 Jan_18_TOTALDEMAND decimal(18,6), 
	 Feb_18_TOTALDEMAND decimal(18,6), 
	 Mar_18_TOTALDEMAND decimal(18,6), 
	 Apr_18_TOTALDEMAND decimal(18,6), 
	 May_18_TOTALDEMAND decimal(18,6), 
	 Jun_18_TOTALDEMAND decimal(18,6), 
	 Jul_18_TOTALDEMAND decimal(18,6), 
	 Aug_18_TOTALDEMAND decimal(18,6), 
	 Sep_18_TOTALDEMAND decimal(18,6), 
	 Oct_18_TOTALDEMAND decimal(18,6), 
	 Nov_18_TOTALDEMAND decimal(18,6), 
	 Dec_18_TOTALDEMAND decimal(18,6),
	 
	 Jan_19_TOTALDEMAND decimal(18,6), 
	 Feb_19_TOTALDEMAND decimal(18,6), 
	 Mar_19_TOTALDEMAND decimal(18,6), 
	 Apr_19_TOTALDEMAND decimal(18,6), 
	 May_19_TOTALDEMAND decimal(18,6), 
	 Jun_19_TOTALDEMAND decimal(18,6), 
	 Jul_19_TOTALDEMAND decimal(18,6), 
	 Aug_19_TOTALDEMAND decimal(18,6), 
	 Sep_19_TOTALDEMAND decimal(18,6), 
	 Oct_19_TOTALDEMAND decimal(18,6), 
	 Nov_19_TOTALDEMAND decimal(18,6), 
	 Dec_19_TOTALDEMAND decimal(18,6),

	 Jan_20_TOTALDEMAND decimal(18,6), 
	 Feb_20_TOTALDEMAND decimal(18,6), 
	 Mar_20_TOTALDEMAND decimal(18,6), 
	 Apr_20_TOTALDEMAND decimal(18,6), 
	 May_20_TOTALDEMAND decimal(18,6), 
	 Jun_20_TOTALDEMAND decimal(18,6), 
	 Jul_20_TOTALDEMAND decimal(18,6), 
	 Aug_20_TOTALDEMAND decimal(18,6), 
	 Sep_20_TOTALDEMAND decimal(18,6), 
	 Oct_20_TOTALDEMAND decimal(18,6), 
	 Nov_20_TOTALDEMAND decimal(18,6), 
	 Dec_20_TOTALDEMAND decimal(18,6),

	 --Jan_21_TOTALDEMAND decimal(18,6), 
	 --Feb_21_TOTALDEMAND decimal(18,6), 
	 --Mar_21_TOTALDEMAND decimal(18,6), 
	 --Apr_21_TOTALDEMAND decimal(18,6), 
	 --May_21_TOTALDEMAND decimal(18,6), 
	 --Jun_21_TOTALDEMAND decimal(18,6), 
	 --Jul_21_TOTALDEMAND decimal(18,6), 
	 --Aug_21_TOTALDEMAND decimal(18,6), 
	 --Sep_21_TOTALDEMAND decimal(18,6), 
	 --Oct_21_TOTALDEMAND decimal(18,6), 
	 --Nov_21_TOTALDEMAND decimal(18,6), 
	 --Dec_21_TOTALDEMAND decimal(18,6),
	 
	 Jan_18_Sales decimal(18,6), 
	 Feb_18_Sales decimal(18,6), 
	 Mar_18_Sales decimal(18,6), 
	 Apr_18_Sales decimal(18,6), 
	 May_18_Sales decimal(18,6), 
	 Jun_18_Sales decimal(18,6), 
	 Jul_18_Sales decimal(18,6), 
	 Aug_18_Sales decimal(18,6), 
	 Sep_18_Sales decimal(18,6), 
	 Oct_18_Sales decimal(18,6), 
	 Nov_18_Sales decimal(18,6), 
	 Dec_18_Sales decimal(18,6),
	 Jan_19_Sales decimal(18,6), 
	 Feb_19_Sales decimal(18,6), 
	 Mar_19_Sales decimal(18,6), 
	 Apr_19_Sales decimal(18,6), 
	 May_19_Sales decimal(18,6), 
	 Jun_19_Sales decimal(18,6), 
	 Jul_19_Sales decimal(18,6), 
	 Aug_19_Sales decimal(18,6), 
	 Sep_19_Sales decimal(18,6), 
	 Oct_19_Sales decimal(18,6), 
	 Nov_19_Sales decimal(18,6), 
	 Dec_19_Sales decimal(18,6),

	 Jan_20_Sales decimal(18,6), 
	 Feb_20_Sales decimal(18,6), 
	 Mar_20_Sales decimal(18,6), 
	 Apr_20_Sales decimal(18,6), 
	 May_20_Sales decimal(18,6), 
	 Jun_20_Sales decimal(18,6), 
	 Jul_20_Sales decimal(18,6), 
	 Aug_20_Sales decimal(18,6), 
	 Sep_20_Sales decimal(18,6), 
	 Oct_20_Sales decimal(18,6), 
	 Nov_20_Sales decimal(18,6), 
	 Dec_20_Sales decimal(18,6)

	 --,Jan_21_Sales decimal(18,6), 
	 --Feb_21_Sales decimal(18,6), 
	 --Mar_21_Sales decimal(18,6), 
	 --Apr_21_Sales decimal(18,6), 
	 --May_21_Sales decimal(18,6), 
	 --Jun_21_Sales decimal(18,6), 
	 --Jul_21_Sales decimal(18,6), 
	 --Aug_21_Sales decimal(18,6), 
	 --Sep_21_Sales decimal(18,6), 
	 --Oct_21_Sales decimal(18,6), 
	 --Nov_21_Sales decimal(18,6), 
	 --Dec_21_Sales decimal(18,6)

	)

insert into @b

select customer, base_part, 
Jan_18_TOTALDEMAND, Feb_18_TOTALDEMAND, Mar_18_TOTALDEMAND, Apr_18_TOTALDEMAND, May_18_TOTALDEMAND, Jun_18_TOTALDEMAND, Jul_18_TOTALDEMAND, Aug_18_TOTALDEMAND, Sep_18_TOTALDEMAND, Oct_18_TOTALDEMAND, Nov_18_TOTALDEMAND, Dec_18_TOTALDEMAND,
Jan_19_TOTALDEMAND, Feb_19_TOTALDEMAND, Mar_19_TOTALDEMAND, Apr_19_TOTALDEMAND, May_19_TOTALDEMAND, Jun_19_TOTALDEMAND, Jul_19_TOTALDEMAND, Aug_19_TOTALDEMAND, Sep_19_TOTALDEMAND, Oct_19_TOTALDEMAND, Nov_19_TOTALDEMAND, Dec_19_TOTALDEMAND,
Jan_20_TOTALDEMAND, Feb_20_TOTALDEMAND, Mar_20_TOTALDEMAND, Apr_20_TOTALDEMAND, May_20_TOTALDEMAND, Jun_20_TOTALDEMAND, Jul_20_TOTALDEMAND, Aug_20_TOTALDEMAND, Sep_20_TOTALDEMAND, Oct_20_TOTALDEMAND, Nov_20_TOTALDEMAND, Dec_20_TOTALDEMAND,
--Jan_21_TOTALDEMAND, Feb_21_TOTALDEMAND, Mar_21_TOTALDEMAND, Apr_21_TOTALDEMAND, May_21_TOTALDEMAND, Jun_21_TOTALDEMAND, Jul_21_TOTALDEMAND, Aug_21_TOTALDEMAND, Sep_21_TOTALDEMAND, Oct_21_TOTALDEMAND, Nov_21_TOTALDEMAND, Dec_21_TOTALDEMAND,

Jan_18_Sales, Feb_18_Sales, Mar_18_Sales, Apr_18_Sales, May_18_Sales, Jun_18_Sales, Jul_18_Sales, Aug_18_Sales, Sep_18_Sales, Oct_18_Sales, Nov_18_Sales, Dec_18_Sales,
Jan_19_Sales, Feb_19_Sales, Mar_19_Sales, Apr_19_Sales, May_19_Sales, Jun_19_Sales, Jul_19_Sales, Aug_19_Sales, Sep_19_Sales, Oct_19_Sales, Nov_19_Sales, Dec_19_Sales,
Jan_20_Sales, Feb_20_Sales, Mar_20_Sales, Apr_20_Sales, May_20_Sales, Jun_20_Sales, Jul_20_Sales, Aug_20_Sales, Sep_20_Sales, Oct_20_Sales, Nov_20_Sales, Dec_20_Sales
--Jan_21_Sales, Feb_21_Sales, Mar_21_Sales, Apr_21_Sales, May_21_Sales, Jun_21_Sales, Jul_21_Sales, Aug_21_Sales, Sep_21_Sales, Oct_21_Sales, Nov_21_Sales, Dec_21_Sales

from eeiuser.acctg_csm_vw_select_sales_forecast


insert into sales_1

select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','1', sum(Jan_18_TOTALdemand), case sum(Jan_18_Sales) when 0 then 0 else Sum(Jan_18_Sales)/sum(Jan_18_TOTALdemand) end, Sum(Jan_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','2', sum(Feb_18_TOTALdemand), case sum(Feb_18_Sales) when 0 then 0 else Sum(Feb_18_Sales)/sum(Feb_18_TOTALdemand) end, Sum(Feb_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','3', sum(Mar_18_TOTALdemand), case sum(Mar_18_Sales) when 0 then 0 else Sum(Mar_18_Sales)/sum(Mar_18_TOTALdemand) end, Sum(Mar_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','4', sum(Apr_18_TOTALdemand), case sum(Apr_18_Sales) when 0 then 0 else Sum(Apr_18_Sales)/sum(Apr_18_TOTALdemand) end, Sum(Apr_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','5', sum(May_18_TOTALdemand), case sum(May_18_Sales) when 0 then 0 else Sum(May_18_Sales)/sum(May_18_TOTALdemand) end, Sum(May_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','6', sum(Jun_18_TOTALdemand), case sum(Jun_18_Sales) when 0 then 0 else Sum(Jun_18_Sales)/sum(Jun_18_TOTALdemand) end, Sum(Jun_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','7', sum(Jul_18_TOTALdemand), case sum(Jul_18_Sales) when 0 then 0 else Sum(Jul_18_Sales)/sum(Jul_18_TOTALdemand) end, Sum(Jul_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','8', sum(Aug_18_TOTALdemand), case sum(Aug_18_Sales) when 0 then 0 else Sum(Aug_18_Sales)/sum(Aug_18_TOTALdemand) end, Sum(Aug_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','9', sum(Sep_18_TOTALdemand), case sum(Sep_18_Sales) when 0 then 0 else Sum(Sep_18_Sales)/sum(Sep_18_TOTALdemand) end, Sum(Sep_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','10', sum(Oct_18_TOTALdemand), case sum(Oct_18_Sales) when 0 then 0 else Sum(Oct_18_Sales)/sum(Oct_18_TOTALdemand) end, Sum(Oct_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','11', sum(Nov_18_TOTALdemand), case sum(Nov_18_Sales) when 0 then 0 else Sum(Nov_18_Sales)/sum(Nov_18_TOTALdemand) end, Sum(Nov_18_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2018','12', sum(Dec_18_TOTALdemand), case sum(Dec_18_Sales) when 0 then 0 else Sum(Dec_18_Sales)/sum(Dec_18_TOTALdemand) end, Sum(Dec_18_Sales) from @b group by customer, base_part

union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','1', sum(Jan_19_TOTALdemand), case sum(Jan_19_Sales) when 0 then 0 else Sum(Jan_19_Sales)/sum(Jan_19_TOTALdemand) end, Sum(Jan_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','2', sum(Feb_19_TOTALdemand), case sum(Feb_19_Sales) when 0 then 0 else Sum(Feb_19_Sales)/sum(Feb_19_TOTALdemand) end, Sum(Feb_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','3', sum(Mar_19_TOTALdemand), case sum(Mar_19_Sales) when 0 then 0 else Sum(Mar_19_Sales)/sum(Mar_19_TOTALdemand) end, Sum(Mar_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','4', sum(Apr_19_TOTALdemand), case sum(Apr_19_Sales) when 0 then 0 else Sum(Apr_19_Sales)/sum(Apr_19_TOTALdemand) end, Sum(Apr_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','5', sum(May_19_TOTALdemand), case sum(May_19_Sales) when 0 then 0 else Sum(May_19_Sales)/sum(May_19_TOTALdemand) end, Sum(May_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','6', sum(Jun_19_TOTALdemand), case sum(Jun_19_Sales) when 0 then 0 else Sum(Jun_19_Sales)/sum(Jun_19_TOTALdemand) end, Sum(Jun_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','7', sum(Jul_19_TOTALdemand), case sum(Jul_19_Sales) when 0 then 0 else Sum(Jul_19_Sales)/sum(Jul_19_TOTALdemand) end, Sum(Jul_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','8', sum(Aug_19_TOTALdemand), case sum(Aug_19_Sales) when 0 then 0 else Sum(Aug_19_Sales)/sum(Aug_19_TOTALdemand) end, Sum(Aug_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','9', sum(Sep_19_TOTALdemand), case sum(Sep_19_Sales) when 0 then 0 else Sum(Sep_19_Sales)/sum(Sep_19_TOTALdemand) end, Sum(Sep_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','10', sum(Oct_19_TOTALdemand), case sum(Oct_19_Sales) when 0 then 0 else Sum(Oct_19_Sales)/sum(Oct_19_TOTALdemand) end, Sum(Oct_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','11', sum(Nov_19_TOTALdemand), case sum(Nov_19_Sales) when 0 then 0 else Sum(Nov_19_Sales)/sum(Nov_19_TOTALdemand) end, Sum(Nov_19_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2019','12', sum(Dec_19_TOTALdemand), case sum(Dec_19_Sales) when 0 then 0 else Sum(Dec_19_Sales)/sum(Dec_19_TOTALdemand) end, Sum(Dec_19_Sales) from @b group by customer, base_part


union

select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','1', sum(Jan_20_TOTALdemand), case sum(Jan_20_Sales) when 0 then 0 else Sum(Jan_20_Sales)/sum(Jan_20_TOTALdemand) end, Sum(Jan_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','2', sum(Feb_20_TOTALdemand), case sum(Feb_20_Sales) when 0 then 0 else Sum(Feb_20_Sales)/sum(Feb_20_TOTALdemand) end, Sum(Feb_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','3', sum(Mar_20_TOTALdemand), case sum(Mar_20_Sales) when 0 then 0 else Sum(Mar_20_Sales)/sum(Mar_20_TOTALdemand) end, Sum(Mar_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','4', sum(Apr_20_TOTALdemand), case sum(Apr_20_Sales) when 0 then 0 else Sum(Apr_20_Sales)/sum(Apr_20_TOTALdemand) end, Sum(Apr_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','5', sum(May_20_TOTALdemand), case sum(May_20_Sales) when 0 then 0 else Sum(May_20_Sales)/sum(May_20_TOTALdemand) end, Sum(May_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','6', sum(Jun_20_TOTALdemand), case sum(Jun_20_Sales) when 0 then 0 else Sum(Jun_20_Sales)/sum(Jun_20_TOTALdemand) end, Sum(Jun_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','7', sum(Jul_20_TOTALdemand), case sum(Jul_20_Sales) when 0 then 0 else Sum(Jul_20_Sales)/sum(Jul_20_TOTALdemand) end, Sum(Jul_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','8', sum(Aug_20_TOTALdemand), case sum(Aug_20_Sales) when 0 then 0 else Sum(Aug_20_Sales)/sum(Aug_20_TOTALdemand) end, Sum(Aug_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','9', sum(Sep_20_TOTALdemand), case sum(Sep_20_Sales) when 0 then 0 else Sum(Sep_20_Sales)/sum(Sep_20_TOTALdemand) end, Sum(Sep_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','10', sum(Oct_20_TOTALdemand), case sum(Oct_20_Sales) when 0 then 0 else Sum(Oct_20_Sales)/sum(Oct_20_TOTALdemand) end, Sum(Oct_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','11', sum(Nov_20_TOTALdemand), case sum(Nov_20_Sales) when 0 then 0 else Sum(Nov_20_Sales)/sum(Nov_20_TOTALdemand) end, Sum(Nov_20_Sales) from @b group by customer, base_part
union
select @forecast_name, @time_stamp, NULL, customer, base_part, '2020','12', sum(Dec_20_TOTALdemand), case sum(Dec_20_Sales) when 0 then 0 else Sum(Dec_20_Sales)/sum(Dec_20_TOTALdemand) end, Sum(Dec_20_Sales) from @b group by customer, base_part

order by 5,6



GO
