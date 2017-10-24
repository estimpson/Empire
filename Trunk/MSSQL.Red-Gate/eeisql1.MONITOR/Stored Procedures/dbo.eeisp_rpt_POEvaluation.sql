SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_rpt_POEvaluation](@PoNumber integer)
as
begin
  select max(FABAuthorizations.AuthorizedAccum),
    PONo=FABAuthorizations.poNumber,
    WeekNumber=FABAuthorizations.WeekNo,
    dateweek=dateadd(wk,FABAuthorizations.WeekNo,'1999/01/03'),
    HighFABAuthorizations.AuthorizedAccum,
    HighFABAuthorizations.Part,
    (select receivedAccum
      from FT.vwVendorPerformance vwVendorPerformance
      where PONumber=FABAuthorizations.poNumber and vwVendorPerformance.WeekNo=FABAuthorizations.WeekNo),
    ATReceipts=(select sum(quantity)
      from audit_trail
      where type in('R','D')
      and po_number=convert(varchar(20),@PONumber)
      and part=HighFABAuthorizations.Part and date_stamp<dateadd(dd,6,dateadd(wk,FABAuthorizations.WeekNo,'1999/01/03'))),
    AccumDueforPOPriorWeek=(select max(postAccum)
      from FT.ReleasePlanRaw as RPR join
      FT.ReleasePlans as RP on RPR.ReleasePlanID=RP.ID
      where RPR.WeekNo=FABAuthorizations.WeekNo
      and RPR.PONumber=FABAuthorizations.poNumber
      and RPR.Part=HighFABAuthorizations.Part
      and RP.ID=(select max(id) from FT.ReleasePlans as RP2 where RP2.GeneratedWeekNo=FABAuthorizations.WeekNo-1))
    from FT.FABAuthorizations FABAuthorizations
    ,FT.HighFABAuthorizations HighFABAuthorizations
    where FABAuthorizations.PONUmber=@PONumber
    and FABAuthorizations.PONUmber=HighFABAuthorizations.PONUmber
    group by FABAuthorizations.PONumber,HighFABAuthorizations.AuthorizedAccum,FABAuthorizations.WeekNo,HighFABAuthorizations.Part
end
GO
