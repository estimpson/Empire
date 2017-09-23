SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEIACCT].[f_WeekName]
(
	@WeekNo int
)
returns nvarchar(17)
as
begin
--- <Body>
	declare
		@WeekDT datetime
	,	@WeekName nvarchar(17)

	set	@WeekDT = dateadd(week, @WeekNo, '2008-12-29')
	set	@WeekName =
			convert(nvarchar, @WeekNo + 1) + N' ' +
			convert(nvarchar, datepart(month, @WeekDT)) + N'/' +
			convert(nvarchar, datepart(day, @WeekDT)) + N' - ' +
			convert(nvarchar, datepart(month, @WeekDT + 6)) + N'/' +
			convert(nvarchar, datepart(day, @WeekDT + 6))

--- </Body>

---	<Return>
	return
		@WeekName
end
GO
