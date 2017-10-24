
/*
select
	*
from
	FT.Costing_Snapshots_PRI csp

truncate table
	FT.Costing_POReceiverItemsHistorical

drop table
	FT.Costing_POReceiverItemsHistorical

create table
	FT.Costing_POReceiverItemsHistorical
(	PONumber varchar(25) not null
,	BillOfLading varchar(25) not null
,	BillOfLadingLine smallint not null
,	Receiver varchar(25) not null
,	BeginDT datetime not null
,	EndDT datetime null
,	Invoice varchar(25) null
,	InvoiceLine smallint null
,	Item varchar(50) null
,	Approved char(1) null
,	ReceiverComments text null
,	LedgerAccountCode varchar(50) null
,	QuantityReceived numeric(18, 6) null
,	UnitCost numeric(18, 6) null
,	ChangedDate datetime null
,	ChangedUserId varchar(25) null
,	TotalCost numeric(18, 6) null
,	ItemDescription text null
,	FreightCost numeric(18, 6) null
,	OtherCost numeric(18, 6) null
,	MonthEnd varchar(1) null
,	BinCheckSum int
,	LastSnapshotRowID int
,	primary key
		(	PONumber
		,	BillOfLading
		,	BillOfLadingLine
		,	Receiver
		,	BeginDT
		)
)

create index ix_Costing_POReceiverItemsHistorical_1 on FT.Costing_POReceiverItemsHistorical (PONumber, BillOfLading, BillOfLadingLine, Receiver, EndDT, BinCheckSum)
create index ix_Costing_POReceiverItemsHistorical_2 on FT.Costing_POReceiverItemsHistorical (BeginDT, EndDT, PONumber, BillOfLading, BillOfLadingLine, Receiver)
*/
