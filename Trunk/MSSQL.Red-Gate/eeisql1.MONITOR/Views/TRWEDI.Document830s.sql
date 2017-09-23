SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [TRWEDI].[Document830s]
as
select
	DocumentGUID = fh.RawDocumentGUID
,	DocumentQueue = 0 --?
,	DocumentStatus = fh.Status
,	DocumentType = 'TRW 830'
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
	EDI.TRW_DELFOR_Headers fh
	join EDI.TRW_DELFOR_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	join TRWEDI.BlanketOrders bo
		on bo.ShipToCode in (fr.ICCode, fr.ShipToCode)
		and bo.CustomerPart = fr.CustomerPart
		and bo.ProcessReleases = 1
	join EDI.ShipToDimensions std
		on std.ShipToCode = bo.ShipToCode
group by
	fh.RawDocumentGUID
,	fh.Status
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
