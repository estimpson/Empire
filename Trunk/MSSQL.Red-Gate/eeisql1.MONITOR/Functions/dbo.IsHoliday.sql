SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IsHoliday] (@InputDate DATETIME)
RETURNS int
AS
BEGIN

DECLARE @M TINYINT 
DECLARE @D TINYINT 
DECLARE @DW TINYINT 
DECLARE @Holiday INT
SET @Holiday = 0

-- Day of Week (@DW)
-- 1 - Sunday
-- 2 - Monday
-- 3 - Tuesday
-- 4 - Wednesday
-- 5 - Thursday
-- 6 - Friday
-- 7 - Saturday

SET @M = DATEPART(MM, @InputDate)
SET @D = DATEPART(DD, @InputDate)
SET @DW = DATEPART(DW, @InputDate)


-- New Years Day
-- Falls on Weekday
IF (@M = 1 AND @D = 1 AND @DW BETWEEN 2 AND 6) SET @Holiday = 1
ELSE
-- Falls on Sunday
IF (@M = 1 AND @D = 2 AND @DW = 2) SET @Holiday = 1
ELSE
-- Falls on Saturday
IF (@M = 12 AND @D = 31 AND @DW = 6) SET @Holiday = 1


-- Memorial Day (Last Monday of May)
IF (@M = 5 AND @D BETWEEN 25 AND 31 AND @DW = 2) SET @Holiday = 1

-- Independence Day
-- Falls on Weekday
IF (@M = 7 AND @D = 4 AND @DW BETWEEN 2 AND 6) SET @Holiday = 1
ELSE
-- Falls on Sunday
IF (@M = 7 AND @D = 5 AND @DW = 2) SET @Holiday = 1
ELSE
-- Falls on Saturday
IF (@M = 7 AND @D = 3 AND @DW = 6) SET @Holiday = 1

-- Labor Day (1st Monday of September)
IF (@M = 9 AND @D BETWEEN 1 AND 7 AND @DW = 2) SET @Holiday = 1



-- Thanksgiving Day (4th Thursday of November)
IF (@M = 11 AND @D BETWEEN 22 AND 28 AND @DW = 5) SET @Holiday = 1
IF (@M = 11 AND @D BETWEEN 22 AND 28 AND @DW = 6) SET @Holiday = 1


-- Christmas Day (December 25th)
IF (@M = 12 AND @D = 25 AND @DW BETWEEN 2 AND 6) SET @Holiday =1
ELSE
-- Falls on Sunday
IF (@M = 12 AND @D = 26 AND @DW = 2) SET @Holiday =1
ELSE
-- Falls on Saturday
IF (@M = 12 AND @D = 24 AND @DW = 6) SET @Holiday = 1


RETURN @Holiday

END
GO
