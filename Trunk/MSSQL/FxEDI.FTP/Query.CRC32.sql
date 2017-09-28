use FxEDI
go

select
	*
,	RawData = convert (varchar(max), ed.Data)
,	CRC = FxUtilities.Fx.FileCRC(convert (varchar(max), ed.Data))
from
	FxEDI.EDI.EDIDocuments ed
where
	ed.Type not in ('DESADV', '856')
	and ed.FileName = 'ffe605.xml'

select
	RawData = convert (varchar(max), red.file_stream)
,	CRCOld = convert(varbinary, FxUtilities.dbo.CRC32(convert (varchar(max), red.file_stream)))
,	CRC = convert(varbinary, FxUtilities.Fx.FileCRC(convert (varchar(max), red.file_stream)))
,	*
from
	FxEDI.dbo.RawEDIData red
where
	red.name like '%.ffe605.xml'


select
	RawData = convert (varchar(max), red.file_stream)
,	CRCOld = convert(varbinary, FxUtilities.dbo.CRC32(convert (varchar(max), red.file_stream)))
,	CRC = convert(varbinary, FxUtilities.Fx.FileCRC(convert (varchar(max), red.file_stream)))
,	*
from
	FxEDI.dbo.RawEDIData red
where
	red.name like '%.ffe605.xml'

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
,	convert(varbinary, FxUtilities.Fx.FileStreamCRC(red.file_stream))
from
	FTP.ReceiveFileLog rfl
	join dbo.RawEDIData red
		on red.stream_id = rfl.ReceiveFileGUID
where
	rfl.RowCreateDT > getdate() - 1

select
	convert(varbinary, FxUtilities.dbo.CRC32 ('Test'))
,	convert(varbinary, FxUtilities.Fx.FileCRC ('Test'))
,	convert(varbinary(8), convert(varchar, convert(varbinary, FxUtilities.dbo.CRC32 ('Test')), 2), 2)