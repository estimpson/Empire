select
	recentDocs.RowCreateDT
,	RawData = left(recentDocs.RawData, 25) + '...'
,	XMLDataLength = len(recentDocs.RawData)
,	recentDocs.TradingPartner
,	recentDocs.Type
,	recentDocs.Version
,	recentDocs.EDIStandard
,	recentDocs.Release
,	recentDocs.DocNumber
,	recentDocs.ControlNumber
,	recentDocs.DeliverySchedule
,	recentDocs.MessageNumber
,	recentDocs.SourceType
,	recentDocs.MoparSSDDocument
,	recentDocs.VersionEDIFACTorX12
,	recentDocs.ID
,	recentDocs.GUID
,	recentDocs.Status
,	recentDocs.FileName
,	recentDocs.RowCreateUser
from
	(	select
			*
		,	RawData = convert (varchar(max), ed.Data)
		from
			EDI.EDIDocuments ed
		where
			ed.RowCreateDT > getdate() - 4
			and ed.Type not in ('DESADV', '856')
	) recentDocs
