SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[DateDiffWeekdays]
(@fromdate datetime,
@todate datetime)
RETURNS int
AS 
begin
declare @procdate datetime, @enddate datetime
declare @weekdays int
set @procdate = @fromdate 
set @weekdays = 0

while (@procdate < @todate) 
begin
if (datepart(dw, @procdate + 1) <> 1) and (datepart(dw, @procdate + 1) <> 7)
set @weekdays = @weekdays + 1
set @procdate = dateadd(d, 1, @procdate)

end
---
if @todate is null 
set @weekdays = null

return @weekdays
end
GO
