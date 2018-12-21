SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
						and ql.QuoteStatus != 'NO QUOTE'
						--and ql.CustomerQuoteDate is not null
						--and ql.CustomerQuoteDate <= ql.EEIPromisedDueDate
						and ql.EngineeringMaterialsDate is not null
						and ql.EngineeringMaterialsDate <= ql.EEIPromisedDueDate
						and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
	,	Late = (	select
						COUNT(1)
					from
						eeiuser.QT_QuoteLog ql
					where
						ql.EngineeringInitials = @QE
						and ql.QuoteStatus != 'NO QUOTE'
						--and ql.CustomerQuoteDate is not null
						--and ql.CustomerQuoteDate > ql.EEIPromisedDueDate
						and ql.EngineeringMaterialsDate is not null
						and ql.EngineeringMaterialsDate > ql.EEIPromisedDueDate
						and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
	
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
		qei.FirstName + ' ' + left(qei.LastName, 1)
		--case
		--	when (coalesce(qei.FirstName, '') <> '') and (coalesce(qei.LastName, '') <> '') then qei.FirstName + ' ' + left(qei.LastName, 1)
		--	when (coalesce(qei.FirstName, '') <> '') then qei.FirstName
		--	else tcq.QuoteEngineer
		--end
,	OnTime
,	Late
from 
	@tempCompletedQuotes tcq
	join EEIUser.QT_EngineeringInitials qei
		on qei.Initials = tcq.QuoteEngineer
where
	tcq.OnTime > 0
	or tcq.Late > 0
	and (coalesce(qei.FirstName, '') <> '') and (coalesce(qei.LastName, '') <> '')
--- </Return>
GO
