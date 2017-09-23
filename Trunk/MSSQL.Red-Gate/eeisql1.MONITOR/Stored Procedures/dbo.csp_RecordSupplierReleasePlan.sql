SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[csp_RecordSupplierReleasePlan]
(	@SupplierReleasePlanID integer output
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

declare	@SupplierReleasePlanID integer

execute	csp_RecordSupplierReleasePlan
	@SupplierReleasePlanID = @SupplierReleasePlanID output
--<Debug>
	,
	@Debug = 1
--</Debug>

select	*
from	CurrentSupplierReleasePlan
where	ReleasePlanID = @SupplierReleasePlanID

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
--	I.		Generate a new Supplier Release Plan.
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
	print	'RecordSupplierReleasePlan START. ' + Convert ( varchar (50), @ProcStartDT)
end
--</Debug>

--	<Tran>
if @@TranCount = 0
	begin transaction RecordSupplierReleasePlan
save transaction RecordSupplierReleasePlan
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

insert	SupplierReleasePlans
(	GeneratedWeekNo,
	BaseDT)
select	DateDiff ( wk, Value, GetDate ()),
	Value
from	FT.DTGlobals
where	Name = 'BaseWeek'

select	@SupplierReleasePlanID = @@identity

select	@GeneratedDT = GeneratedDT
from	SupplierReleasePlans
where	ID = @SupplierReleasePlanID

--	II.	Record the raw release plan data.
--	<Debug>
if @Debug & 1 = 1
begin
	print	'Record raw release plan...'
	select	@StartDT = GetDate ()
end
--	</Debug>

insert	SupplierReleasePlanRaw
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
select	@SupplierReleasePlanID,
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
from	vwPOD

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
