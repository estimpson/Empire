SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[vw_QT_QuoteReasons]
as
select
	qr.QuoteReason
,	row_number() over(order by qr.QuoteReason) as RowId
from 
	eeiuser.QT_QuoteReasons qr

GO
