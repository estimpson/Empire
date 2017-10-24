
/*
Create View.FxEDI.FTP.MissingFileList.sql
*/

use FxEDI
go

--drop table FTP.MissingFileList
if	objectproperty(object_id('FTP.MissingFileList'), 'IsView') = 1 begin
	drop view FTP.MissingFileList
end
go

create view FTP.MissingFileList
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
go

select
	*
from
	FTP.MissingFileList mfl
go

