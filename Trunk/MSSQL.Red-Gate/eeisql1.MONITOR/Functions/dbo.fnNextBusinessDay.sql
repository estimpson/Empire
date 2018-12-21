SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION 
[dbo].[fnNextBusinessDay](@DateToCheck datetime)
RETURNS datetime
AS
BEGIN
DECLARE
@result DATETIME,
@BusinessDay DATETIME

--add two days
SET @BusinessDay = DATEADD(DAY, 2%5 + 
           CASE         
        WHEN DATEPART(WEEKDAY,@DateToCheck ) +  2%5 > 6 THEN 2                  
        ELSE 0 
           END,     
   DATEADD(WEEK,2/5,@DateToCheck ))    
  
  
  ----add holiday day

  SELECT @BusinessDay =  DATEADD(DAY,(( CASE 
				WHEN DATEPART(MONTH, @BusinessDay) =  1 AND DATEPART (DAY , @BusinessDay) = 1 THEN 1 --NewYearsDay
				WHEN DATEPART(MONTH, @BusinessDay) =  7 AND DATEPART (DAY , @BusinessDay) = 4 THEN 1 -- July4th
				WHEN DATEPART(MONTH, @BusinessDay) =  12 AND DATEPART (DAY , @BusinessDay) = 25 THEN 1 -- Christmas
				WHEN datepart(dw, @BusinessDay) = 2 AND DATEPART(month, DATEADD(day, 7, @BusinessDay)) <> DATEPART(month, @BusinessDay)   THEN 1 --MemorialDay
				ELSE 0
				END
				) ), @BusinessDay )
		
			
    --Check for Weekend
   
   SELECT @result = @BusinessDay + 
					CASE 
					WHEN DATEPART(WEEKDAY, @BusinessDay) = 7 THEN 2 --Saturday
					WHEN DATEPART(WEEKDAY, @BusinessDay) =1 THEN 1 --Sunday
					ELSE 0
					END

   
 RETURN @result
END

--SELECT dbo.fnNextBusinessDay('2018-06-30 04:00:01')

--SELECT DATEPART(MONTH, '2018-07-04 04:00:01.000'),DATEPART (DAY , '2018-07-04 04:00:01.000') 


GO
