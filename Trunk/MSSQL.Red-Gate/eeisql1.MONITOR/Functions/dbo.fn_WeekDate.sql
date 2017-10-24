SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fn_WeekDate]
(
	@AnyDate datetime
,	@DayOfWeek int)
returns datetime
as
begin
	declare
		@WeekDate datetime
	
	set	@WeekDate = dateadd(day, @DayOfWeek - datepart(dw, @AnyDate), FT.fn_TruncDate('day', @AnyDate))
	
	return
		@WeekDate
end
GO
