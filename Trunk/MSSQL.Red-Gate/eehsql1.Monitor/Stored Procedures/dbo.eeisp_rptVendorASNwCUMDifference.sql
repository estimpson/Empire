SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure
[dbo].[eeisp_rptVendorASNwCUMDifference](@received varchar(1))
as
begin
  /*	Declarations:*/
  declare @ReceiptPeriodID integer,
  @PeriodEndDT datetime
  begin transaction
  execute FT.csp_RecordReceipts @ReceiptPeriodID,@PeriodEndDT,0
  commit transaction
  create table
    #ASNs(
    ASNDate datetime null,
    PONumber integer null,
    Part varchar(25) null,
    QtyShipped decimal(20,6) null,
    CUMQtyShipped decimal(20,6) null,
    )
  create table
    #Receipts(
    PONumber integer null,
    Part varchar(25) null,
    QTYReceived decimal(20,6) null,
    CUMQtyReceived decimal(20,6) null,
    CUMQtyAdjust decimal(20,6) null,
    )
  insert into #ASNs
    select distinct
      ASNDate,
      EEPO,
      EEPART,
      QtyShipped,
      CUMQtyShipped
      from VendorASNsWaitingforReview
  insert into #Receipts
    select PONumber,
      Part,
      0,
      StdQty,
      isNULL(AccumAdjust,0)
      from FT.POReceiptTotals
  begin transaction
  insert into VendorASNHistory
    select*
      from VendorASNsWaitingforReview
  commit transaction
  begin transaction
  delete from VendorASNsWaitingforReview
  commit transaction
  select #ASNs.ASNDate,
    #ASNs.PONumber,
    #ASNs.Part,
    #ASNs.QtyShipped,
    #ASNs.CUMQtyShipped,
    CUM_to_consider=(case when isNULL(@received,'N')='Y' then #ASNs.CUMQtyShipped else #ASNs.CUMQtyShipped-#ASNs.QtyShipped end),
    #Receipts.PONumber,
    #Receipts.Part,
    #Receipts.CUMQtyReceived,
    #Receipts.CUMQtyAdjust,
    PO_Header.vendor_code
    from #ASNs left outer join
    #Receipts on #ASNs.PONumber=#Receipts.PONumber and #ASNs.Part=#Receipts.Part left outer join
    po_header on #ASNs.PONumber=po_header.po_number and #ASNs.Part=PO_header.blanket_Part
end
GO
