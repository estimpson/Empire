SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[QuoteReasons]
as
select
	QuoteReasonID = qqr.ID
,	qqr.QuoteReason
,	RowID = qqr.ID
from
	MONITOR.EEIUSer.QT_QuoteReasons qqr
GO
