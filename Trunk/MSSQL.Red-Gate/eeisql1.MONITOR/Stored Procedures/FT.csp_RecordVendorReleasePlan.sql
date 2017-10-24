SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[csp_RecordVendorReleasePlan]
(	@ReleasePlanID integer output
--	<Debug>
	,
	@Debug integer = 0
--	</Debug>
)
as
/*
Arguments:
ReleasePlanID	The ID of the newly generated Release Plan.

Result set:
None

Description:
Create new PO Schedule.

Example:
begin transaction
begin
declare	@ReleasePlanID integer

execute	FT.csp_RecordVendorReleasePlan
	@ReleasePlanID = @ReleasePlanID output
--<Debug>
	,
	@Debug = 1
--</Debug>

select	*
from	FT.CurrentReleasePlan
where	ReleasePlanID = @ReleasePlanID
end
go
--resume
go
--rollback
go
:end example
Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	Declarations.
--	I.	Generate a new Vendor Release Plan.
--	II.	Record the total receipts to date.
--	III.	Record the Raw release plan data.
--	IV.	Refresh and summarize the current release plan by week within
--		leadtime.
--	V.	Record Fab Authorizations.
--	VI.	Freshen High Fab Authorizations.
--	VII.	Finished
*/
begin transaction

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ()
	select	@ProcStartDT = GetDate ()
	print	'RecordVendorReleasePlan START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--	<Tran>
if @@TranCount = 0
begin transaction RecordVendorReleasePlan
save transaction RecordVendorReleasePlan
--	</Tran>

--	Declarations.
declare	@GeneratedDT datetime,
	@ReceiptPeriodID integer,
	@ProcResult integer,
	@Error integer

--	I.	Generate a new Vendor Release Plan.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Generate a new Release Plan'
end
--	</Debug>

insert	FT.ReleasePlans
(	GeneratedWeekNo,
	BaseDT )
select	DateDiff ( wk, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate () ),
	FT.fn_DTGlobal ( 'BaseWeek' )

select	@ReleasePlanID = @@identity

select	@GeneratedDT = GeneratedDT
from	FT.ReleasePlans
where	ID = @ReleasePlanID

--	II.	Record the total receipts to date.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Record total receipts to date...'
	select	@StartDT = GetDate ()
end
--	</Debug>

execute	@ProcResult = FT.csp_RecordReceipts
	@ReceiptPeriodID = @ReceiptPeriodID output,
	@PeriodEndDT = @GeneratedDT output
--<Debug>
	,
	@Debug = @Debug
--</Debug>

select	@Error = @@Error

if @ProcResult != 0 or @Error != 0 or @@Error != 0
begin
--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'!!!!Recording receipts failed.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
		print	'!!!!Proc Result.   ' + Convert ( varchar, @ProcResult )
		print	'!!!!Error Code.   ' + Convert ( varchar, @Error )
	end
--	</Debug>
--	<Tran>
	rollback transaction RecordVendorReleasePlan
--	</Tran>
	return -1
end
--	<Debug>
if @Debug & 1 = 1
	print	'Recorded.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	III.	Record the Raw release plan data.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Record Raw release plan...'
	select	@StartDT = GetDate ()
end
--	</Debug>

insert	FT.ReleasePlanRaw
(	ReleasePlanID,
	ReceiptPeriodID,
	PONumber,
	Part,
	WeekNo,
	DueDT,
	LineID,
	StdQty,
	PriorAccum,
	PostAccum,
	AccumReceived,
	LastReceivedDT,
	LastReceivedAmount,
	FabWeekNo,
	RawWeekNo )
select	@ReleasePlanID,
	@ReceiptPeriodID,
	vwAVR.PONumber,
	vwAVR.Part,
	vwAVR.WeekNo,
	vwAVR.DueDT,
	vwAVR.LineID,
	vwAVR.StdQty,
	vwAVR.PriorAccum,
	PostAccum = vwAVR.PriorAccum + vwAVR.StdQty,
	vwAVR.AccumReceived,
	vwAVR.LastReceivedDT,
	vwAVR.LastReceivedAmount,
	vwAVR.FabWeekNo,
	vwAVR.RawWeekNo
from	FT.vwAVR vwAVR
--	<Debug>
if @Debug & 1 = 1
	print	'Recorded.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	IV.	Refresh and summarize the current release plan by week within
--		leadtime.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Refresh and summarize current release plan...'
	select	@StartDT = GetDate ()
end
--	</Debug>

delete	FT.CurrentReleasePlan

insert	FT.CurrentReleasePlan
(	PONumber,
	Part,
	WeekNo,
	StdQty,
	PriorAccum,
	PostAccum,
	ReleasePlanID )
select	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	ReleasePlanRaw.WeekNo,
	StdQty = sum ( ReleasePlanRaw.StdQty ),
	PriorAccum = min ( ReleasePlanRaw.PriorAccum ),
	PostAccum = max ( ReleasePlanRaw.PostAccum ),
	@ReleasePlanID
from	FT.ReleasePlanRaw ReleasePlanRaw
where	ReleasePlanRaw.ReleasePlanID = @ReleasePlanID and
	ReleasePlanRaw.WeekNo <= ReleasePlanRaw.FabWeekNo
group by
	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	ReleasePlanRaw.WeekNo
--	<Debug>
if @Debug & 1 = 1
	print	'Refreshed.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	V.	Record Fab Authorizations and Raw Authorizations.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Record fab/Raw authorizations...'
	select	@StartDT = GetDate ()
end
--	</Debug>

insert	FT.FabAuthorizations
(	ReleasePlanID,
	PONumber,
	Part,
	WeekNo,
	AuthorizedAccum )
select	@ReleasePlanID,
	PONumber,
	Part,
	FabWeekNo,
	max ( PostAccum )
from	FT.ReleasePlanRaw ReleasePlanRaw
where	ReleasePlanRaw.ReleasePlanID = @ReleasePlanID and
	ReleasePlanRaw.WeekNo <= ReleasePlanRaw.FabWeekNo
group by
	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	FabWeekNo

insert	FT.FabAuthorizations
(	ReleasePlanID,
	PONumber,
	Part,
	WeekNo,
	AuthorizedAccum )
select	@ReleasePlanID,
	PONumber,
	Part,
	FabWeekNo,
	AccumReceived
from	FT.vwPOHeaderEDI vwPOHeaderEDI
where	not exists
	(	select	1
		from	FT.FabAuthorizations FabAuthorizations
		where	FabAuthorizations.ReleasePlanID = @ReleasePlanID and
			FabAuthorizations.PONumber = vwPOHeaderEDI.PONumber and
			FabAuthorizations.Part = vwPOHeaderEDI.Part ) and
	vwPOHeaderEDI.PONumber in
	(	select	vwPPrA.DefaultPO
		from	FT.vwPPrA vwPPrA ) and
	vwPOHeaderEDI.FabDate > GetDate ()

insert	FT.RawAuthorizations
(	ReleasePlanID,
	PONumber,
	Part,
	WeekNo,
	AuthorizedAccum )
select	@ReleasePlanID,
	PONumber,
	Part,
	RawWeekNo,
	max ( PostAccum )
from	FT.ReleasePlanRaw ReleasePlanRaw
where	ReleasePlanRaw.ReleasePlanID = @ReleasePlanID and
	ReleasePlanRaw.WeekNo <= ReleasePlanRaw.RawWeekNo
group by
	ReleasePlanRaw.PONumber,
	ReleasePlanRaw.Part,
	RawWeekNo

insert	FT.RawAuthorizations
(	ReleasePlanID,
	PONumber,
	Part,
	WeekNo,
	AuthorizedAccum )
select	@ReleasePlanID,
	PONumber,
	Part,
	RawWeekNo,
	AccumReceived
from	FT.vwPOHeaderEDI vwPOHeaderEDI
where	not exists
	(	select	1
		from	FT.RawAuthorizations RawAuthorizations
		where	RawAuthorizations.ReleasePlanID = @ReleasePlanID and
			RawAuthorizations.PONumber = vwPOHeaderEDI.PONumber and
			RawAuthorizations.Part = vwPOHeaderEDI.Part ) and
	vwPOHeaderEDI.PONumber in
	(	select	vwPPrA.DefaultPO
		from	FT.vwPPrA vwPPrA ) and
	vwPOHeaderEDI.RawDate > GetDate ()
--	<Debug>
if @Debug & 1 = 1
	print	'Recorded.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	VI.	Freshen High Fab /Raw  Authorizations.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Freshen fab authorizations...'
	select	@StartDT = GetDate ()
end
--	</Debug>

update	FT.HighFabAuthorizations
set	FT.HighFabAuthorizations.AuthorizedAccum = FabAuthorizations.AuthorizedAccum,
	FT.HighFabAuthorizations.WeekNo = FabAuthorizations.WeekNo,
	FT.HighFabAuthorizations.ReleasePlanID = FabAuthorizations.ReleasePlanID
from	FT.HighFabAuthorizations HighFabAuthorizations
	join FT.FabAuthorizations FabAuthorizations on FabAuthorizations.PONumber = HighFabAuthorizations.PONumber and
		FabAuthorizations.Part = HighFabAuthorizations.Part
where	HighFabAuthorizations.AuthorizedAccum < FabAuthorizations.AuthorizedAccum

insert	FT.HighFabAuthorizations
(	PONumber,
	Part,
	AuthorizedAccum,
	WeekNo,
	ReleasePlanID )
select	PONumber = FabAuthorizations.PONumber,
	Part = FabAuthorizations.Part,
	AuthorizedAccum = max ( FabAuthorizations.AuthorizedAccum ),
	WeekNo = max ( FabAuthorizations.WeekNo ),
	ReleasePlanID = @ReleasePlanID
from	FT.FabAuthorizations FabAuthorizations
where	FabAuthorizations.ReleasePlanID = @ReleasePlanID and
	not exists
	(	select	1
		from	FT.HighFabAuthorizations HighFabAuthorizations
		where	FabAuthorizations.PONumber = HighFabAuthorizations.PONumber and
			FabAuthorizations.Part = HighFabAuthorizations.Part )
group by
	FabAuthorizations.PONumber,
	FabAuthorizations.Part

----	Update/Insert Raw Authorizations
update	FT.HighRawAuthorizations
set	FT.HighRawAuthorizations.AuthorizedAccum = RawAuthorizations.AuthorizedAccum,
	FT.HighRawAuthorizations.WeekNo = RawAuthorizations.WeekNo,
	FT.HighRawAuthorizations.ReleasePlanID = RawAuthorizations.ReleasePlanID
from	FT.HighRawAuthorizations HighRawAuthorizations
	join FT.RawAuthorizations RawAuthorizations on RawAuthorizations.PONumber = HighRawAuthorizations.PONumber and
		RawAuthorizations.Part = HighRawAuthorizations.Part
where	HighRawAuthorizations.AuthorizedAccum < RawAuthorizations.AuthorizedAccum

insert	FT.HighRawAuthorizations
(	PONumber,
	Part,
	AuthorizedAccum,
	WeekNo,
	ReleasePlanID )
select	PONumber = RawAuthorizations.PONumber,
	Part = RawAuthorizations.Part,
	AuthorizedAccum = max ( RawAuthorizations.AuthorizedAccum ),
	WeekNo = max ( RawAuthorizations.WeekNo ),
	ReleasePlanID = @ReleasePlanID
from	FT.RawAuthorizations RawAuthorizations
where	RawAuthorizations.ReleasePlanID = @ReleasePlanID and
	not exists
	(	select	1
		from	FT.HighRawAuthorizations HighRawAuthorizations
		where	RawAuthorizations.PONumber = HighRawAuthorizations.PONumber and
			RawAuthorizations.Part = HighRawAuthorizations.Part )
group by
	RawAuthorizations.PONumber,
	RawAuthorizations.Part
--	<Debug>
if @Debug & 1 = 1
	print	'Freshen.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	VII.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate () ) ) + ' ms'
end
--</Debug>
commit transaction
GO
