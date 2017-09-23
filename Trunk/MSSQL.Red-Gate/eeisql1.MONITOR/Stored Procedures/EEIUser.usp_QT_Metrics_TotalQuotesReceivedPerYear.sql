SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_TotalQuotesReceivedPerYear]
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@CurrentDate datetime
,	@Year int

declare @tempQuotes table
(
	QuoteYear varchar(4)
,	NumberOfQuotes int
)
	
set @CurrentDate = GETDATE()
set @Year = DATEPART(yyyy, @CurrentDate)

-- Get total received quotes for current year
insert 
	@tempQuotes
(	QuoteYear
,	NumberOfQuotes
)
select
	QuoteYear = CONVERT(varchar, @Year)
,	NumberOfQuotes = count(ReceiptDate)
from 
	EEIUser.QT_QuoteLog
where
	DATEPART(yyyy, ReceiptDate) = @Year 



-- Get total received quotes for every year after 2006
set @Year = @Year - 1
while (@Year > 2006) begin
	insert 
		@tempQuotes
	(	QuoteYear
	,	NumberOfQuotes
	)
	select
		QuoteYear = CONVERT(varchar, @Year)
	,	NumberOfQuotes = count(ReceiptDate)
	from 
		EEIUser.QT_QuoteLog
	where
		DATEPART(yyyy, ReceiptDate) = @Year 
		
	set @Year = @Year - 1
end
--- </Body>
	
	
--- <Return>	
select 
	QuoteYear
,	NumberOfQuotes
from 
	@tempQuotes
--- </Return>
GO
