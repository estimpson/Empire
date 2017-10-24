SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_edi_vend_830_rev1] as
begin
------------------------------------------------------------------------------------
-- eeisp_edi_vend_830
-- Gather data for POs to vendors
-- 05/2002 by Bruce Harold
-- 09/2003 - Track high water marks on authorizations
-- 09/2003 - Handle po_detail records marked for deletion
-- 03/2004 - Send open releases rather than what should be future
--	   - allow them to send no raw authorization
--08/2004 - Set Raw Auth to 0 where Raw Auth is NULL --- Andre S. Boulanger
--09/2004 - Update part_vendor.vendor_part to part_vendor.part where vendor_part is NULL or '' --- Andre S. Boulanger
--10/07/2004 - Changed horizon end date logic. Will pull po_detail where due_date <= Horizon end date in line item dw --- Andre S. Boulanger
--11/24/2004 - Changed select statement for PO list to include POs where release control = 'L'
---08/26/2005  Changed to pull actual Raw Auth Qty. Applied as  eeisp_edi_vend_830_rev1 Original procedure was eeisp_edi_vend_830 - Andre S. Boulanger
------------------------------------------------------------------------------------

-- Define variables
declare @currdate       datetime,
        @sendstart  	datetime,
        @curryear       integer,
        @curryearstart  datetime,
        @StcurrentYear	varchar(25),
        @vendcnt        integer,
        @day_char_check char (3),
        @Debug 					integer

-- Set values
select  @currdate = getdate()
-- Set to Monday of current week
select  @sendstart = 	convert(datetime,
				(convert(varchar(10),
                			dateadd(day, 2-(datepart(dw,@currdate)), @currdate),
                		111) ) )
select  @curryear = year(@currdate)
Select	@StcurrentYear = convert(varchar(25), @curryear)
select  @curryearstart = convert (datetime, @StcurrentYear +'-'+'01'+'-'+'01')


begin
declare	@ReleasePlanID integer

execute	FT.csp_RecordVendorReleasePlan
	@ReleasePlanID = @ReleasePlanID output
end
	

-- Clear out work table
truncate table
	edi_830_work

-- Get list of vendors.  Existing list from manual selection or select for today.
if (select count (*) from edi_vendor_send_list) = 0
begin
        select @day_char_check =
                '%' + substring('NMTWHFS', datepart(dw, @currdate), 1) + '%'
        
        insert into edi_vendor_send_list
        select  edi_vendor.vendor
        from    edi_vendor
        where   auto_create_po = 'Y' and
                send_days like @day_char_check
end

-- Update Part_vendor
update 	part_vendor
set	vendor_part = part
where	vendor_part = '' or vendor_part is NULL

-- Get full list of POs and parts that are qualified
-- Custom for Empire: remove outer join for edi_po.  Therefore must be defined
--   in edi_po.
-- Custom for Empire: 0 in raw weeks means no raw authorization.
-- Andre S. Boulanger 11/24/04 Changed where clause to include Release control 'L'
insert  edi_830_work
        (po_number,
        vendor,
        part,
        firm_end_date,
        horizon_end_date,
        raw_auth_end_date)
select  po_header.po_number,
        po_header.vendor_code,
        po_header.blanket_part,
        FabDate =
        (	select	FabDate
        	from	FT.vwPOHeaderEDI
        	where	FT.vwPOHeaderEDI.PONumber = po_header.po_number and
        		FT.vwPOHeaderEDI.Part = po_header.blanket_part ),
--        dateadd(day,
--                (case when isnull(edi_po.firm_days, 0) > 0
--                        then edi_po.firm_days
--                else 14 end),
--                @sendstart),
        dateadd(week,
                (case when isnull(edi_vendor.total_weeks, 0) > 0
                        then edi_vendor.total_weeks
                else 6 end),
                @sendstart),
        -- Number of weeks of orders to determine raw material authorization
       RawDate =
        (	select	RawDate
        	from	FT.vwPOHeaderEDI
        	where	FT.vwPOHeaderEDI.PONumber = po_header.po_number and
        		FT.vwPOHeaderEDI.Part = po_header.blanket_part )
       
----       dateadd(week,
----                (isnull(edi_vendor.raw_auth_weeks, 4)),
----                @sendstart)
from    po_header
        join edi_vendor_send_list on edi_vendor_send_list.vendor = po_header.vendor_code
        join edi_vendor on edi_vendor.vendor = po_header.vendor_code
         join edi_po on edi_po.po_number = po_header.po_number
where   edi_vendor.auto_create_po = 'Y' and
        po_header.release_control in ('L', 'A' ) and
        po_header.status <> 'C' and
	po_header.type = 'B'

-- "Removed 10/7/04 Andre S. Boulanger"
-- "Will modify select statement on line item dw to not select any po_detail with demand 
--  after the horizon end date
--delete  edi_830_work
--where   not exists(
--             select  1 from po_detail
--          where   po_detail.po_number = edi_830_work.po_number and
--                    po_detail.part_number = edi_830_work.part and
--                 date_due <= horizon_end_date and
--		isnull(po_detail.deleted,'') <> 'Y'
--       )

-- Update vendor part
update  edi_830_work
set     vendor_part = (
                select  isnull(part_vendor.vendor_part, edi_830_work.part)
                from    part_vendor
                where   part_vendor.part = edi_830_work.part and
                        part_vendor.vendor = edi_830_work.vendor
        )

-- Update unit of measure and description
-- "Modified 10/7/2004 Changed logic to use part_inventory standard unit and part.name
-- standard unit was being used indirectly due to the fact no unit conversions exist
-- description comes from part name.
-- This is required becuase we need to send the UM when no po_detail exists" 

--update  edi_830_work
--set     unit_of_measure = (
--                select  max(unit_of_measure)
--                from    po_detail
--                where   po_detail.po_number = edi_830_work.po_number and
--                        po_detail.part_number = edi_830_work.part
--        ),
--        description = (
--                select  max(description)
--                from    po_detail
--                where   po_detail.po_number = edi_830_work.po_number and
--                        po_detail.part_number = edi_830_work.part
--        )

update  edi_830_work
set     unit_of_measure = (
                select  standard_unit
                from    part_inventory
                where   part_inventory.part = edi_830_work.part
        ),
        description = (
                select  substring(name,1,78)
                from    part
                where   part.part = edi_830_work.part
        )

-- Update from edi_po and edi_buyer
update  edi_830_work
set     edi_830_work.dock_code = edi_po.dock_code,
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

-- Update engineering change level
update  edi_830_work
set     edi_830_work.engineering_level =
	(	select	effective_change_notice.engineering_level
		from	effective_change_notice 
		where   effective_date =
			(	select  max(effective_date)
				from    effective_change_notice
				where   part = edi_830_work.part and effective_date <= @sendstart ) and
        		effective_change_notice.part = edi_830_work.part )

update	edi_830_work
set	cum_received = isnull (
	(	select	StdQty + AccumAdjust
		from	FT.POReceiptTotals
		where	edi_830_work.po_number = FT.POReceiptTotals.PONumber and
			edi_830_work.part = FT.POReceiptTotals.Part ), 0 )

--update  edi_830_work
--set     cum_received = (
--                select  isnull( sum(quantity), 0 )
--                from    audit_trail
--                where   audit_trail.part = edi_830_work.part and
--                        audit_trail.type = 'R' and
--                        audit_trail.po_number = convert(varchar(30), edi_830_work.po_number) and
--                        audit_trail.date_stamp >= @curryearstart
--        )

--update  edi_830_work
--set     cum_received = cum_received + isnull(cum_adjust, 0)
--from    edi_po_year
--where   edi_po_year.po_number = edi_830_work.po_number and
--        edi_po_year.part = edi_830_work.part and
--        edi_po_year.year = @curryear

-- Update cum expected
-- initial default
update  edi_830_work
set     cum_expected = cum_received

-- Other steps removed for Empire 03/2004
---- past due
--update  edi_830_work
--set     cum_expected = cum_expected + (
--                select  isnull( sum(balance), 0 )
--                from    po_detail
--                where   po_detail.po_number = edi_830_work.po_number and
--                        po_detail.part_number = edi_830_work.part and
--                        po_detail.date_due < @sendstart
--        )
---- received ahead (po_detail)
--update  edi_830_work
--set     cum_expected = cum_expected - (
--                select  isnull( sum(received), 0 )
--                from    po_detail
--                where   po_detail.po_number = edi_830_work.po_number and
--                        po_detail.part_number = edi_830_work.part and
--                        po_detail.date_due >= @sendstart
--        )
---- received ahead (po_detail_history, only ones not still in po_detail)
--update  edi_830_work
--set     cum_expected = cum_expected - (
--                select  isnull( sum(received), 0 )
--                from    po_detail_history
--                where   po_detail_history.po_number = edi_830_work.po_number and
--                        po_detail_history.part_number = edi_830_work.part and
--                        po_detail_history.date_due >= @sendstart and
--                        not exists (
--                                select  1 from po_detail
--                                where   po_detail.po_number = po_detail_history.po_number and
--                                        po_detail.part_number = po_detail_history.part_number and
--                                        po_detail.date_due = po_detail_history.date_due and
--                                        po_detail.row_id = po_detail_history.row_id
--                        )
--        )
--

-- Update last received

-- start with last point in time
update  edi_830_work
set     last_rcv_date = (
                select  isnull( max(audit_trail.date_stamp),  @currdate )
                from    audit_trail
                where   audit_trail.part = edi_830_work.part and
                        audit_trail.po_number = convert(varchar(30), edi_830_work.po_number) and
                        audit_trail.type = 'R'
        )

-- then find vendor's shipper for this point in time    
update  edi_830_work
set     last_rcv_id = (
                select  isnull( max(audit_trail.shipper), '' )
                from    audit_trail
                where   audit_trail.part = edi_830_work.part and
                        audit_trail.date_stamp = edi_830_work.last_rcv_date and
                        audit_trail.po_number = convert(varchar(30), edi_830_work.po_number) and
                        audit_trail.type = 'R'
        )

-- last find the total quantity for the vendor's shipper
update  edi_830_work
set     last_rcv_qty = (
                select  isnull( sum(audit_trail.quantity), 0 )
                from    audit_trail
                where   audit_trail.part = edi_830_work.part and
                        audit_trail.shipper = edi_830_work.last_rcv_id and
                        audit_trail.po_number = convert(varchar(30), edi_830_work.po_number) and
                        audit_trail.type = 'R' and
                        edi_830_work.last_rcv_id > ' '
        )

-- Update fab authorization based on orders within firm weeks range
-- update from PO Detail
-- Modified to sum(balance) and not quantity --- Andre S. Boulanger 10/07/04
-- Removed check on po_detail due date being > @sendstart; Potential problem when ARS is run on Saturday
update  edi_830_work
set     fab_auth_qty = isnull (
        (	select	HighFabQty
        	from	FT.vwPOHeaderEDI
        	where	FT.vwPOHeaderEDI.PONumber = edi_830_work.po_number and
        		FT.vwPOHeaderEDI.Part = edi_830_work.part ), 0 )
update  edi_830_work
set     raw_auth_qty = isnull (
        (	select	HighRawQty
        	from	FT.vwPOHeaderEDI
        	where	FT.vwPOHeaderEDI.PONumber = edi_830_work.po_number and
        		FT.vwPOHeaderEDI.Part = edi_830_work.part ), 0 )
-- avoid negatives
update  edi_830_work
set     fab_auth_qty = 0.0
where   fab_auth_qty < 0.0

update  edi_830_work
set     raw_auth_qty = 0.0
where   raw_auth_qty < 0.0

--- Raw Auth should always be >= FAb Auth
update  edi_830_work
set     raw_auth_qty = fab_auth_qty
where   raw_auth_qty < fab_auth_qty



--update  edi_830_work
--set     fab_auth_qty = cum_expected + (
--                select  isnull( sum( balance ), 0)
--                from    po_detail
--                where   edi_830_work.po_number = po_detail.po_number and
--                        edi_830_work.part = po_detail.part_number and
----                        po_detail.date_due >= @sendstart and
--                        po_detail.date_due < edi_830_work.firm_end_date
--                )

-- Removed for Empire 03/2004
---- update from PO Detail History (for records no longer in PO Detail)
---- "received" is the most accurate value for the final quantity once the
----   record is no longer in current, but it has limitations
--update  edi_830_work
--set     fab_auth_qty = fab_auth_qty + isnull(
--                (select sum(received)
--                from    po_detail_history
--                where   edi_830_work.po_number = po_detail_history.po_number and
--                        edi_830_work.part = po_detail_history.part_number and
--                        po_detail_history.date_due >= @sendstart and
--                        po_detail_history.date_due < edi_830_work.firm_end_date and
--                        not exists (
--                                select  1 from po_detail
--                                where   po_detail.po_number = po_detail_history.po_number and
--                                        po_detail.part_number = po_detail_history.part_number and
--                                        po_detail.date_due = po_detail_history.date_due and
--                                        po_detail.row_id = po_detail_history.row_id
--                        )),
--                0)



-- Update raw authorization based on orders within raw auth weeks range
-- update from PO Detail
-- For Empire: Only send if fab weeks > 0
-- Sum (balance) not quantity Andre S. Boulanger 10/7/2004

--update  edi_830_work
--set     raw_auth_qty = fab_auth_qty + (
--                select  isnull( sum( balance ), 0)
--                from    po_detail
--                where   edi_830_work.po_number = po_detail.po_number and
--                        edi_830_work.part = po_detail.part_number and
--                        po_detail.date_due >= edi_830_work.firm_end_date and
--                        po_detail.date_due < edi_830_work.raw_auth_end_date
--                )
--where	raw_auth_end_date > @sendstart

-- Removed for Empire 03/2004
-- update from PO Detail History (for records no longer in PO Detail)
--update  edi_830_work
--set     raw_auth_qty = raw_auth_qty + isnull(
--                (select sum(received)
--                from    po_detail_history
--                where   edi_830_work.po_number = po_detail_history.po_number and
--                        edi_830_work.part = po_detail_history.part_number and
--                        po_detail_history.date_due >= edi_830_work.firm_end_date and
--                        po_detail_history.date_due < edi_830_work.raw_auth_end_date and
--                        not exists (
--                                select  1 from po_detail
--                                where   po_detail.po_number = po_detail_history.po_number and
--                                        po_detail.part_number = po_detail_history.part_number and
--                                        po_detail.date_due = po_detail_history.date_due and
--                                        po_detail.row_id = po_detail_history.row_id
--                        )),
--                0)

-- avoid negatives
----update  edi_830_work
----set     raw_auth_qty = 0.0
----where   raw_auth_qty < 0.0 or raw_auth_qty is NULL

-- Update High water mark for fab/raw authorizations if higher or new year
-- Removed 01/05/2005 Andre S. Boulanger. FT tables now being used to store this data.

/*update  edi_po_high_auth ph
--set     high_fab_date = @currdate,
        high_fab_auth = fab_auth_qty
from    edi_830_work w
where   ph.po_number = w.po_number and
        ph.part = w.part and
        ph.cumyear = @curryear and
	w.fab_auth_qty > ph.high_fab_auth

update  edi_po_high_auth ph
set     high_raw_date = @currdate,
        high_raw_auth = raw_auth_qty
from    edi_830_work w
where   ph.po_number = w.po_number and
        ph.part = w.part and
        ph.cumyear = @curryear and
	w.raw_auth_qty > ph.high_raw_auth

-- Insert high water mark for new PO/Part

insert  into edi_po_high_auth
        (po_number, part, cumyear, high_fab_date, high_fab_auth,
        high_raw_date, high_raw_auth)
select	w.po_number, w.part, @curryear, @currdate, w.fab_auth_qty,
        @currdate,
        isnull(w.raw_auth_qty,0)
from    edi_830_work w
where   not exists      (select *
                        from    edi_po_high_auth ph2
                        where   ph2.po_number = w.po_number and
                                ph2.part = w.part and
                                ph2.cumyear = @curryear)*/

-- Reset send list
delete edi_vendor_send_list

-- Final selection for datawindow
select distinct vendor
from edi_830_work
order by vendor

end

GO
