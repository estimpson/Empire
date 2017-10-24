SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [FT].[BusinessDaysDateAdd] 
(
    @StartDate DATETIME,  
    @BusinessDays INT 
)

RETURNS DATE
AS  
BEGIN 
DECLARE @EndDate DATE

SET @EndDate = DATEADD(DAY, @BusinessDays%5 + 
           CASE         
        WHEN DATEPART(WEEKDAY,@StartDate) +  @BusinessDays%5 > 6 THEN 2                  
        ELSE 0 
           END,     
   DATEADD(WEEK,@BusinessDays/5,@StartDate))    

   RETURN @EndDate
END  


GO
