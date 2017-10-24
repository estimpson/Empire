SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_BlanketReleaseForm_dump_hc]
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
-10/24/2006	Andre S. Boulanger		For the select statement that inserts insert into EEH_BlanketReleaseform_dump, added part_vendor_price_matrix subselect to obtain pricing for the line item.

Process:
--	I.	Populate PODetail with one row for each week in the horizon.
--	II.	Return results.
--	III.	Finished.
*/
as
/*<Debug>*/

declare @ProcStartDT datetime
declare @StartDT datetime
select @StartDT=getdate()
select @ProcStartDT=getdate()
print 'GetVendorReleases START.   '+convert(varchar(50),@ProcStartDT)
/*</Debug>*/


delete from LatestBlanketRelease_nonEDI
/*	Temporary Tables:*/
/*	PODetail gets one row per week within the firm and planning horizon for the vendor.*/
create table #PODetail(
  WeekNo tinyint not null,
  SchedType char(1) null,
  Quantity decimal(20,6) null,
  primary key(WeekNo),
  ) /*	Declarations:*/
declare @FirmDays tinyint, /*	Firm days in schedule.*/
@VendorDeliveryDay tinyint, /*	Vendor's delivery day.*/
@FirstDayofWeek datetime, /*	Sunday of the current week.*/
@WeekNo tinyint, /*	Week No (0) is current week.*/
@FirmWeeks tinyint, /*	Number of firm weeks.*/
@PlanWeeks tinyint, /*	Number of planning weeks.*/
@part varchar(50), /*PO Header Blanket Part,*/
@PONumber integer, /* PO Number*/
@VendorPart varchar(50), /* Vendor Part*/
@ReceiptPeriodID integer,
@PeriodEndDT datetime



execute FT.csp_RecordReceipts @ReceiptPeriodID,@PeriodEndDT,0
/*	I.	Populate PODetail with one row for each week in the horizon.*/
/*	<Debug>*/
print 'Firm Days must be more than zero...'
/*	</Debug>*/
declare CreatePOLines cursor local for select default_po_number,
    blanket_part
    from po_header
    ,part_online
    where po_header.po_number=part_online.default_po_number
    and po_header.blanket_part=part_online.part
    and isNULL(po_header.status,'X')<>'C'
    and isNULL(po_header.type,'N')='B'
    and not po_header.vendor_code=any(select vendor from edi_vendor)
open CreatePOLines
fetch CreatePOLines into @PONumber,
  @part
while @@fetch_status=0
  begin
    select @FirmDays=(case when isnull(FABAuthdays,0)>0 then FABAuthDays else 14 end),
      @VendorPart=(case when isNULL(part_vendor.vendor_part,'X')='X' then part.cross_ref else part_vendor.vendor_part end)
      from
		  part_vendor
		  right join po_header
			on part_vendor.part=blanket_part
			and part_vendor.vendor=po_header.vendor_code
		  join part
			on part.part=@part
      where po_number=@PONumber
      and blanket_part=@Part
    /**/
    /*	<Debug>*/
    print 'Vendor Delivery Day must be between 1 and 7 and defaults to 2...'
    /*	</Debug>*/
    select @VendorDeliveryDay=isnull((case when custom4 like '[0-7]' then convert(integer,custom4) end),2)
      from vendor_custom
      where code
      =(select vendor_code
        from po_header
        where po_number=@PONumber)
    /*	<Debug>*/
    print 'Firm weeks is Firm Days / 7 unless Firm Days is later in the week than Delivery Day...'
    /*	</Debug>*/
    select @FirmWeeks=(case when (@FirmDays%7)+1<=@VendorDeliveryDay then @FirmDays/7 else 1+@FirmDays/7 end)
    /*	<Debug>*/
    print 'Read planning weeks, which must be at least 1...'
    /*	</Debug>*/
    select @PlanWeeks=(case when isnull(ceiling(Lead_time/7),0)>0 then ceiling(Lead_time/7)+20 else @firmWeeks end)
      from part_vendor
      where vendor
      =(select vendor_code
        from po_header
        where po_number=@PONumber)
      and part=@Part
    /*	<Debug>*/
    print 'Loop and generate a row for each line in the release plan...'
    /*	</Debug>*/
    select @WeekNo=0
    while @WeekNo<@PlanWeeks
      begin
        insert into #PODetail(WeekNo,
          SchedType)
          select @WeekNo,
            (case when @WeekNo<=@FirmWeeks then 'C' else 'D' end)
        select @WeekNo=@WeekNo+1
      end
    /*	<Debug>*/
    print 'First day of week is Sunday of current week...'
    /*	</Debug>*/
    select @FirstDayofWeek=dateadd(day,datediff(day,'2001-01-01',dateadd(day,1-(datepart(dw,getdate())),getdate())),'2001-01-01')
    /*	<Debug>*/
    print 'Return results...'

    /*	</Debug>*/
    /*	II.	Return / Insert/ Select  results.*/
    insert into LatestBlanketRelease_NonEDI
      select PONumber=@PONumber,
        Part=@Part,
        VendorPart=@VendorPart,
        Quantity=convert(integer,isnull(sum(po_detail.balance),0)),
        SchedType=min(#PODetail.SchedType),
		DueDT=convert(char(6),DateAdd(day,#PODetail.WeekNo*7+@VendorDeliveryDay-1,@FirstDayofWeek),12),
		PODetailDueDate=po_detail.date_due
        from #PODetail left outer join
        po_detail on po_detail.po_number=@PONumber
        and po_detail.part_number=@Part
        and(isnull(po_detail.deleted,'N')<>'Y' or po_detail.received>0)
        and(DateDiff(wk,@FirstDayofWeek,po_detail.date_due)=#PODetail.WeekNo
        or(#PODetail.WeekNo=0 and po_detail.date_due<@FirstDayofWeek))
        group by #PODetail.WeekNo,
						po_detail.date_due
    delete from #PODetail
    fetch CreatePOLines into @PONumber,
      @part end
close CreatePOLines
deallocate
	CreatePOLines
Truncate Table EEH_BlanketReleaseform_dump

insert into EEH_BlanketReleaseform_dump
  select BR.PONumber,
    BR.Part,
    BR.VendorPart,
    BR.Quantity,
	convert(datetime,BR.DueDT),
	 FirmorPlanning=(case when BR.SchedType='C' then 'Firm' else 'Planning' end),
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
      where audit_trail.part=po_header.blanket_part
      and datediff ( day, audit_trail.date_stamp,LastReceivedDT) = 0
      and audit_trail.po_number=convert(varchar(30),po_header.po_number)
      and audit_trail.type='R'),
    LastReceivedDT,
	po_header.terms,
	po_header.ship_via,
	po_header.fob,
	BR.poDetailDueDate,
	0,
	(Select	alternate_price 
		from		part_vendor_price_matrix pvpm
		where	pvpm.part = po_header.blanket_part and
					pvpm.vendor = po_header.vendor_code and
					pvpm.break_qty = (Select	max(pvpm2.break_qty)
														from	part_vendor_price_matrix pvpm2
													where	pvpm2.break_qty <= BR.Quantity and
																pvpm2.part = po_header.blanket_part and
																pvpm2.vendor = po_header.vendor_code))
																
    from LatestBlanketRelease_nonEDI as BR left outer join
    FT.POReceiptTotals POReceiptTotals on BR.PONumber=POReceiptTotals.PONumber and BR.Part=POReceiptTotals.Part join
    PO_header on BR.PONumber=PO_header.Po_number and PO_header.blanket_part=BR.part join
    Vendor on PO_header.vendor_code=vendor.code join
    part on po_header.blanket_part=part.part left outer join
    destination on po_header.ship_to_destination=destination.destination
    WHERE	schedtype = 'C' or (schedtype ='D' and BR.Quantity >0)


	/*SELECT  audit_trail.shipper, audit_trail.quantity AS qty INTO #Shiper_Qty
	FROM EEH_BlanketReleaseform_dump INNER JOIN audit_trail ON EEH_BlanketReleaseform_dump.last_rec_id = audit_trail.Shipper
	WHERE     (audit_trail.type = 'R')*/

	Update EEH_BlanketReleaseform_dump 
		Set EEH_BlanketReleaseform_dump.Last_Received_qty = EEH_Shippers_Qty.QTY 
		FROM EEH_BlanketReleaseform_dump INNER JOIN EEH_Shippers_Qty ON EEH_BlanketReleaseform_dump.last_rec_id = EEH_Shippers_Qty.Shipper

/*	III.	Finished.*/
/*<Debug>*/
begin
  print 'FINISHED.   '+convert(varchar,DateDiff(ms,@ProcStartDT,getdate()))+' ms'

end
--commit transaction
/*</Debug>*/
GO
