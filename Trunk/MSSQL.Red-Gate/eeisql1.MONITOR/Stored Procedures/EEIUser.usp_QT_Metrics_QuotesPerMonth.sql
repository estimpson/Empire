SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_QuotesPerMonth]
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@CurrentDate datetime
,	@CurrentYear int
,	@Year int
,	@Month int
,	@MonthName varchar(12)
,	@Day int


declare @tempQuotes table
(
	QuoteYear int
,	QuoteMonth varchar(12)
,	QuoteMonthInt int
,	NumberOfQuotes int
)
	
set @CurrentDate = GETDATE()
set @CurrentYear = DATEPART(yyyy, @CurrentDate)
set @Year = DATEPART(yyyy, @CurrentDate)
set @Month = DATEPART(mm, @CurrentDate)
set @Day = DATEPART(dd, @CurrentDate)

select @MonthName =
	case
		when @Month = 1 then 'JAN'
		when @Month = 2 then 'FEB'
		when @Month = 3 then 'MAR'
		when @Month = 4 then 'APR'
		when @Month = 5 then 'MAY'
		when @Month = 6 then 'JUN'
		when @Month = 7 then 'JUL'
		when @Month = 8 then 'AUG'
		when @Month = 9 then 'SEP'
		when @Month = 10 then 'OCT'
		when @Month = 11 then 'NOV'
		when @Month = 12 then 'DEC'
	end

-- Get quotes received for the current month
insert 
	@tempQuotes
(	QuoteYear
,	QuoteMonth
,	QuoteMonthInt
,	NumberOfQuotes
)
select
	QuoteYear = @Year
,	QuoteMonth = @MonthName
,	QuoteMonthInt = @Month
,	NumberOfQuotes = count(ReceiptDate)
from 
	EEIUser.QT_QuoteLog
where
	ReceiptDate <= @CurrentDate
	and DATEPART(mm, ReceiptDate) = @Month
	and DATEPART(yyyy, ReceiptDate) = @Year 


-- Get quotes received for all other months of the current year
set @Month = @Month - 1
while (@Month > 0) begin

	select @MonthName =
		case
			when @Month = 1 then 'JAN'
			when @Month = 2 then 'FEB'
			when @Month = 3 then 'MAR'
			when @Month = 4 then 'APR'
			when @Month = 5 then 'MAY'
			when @Month = 6 then 'JUN'
			when @Month = 7 then 'JUL'
			when @Month = 8 then 'AUG'
			when @Month = 9 then 'SEP'
			when @Month = 10 then 'OCT'
			when @Month = 11 then 'NOV'
			when @Month = 12 then 'DEC'
		end
	
	insert 
		@tempQuotes
	(	QuoteYear
	,	QuoteMonth
	,	QuoteMonthInt
	,	NumberOfQuotes
	)
	select
		QuoteYear = @Year
	,	QuoteMonth = @MonthName
	,	QuoteMonthInt = @Month
	,	NumberOfQuotes = count(ReceiptDate)
	from 
		EEIUser.QT_QuoteLog
	where
		DATEPART(mm, ReceiptDate) = @Month
		and DATEPART(yyyy, ReceiptDate) = @Year 

	set @Month = @Month - 1
end



-- Get quotes received for each month of the prior four years
set @Year = @Year - 1
set @Month = 12
while (@Year > @CurrentYear - 5) begin
	while (@Month > 0) begin

		select @MonthName =
			case
				when @Month = 1 then 'JAN'
				when @Month = 2 then 'FEB'
				when @Month = 3 then 'MAR'
				when @Month = 4 then 'APR'
				when @Month = 5 then 'MAY'
				when @Month = 6 then 'JUN'
				when @Month = 7 then 'JUL'
				when @Month = 8 then 'AUG'
				when @Month = 9 then 'SEP'
				when @Month = 10 then 'OCT'
				when @Month = 11 then 'NOV'
				when @Month = 12 then 'DEC'
			end
			
		insert 
			@tempQuotes
		(	QuoteYear
		,	QuoteMonth
		,	QuoteMonthInt
		,	NumberOfQuotes
		)
		select
			QuoteYear = @Year
		,	QuoteMonth = @MonthName
		,	QuoteMonthInt = @Month
		,	NumberOfQuotes = count(ReceiptDate)
		from 
			EEIUser.QT_QuoteLog
		where
			DATEPART(mm, ReceiptDate) = @Month
			and DATEPART(yyyy, ReceiptDate) = @Year 

		set @Month = @Month - 1
	end
	
	set @Year = @Year - 1	
	set @Month = 12
end
--- </Body>
	
	
--- <Return>	
select 
	QuoteYear
,	QuoteMonth
,	NumberOfQuotes
from 
	@tempQuotes
order by
	QuoteMonthInt
--- </Return>
GO
