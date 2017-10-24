SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Metrics_TypeOfRequests]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	Requote = 
		case
			when ql.Requote = 'N' then 'New Quotes'
			when ql.Requote = 'Y' then 'Re-Quotes'
			when ql.Requote = 'P' then 'ECN'
			when ql.Requote = 'S' then 'Service'
		end
,	Quantity = count(ql.Requote)
from 
	eeiuser.QT_QuoteLog ql
where
	DATEPART(yyyy, ql.ReceiptDate) = DATEPART(yyyy, getdate())
group by
	Requote
--- </Body>
GO
