use FxEDI
go

select
	*
,	RawData = convert (varchar(max), ed.Data)
,	CRC = FxUtilities.dbo.CRC32(convert (varchar(max), ed.Data))
from
	FxEDI.EDI.EDIDocuments ed
where
	ed.Type not in ('DESADV', '856')
	and ed.FileName = 'ffe605.xml'

select
	RawData = convert (varchar(max), red.file_stream)
,	CRC = convert(varbinary, FxUtilities.dbo.CRC32(convert (varchar(max), red.file_stream)))
,	*
from
	FxEDI.dbo.RawEDIData red
where
	red.name like '%.ffe605.xml'

select
	convert(varbinary, FxUtilities.dbo.CRC32 ('Test'))
,	convert(varbinary(8), convert(varchar, convert(varbinary, FxUtilities.dbo.CRC32 ('Test')), 2), 2)