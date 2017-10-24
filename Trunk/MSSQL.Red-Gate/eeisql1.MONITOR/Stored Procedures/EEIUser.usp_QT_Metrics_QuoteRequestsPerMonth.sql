SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_QuoteRequestsPerMonth]
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@Year int
,	@Month int
,	@MonthName varchar(12)


declare @tempQuotes table
(
	QuoteEngineer varchar(50)
,	QuoteMonthInt int
,	QuoteMonth varchar(12)
,	NumberOfQuotes int
)
	
declare 
	@QEList varchar(150)
,	@QE varchar(50)

exec EEIUser.usp_QT_Metrics_GetQuoteEngineers @QEList out

while (@QEList != '') begin
	if (PATINDEX('%,%', @QEList) > 0) begin
		set @QE = SUBSTRING(@QEList,0, PATINDEX('%,%', @QEList))
	end
	else begin
		set @QE = @QEList
	end		
	
	set @Month = DATEPART(mm, GETDATE())
	set @Year = DATEPART(yyyy, GETDATE())

	-- Get quotes received for all months of the current year up to the current date
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
			
		insert @tempQuotes
		(
			QuoteEngineer
		,	QuoteMonthInt
		,	QuoteMonth
		,	NumberOfQuotes
		)
		select
			QuoteEngineer = @QE
		,	QuoteMonthInt = @Month
		,	QuoteMonth = @MonthName
		,	NumberOfQuotes = COUNT(ql.ReceiptDate)
		from	
			eeiuser.QT_QuoteLog ql
		where	
			ql.EngineeringInitials = @QE
			and DATEPART(mm, ReceiptDate) = @Month
			and DATEPART(yyyy, ql.ReceiptDate) = @Year
			
		set @Month = @Month - 1
	end
	
	if (PATINDEX('%,%', @QEList) > 0) begin
		set @QEList = SUBSTRING(@QEList, PATINDEX('%,%', @QEList) + 1, LEN(@QEList))
	end
	else begin
		set @QEList = ''
	end
end
--- </Body>
	
	
--- <Return>
select 
	QuoteEngineer = 
		case
			when (coalesce(qei.FirstName, '') <> '') then qei.FirstName
			else tq.QuoteEngineer
		end
,	QuoteMonth
,	NumberOfQuotes
from 
	@tempQuotes tq
	join EEIUser.QT_EngineeringInitials qei
		on qei.Initials = tq.QuoteEngineer
order by
	QuoteMonthInt
--- </Return>
GO
