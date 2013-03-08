USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_Metrics_TypeOfRequestsPerCustomer]    Script Date: 03/04/2013 11:29:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_Metrics_TypeOfRequestsPerCustomer]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	Customer
,	ReQuotes
,	NewQuotes
from
	(	select
			Customer = ql.Customer
		,	ReQuotes = (	select	COUNT(Requote)
							from	eeiuser.QT_QuoteLog
							where	Requote = 'Y'
									and Customer = ql.Customer
									and DATEPART(yyyy, ReceiptDate) = DATEPART(yyyy, getdate())	)
		,	NewQuotes = (	select	COUNT(Requote)
							from	eeiuser.QT_QuoteLog
							where	Requote = 'N'
									and Customer = ql.Customer
									and DATEPART(yyyy, ReceiptDate) = DATEPART(yyyy, getdate())	)
		,	Ranking = row_number() OVER (ORDER BY
						(	select	COUNT(Requote)
							from	eeiuser.QT_QuoteLog
							where	Requote in ('N', 'Y')
									and Customer = ql.Customer
									and DATEPART(yyyy, ReceiptDate) = DATEPART(yyyy, getdate())	) desc)
		from 
			eeiuser.QT_QuoteLog ql
		where
			DATEPART(yyyy, ql.ReceiptDate) = DATEPART(yyyy, getdate())
		group by
			ql.Customer
	) tResult
where
	Ranking <= 12
order by
	tResult.Customer
--- </Body>

GO

