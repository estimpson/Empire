SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FTP].[OverallStatus]
as
select
	CurrentDatetime = getdate()
,	FilesMissing = convert(int, 0)
,	CorruptFiles = convert(int, 0)
,	RowID = 1
GO
