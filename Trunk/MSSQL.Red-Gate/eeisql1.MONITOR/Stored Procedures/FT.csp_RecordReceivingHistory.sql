SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[csp_RecordReceivingHistory]
(	@FirstWeekNo smallint = null,
	@LastWeekNo smallint = null output
--	<Debug>
	,
	@Debug integer = 0
--	</Debug>
)
as
/*
Arguments:
FirstWeekNo	This is the first week to (re)measure.  If not specified, only
		new weeks are measured.
LastWeekNo	This is the final week that is to be measured and will be the
		previous week of the current week unless specified.

Result set:
None

Description:
Measures vendor performance since the last time it was measured (or for a user
specified period of weeks.

Example:
begin transaction
begin
declare	@LastWeekNo smallint

execute	FT.csp_RecordReceivingHistory
	@FirstWeekNo = 376,
	@LastWeekNo = @LastWeekNo output
--<Debug>
	,
	@Debug = 1
--</Debug>

select	*
from	FT.ReceivingHistory
where	PONumber = 19789
end
go
--resume
go
rollback
go
:end example
Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Get the first week to process.
--	II.	Calculate the last week to process.
--	III.	Make a temp table for receipts from the first week to the last week.
--	IV.	Tabulate the receipts for this period.
--	V.	Finished
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ()
	select	@ProcStartDT = GetDate ()
	print	'RecordReceivingHistory START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--	I.	Get the first week to process.
select	@FirstWeekNo = isnull ( @FirstWeekNo,
	(	select	isnull ( max ( WeekNo + 1 ), 0 )
		from	FT.ReceivingHistory ) )

--	II.	Calculate the last week to process.
select	@LastWeekNo = isnull ( @LastWeekNo, DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ) )

--	<Debug>
if @Debug & 1 = 1
begin
	print	'Build list of receipts...'
	select	@StartDT = GetDate ()
end
--	</Debug>

--	IV.	Tabulate the receipts for this period.
delete	FT.ReceivingHistory
where	WeekNo between @FirstWeekNo and @LastWeekNo - 1

insert	FT.ReceivingHistory
(	PONumber,
	Part,
	WeekNO,
	AccumOrdered,
	OrderedReleasePlanID,
	AuthorizedAccum,
	AuthorizedReleasePlanID,
	ReceivedAccum,
	LastReceivedDT )
select	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	ReleasePlanRaw.WeekNO,
	AccumOrdered = max ( ReleasePlanRaw.PostAccum ),
	OrderedReleasePlanID = convert ( int, right ( max ( convert ( char (20), ReleasePlanRaw.PostAccum ) + convert ( char (12), ReleasePlanRaw.ReleasePlanID ) ), 12 ) ),
	AuthorizedAccum = isnull (
	(	select	max ( FabAuthorizations.AuthorizedAccum )
		from	FT.FabAuthorizations FabAuthorizations
		where	ReleasePlanRaw.PONumber = FabAuthorizations.PONumber and
			ReleasePlanRaw.Part = FabAuthorizations.Part and
			FabAuthorizations.WeekNo =
			(	select	Max ( FabAuthorizations.WeekNo )
				from	FT.FabAuthorizations FabAuthorizations
				where	ReleasePlanRaw.PONumber = FabAuthorizations.PONumber and
					ReleasePlanRaw.Part = FabAuthorizations.Part and
					ReleasePlanRaw.WeekNo >= FabAuthorizations.WeekNo ) ), 0 ),
	AuthorizedReleasePlanID =
	(	select	nullif ( convert ( int, right ( max ( convert ( char (20), FabAuthorizations.AuthorizedAccum ) + convert ( char (12), FabAuthorizations.ReleasePlanID ) ), 12 ) ), 0 )
		from	FT.FabAuthorizations FabAuthorizations
		where	ReleasePlanRaw.PONumber = FabAuthorizations.PONumber and
			ReleasePlanRaw.Part = FabAuthorizations.Part and
			FabAuthorizations.WeekNo =
			(	select	Max ( FabAuthorizations.WeekNo )
				from	FT.FabAuthorizations FabAuthorizations
				where	ReleasePlanRaw.PONumber = FabAuthorizations.PONumber and
					ReleasePlanRaw.Part = FabAuthorizations.Part and
					ReleasePlanRaw.WeekNo >= FabAuthorizations.WeekNo ) ),
	ReceivedAccum = isnull (
	(	select	sum ( POReceiptPeriods.StdQty )
		from	FT.POReceiptPeriods POReceiptPeriods
		where	ReleasePlanRaw.PONumber = POReceiptPeriods.PONumber and
			ReleasePlanRaw.Part = POReceiptPeriods.Part and
			ReleasePlanRaw.WeekNo >= DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), LastReceivedDT ) ), 0 ),
	LastReceivedDT =
	(	select	max ( POReceiptPeriods.LastReceivedDT )
		from	FT.POReceiptPeriods POReceiptPeriods
		where	ReleasePlanRaw.PONumber = POReceiptPeriods.PONumber and
			ReleasePlanRaw.Part = POReceiptPeriods.Part and
			ReleasePlanRaw.WeekNo >= DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), LastReceivedDT ) )
from	FT.ReleasePlanRaw ReleasePlanRaw
where	ReleasePlanRaw.WeekNo >= @FirstWeekNo and
	ReleasePlanRaw.WeekNo < @LastWeekNo and
	ReleasePlanRaw.WeekNo <= ReleasePlanRaw.FabWeekNo
group by
	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	ReleasePlanRaw.WeekNo

insert	FT.ReceivingHistory
(	PONumber,
	Part,
	WeekNO,
	AccumOrdered,
	OrderedReleasePlanID,
	AuthorizedAccum,
	AuthorizedReleasePlanID,
	ReceivedAccum,
	LastReceivedDT )
select	Receipts.PONumber,
	Receipts.Part,
	Receipts.WeekNo,
	AccumOrdered = isnull ( max ( ReleasePlanRaw.PostAccum ), 0 ),
	OrderedReleasePlanID = convert ( int, right ( max ( convert ( char (20), ReleasePlanRaw.PostAccum ) + convert ( char (12), ReleasePlanRaw.ReleasePlanID ) ), 12 ) ),
	AuthorizedAccum = isnull (
	(	select	max ( FabAuthorizations.AuthorizedAccum )
		from	FT.FabAuthorizations FabAuthorizations
		where	Receipts.PONumber = FabAuthorizations.PONumber and
			Receipts.Part = FabAuthorizations.Part and
			FabAuthorizations.WeekNo =
			(	select	Max ( FabAuthorizations.WeekNo )
				from	FT.FabAuthorizations FabAuthorizations
				where	Receipts.PONumber = FabAuthorizations.PONumber and
					Receipts.Part = FabAuthorizations.Part and
					Receipts.WeekNo >= FabAuthorizations.WeekNo ) ), 0 ),
	AuthorizedReleasePlanID =
	(	select	nullif ( convert ( int, right ( max ( convert ( char (20), FabAuthorizations.AuthorizedAccum ) + convert ( char (12), FabAuthorizations.ReleasePlanID ) ), 12 ) ), 0 )
		from	FT.FabAuthorizations FabAuthorizations
		where	Receipts.PONumber = FabAuthorizations.PONumber and
			Receipts.Part = FabAuthorizations.Part and
			FabAuthorizations.WeekNo =
			(	select	Max ( FabAuthorizations.WeekNo )
				from	FT.FabAuthorizations FabAuthorizations
				where	Receipts.PONumber = FabAuthorizations.PONumber and
					Receipts.Part = FabAuthorizations.Part and
					Receipts.WeekNo >= FabAuthorizations.WeekNo ) ),
	ReceivedAccum =
	(	select	sum ( PriorPOReceiptPeriods.StdQty )
		from	FT.POReceiptPeriods PriorPOReceiptPeriods
		where	PriorPOReceiptPeriods.PONumber = Receipts.PONumber and
			PriorPOReceiptPeriods.Part = Receipts.Part and
			DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), PriorPOReceiptPeriods.LastReceivedDT ) <= Receipts.WeekNo ),
	LastReceivedDT = max ( Receipts.ReceivedDT )
from	(	select	POReceiptPeriods.PONumber,
			POReceiptPeriods.Part,
			WeekNo = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), LastReceivedDT ),
			ReceivedDT = max ( LastReceivedDT )
		from	FT.POReceiptPeriods POReceiptPeriods
		group by
			POReceiptPeriods.PONumber,
			POReceiptPeriods.Part,
			DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), LastReceivedDT ) ) Receipts
	left outer join FT.ReleasePlanRaw ReleasePlanRaw on Receipts.PONumber = ReleasePlanRaw.PONumber and
		Receipts.Part = ReleasePlanRaw.Part and
		ReleasePlanRaw.WeekNo =
		(	select	max ( ReleasePlanRaw.WeekNo )
			from	FT.ReleasePlanRaw ReleasePlanRaw
			where	Receipts.PONumber = ReleasePlanRaw.PONumber and
				Receipts.Part = ReleasePlanRaw.Part and
				Receipts.WeekNo > ReleasePlanRaw.WeekNo and
				ReleasePlanRaw.WeekNo <= ReleasePlanRaw.FabWeekNo ) and
		ReleasePlanRaw.ReleasePlanID =
		(	select	convert ( int, right ( max ( convert ( char (20), ReleasePlanRaw.WeekNo ) + convert ( char (12), ReleasePlanRaw.ReleasePlanID ) ), 12 ) )
			from	FT.ReleasePlanRaw ReleasePlanRaw
			where	Receipts.PONumber = ReleasePlanRaw.PONumber and
				Receipts.Part = ReleasePlanRaw.Part and
				Receipts.WeekNo > ReleasePlanRaw.WeekNo and
				ReleasePlanRaw.WeekNo <= ReleasePlanRaw.FabWeekNo )
where	Receipts.WeekNo >= @FirstWeekNo and
	not exists
	(	select	1
		from	FT.ReceivingHistory ReceivingHistory
		where	ReceivingHistory.PONumber = Receipts.PONumber and
			ReceivingHistory.Part = Receipts.Part and
			ReceivingHistory.WeekNo = Receipts.WeekNo )
group by
	Receipts.PONumber,
	Receipts.Part,
	Receipts.WeekNo

--	<Debug>
if @Debug & 1 = 1
	print	'Tabulated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate () ) ) + ' ms'
--	</Debug>

--	V.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate () ) ) + ' ms'
end
--</Debug>
GO
