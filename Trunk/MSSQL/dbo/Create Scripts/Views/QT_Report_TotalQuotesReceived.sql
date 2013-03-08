USE [MONITOR]
GO

/****** Object:  View [EEIUser].[QT_Report_TotalQuotesReceived]    Script Date: 03/04/2013 11:34:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [EEIUser].[QT_Report_TotalQuotesReceived]
as
(
	select
		QuoteYear = '2007'
	,	NumberOfQuotes = count(ReceiptDate)
	from 
		EEIUser.QT_QuoteLog
	where
		ReceiptDate < CONVERT(datetime, '2008-1-1')
	union all
	select 
		QuoteYear = '2008'
	,	NumberOfQuotes = count(ReceiptDate)
	from 
		EEIUser.QT_QuoteLog
	where 
		ReceiptDate > CONVERT(datetime, '2008-1-1')
		and ReceiptDate < CONVERT(datetime, '2008-12-1')
)
	

GO

