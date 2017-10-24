SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [TRWEDI].[Document862s]
as
select
	DocumentGUID = fh.RawDocumentGUID
,	DocumentQueue = 0 --(Incoming)
,	DocumentStatus = fh.Status
,	DocumentStatusName = sd.StatusName
,	DocumentType = 'TRW DELJIT'
,	DocumentNumber = fh.DocNumber
,	DocumentRevision = fh.Version
,	OriginalDate = fh.DocumentDT
,	DocumentArrivalDate = fh.DocumentImportDT
,	ProcessedDate = fh.RowCreateDT
,	ShipToCode = std.ShipToCode
,	ShipToName = std.ShipToName
,	BillToCode = std.BillToCode
,	BillToName = std.BillToName
,	EDIOverlayGroup = std.EDIOverlayGroup
,	EDIOperatorCode = std.EDIOperatorCode
from
	EDI.TRW_DELJIT_Headers fh
	join EDI.TRW_DELJIT_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	join TRWEDI.BlanketOrders bo
		on bo.ShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and bo.ProcessReleases = 1
	join EDI.ShipToDimensions std
		on std.ShipToCode = bo.ShipToCode
	join FT.StatusDefn sd
		on sd.StatusTable = 'EDI.TRW_DELJIT_Headers'
		and sd.StatusColumn = 'Status'
		and sd.StatusCode = fh.Status
group by
	fh.RawDocumentGUID
,	fh.Status
,	sd.StatusName
,	fh.DocNumber
,	fh.Version
,	fh.DocumentDT
,	fh.DocumentImportDT
,	fh.RowCreateDT
,	std.ShipToCode
,	std.ShipToName
,	std.BillToCode
,	std.BillToName
,	std.EDIOverlayGroup
,	std.EDIOperatorCode
GO
