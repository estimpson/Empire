USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_Metrics_OnTimeDelivery]    Script Date: 03/04/2013 11:26:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
					ql.CustomerQuoteDate is not null
					and ql.CustomerQuoteDate <= ql.EEIPromisedDueDate
					and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
,	Late = (	select
					COUNT(1)
				from
					eeiuser.QT_QuoteLog ql
				where
					ql.CustomerQuoteDate is not null
					and ql.CustomerQuoteDate > ql.EEIPromisedDueDate
					and datepart(yyyy, ql.CustomerQuoteDate) = datepart(yyyy, GETDATE())	)
--- </Body>

GO

