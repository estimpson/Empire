SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[CUMdiffanalysis_fxDelete]
as
begin
  begin transaction
  create table #POReceiptPart(
    PONumber integer null,
    Part varchar(25) null,
    ATQty decimal(20,6) null,
    FTQty decimal(20,6) null,
    FTMissedQty decimal(20,6) null,
    )
  create table #MissingReceiptsSummed(
    PONumber integer null,
    Part varchar(25) null,
    SummedFTMissedQty decimal(20,6) null,
    )
  insert into #POReceiptPart
    select PONumber,
      Part,
      ATQty,
      FTQty,
      null
      from eeiat_ftcumqtydifference
  insert into #MissingReceiptsSummed
    select PONumber,
      Part,
      Sum(qty)
      from eeiproblemreceiptperiods
      group by PONumber,
      Part
  update #POReceiptPart set
    FTMissedQty=isNULL(SummedFTMissedQty,0)
    from #POReceiptPart
    ,#MissingReceiptsSummed
    where #POReceiptPart.POnumber=#MissingReceiptsSummed.PONumber
    and #POReceiptPart.Part=#MissingReceiptsSummed.Part
  select #POReceiptPart.PONumber,#POReceiptPart.Part,#POReceiptPart.ATQty,
    #POReceiptPart.FTQty,isNULL(#POReceiptPart.FTMissedQty,0),
    Diff=ATQty-FTQty,Diff-isNULL(FTMissedQty,0),Vendor_code,Vendor.name,vendor.contact,vendor.phone,AccumAdjust
    from #POReceiptPart join
    FT.POReceiptTotals on #POReceiptPart.PONumber=POReceiptTotals.PONumber and #POReceiptPart.part=POReceiptTotals.part join
    po_header on #POReceiptPart.PONumber=po_header.po_number join
    vendor on po_header.vendor_code=vendor.code order by
    vendor_code asc,#POReceiptPart.PONumber asc
end

GO
