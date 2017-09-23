SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fnDateaftinWeekdays]
(	@fromdate datetime,
	@Days int	)
RETURNS datetime
AS
begin
declare	@enddate datetime
declare	@procdate datetime
declare	@weekdays int
declare	@Counter int

set		@procdate = @fromdate 
set		@Counter = 0

while (@Counter < @Days) 
begin
	IF datepart(dw, @procdate) in(1,7) begin
		set @Counter = @Counter + 0
		set @procdate = dateadd(d, 1, @procdate)
	end
	ELSE begin
		set @Counter = @Counter + 1
		set @procdate = dateadd(d, 1, @procdate)
	end
end
---
Select @enddate = @procdate
return @enddate
end
GO
