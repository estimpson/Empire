SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create view [EEIUser].[QL_QuoteTransfer_AwardedQuoteNumbers]
as
select
	ql.QuoteNumber as QuoteNumber
,	ql.EEIPartNumber as EEIPartNumber
,	ql.RowID as RowID
from
	eeiuser.QT_QuoteLog ql
where
	ql.Awarded = 'Y'


GO
