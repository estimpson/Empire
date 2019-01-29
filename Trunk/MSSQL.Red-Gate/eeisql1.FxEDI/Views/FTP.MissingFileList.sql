SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FTP].[MissingFileList]
as
select
	rfl.SourceFileName
,	rfl.Status
,	rfl.Type
,	rfl.SourceFileLength
,	rfl.SourceCRC32
,	rfl.SourceFileDT
,	rfl.SourceFileAvailable
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
where
	rfl.SourceFileAvailable = 1
	and rfl.ReceiveFileGUID is null
	and rfl.Status = 1
GO
