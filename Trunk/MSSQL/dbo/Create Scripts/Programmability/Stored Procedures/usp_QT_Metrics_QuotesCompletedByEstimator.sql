USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_Metrics_QuotesCompletedByEstimator]    Script Date: 03/04/2013 11:27:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_Metrics_QuotesCompletedByEstimator]
as
set nocount on
set ansi_warnings off

--- <Body>
declare @tempCompletedQuotes table
(
	QuoteEngineer varchar(50)
,	OnTime int
,	Late int
)

declare 
	@QEList varchar(255)
,	@QE varchar(50)

set @QEList = 'TB,SH,DC,DG,MM'

while (@QEList != '') begin
	if (PATINDEX('%,%', @QEList) > 0) begin
		set @QE = SUBSTRING(@QEList,0, PATINDEX('%,%', @QEList))
	end
	else begin
		set @QE = @QEList
	end	

	insert @tempCompletedQuotes
	(
		QuoteEngineer
	,	OnTime
	,	Late
	)
	select
		QuoteEngineer = @QE
	,	OnTime = (	select
						COUNT(1)
					from
						eeiuser.QT_QuoteLog ql
					where
						ql.EngineeringInitials = @QE
						and ql.CustomerQuoteDate is not null
						and ql.CustomerQuoteDate <= ql.EEIPromisedDueDate
						and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
	,	Late = (	select
						COUNT(1)
					from
						eeiuser.QT_QuoteLog ql
					where
						ql.EngineeringInitials = @QE
						and ql.CustomerQuoteDate is not null
						and ql.CustomerQuoteDate > ql.EEIPromisedDueDate
						and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
	
	if (PATINDEX('%,%', @QEList) > 0) begin
		set @QEList = SUBSTRING(@QEList, PATINDEX('%,%', @QEList) + 1, LEN(@QEList))
	end
	else begin
		set @QEList = ''
	end
end

update @tempCompletedQuotes set QuoteEngineer = 'Tony' where QuoteEngineer = 'TB'
update @tempCompletedQuotes set QuoteEngineer = 'Steve' where QuoteEngineer = 'SH'
update @tempCompletedQuotes set QuoteEngineer = 'Deana' where QuoteEngineer = 'DC'
update @tempCompletedQuotes set QuoteEngineer = 'Derek' where QuoteEngineer = 'DG'
update @tempCompletedQuotes set QuoteEngineer = 'Mike' where QuoteEngineer = 'MM'
--- </Body>
	
	
--- <Return>	
select 
	QuoteEngineer
,	OnTime
,	Late
from 
	@tempCompletedQuotes
--- </Return>
GO

