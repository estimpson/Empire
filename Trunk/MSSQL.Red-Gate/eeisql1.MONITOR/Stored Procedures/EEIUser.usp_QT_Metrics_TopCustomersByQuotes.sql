SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Metrics_TopCustomersByQuotes]
as
set nocount on
set ansi_warnings off

--- <Body>
--- Top Customers by Number of Quotes
select top 10
	Customer = ql.Customer
,	count(1) as QuotesReceived
from 
	eeiuser.QT_QuoteLog ql
where
	DATEPART(yyyy, ql.ReceiptDate) = DATEPART(yyyy, getdate())
group by
	ql.Customer
order by
	QuotesReceived desc
--- </Body>
GO
