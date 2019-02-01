SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[EDIFn_NextBusinessDay] (@Date DATETIME, @n INT)
RETURNS DATE
AS
BEGIN

DECLARE @d1 INT,@f INT,@DW INT;


DECLARE @M INT
DECLARE @D INT
DECLARE @DW2 INT
DECLARE @Holiday INT
DECLARE @NextDate DATE
DECLARE @PickupDate DATE

--Add two business days to @Date (date passed to function to get @NextDate

SET @f=CAST(abs(1^SIGN(DATEPART(DW, @Date)-(7-@@DATEFIRST))) AS BIT)
SET @DW=DATEPART(DW,@Date)-(7-@@DATEFIRST)*(@f^1)+@@DATEFIRST*(@f&1)
SET @d1=4-SIGN(@n)*(4-@DW);


SELECT @NextDate =  DATEADD(D,@n+((ABS(@n)+(@d1%(8+SIGN(@n)))-2)/5)*2*SIGN(@n)-@d1/7,@Date)


SET @Holiday = 0


SET @M = DATEPART(MM, @NextDate)
SET @D = DATEPART(DD, @NextDate)
SET @DW2 = DATEPART(DW, @NextDate)


--Determine if @NextDate falls on Holiday

-- New Years Day
-- Falls on Weekday
IF (@M = 1 AND @D = 1 AND @DW2 BETWEEN 2 AND 6) SET @Holiday = 1
ELSE
-- Falls on Sunday
IF (@M = 1 AND @D = 2 AND @DW2 = 2) SET @Holiday = 1
ELSE
-- Falls on Saturday
IF (@M = 12 AND @D = 31 AND @DW2 = 6) SET @Holiday = 1
ELSE
-- Memorial Day (Last Monday of May)
IF (@M = 5 AND @D BETWEEN 25 AND 31 AND @DW2 = 2) SET @Holiday = 1
ELSE
-- Independence Day
-- Falls on Weekday
IF (@M = 7 AND @D = 4 AND @DW2 BETWEEN 2 AND 6) SET @Holiday = 1
ELSE
-- Falls on Sunday
IF (@M = 7 AND @D = 5 AND @DW2 = 2) SET @Holiday = 1
ELSE
-- Falls on Saturday
IF (@M = 7 AND @D = 3 AND @DW2 = 6) SET @Holiday = 1
ELSE
-- Labor Day (1st Monday of September)
IF (@M = 9 AND @D BETWEEN 1 AND 7 AND @DW2 = 2) SET @Holiday = 1
ELSE-- Thanksgiving Day (4th Thursday of November)
IF (@M = 11 AND @D BETWEEN 22 AND 28 AND @DW2 = 5) SET @Holiday = 1
ELSE 
IF (@M = 11 AND @D BETWEEN 22 AND 28 AND @DW2 = 6) SET @Holiday = 1


-- Christmas Day (December 25th)
IF (@M = 12 AND @D = 25 AND @DW2 BETWEEN 2 AND 6) SET @Holiday =1
ELSE
-- Falls on Sunday
IF (@M = 12 AND @D = 26 AND @DW2 = 2) SET @Holiday =1
ELSE
-- Falls on Saturday
IF (@M = 12 AND @D = 24 AND @DW2 = 6) SET @Holiday = 1


Select  @PickupDate = DATEADD(dd, @Holiday, @NextDate)

--Move PickupDate to next Business Date if PickUpdate calculates to weekend after holiday
										
SELECT		@PickupDate =
					CASE When DATEPART(DW,@PickupDate) = 1 
					THEN DATEADD(DD, 1, @PickUpDate)
					WHEN DATEPART(DW,@PickupDate) = 6
					THEN DATEADD(DD, 2, @PickUpDate)
					ELSE @PickupDate
					END
--

RETURN @PickupDate

END
GO
