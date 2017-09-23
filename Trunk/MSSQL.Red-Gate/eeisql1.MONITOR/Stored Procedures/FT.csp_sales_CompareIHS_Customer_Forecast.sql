SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  procedure [FT].[csp_sales_CompareIHS_Customer_Forecast]
AS

BEGIN
CREATE TABLE #AvgMonthlyShippedQtyCurrentYear
 (		base_part VARCHAR(50),
		AvgMonthlyShippedQty Int
      ) 
 CREATE TABLE #AvgMonthlyShippedQtyPriorYear
 (		base_part VARCHAR(50),
		avgMonthlyShippedQty Int
      ) 

Declare @MonthlyShippedCurrentYear table
(	base_part varchar(25),
	MonthsInYear int,
	QtyShipped int
	)

	insert @MonthlyShippedCurrentYear
	  Select
		left(part_original, 7) as base_part,
		max(datepart(month,getdate()))-1 as MonthsinYear,
		sum(qty_packed) as QtyShipped
		from
			shipper_detail sd
		Join
			shipper s on sd.shipper = s.id
		and ISNULL(s.type,'xyz') not in ('T','V')
		and sd.part_original not like '%-PT'
		and s.date_shipped >= ft.fn_TruncDate('year', getdate()) and s.date_shipped < ft.fn_TruncDate('month', getdate()) 
		group by left(part_original, 7)


Declare @MonthlyShippedPriorYear table
(	base_part varchar(25),
	MonthsInYear int,
	QtyShipped int
	)

	insert @MonthlyShippedPriorYear
	  Select
		left(part_original, 7) as base_part,
		12 as MonthsinYear,
		sum(qty_packed) as QtyShipped
		from
			shipper_detail sd
		Join
			shipper s on sd.shipper = s.id
		and ISNULL(s.type,'xyz') not in ('T','V')
		and sd.part_original not like '%-PT'
		and s.date_shipped >= ft.fn_TruncDate('year', dateadd(yy, -1,getdate())) and s.date_shipped< ft.fn_TruncDate('year', getdate())
		group by left(part_original, 7)




Insert #AvgMonthlyShippedQtyCurrentYear
 Select
	base_part,
	QtyShipped/MonthsinYear
from @MonthlyShippedCurrentYear


Insert #AvgMonthlyShippedQtyPriorYear
 Select
	base_part,
	QtyShipped/MonthsinYear
from @MonthlyShippedPriorYear


	CREATE INDEX avgmonthShippedCY_idx ON  #AvgMonthlyShippedQtyCurrentYear (base_part)

	CREATE INDEX avgmonthShippedPY_idx ON  #AvgMonthlyShippedQtyCurrentYear (base_part)






--Get IHS data


 CREATE TABLE #ihsdemand
 (		Forecast_name VARCHAR(50),
		time_stamp  DATETIME,
		program_manager VARCHAR(50) ,
		customer VARCHAR(50) ,
		base_part VARCHAR(50) ,
		forecast_year Int,
		forecast_period int,
		forecast_units NUMERIC(20,6) ,
		selling_price NUMERIC(20,6),
		forecast_sales NUMERIC(20,6),
		MonthDT DATETIME,
		NumberOfDaysInMonth int,
		AvgDailyDemand INT
      ) 

	
	
	INSERT #ihsdemand
	        (	base_part ,
				forecast_units ,
				customer ,
				program_manager ,
				forecast_period ,	          
				forecast_year ,
				MonthDT ,
				NumberOfDaysInMonth ,
				AvgDailyDemand
	              
	        )
	

Select *
		
		,CONVERT(datetime, CONVERT(VARCHAR(25),forecast_year)+'-'+CONVERT(VARCHAR(25), forecast_period) +'-'+'1') AS MonthDT,
		day(dateadd(mm,DateDiff(mm, -1, CONVERT(datetime, CONVERT(VARCHAR(25),forecast_year)+'-'+CONVERT(VARCHAR(25), forecast_period) +'-'+'1')),0) -1)  AS NumberOfDaysInMonth,
		forecast_units/DAY(dateadd(mm,DateDiff(mm, -1, CONVERT(datetime, CONVERT(VARCHAR(25),forecast_year)+'-'+CONVERT(VARCHAR(25), forecast_period) +'-'+'1')),0) -1)  AS AvgDailyDemand 
		
From 
(
select	fc17.base_part,
		TotalDemand_monthly as forecast_units,
		left(fc17.base_part, 3) as Customer, 
		program_manager,
(		Case 
		when left(Period,3) = 'Jan' THEN 1 
		when left(Period,3) = 'Feb' THEN 2
		when left(Period,3) = 'Mar' THEN 3 
		when left(Period,3) = 'Apr' THEN 4
		when left(Period,3) = 'May' THEN 5 
		when left(Period,3) = 'Jun' THEN 6
		when left(Period,3) = 'Jul' THEN 7 
		when left(Period,3) = 'Aug' THEN 8
		when left(Period,3) = 'Sep' THEN 9 
		when left(Period,3) = 'Oct' THEN 10
		when left(Period,3) = 'Nov' THEN 11 
		when left(Period,3) = 'Dec' THEN 12
		ELSE 0 END) as Forecast_period,
'20'+Substring(Period,5,2) as Forecast_year 
From	ft.csm_vw_select_sales_forecast_2017 fc17
cross apply ( Select max(program_manager) program_manager from eeiuser.sales_1 s1 where s1.base_part = fc17.base_part and  time_stamp> getdate() -31 ) sales1 
UNION
select	fc18.base_part,
		TotalDemand_monthly as forecast_units,
		left(fc18.base_part, 3) as Customer, 
		program_manager,
(		Case 
		when left(Period,3) = 'Jan' THEN 1 
		when left(Period,3) = 'Feb' THEN 2
		when left(Period,3) = 'Mar' THEN 3 
		when left(Period,3) = 'Apr' THEN 4
		when left(Period,3) = 'May' THEN 5 
		when left(Period,3) = 'Jun' THEN 6
		when left(Period,3) = 'Jul' THEN 7 
		when left(Period,3) = 'Aug' THEN 8
		when left(Period,3) = 'Sep' THEN 9 
		when left(Period,3) = 'Oct' THEN 10
		when left(Period,3) = 'Nov' THEN 11 
		when left(Period,3) = 'Dec' THEN 12
		ELSE 0 END) as Forecast_period,
'20'+Substring(Period,5,2) as Forecast_year 
From	ft.csm_vw_select_sales_forecast_2018 fc18
cross apply ( Select max(program_manager) program_manager from eeiuser.sales_1 s1 where s1.base_part = fc18.base_part and  time_stamp> getdate() -31 ) sales1 ) sales_1
 


CREATE INDEX ihsdemand_idx ON #ihsdemand (base_part, forecast_year, forecast_period, MonthDT)

DECLARE @EndOFPlanningHorizon DATETIME

DECLARE @StartOfPlanningHorizon DATETIME


SELECT @EndOFPlanningHorizon = DATEADD(MONTH, 1,  [FT].[fn_TruncDate]( 'Month', (SELECT GETDATE()+180)))-1

CREATE TABLE #CalendarDemand
	(
				EntryDT DATETIME, 
				periodDT INT,
				YearDT INT,
				base_part VARCHAR(25),
				AvgDailyIHSDemand INT DEFAULT(0),
				AvgDailyIHSDemandAccum INT DEFAULT(0),
				AvgCustomerDemand INT DEFAULT(0),
				AvgCustomerDemandAccum INT DEFAULT(0),
				AvgCustomerShipHistoryCurrentYear INT DEFAULT(0),
				AvgCustomerShipHistoryAccumCurrentYear INT DEFAULT(0),
				AvgCustomerShipHistoryPriorYear INT DEFAULT(0),
				AvgCustomerShipHistoryAccumPriorYear INT DEFAULT(0),
				ActualCustomerDemand INT DEFAULT(0),
				ActualCustomerDemandShipped INT DEFAULT(0),
				ActualCustomerDemandPlusShipped INT DEFAULT(0),
				ActualCustomerDemandAccum INT DEFAULT(0),
				ActualCustomerDemandPlusShippedAccum INT DEFAULT(0)
	)

	

INSERT #CalendarDemand
        ( EntryDT ,
          periodDT ,
          YearDT ,
          base_part ,
          AvgDailyIHSDemand ,
          AvgDailyIHSDemandAccum ,
          AvgCustomerDemand ,
          AvgCustomerDemandAccum ,
		  AvgCustomerShipHistoryCurrentYear,
		  AvgCustomerShipHistoryAccumCurrentYear,
		  AvgCustomerShipHistoryPriorYear,
		  AvgCustomerShipHistoryAccumPriorYear,
          ActualCustomerDemand ,
          ActualCustomerDemandAccum
        )

		  

	SELECT  EntryDT, 
					DATEPART(MONTH, EntryDT) AS  periodDT,
					DATEPART(YEAR, EntryDT) AS  YearDT,
					base_part AS basePart,
					0 AS AvgDailyIHSDemand,
					0 AS AvgDailyIHSDemandAccum,
					0 AS AvgCustomerDemand,
					0 AS AvgCustomerDemandAccum,
					0 AS AvgCustomerShipHistoryCurrentYear,
					0 AS AvgCustomerShipHistoryAccumCurrentYear,
					0 AS AvgCustomerShipHistoryPriorYear,
					0 AS AvgCustomerShipHistoryAccumPriorYear,
					0 AS ActualCustomerDemand,
					0 AS ActualCustomerDemandAccum
	
	FROM [dbo].[fn_Calendar_StartCurrentDay] (	@EndOFPlanningHorizon     ,'day'  ,1  ,NULL)
	CROSS APPLY ( SELECT DISTINCT BASE_Part FROM #ihsdemand)  AS BaseParts

	CREATE INDEX calendarDemand_idx ON #CalendarDemand (base_part, EntryDT, periodDT, YearDT)

	Select @StartOfPlanningHorizon = min(EntryDT) from #CalendarDemand

	UPDATE cd
	SET cd.AvgDailyIHSDemand = ( SELECT max(ihs.AvgDailyDemand) FROM #ihsdemand ihs WHERE ihs.base_part = cd.base_Part AND ihs.forecast_year = cd.YearDT  AND ihs.forecast_period = cd.periodDT )
	FROM #CalendarDemand cd

	UPDATE cd
	SET cd.AvgDailyIHSDemandAccum = ( SELECT SUM(cd2.AvgDailyIHSDemand) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT) 
	FROM #CalendarDemand cd


	UPDATE cd
	SET cd.ActualCustomerDemand = COALESCE(( SELECT SUM(quantity) FROM dbo.order_detail od WHERE LEFT(od.part_number ,7) = cd.base_Part AND od.due_date= cd.EntryDT ),0) 
	FROM #CalendarDemand cd 

	
	UPDATE cd
	SET cd.AvgCustomerDemand = COALESCE(( SELECT SUM(quantity) FROM dbo.order_detail od WHERE LEFT(od.part_number ,7) = cd.base_Part AND od.due_date <= dateadd(dd, 90, getdate()) ),0) /90
	FROM #CalendarDemand cd 

	
	UPDATE cd
	SET cd.AvgCustomerDemandAccum = ( SELECT SUM(cd2.avgCustomerDemand) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT)
	FROM #CalendarDemand cd


	UPDATE cd
	SET cd.AvgCustomerShipHistoryCurrentYear = COALESCE(( SELECT SUM(avgMonthlyShippedQty) FROM #AvgMonthlyShippedQtyCurrentYear cy WHERE cy.base_part = cd.base_Part ),0)/30
	FROM #CalendarDemand cd 

	UPDATE cd
	SET cd.AvgCustomerShipHistoryPriorYear = COALESCE(( SELECT SUM(avgMonthlyShippedQty) FROM #AvgMonthlyShippedQtyPriorYear py WHERE py.base_part = cd.base_Part ),0)/30
	FROM #CalendarDemand cd
	
	UPDATE cd
	SET cd.AvgCustomerShipHistoryAccumCurrentYear = ( SELECT SUM(cd2.AvgCustomerShipHistoryCurrentYear) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT) 
	FROM #CalendarDemand cd 

	UPDATE cd
	SET cd.AvgCustomerShipHistoryAccumPriorYear = ( SELECT SUM(cd2.AvgCustomerShipHistoryPriorYear) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT) 
	FROM #CalendarDemand cd 


	UPDATE cd
	SET cd.ActualCustomerDemandShipped = COALESCE( (Select SUM(qty_packed) FROM Shipper_detail sd join shipper s on s.id = sd.shipper where Left(sd.part_original,7) = cd.base_part  and s.date_shipped>= ft.fn_truncdate('month', @StartofPlanningHorizon) and cd.EntryDT = @startOfPlanningHorizon),0)
	FROM #CalendarDemand cd 

	UPDATE cd
	SET cd.ActualCustomerDemandPlusShipped = cd.ActualCustomerDemand+cd.ActualCustomerDemandShipped
	FROM #CalendarDemand cd 
									

	UPDATE cd
	SET cd.ActualCustomerDemandAccum = ( SELECT SUM(cd2.ActualCustomerDemand) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT)
	FROM #CalendarDemand cd

	
	UPDATE cd
	SET cd.ActualCustomerDemandPlusShippedAccum = ( SELECT SUM(cd2.ActualCustomerDemandPlusShipped) FROM #CalendarDemand cd2 WHERE cd2.base_part = cd.base_Part AND cd2.EntryDT<= cd.EntryDT)
	FROM #CalendarDemand cd

	
truncate table IHSCalendarDemand

insert IHSCalendarDemand
SELECT * 
		FROM #CalendarDemand [ForecastDemand]
ORDER BY 1
END

GO
