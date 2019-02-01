SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_OnTimeDaysLateBreakdown]
as
set nocount on
set ansi_warnings off

--- <Body>
declare	
	@DaysLate int

declare @temp table
(
	Category varchar(50)
,	NumberOfDaysLate int
)


select 
	@DaysLate = count(*)
from
	eeiuser.QT_QuoteLog ql
where
	ql.EngineeringMaterialsDate is not null
	and ql.QuoteStatus != 'NO QUOTE'
	--and datediff(day, ql.EEIPromisedDueDate, ql.EngineeringMaterialsDate) between 1 and 4
	and datediff(day, coalesce(ql.RequestedDueDate, ql.EEIPromisedDueDate), ql.EngineeringMaterialsDate) between 1 and 4
	and year(ql.CustomerQuoteDate) = year(getdate()) 	

insert @temp
(
	Category
,	NumberOfDaysLate
)
select
	'1 - 4 Days Late'
,	@DaysLate


select 
	@DaysLate = count(*)
from
	eeiuser.QT_QuoteLog ql
where
	ql.EngineeringMaterialsDate is not null
	and ql.QuoteStatus != 'NO QUOTE'
	--and datediff(day, ql.EEIPromisedDueDate, ql.EngineeringMaterialsDate) between 5 and 14
	and datediff(day, coalesce(ql.RequestedDueDate, ql.EEIPromisedDueDate), ql.EngineeringMaterialsDate) between 5 and 14
	and year(ql.CustomerQuoteDate) = year(getdate()) 
	
insert @temp
(
	Category
,	NumberOfDaysLate
)
select
	'5 - 14 Days Late'
,	@DaysLate


select 
	@DaysLate = count(*)
from
	eeiuser.QT_QuoteLog ql
where
	ql.EngineeringMaterialsDate is not null
	and ql.QuoteStatus != 'NO QUOTE'
	--and datediff(day, ql.EEIPromisedDueDate, ql.EngineeringMaterialsDate) > 14
	and datediff(day, coalesce(ql.RequestedDueDate, ql.EEIPromisedDueDate), ql.EngineeringMaterialsDate) > 14
	and year(ql.CustomerQuoteDate) = year(getdate()) 
	
insert @temp
(
	Category
,	NumberOfDaysLate
)
select
	'15+ Days Late'
,	@DaysLate


-- Return result
select
	*
from
	@temp
--- </Body>
GO
