SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_rpt_HighestAuthforVendorPO2](@po_number integer)
as
begin
  declare @ReleasePlanID integer
  begin transaction
  execute FT.csp_RecordVendorReleasePlan @ReleasePlanID=
  @ReleasePlanID
  commit transaction
  create table #RawRelease(
    ReleasePlanID smallint null,
    PONumber smallint null,
    Part varchar(50) null,
    WeekNo smallint null,
    PostAccum decimal(20,6) null,
    )
  create index idx_rawRelease1 on #RawRelease(WeekNo asc)
  create index idx_rawRelease2 on #RawRelease(ReleasePlanID asc)
  create index idx_rawRelease3 on #RawRelease(Part asc,PONumber asc)
  create table #UnauthReceipts(
    poNumber integer null,
    Part varchar(25) null,
    )
  create index idxunauthreceipts on #Unauthreceipts(Part asc,PONumber asc)
  insert into #Unauthreceipts
    select po_Number,
      blanket_part
      from po_header
      where po_header.po_number=@po_number
  insert into #RawRelease
    select ReleaseplanRaw.ReleasePlanID,
      ReleaseplanRaw.PONumber,
      ReleaseplanRaw.Part,
      ReleaseplanRaw.WeekNo,
      ReleaseplanRaw.PostAccum
      from FT.ReleaseplanRaw join
      #Unauthreceipts on ReleasePlanRaw.Part=#Unauthreceipts.part and ReleasePlanRaw.PONumber=#Unauthreceipts.PONumber
      where ReleaseplanID=any(select max(id) from FT.ReleasePlans group by GeneratedWeekNo)
  select FABweek=FABAuthorizations.WeekNo,
    FabDate=Dateadd(wk,FABAuthorizations.WeekNo,'1999/01/03'),
    FABGeneratedWeek=(select RP2.GeneratedWeekNo from FT.ReleasePlans as RP2 where RP2.ID=ReleasePlanID),
    FabGeneratedDate=Dateadd(wk,FABGeneratedWeek,'1999/01/03'),
    FABAuthorizations.PONumber,
    FABAuthorizations.Part,
    FABAuthorizations.AuthorizedAccum,
    MAxAccum=(select max(postAccum) from FT.releasePlanRaw as RPR where RPR.WeekNo<=FABAuthorizations.weekNo and RPR.ReleasePlanID>=FABAuthorizations.ReleasePlanID and RPR.PONumber=FABAuthorizations.PONumber and RPR.part=FABAuthorizations.part),
    HighFAB=(select max(HighFABAuthorizations.AuthorizedAccum) from FT.HighFABAuthorizations where HighFabAuthorizations.POnumber=FABAuthorizations.POnumber and HighFabAuthorizations.Part=FABAuthorizations.Part),
    vendor.code,
    vendor.name,
    vendor.contact,
    vendor.phone,
    AccumReceived=(select max(POReceiptTotals.STDQty) from FT.POReceiptTotals where POReceiptTotals.POnumber=FABAuthorizations.POnumber and POReceiptTotals.Part=FABAuthorizations.Part),
    1,
    LastReceivedDate=(select max(POReceiptTotals.LastReceivedDT) from FT.POReceiptTotals where POReceiptTotals.POnumber=FABAuthorizations.POnumber and POReceiptTotals.Part=FABAuthorizations.Part),
    TotalQtyOnPO=isNULL((select sum(quantity) from po_detail where po_number=FABAuthorizations.POnumber and part_number=FABAuthorizations.Part),0),
    firsTDueDate=(select min(date_due) from po_detail where po_number=FABAuthorizations.POnumber and part_number=FABAuthorizations.Part),
    lastDueDate=(select max(date_due) from po_detail where po_number=FABAuthorizations.POnumber and part_number=FABAuthorizations.Part),
    Lead_time=(FABWeek-FABGeneratedWeek),
    currentWeek=datediff(wk,'1999/01/03',getdate())
    from FT.FABAuthorizations join
    #UnauthReceipts on FABAUTHorizations.Part=#Unauthreceipts.part and FABAUTHorizations.PONumber=#Unauthreceipts.PONumber join
    PO_header on Fabauthorizations.PONumber=po_header.po_number and Fabauthorizations.part=po_header.blanket_part join
    Vendor on po_header.vendor_code=vendor.code
    where ReleasePlanID=any(select max(id) from FT.ReleasePlans where id=any(select ReleasePlanID from FT.FABAuthorizations) group by GeneratedWeekNo)
end
GO
