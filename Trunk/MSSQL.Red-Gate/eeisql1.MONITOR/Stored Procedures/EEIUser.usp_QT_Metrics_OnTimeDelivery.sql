SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_OnTimeDelivery]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	OnTime = (	select
					COUNT(1)
				from
					eeiuser.QT_QuoteLog ql
				where
					ql.EngineeringMaterialsDate is not null
					and ql.QuoteStatus != 'NO QUOTE'
					--and ql.EngineeringMaterialsDate <= ql.EEIPromisedDueDate
					and ql.EngineeringMaterialsDate <= coalesce(ql.RequestedDueDate, ql.EEIPromisedDueDate)
					and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
,	Late = (	select
					COUNT(1)
				from
					eeiuser.QT_QuoteLog ql
				where
					ql.EngineeringMaterialsDate is not null
					and ql.QuoteStatus != 'NO QUOTE'
					--and ql.EngineeringMaterialsDate > ql.EEIPromisedDueDate
					and ql.EngineeringMaterialsDate > coalesce(ql.RequestedDueDate, ql.EEIPromisedDueDate)
					and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
--- </Body>
GO
