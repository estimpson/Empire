SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FS].[QT_Files]
as
select
	StreamID = qf.stream_id
,	[FileContents] = qf.file_stream
,	[FileName] = qf.name
,	PathLocator = qf.path_locator
from
	dbo.QT_Files qf
GO
