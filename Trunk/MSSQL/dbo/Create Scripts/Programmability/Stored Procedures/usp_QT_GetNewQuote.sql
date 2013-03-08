USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_GetNewQuote]    Script Date: 03/04/2013 11:19:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_GetNewQuote]
	@NewQuoteNumber varchar(50) = null out
as
declare
	@year int = datepart(year, getdate())
,	@nextQuoteNumber int
,	@lastQuoteNumber varchar(50)
,	@lastQuoteNumberRoot int


-- Get the last new quote number (non-price change, non-bom modification)
select
	@lastQuoteNumber = ql.QuoteNumber
from
	EEIUser.QT_QuoteLog ql
where
	ql.RowID in (	
					select	max(RowID)
					from	EEIUser.QT_QuoteLog
				)
	and ql.QuoteNumber not like '%[A-Z]%'
	and ql.QuoteNumber not like '%-%-%' 
	and ql.QuoteNumber not like '%-[A-Z]%'

-- Remove the year from the last new quote number					
set @lastQuoteNumberRoot = convert(int, left(@lastQuoteNumber, patindex('%[^0-9]%', @lastQuoteNumber) - 1))


-- Get the system's next new quote number
select
	@nextQuoteNumber = NextQuoteNumber
from
	eeiuser.QT_NextQuote
where
	QuoteYear = @year
	
	
if (@lastQuoteNumberRoot <> (@nextQuoteNumber - 1)) begin
	-- Some quote numbers in the sequence have been deleted,
	--  so reset the next quote number to the last quote in the system
	set @nextQuoteNumber = @lastQuoteNumberRoot + 1

	update
		eeiuser.QT_NextQuote
	set
		NextQuoteNumber = @nextQuoteNumber + 1
	where
		QuoteYear = @year
end
else begin
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

