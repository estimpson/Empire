SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE FUNCTION [dbo].[fn_returnPSFSnapShots]
()
RETURNS @PSF TABLE
(	ForecastPeriodName VARCHAR(100),
	ForecastTimeStamp DATETIME,
	Totalsales NUMERIC(20,6)
)
AS
BEGIN
--- <Body>
	-- Andre S. Boulanger	Fore-Thought, LLC	2014-04-25	Original

DECLARE	 @PSFHorizonStartDT DATETIME
	

SELECT	@PSFHorizonStartDT  =  DATEADD( WEEK, -3, (ft.fn_TruncDate_monday('wk', GETDATE())-1))



INSERT @PSF
        ( ForecastPeriodName, ForecastTimeStamp, Totalsales )


	
SELECT  
	forecast_name ,
    time_stamp ,
	SUM(forecast_sales)		

FROM
	eeiuser.sales_1
WHERE
	forecast_name LIKE '%PSF%' AND
	time_stamp >= @PSFHorizonStartDT
GROUP BY
	forecast_name,
	time_stamp

ORDER BY
	2
			
--- </Body>

---	<Return>
	RETURN
END

























GO
