SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [dbo].[fn_SalesForecastComparison]
(@LastWeekForecastSchedulename VARCHAR(100), @CurrentWeekForecastSchedulename VARCHAR(100))
RETURNS @SalesForecastComparison TABLE
(	BasePart VARCHAR(50)
,	Customer VARCHAR(50)
,	OEM VARCHAR(800)
,	Program VARCHAR(800)
,	Vehicle VARCHAR(800)
,	ForecastYear VARCHAR(15)
,	ForecastPeriod VARCHAR(15)
,	ForecastPeriodName VARCHAR(50)
,	CurrentWeekForecastName VARCHAR(50)
,	CurrentWeekForecastTimeStamp DATETIME
,	BasepartUOM VARCHAR(10)
,	CurrentWeekForecastUnits NUMERIC(20,6)
,	CurrentWeekForecastSales NUMERIC(20,6)
,	PriorWeekForecastName VARCHAR(50)
,	PrioWeekForecastTimeStamp DATETIME
,	PriorWeekForecastUnits NUMERIC(20,6)
,	PriorWeekForecastSales NUMERIC(20,6)
,	SalesForecastVariance NUMERIC(20,6)
)
AS
BEGIN
--- <Body>
	-- Andre S. Boulanger	Fore-Thought, LLC	2014-04-17	Original
	-- Andre S. boulanger	Fore-Thought, LLC	2014-04-25	Modified fynction to accept two PSF names that will be passed by schedulers
	-- Andre S. Boulanger Fore-Thought, LLC 2019-03-22 : Added part_inventory standaed unit to report

--DECLARE	 @SundayOfCurrentWeek DATETIME
	

--SELECT	@SundayOfCurrentWeek =  ft.fn_TruncDate_monday('wk', GETDATE())-1

--SELECT	
--	@LastWeekForecastSchedulename = MAX(forecast_name) 
--	FROM eeiuser.sales_1
--	WHERE time_stamp =  (SELECT MAX(time_stamp) FROM eeiuser.sales_1 WHERE time_stamp< @SundayOfCurrentWeek ) AND
--			sales_1.forecast_name LIKE '%PSF%'

--SELECT	
--	@CurrentWeekForecastSchedulename = MAX(forecast_name)
--	FROM eeiuser.sales_1
--	WHERE time_stamp =  (SELECT MAX(time_stamp) FROM eeiuser.sales_1 WHERE time_stamp>= @SundayOfCurrentWeek ) AND
--			sales_1.forecast_name LIKE '%PSF%'

DECLARE @PriorWeekSalesForcast TABLE

(			forecast_name VARCHAR(50) ,
	        time_stamp DATETIME,
	        program_manager VARCHAR(50) ,
	        customer VARCHAR(50) ,
	        base_part VARCHAR(50),
	        forecast_year VARCHAR(15),
	        forecast_period VARCHAR(15),
	        forecast_units NUMERIC(20,6),
			forecast_units_uom VARCHAR(10),
	        selling_price NUMERIC(20,6),
	        forecast_sales NUMERIC(20,6)

)



DECLARE @CurrentWeekSalesForcast TABLE

(			forecast_name VARCHAR(50) ,
	        time_stamp DATETIME,
	        program_manager VARCHAR(50) ,
	        customer VARCHAR(50) ,
	        base_part VARCHAR(50),
	        forecast_year VARCHAR(15),
	        forecast_period VARCHAR(15),
	        forecast_units NUMERIC(20,6),
			forecast_units_uom VARCHAR(10),
	        selling_price NUMERIC(20,6),
	        forecast_sales NUMERIC(20,6)

)

INSERT @PriorWeekSalesForcast
        ( forecast_name ,
          time_stamp ,
          program_manager ,
          customer ,
          base_part ,
          forecast_year ,
          forecast_period ,
          forecast_units ,
		  forecast_units_uom,
          selling_price ,
          forecast_sales
        )
SELECT	
			forecast_name ,
	        time_stamp ,
	        program_manager ,
	        customer ,
	        base_part ,
	        forecast_year ,
	        forecast_period ,
	        forecast_units ,
			COALESCE(piv.standard_unit, 'EA'),
	        selling_price ,
	        forecast_sales
FROM
	eeiuser.sales_1 WITH (NOLOCK)
	CROSS APPLY ( SELECT TOP 1 piv.standard_unit FROM dbo.part_inventory piv WITH (NOLOCK) WHERE LEFT(piv.part,7) = sales_1.base_part ) AS piv
WHERE
	forecast_name = @LastWeekForecastSchedulename	

INSERT @CurrentWeekSalesForcast
        ( forecast_name ,
          time_stamp ,
          program_manager ,
          customer ,
          base_part ,
          forecast_year ,
          forecast_period ,
          forecast_units ,
		  forecast_units_uom,
          selling_price ,
          forecast_sales
        )

SELECT	
			forecast_name ,
	        time_stamp ,
	        program_manager ,
	        customer ,
	        base_part ,
	        forecast_year ,
	        forecast_period ,
	        forecast_units ,
			COALESCE(piv.standard_unit, 'EA'),
	        selling_price ,
	        forecast_sales
FROM
	eeiuser.sales_1 WITH (NOLOCK)
	CROSS APPLY ( SELECT TOP 1 piv.standard_unit   FROM dbo.part_inventory piv WITH (NOLOCK) WHERE LEFT(piv.part,7) = sales_1.base_part ) AS piv
WHERE
	forecast_name = @CurrentWeekForecastSchedulename
	
INSERT @SalesForecastComparison
        ( BasePart ,
		  BasepartUOM, 
          Customer ,
		  OEM,
		  Program,
		  Vehicle,
          ForecastYear ,
          ForecastPeriod ,
          ForecastPeriodName ,
          CurrentWeekForecastName ,
          CurrentWeekForecastTimeStamp ,
		  CurrentWeekForecastUnits,
          CurrentWeekForecastSales ,
          PriorWeekForecastName ,
          PrioWeekForecastTimeStamp ,
		  PriorWeekForecastUnits,
          PriorWeekForecastSales ,
          SalesForecastVariance
        )

	
SELECT 
			COALESCE(cwsf.base_part, pwsf.base_part ) AS Basepart,
			cwsf.forecast_units_uom AS BasepartUOM,
			COALESCE(cwsf.customer, pwsf.customer ) AS Customer,
			COALESCE(vwFlatCSM.oem, 'N/A') AS OEM,
			COALESCE(vwFlatCSM.program, 'N/A') AS Program,
			COALESCE(vwFlatCSM.vehicle, 'N/A') AS Vehicle,
			COALESCE(cwsf.forecast_year, pwsf.forecast_year) AS ForecastYear,
	        COALESCE(cwsf.forecast_period, pwsf.forecast_period) AS ForecastPeriod,
			CASE COALESCE(cwsf.forecast_period, pwsf.forecast_period)
			WHEN 1 THEN 'JANUARY'
			WHEN 2 THEN 'FEBRUARY'
			WHEN 3 THEN 'MARCH'
			WHEN 4 THEN 'APRIL'
			WHEN 5 THEN 'MAY'
			WHEN 6 THEN 'JUNE'
			WHEN 7 THEN 'JULY'
			WHEN 8 THEN 'AUGUST'
			WHEN 9 THEN 'SEPTEMBER'
			WHEN 10 THEN 'OCTOBER'
			WHEN 11 THEN 'NOVEMBER'
			ELSE 'DECEMBER' END AS ForecastPeriodName,
			cwsf.forecast_name AS CurrentWeekForecastName,
			cwsf.time_stamp AS CurrentWeekForecastTimeStamp,
			COALESCE(cwsf.forecast_units,0)  AS CurrentWeekForecastUnits,			 
	        COALESCE(cwsf.forecast_sales,0)  AS CurrentWeekForecastSales,
	        pwsf.forecast_name AS PriorWeekForecastName,
	        pwsf.time_stamp AS PriorWeekForecastTimeStamp ,
			COALESCE(pwsf.forecast_units,0)  AS PriorWeekForecastUnits,
	        COALESCE(pwsf.forecast_sales,0) PriorWeekForecastSales,
			COALESCE(cwsf.forecast_sales,0) - COALESCE(pwsf.forecast_sales,0) AS ForecastSalesVariance

FROM
	@CurrentWeekSalesForcast cwsf
LEFT JOIN
	[dbo].[vw_flatCSM] vwFlatCSM  WITH (NOLOCK) ON vwFlatCSM.basepart = cwsf.base_part
FULL JOIN
	@PriorWeekSalesForcast pwsf ON pwsf.base_part = cwsf.base_part AND
	pwsf.forecast_period = cwsf.forecast_period AND
	pwsf.forecast_year = cwsf.forecast_year AND
	pwsf.customer = cwsf.customer

ORDER BY
	1,3,4
			
--- </Body>

---	<Return>
	RETURN
END




























GO
