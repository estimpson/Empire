SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_GetNewQuote]
	@NewQuoteNumber varchar(50) = null out
as
declare
	@year int = datepart(year, getdate())
,	@nextQuoteNumber int
,	@lastQuoteNumber varchar(50)
,	@lastQuoteNumberRoot int
,	@lastQuoteNumberYear int
,	@currentCentury char(2)


-- If we have just rolled into a new year, 
-- make sure a starting point exists for quote number generation.
if not exists
	(	select
			qnq.QuoteYear
		from
			eeiuser.QT_NextQuote qnq
		where
			qnq.QuoteYear = @year ) begin
	
	insert into eeiuser.QT_NextQuote
	(	QuoteYear
	,	NextQuoteNumber
	)
	values
	(	@year
	,	1
	)
	
	set @nextQuoteNumber = 1
end
else begin
	-- Get the system's next new quote number
	select
		@nextQuoteNumber = NextQuoteNumber
	from
		eeiuser.QT_NextQuote
	where
		QuoteYear = @year
end


-- Get the last new quote number (non-price change, non-bom modification)
select
	@lastQuoteNumber = ql.QuoteNumber
from
	EEIUser.QT_QuoteLog ql
where
	ql.RowID in (	select	max(RowID)
					from	EEIUser.QT_QuoteLog
					where	QuoteNumber not like '%[A-Z]%'
							and QuoteNumber not like '%-%-%' 
							and QuoteNumber not like '%-[A-Z]%'
	)
	
-- Get the current century
set @currentCentury = convert(char(2), left(convert(char(4), @year), 2))
	
-- Get the year from the last new quote number
set @lastQuoteNumberYear = convert(int, @currentCentury + right(@lastQuoteNumber,2))

-- Remove the year from the last new quote number			
set @lastQuoteNumberRoot = convert(int, left(@lastQuoteNumber, patindex('%[^0-9]%', @lastQuoteNumber) - 1))



if (@lastQuoteNumberRoot <> (@nextQuoteNumber - 1)) begin
	if (@lastQuoteNumberYear < @year) begin
		-- Rolling over from one year to the next, 
		--  so do not use the last quote number created.
		update
			eeiuser.QT_NextQuote
		set
			NextQuoteNumber = NextQuoteNumber + 1
		where
			QuoteYear = @year
	end
	else begin
		-- Some quote numbers in the sequence have been deleted,
		--  so reset the next quote number to the last quote in the system.
		set @nextQuoteNumber = @lastQuoteNumberRoot + 1

		update
			eeiuser.QT_NextQuote
		set
			NextQuoteNumber = @nextQuoteNumber + 1
		where
			QuoteYear = @year
	end
end
else begin
	-- Continue with the quote number sequence
	update
		eeiuser.QT_NextQuote
	set
		NextQuoteNumber = NextQuoteNumber + 1
	where
		QuoteYear = @year
end	
		
		
set	@NewQuoteNumber =
		case
			when @nextQuoteNumber < 1000 then right('000' + convert(varchar, @nextQuoteNumber), 4) + '-' + right(convert(varchar, @year), 2)
			else convert(varchar, @nextQuoteNumber) + '-' + right(convert(varchar, @year), 2)
		end
GO
