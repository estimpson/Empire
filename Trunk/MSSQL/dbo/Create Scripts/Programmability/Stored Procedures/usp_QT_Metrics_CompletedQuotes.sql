USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_Metrics_CompletedQuotes]    Script Date: 03/04/2013 11:25:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_Metrics_CompletedQuotes]
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@CurrentYear int

-- Get quotes that were completed this year
set @CurrentYear = DATEPART(yyyy, GETDATE())	
select
	OnTime = (	select	COUNT(1)
				from	EEIUser.QT_QuoteLog
				where	DATEPART(yyyy, CustomerQuoteDate) = @CurrentYear
						and CustomerQuoteDate is not null
						and CustomerQuoteDate <= EEIPromisedDueDate)
,	Late = (	select	COUNT(1)
				from	EEIUser.QT_QuoteLog
				where	DATEPART(yyyy, CustomerQuoteDate) = @CurrentYear
						and CustomerQuoteDate is not null
						and CustomerQuoteDate > EEIPromisedDueDate)
--- </Body>
GO

