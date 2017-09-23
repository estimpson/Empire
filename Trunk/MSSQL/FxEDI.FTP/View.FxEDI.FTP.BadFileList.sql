
/*
Create View.FxEDI.FTP.BadFileList.sql
*/

use FxEDI
go

--drop table FTP.BadFileList
if	objectproperty(object_id('FTP.BadFileList'), 'IsView') = 1 begin
	drop view FTP.BadFileList
end
go

create view FTP.BadFileList
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
	and rfl.ReceiveFileGUID is not null
	and rfl.SourceCRC32 != rfl.ReceiveCRC32
go

select
	*
from
	FTP.BadFileList mfl
go

