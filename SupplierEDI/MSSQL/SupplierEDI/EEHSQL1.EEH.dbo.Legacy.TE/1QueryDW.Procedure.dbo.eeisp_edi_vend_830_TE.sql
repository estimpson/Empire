alter procedure dbo.eeisp_edi_vend_830_TE
as
------------------------------------------------------------------------------------
-- eeisp_edi_vend_830
-- Gather data for POs to vendors
-- 05/2002 by Bruce Harold
-- 09/2003 - Track high water marks on authorizations
-- 09/2003 - Handle po_detail records marked for deletion
-- 03/2004 - Send open releases rather than what should be future
--	- allow them to send no raw authorization
--08/2004 - set	Raw Auth to 0 where	Raw Auth is NULL --- Andre S. Boulanger
--09/2004 - update	part_vendor.vendor_part to part_vendor.part where	vendor_part is NULL or '' --- Andre S. Boulanger
--10/07/2004 - Changed horizon end date logic. Will pull po_detail where	due_date <= Horizon end date in line item dw --- Andre S. Boulanger
--11/24/2004 - Changed select	statement for PO list to include POs where	release control = 'L'
---08/26/2005 Changed to pull actual Raw Auth Qty. Applied as eeisp_edi_vend_830_rev1 Original procedure was eeisp_edi_vend_830 - Andre S. Boulanger
---06/05/2007 - Eliminates PIONEER from	Vendor List
---11/19/2007- Now Eliminates TTI 
---- 08/12/2008 - Noe Eliminats MCMASTERS
-- 04/04/2014 - Now eliminates KOSTAL --Andre S. Boulanger FT, LLC
-- 10/11/2015 - Retrieves only TE and returns bth Vendor Code and PO Number --Andre S. Boulanger FT, LLC
------------------------------------------------------------------------------------

--	Define variables
declare @currdate datetime,
	@sendstart datetime,
	@curryear integer,
	@curryearstart datetime,
	@StcurrentYear varchar (25),
	@vendcnt integer,
	@day_char_check char (3),
	@Debug integer

--	set values
select	@currdate = getdate ()

--	set to Monday of current week
select	@sendstart = convert (datetime,
		(convert (varchar (10), dateadd (day, 2- (datepart (dw,@currdate)), @currdate), 111)))

select	@curryear = year (@currdate)
Select	@StcurrentYear = convert (varchar (25), @curryear)
select	@curryearstart = convert (datetime, @StcurrentYear +'-'+'01'+'-'+'01')

--	Record vendor release plan.
declare	@ReleasePlanID integer

execute	FT.csp_RecordVendorReleasePlan
	@ReleasePlanID = @ReleasePlanID output
	
--	Clear out work table.
truncate table
	edi_830_work

--	Get list of vendors. Existing list from	manual selection or select for today.
if	(	Select	count (1)
		from	edi_vendor_send_list) = 0
begin
	select	@day_char_check =
		'%' + substring ('NMTWHFS', datepart (dw, @currdate), 1) + '%'
	
	insert	edi_vendor_send_list
	select	edi_vendor.vendor
	from	edi_vendor
	where	auto_create_po = 'Y' and
		send_days like @day_char_check
end

--	update	Part_vendor
update	part_vendor
set	vendor_part = part
where	vendor_part = '' or vendor_part is NULL

--	Get full list of POs and parts that are qualified
--	Custom for Empire: remove outer join for edi_po. Therefore must be defined
--	in edi_po.
--	Custom for Empire: 0 in raw weeks means no raw authorization.
--	Andre S. Boulanger 11/24/04 Changed where clause to include Release control 'L'
insert	edi_830_work
(	po_number,
	vendor,
	part,
	firm_end_date,
	horizon_end_date,
	raw_auth_end_date)
select	po_header.po_number,
	po_header.vendor_code,
	po_header.blanket_part,
	FabDate =
	(	select	FabDate
		from	FT.vwPOHeaderEDI
		where	FT.vwPOHeaderEDI.PONumber = po_header.po_number and
			FT.vwPOHeaderEDI.Part = po_header.blanket_part),
	dateadd (week,
		case	when coalesce (edi_vendor.total_weeks, 0) > 0 then edi_vendor.total_weeks
			else 26
		end, @sendstart),
								-- Number of weeks of orders to determine raw material authorization.
	RawDate =
	(	select	RawDate
		from	FT.vwPOHeaderEDI
		where	FT.vwPOHeaderEDI.PONumber = po_header.po_number and
			FT.vwPOHeaderEDI.Part = po_header.blanket_part)
from	po_header
	join edi_vendor_send_list on edi_vendor_send_list.vendor = po_header.vendor_code
	join edi_vendor on edi_vendor.vendor = po_header.vendor_code
	join edi_po on edi_po.po_number = po_header.po_number
where	edi_vendor.auto_create_po = 'Y' and
	po_header.release_control in ('L', 'A') and
	po_header.status != 'C' and
	po_header.type = 'B' and
	edi_vendor.trading_partner_code  in ( 'TE')
	
	-- ( 'ARROWCORP', 'TTI', 'MCMASTERS', '3M', 'GPOLYMER','ARROW', 'FUTURE')  old list modified on 4/4/2014 Andre S. Boulanger FT, LLC

--	update	vendor part
update	edi_830_work
set	vendor_part =
	(	select	coalesce (part_vendor.vendor_part, edi_830_work.part)
		from	part_vendor
		where	part_vendor.part = edi_830_work.part and
			part_vendor.vendor = edi_830_work.vendor)

--	update unit of measure and description
--	"Modified 10/7/2004 Changed logic to use part_inventory standard unit and part.name
--	standard unit was being used indirectly due to the fact no unit conversions exist
--	description comes from	part name.
--	This is required becuase we need to send the UM when no po_detail exists" 
update	edi_830_work
set	unit_of_measure =
	(	select	standard_unit
		from	part_inventory
		where	part_inventory.part = edi_830_work.part),
	description =
	(	select	substring (name,1,78)
		from	part
		where	part.part = edi_830_work.part)

--	update	from	edi_po and edi_buyer
update	edi_830_work
set	edi_830_work.dock_code = edi_po.dock_code,
	edi_830_work.buyer_name = b1.name,
	edi_830_work.buyer_phone = parameters.phone_number,
	edi_830_work.buyer_email = b1.email,
	edi_830_work.scheduler_name = b2.name,
	edi_830_work.scheduler_phone = parameters.phone_number,
	edi_830_work.scheduler_email = b2.email
from	edi_830_work
	join edi_po on edi_po.po_number = edi_830_work.po_number
	left outer join edi_buyer b1 on b1.buyer_id = edi_po.buyer_id
	left outer join edi_buyer b2 on b2.buyer_id = edi_po.scheduler_id
	cross join parameters

--	update engineering change level
update	edi_830_work
set	edi_830_work.engineering_level =
	(	select	effective_change_notice.engineering_level
		from	effective_change_notice 
		where	effective_date =
		(	select	max (effective_date)
			from	effective_change_notice
			where	part = edi_830_work.part and effective_date <= @sendstart) and
	effective_change_notice.part = edi_830_work.part)

update	edi_830_work
set	cum_received = coalesce (
	(	select	StdQty + AccumAdjust
		from	FT.POReceiptTotals
		where	edi_830_work.po_number = FT.POReceiptTotals.PONumber and
			edi_830_work.part = FT.POReceiptTotals.Part), 0)

--	update cum expected
--	initial default
update	edi_830_work
set	cum_expected = cum_received

--	update last received
--	start with last point in time
update	edi_830_work
set	last_rcv_date =
	(	select	coalesce (max (audit_trail.date_stamp), @currdate)
		from	audit_trail
		where	audit_trail.part = edi_830_work.part and
			audit_trail.po_number = convert (varchar (30), edi_830_work.po_number) and
			audit_trail.type = 'R')

--	then find vendor's shipper for this point in time 
update	edi_830_work
set	last_rcv_id =
	(	select	coalesce (max (audit_trail.shipper), '')
		from	audit_trail
		where	audit_trail.part = edi_830_work.part and
			audit_trail.date_stamp = edi_830_work.last_rcv_date and
			audit_trail.po_number = convert (varchar (30), edi_830_work.po_number) and
			audit_trail.type = 'R')

--	last find the total quantity for the vendor's shipper
update	edi_830_work
set	last_rcv_qty =
	(	select	coalesce (sum (audit_trail.quantity), 0)
		from	audit_trail
		where	audit_trail.part = edi_830_work.part and
			audit_trail.shipper = edi_830_work.last_rcv_id and
			audit_trail.po_number = convert (varchar (30), edi_830_work.po_number) and
			audit_trail.type = 'R' and
			edi_830_work.last_rcv_id > ' ')

--	update fab authorization based on orders within firm weeks range
--	update from PO Detail
--	Modified to sum (balance) and not quantity --- Andre S. Boulanger 10/07/04
--	Removed check on po_detail due date being > @sendstart; Potential problem when ARS is run on Saturday
update	edi_830_work
set	fab_auth_qty = coalesce (
	(	select	HighFabQty
		from	FT.vwPOHeaderEDI
		where	FT.vwPOHeaderEDI.PONumber = edi_830_work.po_number and
			FT.vwPOHeaderEDI.Part = edi_830_work.part), 0)

update	edi_830_work
set	raw_auth_qty = coalesce (
	(	select	HighRawQty
		from	FT.vwPOHeaderEDI
		where	FT.vwPOHeaderEDI.PONumber = edi_830_work.po_number and
			FT.vwPOHeaderEDI.Part = edi_830_work.part), 0)
--	avoid negatives
update	edi_830_work
set	fab_auth_qty = 0.0
where	fab_auth_qty < 0.0

update	edi_830_work
set	raw_auth_qty = 0.0
where	raw_auth_qty < 0.0

--	Raw Auth should always be >= FAb Auth
update	edi_830_work
set	raw_auth_qty = fab_auth_qty
where	raw_auth_qty < fab_auth_qty


--	update statement for Price for PIONEER 830
--	Andre S. Boulanger		June 04 2007
update	edi_830_work
set	price = po_detail.alternate_price
from	edi_830_work,
	po_detail
where	po_detail.part_number = edi_830_work.part and
	po_detail.po_number = edi_830_work.po_number and
	po_detail.date_due =
	(	select	min (date_due) 
		from	po_detail
		where	po_detail.part_number = edi_830_work.part and
			po_detail.po_number = edi_830_work.po_number and
			coalesce (alternate_price, 0) > 0) 

update	edi_830_work
set	price = part_vendor_price_matrix.alternate_price
from	edi_830_work,
	part_vendor_price_matrix
where	part_vendor_price_matrix.part = edi_830_work.part and
	part_vendor_price_matrix.vendor = edi_830_work.vendor and
	part_vendor_price_matrix.break_qty =
	(	select	min (break_qty) 
		from	part_vendor_price_matrix
		where	part_vendor_price_matrix.part = edi_830_work.part and
			part_vendor_price_matrix.vendor = edi_830_work.vendor and
			coalesce (edi_830_work.price, 0) = 0) 

--	Reset send list
delete	edi_vendor_send_list

-- Final selection for datawindow
select distinct vendor
from edi_830_work






GO
