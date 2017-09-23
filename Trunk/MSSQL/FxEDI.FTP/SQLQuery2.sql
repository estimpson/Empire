select
	ed.GUID
,	ed.Status
,	ed.FileName
,	ed.TradingPartner
,	ed.RowCreateDT
,	ed.Data
from
	EDI.EDIDocuments ed
where
	ed.RowCreateDT > getdate() - 5
	and ed.TradingPartner like 'A%'

update
	ed
set
	ed.FileName = 'XXX1c666c.xml'
from
	EDI.EDIDocuments ed
where
	ed.GUID = '677A41AC-6768-E711-BD52-005056ABBDF3'