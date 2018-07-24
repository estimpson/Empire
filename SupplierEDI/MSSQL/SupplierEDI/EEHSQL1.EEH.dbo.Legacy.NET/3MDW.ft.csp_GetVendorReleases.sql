alter procedure ft.csp_GetVendorReleases
(	@PONumber integer,
	@Part varchar (25)
--	<Debug>
	,
	@Debug integer = 0
--	</Debug>
)
as
/*
Arguments:
None

Result set:
None

Description:
Get Vendor EDI Releases for a 

Example:
execute	"FT".csp_GetVendorReleases
	@PONumber = 16260,
	@Part = 'EOVB-13A506-CA'
--<Debug>
	,
	@Debug = 1
--</Debug>

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC
2007.12.15	Andre S. Boulanger -  Modified .	Populate PODetail with one row for each week in the horizon. section by hardcoding 14 Days of firm for TTI

Process:
--	I.	Populate PODetail with one row for each week in the horizon.
--	II.	Return results.
--	III.	Finished.
*/

--<Debug>
Begin Transaction
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ( )
	select	@ProcStartDT = GetDate ( )
	print	'GetVendorReleases START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--	Temporary Tables:
--	PODetail gets one row per week within the firm and planning horizon for the vendor.
create table #PODetail
(	WeekNo int primary key,
	SchedType char (1) null,
	Quantity numeric (20,6) null )

--	Declarations:
declare	@FirmDays int,	--	Firm days in schedule.
	@VendorDeliveryDay int,	--	Vendor's delivery day.
	@FirstDayofWeek datetime,	--	Sunday of the current week.
	@WeekNo int,	--	Week No (0) is current week.
	@FirmWeeks int,	--	Number of firm weeks.
	@PlanWeeks int	--	Number of planning weeks.

--	I.	Populate PODetail with one row for each week in the horizon.
--	<Debug>
if @Debug & 1 = 1
	print	'Firm Days must be more than zero...'
--	</Debug>

select	@FirmDays = ( case when po_header.vendor_code = 'TTI' then 7 when isnull ( FABAuthdays, 0 ) > 0 then FABAuthDays else 14 end )
from		dbo.part_vendor,
			dbo.po_header
where	po_number = @PONumber and
			blanket_part = @Part and
			part_vendor.part = blanket_part and
			part_vendor.vendor = po_header.vendor_code

--	<Debug>
if @Debug & 1 = 1
	print	'Vendor Delivery Day must be between 1 and 7 and defaults to 2...'
--	</Debug>

select	@VendorDeliveryDay = isnull (
	(	case when custom4 like '[0-7]' then convert ( integer, custom4 ) end ), 2 )
from	dbo.vendor_custom
where	code =
	(	select	vendor_code
		from	dbo.po_header
		where	po_number = @PONumber )

--	<Debug>
if @Debug & 1 = 1
	print	'Firm weeks is Firm Days / 7 unless Firm Days is later in the week than Delivery Day...'
--	</Debug>

select	@FirmWeeks = ( case when ( @FirmDays%7 ) + 1 <= @VendorDeliveryDay then @FirmDays / 7 else 1 + @FirmDays / 7 end )

--	<Debug>
if @Debug & 1 = 1
	print	'Read planning weeks, which must be at least 1...'
--	</Debug>


/*	
	Modify:  Hiran Coello Jan/4/2018  Requested by Lidia Rapalo
	Modify to only send 8 weeks of Planning + 1 week of current week, general for all. we are going to modify PartSetup to allow users to change this value 
	based on the part 
*/

declare @PlanWeekToDisplayEDI  int

select	@PlanWeekToDisplayEDI =isnull(PlanWeekToDisplayEDI,0)
from	eeh.dbo.vendor 
where	code =
	(	select	vendor_code
		from	dbo.po_header
		where	po_number = @PONumber )


select	@PlanWeeks =  case when @PlanWeekToDisplayEDI=0
							then ( case when isnull ( total_weeks, 0 ) > 0 then total_weeks else 26 end )
							else @FirmWeeks + @PlanWeekToDisplayEDI + 1 end

from	dbo.edi_vendor
where	vendor =
	(	select	vendor_code
		from	dbo.po_header
		where	po_number = @PONumber )


--set	@PlanWeeks = @FirmWeeks + 9

--	<Debug>
if @Debug & 1 = 1
	print	'Loop and generate a row for each line in the release plan...'
--	</Debug>

select	@WeekNo = 0

while @WeekNo < @PlanWeeks
begin
	insert	#PODetail
	(	WeekNo,
		SchedType )
	select	@WeekNo,
		( case when @WeekNo <= @FirmWeeks then 'C' else 'D' end )
	
	select	@WeekNo = @WeekNo + 1
end

--	<Debug>
if @Debug & 1 = 1
	print	'First day of week is Sunday of current week...'
--	</Debug>

select	@FirstDayofWeek = dateadd ( day, datediff ( day, '2001-01-01', dateadd ( day, 1 - ( datepart ( dw, getdate () ) ), getdate () ) ), '2001-01-01' )

--	<Debug>
if @Debug & 1 = 1
	print	'Return results...'
--	</Debug>

--	II.	Return results.
select	Quantity = convert ( varchar (20), convert ( integer, isnull ( sum ( po_detail.balance ), 0 ) ) ),
	SchedType = min ( #PODetail.SchedType ),
	DueDT = convert ( char (6), DateAdd ( day, #PODetail.WeekNo * 7 + @VendorDeliveryDay - 1, @FirstDayofWeek ), 12 ),
	AccumReceived = isnull (
	(	select	cum_expected
		from	dbo.edi_830_work
		where	po_number = @PONumber and
			part = @Part ), 0 )
from	#PODetail
	left outer join dbo.po_detail on po_detail.po_number = @PONumber and
		po_detail.part_number = @Part and
		(	isnull ( po_detail.deleted, 'N' ) != 'Y' or po_detail.received > 0 ) and
		(	DateDiff ( wk, @FirstDayofWeek, po_detail.date_due ) = #PODetail.WeekNo or
			(	#PODetail.WeekNo = 0 and po_detail.date_due < @FirstDayofWeek ) )
group by
	#PODetail.WeekNo

--	III.	Finished.
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
Commit Transaction
--</Debug>



GO
