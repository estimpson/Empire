SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[udf_GetPeriodBounds.bk]
(	@Period varchar(1000) -- null (Custom), YTD (Year To Date), MTD (Month To Date), -1Mo (Last Month), 0Mo (Current Month), 1Mo (Next Month), Ja|JAN (January), Fe|FEB (February), Mr|MAR (March), Ap|APR (April), My|MAY (May), Je|JUN (June), Jy|JUL (July), Au|AUG (August), Se|SEP (September), Oc|OCT (October), No|NOV (November), De|DEC (December)
,	@Year int = null
,	@Month int = null
,	@FromDT datetime = null
,	@ToDT datetime = null
)
returns @Bounds table
(	Period varchar(1000)
,	FromDT datetime
,	ToDT datetime
)
as
begin
--- <Body>
	declare
		@NowDT datetime
	
	set	@NowDT = (select CurrentDatetime from dbo.vwGetDate)
	
	insert
		@Bounds
	(	Period
	,	FromDT
	,	ToDT
	)
	select
		Period
	,	FromDT
	,	ToDT =
		case
			when coalesce (Period, 'Custom') = 'Custom'
				then coalesce
				(	dateadd(day, 1, @ToDT)
				,	convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, dateadd(month, coalesce(@Month, 1), '2001-01-01')) + ' ' + convert(varchar, coalesce (@Year, datepart(year, @nowDT))))
				)
			when Period in ('YTD', 'Year To date', 'MTD', 'Month To Date')
				then convert(datetime, /*dd mmmm yyyy*/ datename(day, @NowDT) + ' ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT)) + 1
			when Period in ('-1Mo', 'LMo', 'Last Month', '0Mo', 'Current Month', '1Mo', 'Next Month') or Period like '-[0-9]Mo' or Period like '[0-9]Mo' or Period in
				(	'Ja', 'JAN', 'January'
				,	'Fe', 'FEB', 'February'
				,	'Mr', 'MAR', 'March'
				,	'Ap', 'APR', 'April'
				,	'My', 'MAY', 'May'
				,	'Je', 'JUN', 'June'
				,	'Jy', 'JUL', 'July'
				,	'Au', 'AUG', 'August'
				,	'Se', 'SEP', 'September'
				,	'Oc', 'OCT', 'October'
				,	'No', 'NOV', 'November'
				,	'De', 'DEC', 'December'
				)
				then dateadd(month, 1, FromDT)
		end
	from
		(	select
				Period = Period
			,	FromDT =
				case
					when coalesce (Period, 'Custom') = 'Custom'
						then coalesce
						(	@FromDT
						,	convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, dateadd(month, coalesce(@Month - 1, 0), '2001-01-01')) + ' ' + convert(varchar, coalesce (@Year, datepart(year, @nowDT))))
						)
					when Period in ('YTD', 'Year To date')
						then convert(datetime, /*dd mmmm yyyy*/ '01 January ' + datename(year, @NowDT))
					when Period in ('MTD', 'Month To date')
						then convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT))
					when Period in ('-1Mo', 'LMo', 'Last Month')
						then dateadd(month,  -1, convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT)))
					when Period in ('0Mo', 'Current Month')
						then convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT))
					when Period in ('1Mo', 'Next Month')
						then dateadd(month,  1, convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT)))
					when Period like '-[0-9]Mo'
						then dateadd(month,  -convert(int, substring(Period, 2, 1)), convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT)))
					when Period like '[0-9]Mo'
						then dateadd(month,  convert(int, substring(Period, 1, 1)), convert(datetime, /*dd mmmm yyyy*/ '01 ' + datename(month, @NowDT) + ' ' + datename(year, @NowDT)))
					when Period in ('Ja', 'JAN', 'January')
						then convert(datetime, /*dd mmmm yyyy*/ '01 January ' + datename(year, @NowDT))
					when Period in ('Fe', 'FEB', 'February')
						then convert(datetime, /*dd mmmm yyyy*/ '01 February ' + datename(year, @NowDT))
					when Period in ('Mr', 'MAR', 'March')
						then convert(datetime, /*dd mmmm yyyy*/ '01 March ' + datename(year, @NowDT))
					when Period in ('Ap', 'APR', 'April')
						then convert(datetime, /*dd mmmm yyyy*/ '01 April ' + datename(year, @NowDT))
					when Period in ('My', 'MAY', 'May')
						then convert(datetime, /*dd mmmm yyyy*/ '01 May ' + datename(year, @NowDT))
					when Period in ('Je', 'JUN', 'June')
						then convert(datetime, /*dd mmmm yyyy*/ '01 June ' + datename(year, @NowDT))
					when Period in ('Jy', 'JUL', 'July')
						then convert(datetime, /*dd mmmm yyyy*/ '01 July ' + datename(year, @NowDT))
					when Period in ('Au', 'AUG', 'August')
						then convert(datetime, /*dd mmmm yyyy*/ '01 August ' + datename(year, @NowDT))
					when Period in ('Se', 'SEP', 'September')
						then convert(datetime, /*dd mmmm yyyy*/ '01 September ' + datename(year, @NowDT))
					when Period in ('Oc', 'OCT', 'October')
						then convert(datetime, /*dd mmmm yyyy*/ '01 October ' + datename(year, @NowDT))
					when Period in ('No', 'NOV', 'November')
						then convert(datetime, /*dd mmmm yyyy*/ '01 November ' + datename(year, @NowDT))
					when Period in ('De', 'DEC', 'December')
						then convert(datetime, /*dd mmmm yyyy*/ '01 December ' + datename(year, @NowDT))
				end
			from
				(	select
						Period = rtrim(ltrim(value))
					from
						FT.udf_SplitStringToRows(@Period, ',') usstr
				) Periods
		) BeginBounds

/*	(null)|Custom
,	YTD|Year To Date
,	MTD|Month To Date
,	-1Mo|Last Month
,	0Mo|Current Month
,	1Mo|Next Month
,	{n}Mo {+/- n Month}
,	Ja|JAN|January
,	Fe|FEB|February
,	Mr|MAR|March
,	Ap|APR|April
,	My|MAY|May
,	Je|JUN|June
,	Jy|JUL|July
,	Au|AUG|August
,	Se|SEP|September
,	Oc|OCT|October
,	No|NOV|November
,	De|DEC|December
*/
--- </Body>

---	<Return>
	return
end
GO
