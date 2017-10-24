
/*
Create View.EEH.FT.Costing_POReceiverItemsHistorical_All.sql
*/

use EEH
go

--drop table FT.Costing_POReceiverItemsHistorical_All
if	objectproperty(object_id('FT.Costing_POReceiverItemsHistorical_All'), 'IsView') = 1 begin
	drop view FT.Costing_POReceiverItemsHistorical_All
end
go

create view FT.Costing_POReceiverItemsHistorical_All
as
select
	csp.SnapshotDT
,	csp.Reason
,	cprih.PONumber
,	cprih.BillOfLading
,	cprih.BillOfLadingLine
,	cprih.Receiver
,	cprih.BeginDT
,	cprih.EndDT
,	cprih.Invoice
,	cprih.InvoiceLine
,	cprih.Item
,	cprih.Approved
,	cprih.ReceiverComments
,	cprih.LedgerAccountCode
,	cprih.QuantityReceived
,	cprih.UnitCost
,	cprih.ChangedDate
,	cprih.ChangedUserId
,	cprih.TotalCost
,	cprih.ItemDescription
,	cprih.FreightCost
,	cprih.OtherCost
,	cprih.MonthEnd
,	cprih.BinCheckSum
,	cprih.LastSnapshotRowID
,	csp.RowID
,	csp.RowCreateDT
,	csp.RowCreateUser
,	csp.RowModifiedDT
,	csp.RowModifiedUser
from
	FT.Costing_Snapshots_PRI csp
	join FT.Costing_POReceiverItemsHistorical cprih
		on csp.SnapshotDT between cprih.BeginDT and cprih.EndDT
go

select
	cpriha.SnapshotDT
,	count(*)
from
	FT.Costing_POReceiverItemsHistorical_All cpriha
where
	cpriha.SnapshotDT > '2014-01-31'
group by
	cpriha.SnapshotDT
order by
	1
go
