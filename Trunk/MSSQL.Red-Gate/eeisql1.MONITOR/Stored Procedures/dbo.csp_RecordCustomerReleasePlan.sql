SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[csp_RecordCustomerReleasePlan]
(	@CustomerReleasePlanID integer output
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
Create new Order Detail Schedule.

Example:
begin transaction

declare	@CustomerReleasePlanID integer

execute	csp_RecordCustomerReleasePlan
	@CustomerReleasePlanID = @CustomerReleasePlanID output
--<Debug>
	,
	@Debug = 1
--</Debug>

select	*
from	CurrentCustomerReleasePlan
where	ReleasePlanID = @CustomerReleasePlanID

rollback
go
:end example
Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Used 'FT'.csp_RecordVendorReleasePlan as basis for this stored procedure
Andre S. Boulanger May 17, 2004

Process:
--	Declarations.
--	I.		Generate a new Customer Release Plan.
--	II.		Record the raw release plan data.
--	III.	Refresh the current release plan
--- IV.	Insert/Refresh CUM Authorizations
--	V.	Finished
*/

begin Transaction

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ()
	select	@ProcStartDT = GetDate ()
	print	'RecordCustomerReleasePlan START. ' + Convert ( varchar (50), @ProcStartDT)
end
--</Debug>

--	<Tran>
if @@TranCount = 0
	begin transaction RecordCustomerReleasePlan
save transaction RecordCustomerReleasePlan
--	</Tran>

--	Declarations.
declare	@GeneratedDT datetime,
	@ReceiptPeriodID integer,
	@ProcResult integer,
	@Error integer,
	@SQLCode integer

--	I.	Generate a new Vendor Release Plan.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Generate a new Release Plan'
end
--	</Debug>

insert	CustomerReleasePlans
(	GeneratedWeekNo,
	BaseDT)
select	DateDiff ( wk, Value, GetDate ()),
	Value
from	FT.DTGlobals
where	Name = 'BaseWeek'

select	@CustomerReleasePlanID = @@identity

select	@GeneratedDT = GeneratedDT
from	CustomerReleasePlans
where	ID = @CustomerReleasePlanID

--	II.	Record the raw release plan data.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Record raw release plan...'
	select	@StartDT = GetDate ()
end
--	</Debug>

insert	CustomerReleasePlanRaw
(	ReleasePlanID,
	OrderNumber ,
	CurrentWeek,
	Part ,
	WeekNo ,
	DueDT ,
	LineID ,
	StdQty ,
	PriorAccum ,
	PostAccum ,
	AccumShipped ,
	LastShippedDT ,
	LastShippedAmount ,
	LastShippedShipper ,
	Firmweeks ,
	FABWeeks ,
	MATWeeks ,
	FABAuthorized ,
	MATAuthorized ,
	PosAllowedVariancem ,
	NegAllowedVariance ,
	EEIEntry,
	ReleaseNo,
	BasePart,
	Destination)
select	@CustomerReleasePlanID,
	OrderNumber,
	CurrentWeek,
	Part,
	DeliveryWeek,
	DueDT,
	LineID,
	StdQty,
	PriorAccum,
	PostAccum,
	AccumShipped,
	LastShippedDate,
	LastShippedAmount,
	LastShipper,
	Firmweeks,
	FABAuthWeeks,
	MATAuthWeeks,
	FABAuthorized,
	MATAuthorized,
	PosAllowedVariance,
	NegAllowedVariance,
	EEIEntry,
	ReleaseNo,
	left(Part,7),
	ShiptoDestination
from	vwOD

--	<Debug>
if @Debug & 1 = 1
	print	'Recorded. ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>

--	III.	Refresh the current release plan.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Refresh and summarize current release plan...'
	select	@StartDT = GetDate ()
end
--	</Debug>

delete	CurrentCustomerReleasePlan

insert	CurrentCustomerReleasePlan
(	ReleasePlanID,
	OrderNumber ,
	CurrentWeek,
	Part ,
	WeekNo ,
	DueDT ,
	LineID ,
	StdQty ,
	PriorAccum ,
	PostAccum ,
	AccumShipped ,
	LastShippedDT ,
	LastShippedAmount ,
	LastShippedShipper ,
	Firmweeks ,
	FABWeeks ,
	MATWeeks ,
	FABAuthorized ,
	MATAuthorized ,
	PosAllowedVariancem ,
	NegAllowedVariance ,
	EEIEntry,
	ReleaseNo)
select	ReleasePlanID,
	OrderNumber ,
	CurrentWeek,
	Part ,
	WeekNo ,
	DueDT ,
	LineID ,
	StdQty ,
	PriorAccum ,
	PostAccum ,
	AccumShipped ,
	LastShippedDT ,
	LastShippedAmount ,
	LastShippedShipper ,
	Firmweeks ,
	FABWeeks ,
	MATWeeks ,
	FABAuthorized ,
	MATAuthorized ,
	PosAllowedVariancem ,
	NegAllowedVariance ,
	EEIEntry,
	ReleaseNo
from	CustomerReleasePlanRaw
where	CustomerReleasePlanRaw.ReleasePlanID = @CustomerReleasePlanID

--	<Debug>
if @Debug & 1 = 1
	print	'Refreshed. ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>

if @Debug & 1 = 1
begin
	print	'Record/ all authorizations...'
	select	@StartDT = GetDate ()
end
--	</Debug>

insert	FirmOrderAuth
(	ReleasePlanID,
	OrderNumber,
	WeekRecorded,
	AuthWeek,
	PostAccum,
	FirmWeeks,
	EEIEntry,
	atleadtime)
select	ReleasePlanID = @CustomerReleasePlanID,
	OrderNumber = ordernumber,
	WeekRecorded = currentweek,
	AuthWeek = max (WeekNo),
	PostAccum = IsNull (
	(	select	max (PostAccum)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					firmweeks = CurrentCustomerReleasePlan.firmweeks and
					WeekNo <= CurrentWeek + firmWeeks)), 0),
	FirmWeeks = firmweeks,
	EEIEntry = IsNull (
	(	select	max (eeientry)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					firmweeks = CurrentCustomerReleasePlan.firmweeks and
					WeekNo <= CurrentWeek + firmWeeks)), 'N'),
	atleadtime =
	case	when	(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					firmweeks = CurrentCustomerReleasePlan.firmweeks and
					WeekNo <= CurrentWeek + firmWeeks) = (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.firmWeeks)
			then 'Y'
		else 'N'
	end
from	CurrentCustomerReleasePlan
where	CurrentCustomerReleasePlan.WeekNo <= (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.firmWeeks)
group by
	ordernumber, 
	currentweek, 
	firmweeks
			
insert	FABOrderAuth
(	ReleasePlanID, 
	ordernumber, 
	WeekRecorded, 
	AuthWeek,
	PostAccum,
	FABweeks,
	EEIEntry,
	atleadtime)
select	@CustomerReleasePlanID,
	ordernumber,
	currentweek,
	max (WeekNo) as maxweek,
	IsNull (
	(	select	max (PostAccum)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks)), 0) as LastFirmAccum,
	FABweeks,
	IsNull (
	(	select	max (eeientry)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks)), 'N') as EEIOrder,
	case	when	(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks) = (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.FABWeeks)
			then 'Y'
		else 'N'
	end
from	CurrentCustomerReleasePlan
where	CurrentCustomerReleasePlan.WeekNo <= (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.FABWeeks)
group by
	ordernumber,
	currentweek,
	FABweeks

insert	MATOrderAuth
(	ReleasePlanID,
	ordernumber,
	WeekRecorded,
	AuthWeek,
	PostAccum,
	MATweeks,
	EEIEntry,
	atleadtime)
select	@CustomerReleasePlanID,
	ordernumber,
	currentweek,
	max (WeekNo) as maxweek,
	IsNull (
	(	select	max (PostAccum)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks)), 0) as LastFirmAccum,
	MATweeks,
	IsNull (
	(	select	max (eeientry)
		from	currentCustomerReleasePlan CCRP
		where	CCRP.releaseplanID = @CustomerreleaseplanID and
			CCRP.ordernumber = CurrentCustomerReleasePlan.ordernumber and
			CCRP.weekno =
			(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks)), 'N') as EEIOrder,
	case	when	(	select	max (WeekNo)
				from	CurrentCustomerReleasePlan CCRP2
				where	ordernumber = CurrentCustomerReleasePlan.ordernumber and
					currentweek = CurrentCustomerReleasePlan.currentweek and
					WeekNo <= CurrentWeek + firmWeeks) = (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.matWeeks)
			then 'Y'
		else 'N'
	end
from	CurrentCustomerReleasePlan
where	CurrentCustomerReleasePlan.WeekNo <= (CurrentCustomerReleasePlan.CurrentWeek + CurrentCustomerReleasePlan.MATWeeks)
group by
	ordernumber,
	currentweek,
	MATweeks

--	<Debug>
if @Debug & 1 = 1
	print	'Recorded. ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ())) + ' ms'
--	</Debug>


--	iV.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED. ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ())) + ' ms'
end
--</Debug>
commit transaction


GO
