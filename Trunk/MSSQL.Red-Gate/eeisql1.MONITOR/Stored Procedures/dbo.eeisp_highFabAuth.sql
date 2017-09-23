SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_highFabAuth](@refreshdata char(1))
as
begin
  declare @ReleasePlanID integer,
  @currentWeekNo integer
  select @currentweekNo=datediff(wk,'1999/01/03',getdate())
	create table #FabAuths(
	vendor varchar(15) null,
	PONumber integer null,
	Part varchar(50) null,
	WeekNo smallint null,
	AuthAccum decimal(20,6) null,
	HighFABAccum decimal(20,6) null,
	)
	create index idx_FABAuths on #FabAuths(PONumber asc)
 if @refreshdata='Y'
    begin
      begin transaction
      execute FT.csp_RecordVendorReleasePlan @ReleasePlanID=
      @ReleasePlanID
      commit transaction
      insert into #FABAuths
        select po_header.vendor_code,
          FABAuthorizations.PONumber,
          FABAuthorizations.Part,
          FABAuthorizations.WeekNo,
          max(FABAuthorizations.AuthorizedAccum),
          HighFAB=(select max(authorizedAccum) from FT.HighFabAuthorizations where HighfabAuthorizations.PONumber=FabAuthorizations.POnumber and HighFabAuthorizations.Part=FabAuthorizations.Part)
          from FT.FabAuthorizations cross join
          FT.DTGlobals left outer join
          po_header on FabAuthorizations.ponumber=po_header.po_number join
          vendor on po_header.vendor_Code=vendor.code left outer join
          FT.POReceiptTotals on FabAuthorizations.PONumber=POReceiptTotals.POnumber
          where po_header.type='B'
          and DTGlobals.name='BaseWeek'
          and fabAuthorizations.WeekNo>=(@currentWeekNo-2) and fabAuthorizations.WeekNo<=(@currentWeekNo+3)
          and fabAuthorizations.PONumber=any(select default_po_number from part_online)
          group by po_header.vendor_code,FABAuthorizations.PONumber,FABAuthorizations.Part,FABAuthorizations.WeekNo
      select vendor.code,
        vendor.name,
        vendor.contact,
        vendor.phone,
        #FABAuths.PONumber,
        #FABAuths.Part,
        #FABAuths.WeekNo,
        #FABAuths.AuthAccum,
        #FABAuths.HighFABAccum,
        POreceiptTotals.StdQty,
        POReceiptTotals.AccumAdjust,
        POReceiptTotals.LastReceivedDT
        from #FABAuths left outer join
        FT.POReceiptTotals on #FABAuths.PONumber=POReceiptTotals.POnumber and #FABAuths.part=POReceiptTotals.part join
        vendor on #FABAuths.vendor=vendor.code
    end
  else
    begin
      insert into #FABAuths
        select po_header.vendor_code,
          FABAuthorizations.PONumber,
          FABAuthorizations.Part,
          FABAuthorizations.WeekNo,
          max(FABAuthorizations.AuthorizedAccum),
          HighFAB=(select max(authorizedAccum) from FT.HighFabAuthorizations where HighfabAuthorizations.PONumber=FabAuthorizations.POnumber and HighFabAuthorizations.Part=FabAuthorizations.Part)
          from FT.FabAuthorizations cross join
          FT.DTGlobals left outer join
          po_header on FabAuthorizations.ponumber=po_header.po_number join
          vendor on po_header.vendor_Code=vendor.code left outer join
          FT.POReceiptTotals on FabAuthorizations.PONumber=POReceiptTotals.POnumber
          where po_header.type='B'
          and DTGlobals.name='BaseWeek'
          and fabAuthorizations.WeekNo>=(@currentWeekNo-2) and fabAuthorizations.WeekNo<=(@currentWeekNo+3)
          and fabAuthorizations.PONumber=any(select default_po_number from part_online)
          group by po_header.vendor_code,FABAuthorizations.PONumber,FABAuthorizations.Part,FABAuthorizations.WeekNo
      select vendor.code,
        vendor.name,
        vendor.contact,
        vendor.phone,
        #FABAuths.PONumber,
        #FABAuths.Part,
        #FABAuths.WeekNo,
        #FABAuths.AuthAccum,
        #FABAuths.HighFABAccum,
        POreceiptTotals.StdQty,
        POReceiptTotals.AccumAdjust,
        POReceiptTotals.LastReceivedDT
        from #FABAuths left outer join
        FT.POReceiptTotals on #FABAuths.PONumber=POReceiptTotals.POnumber and #FABAuths.part=POReceiptTotals.part join
        vendor on #FABAuths.vendor=vendor.code
    end
end
GO
