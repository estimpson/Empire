SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[csp_RecordReceipts]
(	@ReceiptPeriodID integer output,
	@PeriodEndDT datetime output
--	<Debug>
	,
	@Debug integer = 0
--	</Debug>
)
as
/*
Arguments:
ReceiptPeriodID	The ID of the newly generated Release Plan.
PeriodEndDT	The end of the new period (defaults to current date/time.

Result set:
None

Description:
Creates a new period during which receipts are tabulated and recorded.

Example:
begin transaction
begin
declare	@ReceiptPeriodID integer,
	@PeriodEndDT datetime

execute	FT.csp_RecordReceipts
	@ReceiptPeriodID = @ReceiptPeriodID output,
	@PeriodEndDT = @PeriodEndDT output
--<Debug>
	,
	@Debug = 1
--</Debug>

select	*
from	FT.POReceiptPeriods
where	PeriodID = @ReceiptPeriodID
end
rollback
:end example
Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Read the end of the last ReceiptPeriod.
--	II.	Create a new period with the passed End or default to now.
--	III.	Make a temp table for receipts since last Period End to the end
--		of this period.
--	IV.	Tabulate the receipts for this period.
--	V.	Update totals.
--	VI.	Finished
*/
begin transaction

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ()
	select	@ProcStartDT = GetDate ()
	print	'RecordReceipts START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--	I.	Read the end of the last ReceiptPeriod.
declare	@LastPeriodEndDT datetime

select	@LastPeriodEndDT = max ( PeriodEndDT )
from	FT.ReceiptPeriods

--	II.	Create a new period with the passed End or default to now.
insert	FT.ReceiptPeriods
(	PeriodEndDT )
select	IsNull ( @PeriodEndDT, GetDate ())

select	@ReceiptPeriodID = @@identity

select	@PeriodEndDT = PeriodEndDT
from	FT.ReceiptPeriods
where	ID = @ReceiptPeriodID

--	<Debug>
if @Debug & 1 = 1
begin
	print	'Build list of receipts...'
	select	@StartDT = GetDate ()
end
--	</Debug>
--	III.	Make a temp table for receipts since last Period End to the end
--		of this period.
create table #Receipts
(	PONumber integer,
	Part varchar (25),
	StdQty numeric (20,6),
	ReceivedDT datetime,
	WeekNo smallint,
	shipper varchar(20) )
	
create table #TotalAccumAdjustments
(	PONumber integer,
	Part varchar (25),
	AccumQty numeric (20,6) )

insert	#Receipts
(	PONumber,
	Part,
	StdQty,
	ReceivedDT,
	WeekNo,
	shipper )
select	audit_trail.po_number,
	audit_trail.part,
	audit_trail.std_quantity,
	audit_trail.DBDate,
	WeekNo = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), audit_trail.DBDate ),
	audit_trail.shipper
from	dbo.audit_trail
where	audit_trail.type = 'R' and
	audit_trail.DBDate > IsNull ( @LastPeriodEndDT, convert ( datetime, '1900-01-01' ) ) and
	audit_trail.DBDate <= @PeriodEndDT

create index idx_#Receipts_1 on #Receipts (PONumber, Part, ReceivedDT)
create index idx_#Receipts_2 on #Receipts (PONumber, Part, WeekNo)

--	<Debug>
if @Debug & 1 = 1
	print	'Built.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate () ) ) + ' ms'
--	</Debug>


--	<Debug>
if @Debug & 1 = 1
begin
	print	'Tabulate receipts...'
	select	@StartDT = GetDate ()
end
--	</Debug>
--	IV.	Tabulate the receipts for this period.
insert	FT.POReceiptPeriods
(	PeriodID,
	PONumber,
	Part,
	StdQty,
	AccumAdjust,
	LastReceivedAmount,
	LastReceivedDT,
	ReceiptCount,
	Shipper)
select	@ReceiptPeriodID,
	PONumber,
	Part,
	isnull ( Sum ( StdQty ), 0 ),
	isnull (
	(	select	sum ( cum_adjust )
		from    dbo.edi_po_year
		where   edi_po_year.po_number = #Receipts.PONumber and
		        edi_po_year.part = #Receipts.Part ), 0 ),
	(	select	Max ( R1.StdQty )
		from	#Receipts R1
		where	R1.PONumber = #Receipts.PONumber and
			R1.Part = #Receipts.Part and
			R1.ReceivedDT =
			(	select	Max ( R2.ReceivedDT )
				from	#Receipts R2
				where	R2.PONumber = #Receipts.PONumber and
					R2.Part = #Receipts.Part ) ),
	(	select	Max ( R2.ReceivedDT )
		from	#Receipts R2
		where	R2.PONumber = #Receipts.PONumber and
			R2.Part = #Receipts.Part ),
	Count (1),
	MAX(Shipper)
from	#Receipts
group by
	PONumber,
	Part

--	<Debug>
if @Debug & 1 = 1
	print	'Tabulated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate () ) ) + ' ms'
--	</Debug>


--	<Debug>
if @Debug & 1 = 1
begin
	print	'Update totals...'
	select	@StartDT = GetDate ()
end
--	</Debug>
--	V.	Update totals (create new records for those that don't exist).
update	FT.POReceiptTotals
set	FT.POReceiptTotals.StdQty = POReceiptTotals.StdQty + POReceiptPeriods.StdQty,
	FT.POReceiptTotals.AccumAdjust = POReceiptPeriods.AccumAdjust,
	FT.POReceiptTotals.LastReceivedAmount = POReceiptPeriods.LastReceivedAmount,
	FT.POReceiptTotals.LastReceivedDT = POReceiptPeriods.LastReceivedDT,
	FT.POReceiptTotals.ReceiptCount = POReceiptTotals.ReceiptCount + POReceiptPeriods.ReceiptCount,
	FT.POReceiptTotals.LastUpdated = @PeriodEndDT,
	FT.POReceiptTotals.shipper = POReceiptPeriods.shipper
from	FT.POReceiptTotals POReceiptTotals
	join FT.POReceiptPeriods POReceiptPeriods on POReceiptPeriods.PeriodID = @ReceiptPeriodID and
		POReceiptPeriods.PONumber = POReceiptTotals.PONumber and
		POReceiptPeriods.Part = POReceiptTotals.Part


--update	FT.POReceiptTotals
--set		FT.POReceiptTotals.shipper = Per.shipper
--from	FT.POReceiptTotals Tot
--		join FT.POReceiptPeriods Per on Tot.LastReceivedDT = Per.LastReceivedDT
--									and Tot.PONumber = Per.PONumber

insert	FT.POReceiptTotals
(	PONumber,
	Part,
	StdQty,
	AccumAdjust,
	LastReceivedAmount,
	LastReceivedDT,
	ReceiptCount,
	LastUpdated,
	Shipper )
select	PONumber,
	Part,
	StdQty,
	AccumAdjust,
	LastReceivedAmount,
	LastReceivedDT,
	ReceiptCount,
	@PeriodEndDT,
	Shipper
from	FT.POReceiptPeriods POReceiptPeriods
where	PeriodID = @ReceiptPeriodID and
	not exists
	(	select	1
		from	FT.POReceiptTotals POReceiptTotals
		where	POReceiptPeriods.PONumber = POReceiptTotals.PONumber and
			POReceiptPeriods.Part = POReceiptTotals.Part )
			
---- reupdate POreceiptTotals for all parts. Was only updating for parts that had receipt since last accum update. Not modifying POreceiptPeriods for now. Andre S. Boulanger 7/21/2005
insert	#TotalAccumAdjustments
Select	po_number,
	part,
	isnull ( sum ( cum_adjust ), 0 )
from	dbo.edi_po_year
group by
	po_number,
	part
				
update	FT.POReceiptTotals
set	FT.POReceiptTotals.AccumAdjust = #TotalAccumAdjustments.AccumQty
from	FT.POReceiptTotals POReceiptTotals
	join #TotalAccumAdjustments on POReceiptTotals.POnumber = #TotalAccumAdjustments.PONUmber and
		POReceiptTotals.part = #TotalAccumAdjustments.part

--	<Debug>
if @Debug & 1 = 1
	print	'Updated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate () ) ) + ' ms'
--	</Debug>


--	VI.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate () ) ) + ' ms'
end
--</Debug>
commit transaction
GO
