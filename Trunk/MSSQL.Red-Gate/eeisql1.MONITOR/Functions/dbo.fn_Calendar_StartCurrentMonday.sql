SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fn_Calendar_StartCurrentMonday]
(	@EndDT datetime = null,
	@DatePart nvarchar (25) = null,
	@Increment integer = null,
	@Entries integer = null)
returns @Calendar table
	(	EntryDT datetime primary key)
begin
--	Declare Start date variable
-- example Select	[dbo].[fn_Calendar_StartCurrentMonday](	Null,'wk', 1, 16)
Declare	@BeginDT datetime
--	If EndDT, DatePart, Increment, and Entries are specified, determine BeginDT.
	set	@BeginDT = (Select CurrentWkMonday from dbo.vw_eei_getdate)
--	If BeginDT, DatePart, Increment, and Entries are specified, determine EndDT.
	set	@EndDT = isnull (@EndDT, FT.fn_DateAdd (@DatePart, @Increment * (@Entries - 1), @BeginDT))
--	If BeginDT and EndDT, DatePart, and Increment are specified, determine entries.
	set	@Entries = isnull (@Entries, 1 + FT.fn_DateDiff (@DatePart, @BeginDT, @EndDT) / @Increment)
--	If BeginDT and EndDT, DatePart, and Entries are specified, determine increment.
	set	@Increment = isnull (@Increment, (1 + FT.fn_DateDiff (@DatePart, @BeginDT, @EndDT)) / @Entries)

	while @BeginDT <= @EndDT and @Increment > 0 begin
		insert	@Calendar
		values	(@BeginDT)

		set @BeginDT = FT.fn_DateAdd (@DatePart, @Increment, @BeginDT)
	end
	return
end



GO
