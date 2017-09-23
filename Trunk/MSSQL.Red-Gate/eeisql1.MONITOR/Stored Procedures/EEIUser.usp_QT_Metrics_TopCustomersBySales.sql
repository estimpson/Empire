SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_TopCustomersBySales]
as
set nocount on
set ansi_warnings off

--- <Body>
--- Top Customers by Total Sales Amount
select top 10
	Customer = ql.Customer
,	floor(sum(ql.TotalQuotedSales)) as TotalSales
from 
	eeiuser.QT_QuoteLog ql
where
	DATEPART(yyyy, ql.ReceiptDate) = DATEPART(yyyy, getdate())
group by
	ql.Customer
order by
	TotalSales desc
--- </Body>
GO
