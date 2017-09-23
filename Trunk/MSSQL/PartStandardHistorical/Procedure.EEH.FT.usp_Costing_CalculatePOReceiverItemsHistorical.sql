
/*
Create Procedure.EEH.FT.usp_Costing_CalculatePOReceiverItemsHistorical.sql
*/

use EEH
go

if	objectproperty(object_id('FT.usp_Costing_CalculatePOReceiverItemsHistorical'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_Costing_CalculatePOReceiverItemsHistorical
end
go

create procedure FT.usp_Costing_CalculatePOReceiverItemsHistorical
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

declare
	@snapshotDT datetime
,	@reason varchar(50)
,	@snapshotRowID int

select top 1
	@snapshotDT = csp.SnapshotDT
,	@reason = csp.Reason
,	@snapshotRowID = csp.RowID
from
	FT.Costing_Snapshots_PRI csp
where
	SnapshotDT >
		(	select
				coalesce(max(csp.SnapshotDT), '2000-01-01')
			from
				FT.Costing_POReceiverItemsHistorical cprih
				join FT.Costing_Snapshots_PRI csp
					on cprih.LastSnapshotRowID = csp.RowID
		)
order by
	1
,	2

if	@snapshotDT is null return

create table
	#PRINew
(	PONumber varchar(25) not null
,	BillOfLading varchar(25) not null
,	BillOfLadingLine smallint not null
,	Receiver varchar(25) not null
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
)

if	@reason = 'DAILY' begin

	insert
		#PRINew
	(	PONumber
	,	BillOfLading
	,	BillOfLadingLine
	,	Receiver
	,	Invoice
	,	InvoiceLine
	,	Item
	,	Approved
	,	ReceiverComments
	,	LedgerAccountCode
	,	QuantityReceived
	,	UnitCost
	,	ChangedDate
	,	ChangedUserId
	,	TotalCost
	,	ItemDescription
	,	FreightCost
	,	OtherCost
	,	MonthEnd
	)
	select
		PONumber = prihd.purchase_order
	,	BillOfLading = prihd.bill_of_lading
	,	BillOfLadingLine = prihd.bol_line
	,	Receiver = prihd.receiver
	,	Invoice = prihd.invoice
	,	InvoiceLine = prihd.inv_line
	,	Item = prihd.item
	,	Approved = prihd.approved
	,	ReceiverComments = prihd.receiver_comments
	,	LedgerAccountCode = prihd.ledger_account_code
	,	QuantityReceived = prihd.quantity_received
	,	UnitCost = prihd.unit_cost
	,	ChangedDate = prihd.changed_date
	,	ChangedUserId = prihd.changed_user_id
	,	TotalCost = prihd.total_cost
	,	ItemDescription = prihd.item_description
	,	FreightCost = prihd.freight_cost
	,	OtherCost = prihd.other_cost
	,	MonthEnd = prihd.MonthEnd
	from
		dbo.po_receiver_items_historical_daily prihd
	where
		prihd.time_stamp = @snapshotDT
		and prihd.reason = @reason
	order by
		prihd.purchase_order
	,	prihd.bill_of_lading
	,	prihd.bol_line
end
if	not exists
	(	select
			*
		from
			#PRINew pn
	) begin

	insert
		#PRINew
	(	PONumber
	,	BillOfLading
	,	BillOfLadingLine
	,	Receiver
	,	Invoice
	,	InvoiceLine
	,	Item
	,	Approved
	,	ReceiverComments
	,	LedgerAccountCode
	,	QuantityReceived
	,	UnitCost
	,	ChangedDate
	,	ChangedUserId
	,	TotalCost
	,	ItemDescription
	,	FreightCost
	,	OtherCost
	,	MonthEnd
	)
	select
		PONumber = prihd.purchase_order
	,	BillOfLading = prihd.bill_of_lading
	,	BillOfLadingLine = prihd.bol_line
	,	Receiver = prihd.receiver
	,	Invoice = prihd.invoice
	,	InvoiceLine = prihd.inv_line
	,	Item = prihd.item
	,	Approved = prihd.approved
	,	ReceiverComments = prihd.receiver_comments
	,	LedgerAccountCode = prihd.ledger_account_code
	,	QuantityReceived = prihd.quantity_received
	,	UnitCost = prihd.unit_cost
	,	ChangedDate = prihd.changed_date
	,	ChangedUserId = prihd.changed_user_id
	,	TotalCost = prihd.total_cost
	,	ItemDescription = prihd.item_description
	,	FreightCost = prihd.freight_cost
	,	OtherCost = prihd.other_cost
	,	MonthEnd = 'N'
	from
		dbo.po_receiver_items_historical prihd
	where
		prihd.time_stamp = @snapshotDT
		and prihd.reason = @reason
	order by
		prihd.purchase_order
	,	prihd.bill_of_lading
	,	prihd.bol_line
end

if	not exists
	(	select
			*
		from
			#PRINew pn
	) begin

	insert
		#PRINew
	(	PONumber
	,	BillOfLading
	,	BillOfLadingLine
	,	Receiver
	,	Invoice
	,	InvoiceLine
	,	Item
	,	Approved
	,	ReceiverComments
	,	LedgerAccountCode
	,	QuantityReceived
	,	UnitCost
	,	ChangedDate
	,	ChangedUserId
	,	TotalCost
	,	ItemDescription
	,	FreightCost
	,	OtherCost
	,	MonthEnd
	)
	select
		PONumber = prihd.purchase_order
	,	BillOfLading = prihd.bill_of_lading
	,	BillOfLadingLine = prihd.bol_line
	,	Receiver = prihd.receiver
	,	Invoice = prihd.invoice
	,	InvoiceLine = prihd.inv_line
	,	Item = prihd.item
	,	Approved = prihd.approved
	,	ReceiverComments = prihd.receiver_comments
	,	LedgerAccountCode = prihd.ledger_account_code
	,	QuantityReceived = prihd.quantity_received
	,	UnitCost = prihd.unit_cost
	,	ChangedDate = prihd.changed_date
	,	ChangedUserId = prihd.changed_user_id
	,	TotalCost = prihd.total_cost
	,	ItemDescription = prihd.item_description
	,	FreightCost = prihd.freight_cost
	,	OtherCost = prihd.other_cost
	,	MonthEnd = prihd.MonthEnd
	from
		dbo.po_receiver_items_historical_daily prihd
	where
		prihd.time_stamp = @snapshotDT
		and prihd.reason = @reason
	order by
		prihd.purchase_order
	,	prihd.bill_of_lading
	,	prihd.bol_line
end

update
	pn
set	BinCheckSum = binary_checksum(*)
from
	#PRINew pn

create index ix_#PRINew_1 on #PRINew (PONumber, BillOfLading, BillOfLadingLine, BinCheckSum)

insert
	FT.Costing_POReceiverItemsHistorical
(	PONumber
,	BillOfLading
,	BillOfLadingLine
,	BeginDT
,	EndDT
,	Receiver
,	Invoice
,	InvoiceLine
,	Item
,	Approved
,	ReceiverComments
,	LedgerAccountCode
,	QuantityReceived
,	UnitCost
,	ChangedDate
,	ChangedUserId
,	TotalCost
,	ItemDescription
,	FreightCost
,	OtherCost
,	MonthEnd
,	BinCheckSum
,	LastSnapshotRowID
)
select
	pn.PONumber
,	pn.BillOfLading
,	pn.BillOfLadingLine
,	BeginDT = @snapshotDT
,	EndDT = @snapshotDT
,	pn.Receiver
,	pn.Invoice
,	pn.InvoiceLine
,	pn.Item
,	pn.Approved
,	pn.ReceiverComments
,	pn.LedgerAccountCode
,	pn.QuantityReceived
,	pn.UnitCost
,	pn.ChangedDate
,	pn.ChangedUserId
,	pn.TotalCost
,	pn.ItemDescription
,	pn.FreightCost
,	pn.OtherCost
,	pn.MonthEnd
,	pn.BinCheckSum
,	LastSnapshotRowID = @snapshotRowID
from
	#PRINew pn
	left join FT.Costing_POReceiverItemsHistorical cprih
		on cprih.LastSnapshotRowID = @snapshotRowID - 1
		and cprih.PONumber = pn.PONumber
		and cprih.BillOfLading = pn.BillOfLading
		and cprih.BillOfLadingLine = pn.BillOfLadingLine
		and cprih.Receiver = pn.Receiver
where
	coalesce (cprih.BinCheckSum, -1) != pn.BinCheckSum
	or coalesce (cprih.Invoice, '') != coalesce(pn.Invoice, '')
	or coalesce (cprih.InvoiceLine, -1) != coalesce(pn.InvoiceLine, -1)
	or coalesce (cprih.Item, '') != coalesce(pn.Item, '')
	or coalesce (cprih.Approved, '') != coalesce(pn.Approved, '')
	or coalesce (convert(varchar (8000), cprih.ReceiverComments), '') != coalesce(convert(varchar (8000), pn.ReceiverComments), '')
	or coalesce (cprih.LedgerAccountCode, '') != coalesce(pn.LedgerAccountCode, '')
	or coalesce (cprih.QuantityReceived, -1) != coalesce(pn.QuantityReceived, -1)
	or coalesce (cprih.UnitCost, -1) != coalesce(pn.UnitCost, -1)
	or coalesce (cprih.ChangedDate, getdate()) != coalesce(pn.ChangedDate, getdate())
	or coalesce (cprih.ChangedUserId, '') != coalesce(pn.ChangedUserId, '')
	or coalesce (cprih.TotalCost, -1) != coalesce(pn.TotalCost, -1)
	or coalesce (convert(varchar (8000), cprih.ItemDescription), '') != coalesce(convert(varchar (8000), pn.ItemDescription), '')
	or coalesce (cprih.FreightCost, -1) != coalesce(pn.FreightCost, -1)
	or coalesce (cprih.OtherCost, -1) != coalesce(pn.OtherCost, -1)
	or coalesce (cprih.MonthEnd, '') != coalesce(pn.MonthEnd, '')
order by
	1
,	2
,	3
,	4

update
	cprih
set	EndDT = @snapshotDT
,	LastSnapshotRowID = @snapshotRowID
from
	#PRINew pn
	left join FT.Costing_POReceiverItemsHistorical cprih
		on cprih.LastSnapshotRowID = @snapshotRowID - 1
		and cprih.PONumber = pn.PONumber
		and cprih.BillOfLading = pn.BillOfLading
		and cprih.BillOfLadingLine = pn.BillOfLadingLine
		and cprih.Receiver = pn.Receiver
where
	coalesce (cprih.BinCheckSum, -1) = pn.BinCheckSum
	and coalesce (cprih.Invoice, '') = coalesce(pn.Invoice, '')
	and coalesce (cprih.InvoiceLine, -1) = coalesce(pn.InvoiceLine, -1)
	and coalesce (cprih.Item, '') = coalesce(pn.Item, '')
	and coalesce (cprih.Approved, '') = coalesce(pn.Approved, '')
	and coalesce (convert(varchar (8000), cprih.ReceiverComments), '') = coalesce(convert(varchar (8000), pn.ReceiverComments), '')
	and coalesce (cprih.LedgerAccountCode, '') = coalesce(pn.LedgerAccountCode, '')
	and coalesce (cprih.QuantityReceived, -1) = coalesce(pn.QuantityReceived, -1)
	and coalesce (cprih.UnitCost, -1) = coalesce(pn.UnitCost, -1)
	and coalesce (cprih.ChangedDate, getdate()) = coalesce(pn.ChangedDate, getdate())
	and coalesce (cprih.ChangedUserId, '') = coalesce(pn.ChangedUserId, '')
	and coalesce (cprih.TotalCost, -1) = coalesce(pn.TotalCost, -1)
	and coalesce (convert(varchar (8000), cprih.ItemDescription), '') = coalesce(convert(varchar (8000), pn.ItemDescription), '')
	and coalesce (cprih.FreightCost, -1) = coalesce(pn.FreightCost, -1)
	and coalesce (cprih.OtherCost, -1) = coalesce(pn.OtherCost, -1)
	and coalesce (cprih.MonthEnd, '') = coalesce(pn.MonthEnd, '')

drop table
	#PRINew
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_CalculatePOReceiverItemsHistorical
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
go

declare
	@counter int = 1

while
	@counter <= 100
	and exists
	(	select top 1
			*
		from
			FT.Costing_Snapshots_PRI csp
		where
			SnapshotDT >
				(	select
						coalesce(max(csp.SnapshotDT), '2000-01-01')
					from
						FT.Costing_POReceiverItemsHistorical cprih
						join FT.Costing_Snapshots_PRI csp
							on cprih.LastSnapshotRowID = csp.RowID
				)
	) begin

	begin transaction

	execute
		FT.usp_Costing_CalculatePOReceiverItemsHistorical

	commit

	set @counter += 1

	print 'loop'
end
go

select top 1000
	*
from
	FT.Costing_POReceiverItemsHistorical cprih
order by
	1, 2

select
	count(*)
,	max(EndDT)
,	max(LastSnapshotRowID)
from
	FT.Costing_POReceiverItemsHistorical cprih

rollback
