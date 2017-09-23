SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_DateName]
(	@DatePart varchar (9),
	@ArgDT datetime)
returns	nvarchar(25)
begin
	declare @Return nvarchar (25)
	set	@Return =
		case	when @DatePart in ('Year', 'yyyy', 'yy', 'y') then
				datename (year, @ArgDT)
			when @DatePart in ('Quarter', 'qq', 'q') then
				datename (quarter, @ArgDT)
			when @DatePart in ('Month', 'mm', 'm') then
				datename (month, @ArgDT)
			when @DatePart in ('DayofYear', 'dy', 'jj', 'j') then
				datename (dayofyear, @ArgDT)
			when @DatePart in ('Day', 'dd', 'd') then
				datename (day, @ArgDT)
			when @DatePart in ('Week', 'wk', 'ww') then
				datename (week, @ArgDT)
			when @DatePart in ('Weekday', 'dw', 'kk', 'k') then
				datename (weekday, @ArgDT)
			when @DatePart in ('Hour', 'hh', 'h') then
				datename (hour, @ArgDT)
			when @DatePart in ('Minute', 'mi', 'n') then
				datename (minute, @ArgDT)
			when @DatePart in ('Second', 'ss', 's') then
				datename (second, @ArgDT)
			when @DatePart in ('Millisecond', 'ms', 'lll', 'l') then
				datename (millisecond, @ArgDT)
		end
	return @Return
end
GO
