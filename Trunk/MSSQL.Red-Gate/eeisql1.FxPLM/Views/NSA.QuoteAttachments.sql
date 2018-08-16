SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[QuoteAttachments]
as
select
	qqa.QuoteNumber
,	qqa.AttachmentCategory
,	qqa.AttachmentFileName
,	qqa.FileType
,	qqa.FileSize
,	qqa.CreationDT
,	qqa.LastWriteDT
,	qqa.LastAccessDT
,	qqa.IsDirectory
,	RowID = isnull(row_number() over (order by qqa.QuoteNumber, qqa.AttachmentCategory, qqa.AttachmentFileName), 0)
from
	EEISQL2.FxUtilities.FS.QT_QuoteAttachments qqa
GO
