SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [dbo].[fn_SalesHistory]
(@FromDate DATETIME, @ThroughDate DATETIME )
RETURNS @SalesHistory TABLE
(	BasePart VARCHAR(50)
,	Customer VARCHAR(50)
,	SalesYear VARCHAR(15)
,	SalesPeriod VARCHAR(15)
,	SalesPeriodName VARCHAR(50)
,	Sales NUMERIC(20,6)
)
AS
BEGIN
--- <Body>
	-- Andre S. Boulanger	Fore-Thought, LLC	2014-04-18	Original

--SELECT * FROM dbo.fn_SalesHistory ( '2013-12-01', '2014-03-31')

DECLARE 
@TruncatedFromDT DATETIME,
@TruncatedThroughDT DATETIME


SET @TruncatedFromDT =  FT.fn_TruncDate ('dd', @FromDate)
SET @TruncatedThroughDT =  FT.fn_TruncDate ('dd', @throughDate) + 1 


	
INSERT @SalesHistory
        ( Customer ,
          BasePart ,
          SalesYear ,
		  SalesPeriod,
		  SalesPeriodName,
          Sales 
        
        )

	
SELECT	
		LEFT(basepart,3) AS Customer,
		basepart AS Base_part, 
		DATEPART(YEAR, date_shipped) AS salesYear,		
		DATEPART(MONTH, date_shipped) AS SalesPeriod,
		CASE DATEPART(MONTH, date_shipped)
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
			ELSE 'DECEMBER' END AS SalesPeriodName,
		SUM(extended) AS Extended
FROM		vw_eei_sales_history
JOIN		destination ON  vw_eei_sales_history.destination = destination.destination
WHERE	date_shipped >= @TruncatedFromDT AND date_shipped < @TruncatedThroughDT
GROUP BY
		LEFT(basepart,3),
		basepart, 
		DATEPART(MONTH, date_shipped),
		DATEPART(YEAR, date_shipped)

ORDER BY
	1,3,4
			
--- </Body>

---	<Return>
	RETURN
END
























GO
