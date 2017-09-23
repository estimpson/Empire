SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [TRWEDI].[StagingDocument862s]
as
select
	DocumentGUID = sfh.RawDocumentGUID
,	DocumentQueue = 0 --(Incoming)
,	DocumentStatus = sfh.Status
,	DocumentStatusName = 'Staging'
,	DocumentType = 'TRW DELJIT'
,	DocumentNumber = sfh.DocNumber
,	DocumentRevision = sfh.Version
,	OriginalDate = sfh.DocumentDT
,	DocumentArrivalDate = sfh.DocumentImportDT
,	ProcessedDate = sfh.RowCreateDT
,	ShipToCode = std.ShipToCode
,	ShipToName = std.ShipToName
,	BillToCode = std.BillToCode
,	BillToName = std.BillToName
,	EDIOverlayGroup = std.EDIOverlayGroup
,	EDIOperatorCode = std.EDIOperatorCode
from
	EDI.StagingTRW_DELJIT_Headers sfh
	join EDI.StagingTRW_DELJIT_Releases sfr
		on sfr.RawDocumentGUID = sfh.RawDocumentGUID
	join TRWEDI.BlanketOrders bo
		on bo.ShipToCode = sfr.ShipToCode
		and bo.CustomerPart = sfr.CustomerPart
		and bo.ProcessReleases = 1
	join EDI.ShipToDimensions std
		on std.ShipToCode = bo.ShipToCode
group by
	sfh.RawDocumentGUID
,	sfh.Status
,	sfh.DocNumber
,	sfh.Version
,	sfh.DocumentDT
,	sfh.DocumentImportDT
,	sfh.RowCreateDT
,	std.ShipToCode
,	std.ShipToName
,	std.BillToCode
,	std.BillToName
,	std.EDIOverlayGroup
,	std.EDIOperatorCode
GO
