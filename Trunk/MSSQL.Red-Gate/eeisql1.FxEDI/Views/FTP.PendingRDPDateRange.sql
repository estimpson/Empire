SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FTP].[PendingRDPDateRange]
as
select
	prdpdr.FromDT
,	prdpdr.ToDT
,	RowID = isnull(row_number() over(order by FromDT asc), -1)
from
	(	select
			FromDT = isnull(min(rdpFrom.ScheduledPollDT), '1900-01-01')
		,	ToDT = isnull(max(rdpTo.ScheduledPollDT), '1900-01-01')
		from
			FTP.ReceivedDirectoryPoll rdpFrom
			join FTP.ReceivedDirectoryPoll rdpTo
				on rdpTo.RowID = rdpFrom.RowID + 1
		where
			rdpTo.Status = 0
			and rdpTo.ScheduledPollDT < getdate()
	) prdpdr
GO
