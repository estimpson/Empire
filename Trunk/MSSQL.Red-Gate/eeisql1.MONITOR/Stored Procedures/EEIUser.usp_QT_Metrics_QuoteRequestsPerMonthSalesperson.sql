SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Metrics_QuoteRequestsPerMonthSalesperson]
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
	SalesPerson varchar(50)
,	QuoteMonthInt int
,	QuoteMonth varchar(12)
,	NumberOfQuotes int
)
	
declare 
	@SalesList varchar(255)
,	@Salesperson varchar(50)

set @SalesList = 'PT'


-- Quotes received by specific salespeople
while (@SalesList != '') begin
	if (PATINDEX('%,%', @SalesList) > 0) begin
		set @Salesperson = SUBSTRING(@SalesList,0, PATINDEX('%,%', @SalesList))
	end
	else begin
		set @Salesperson = @SalesList
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
			Salesperson
		,	QuoteMonthInt
		,	QuoteMonth
		,	NumberOfQuotes
		)
		select
			Salesperson = @Salesperson
		,	QuoteMonthInt = @Month
		,	QuoteMonth = @MonthName
		,	NumberOfQuotes = COUNT(ql.ReceiptDate)
		from	
			eeiuser.QT_QuoteLog ql
		where	
			ql.SalesInitials = @Salesperson
			and DATEPART(mm, ReceiptDate) = @Month
			and DATEPART(yyyy, ql.ReceiptDate) = @Year
			
		set @Month = @Month - 1
	end
	
	if (PATINDEX('%,%', @SalesList) > 0) begin
		set @SalesList = SUBSTRING(@SalesList, PATINDEX('%,%', @SalesList) + 1, LEN(@SalesList))
	end
	else begin
		set @SalesList = ''
	end
end


-- Quotes received by all others
set @Month = DATEPART(mm, GETDATE())

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
		Salesperson
	,	QuoteMonthInt
	,	QuoteMonth
	,	NumberOfQuotes
	)
	select
		Salesperson = 'Other'
	,	QuoteMonthInt = @Month
	,	QuoteMonth = @MonthName
	,	NumberOfQuotes = COUNT(ql.ReceiptDate)
	from	
		eeiuser.QT_QuoteLog ql
	where	
		ql.SalesInitials != 'PT'
		and DATEPART(mm, ReceiptDate) = @Month
		and DATEPART(yyyy, ql.ReceiptDate) = @Year
		
	set @Month = @Month - 1
end	

update @tempQuotes set Salesperson = 'Pat' where Salesperson = 'PT'
--- </Body>
	
	
--- <Return>	
select 
	Salesperson
,	QuoteMonth
,	NumberOfQuotes
from 
	@tempQuotes
order by
	QuoteMonthInt
--- </Return>
GO
