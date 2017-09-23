SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create procedure
[dbo].[eeisp_rpt_BlanketReleaseForm_dropship]
/*
Arguments:
None

Result set:
None

Description:
Get Vendor EDI Releases for a 

Example:
execute	eeisp_rpt_BlanketReleaseForm


Author:
Andre S. Boulanger


Process:
--	I.	Populate PODetail with one row for each week in the horizon.
--	II.	Return results.
--	III.	Finished.
*/
as
begin
/*	Declarations:*/
declare 
@ReceiptPeriodID integer,
@PeriodEndDT datetime



execute FT.csp_RecordReceipts @ReceiptPeriodID,@PeriodEndDT,0


  select po_detail.PO_Number,
    po_detail.Part_number,
    (select max(part_vendor.Vendor_Part) from
			part_vendor where
			part_vendor.part = POH.blanket_part and
			POH.vendor_code = part_vendor.vendor) as VendorPart,
    po_detail.balance,
	po_detail.date_due,
	'Firm',
    AccumReceived=isNULL(POReceiptTotals.STDQty,0),
    AccumAdjustment=isNULL(POReceiptTotals.AccumAdjust,0),
    AdjustedCUMReceived=isNULL(POReceiptTotals.STDQty,0)+isNULL(POReceiptTotals.AccumAdjust,0),
    Vendor.code,
    Vendor.name,
    Vendor.address_1,
    Vendor.address_2,
    Vendor.address_3,
    Vendor.address_6,
    Vendor.Contact,
    Vendor.Phone,
    destination.address_1,
    destination.address_2,
    destination.address_3,
    last_rec_id=(select isnull(max(audit_trail.shipper),'')
      from audit_trail
      where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' and
				audit_trail.date_stamp = (select max(date_stamp) from
			audit_trail where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' )),
   last_rec_date = (select max(date_stamp) from
			audit_trail where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' ) ,
	POH.terms,
	POH.ship_via,
	POH.fob,
	(Select	alternate_price 
		from		part_vendor_price_matrix pvpm
		where	pvpm.part = POH.blanket_part and
					pvpm.vendor = POH.vendor_code and
					pvpm.break_qty = (Select	max(pvpm2.break_qty)
														from	part_vendor_price_matrix pvpm2
													where	pvpm2.break_qty <= po_detail.Quantity and
																pvpm2.part = POH.blanket_part and
																pvpm2.vendor = POH.vendor_code)) as Price,
	order_header.customer_po  as customerPO,
	order_detail.customer_part  as customerPart,
	destination.destination as customerdestination,
	destination.name as destinationname,
	  last_rec_quantity=(select sum(quantity)
      from audit_trail
      where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' and
				audit_trail.shipper= (select isnull(max(audit_trail.shipper),'')
      from audit_trail
      where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' and
				audit_trail.date_stamp = (select max(date_stamp) from
			audit_trail where audit_trail.part=POH.blanket_part
      and audit_trail.po_number=convert(varchar(30),POH.po_number)
      and audit_trail.type='R' ))),
	ordertype=(CASE WHEN order_detail.type = 'F' THEN 'FIRM' WHEN order_detail.type = 'P' THEN 'Planning' ELSE 'Forecast' END),
	order_detail.order_no
    from po_header as POH left outer join
    FT.POReceiptTotals POReceiptTotals on POH.PO_Number=POReceiptTotals.PONumber and POH.blanket_Part=POReceiptTotals.Part  join
    PO_detail on POH.PO_Number=PO_detail.Po_number  join
    Vendor on POH.vendor_code=vendor.code join
    part on POH.blanket_part=part.part  join
    destination on POH.ship_to_destination=destination.destination join
	order_detail on po_detail.dropship_oe_row_id = order_detail.row_id and po_detail.sales_order = order_detail.order_no join
	order_header on order_detail.order_no = order_header.order_no
    


end
--commit transaction
/*</Debug>*/

GO
