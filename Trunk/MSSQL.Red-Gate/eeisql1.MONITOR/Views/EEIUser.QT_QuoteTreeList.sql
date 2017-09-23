SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EEIUser].[QT_QuoteTreeList]
as
select 
	ql.RowID
,	ql.QuoteNumber
,	ql.ParentQuoteID
,	ql.ReceiptDate
,	ql.Customer
,	ql.EEIPartNumber
,	ql.ApplicationName
,	ql.QuotePrice
,	ql.Notes
from 
	eeiuser.qt_quotelog ql
where 
	ql.ParentQuoteID is not null
	
union all

select
	ql.RowID
,	ql.QuoteNumber
,	ql.ParentQuoteID
,	ql.ReceiptDate
,	ql.Customer
,	ql.EEIPartNumber
,	ql.ApplicationName
,	ql.QuotePrice
,	ql.Notes
from
	eeiuser.qt_quotelog ql
	join	(	select 
					ql1.ParentQuoteID
				from 
					eeiuser.qt_quotelog ql1
				where 
					ql1.ParentQuoteID is not null) as Parents
		on Parents.ParentQuoteID = ql.RowID
GO
