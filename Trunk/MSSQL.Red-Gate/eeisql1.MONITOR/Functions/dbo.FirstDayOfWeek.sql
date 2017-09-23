SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[FirstDayOfWeek]
(@WeekNumber int, @YearNumber int)
/*
	select FirstDay=convert(date,dbo.FirstDayOfWeek(37,2017)),LastDay=convert(date,dateadd(day,11,dbo.FirstDayOfWeek(37,2017)))
*/
RETURNS DATETIME
AS
BEGIN

DECLARE @Year varchar(4)
SET @Year = convert(varchar,@YearNumber)

DECLARE @Week int
SET @Week = @WeekNumber

DECLARE @FirstDayOfYear datetime
SET @FirstDayOfYear = CAST( (CAST(@Year as varchar(4)) +'-01-01') as DateTime) 
 --select @FirstDayOfYear

DECLARE @FirstDayOfWeek	datetime

SELECT @FirstDayOfWeek= DATEADD(week,@week,@firstDayOfYear)

RETURN (DATEADD(DAY,-6,DATEADD(week,@week,@firstDayOfYear)) )
END
GO
