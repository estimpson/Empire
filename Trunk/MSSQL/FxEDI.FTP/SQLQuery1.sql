use FxEDI
go

select
	*
from
	FTP.TaskActivityMonitor tam

select
	*
from
	FTP.ReceivedDirectoryPoll rdp
where
	rdp.Status = 1
order by
	rdp.ScheduledPollDT desc

select
	rfl.SourceFileName
,	rfl.Status
,	rfl.Type
,	rfl.SourceFileLength
,	rfl.SourceCRC32
,	rfl.SourceFileDT
,	rfl.ReceiveFileGUID
,	rfl.ReceiveFileName
,	rfl.ReceiveCRC32
,	rfl.ReceiveFileLength
,	rfl.RowID
,	rfl.RowCreateDT
,	rfl.RowCreateUser
,	rfl.RowModifiedDT
,	rfl.RowModifiedUser
from
	FTP.ReceiveFileLog rfl
order by
	rfl.SourceFileDT desc

/*
update
	FTP.ReceivedDirectoryPoll
set	ReceivedDirectoryPoll.Status = 0
,	ReceivedDirectoryPoll.SourceFileCount = null
,	ReceivedDirectoryPoll.ReceivedFileCount = null
where
	ReceivedDirectoryPoll.RowID >= 84
*/